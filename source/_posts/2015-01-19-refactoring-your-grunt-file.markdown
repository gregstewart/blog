---
layout: post
title: "refactoring your grunt file"
date: 2015-01-19 08:58:44 +0000
comments: true
categories: [book, javascript, grunt, refactoring]
---
Things left unchecked over time just grow to be unwieldy. Take this Gruntfile for example:

    module.exports = function (grunt) {
        'use strit';
        grunt.initConfig({
            express: {
                test: {
                    options: {
                        script: './server.js'
                    }
                }
            },
            cucumberjs: {
                src: 'tests/e2e/features/',
                options: {
                    steps: 'tests/e2e/steps/'
                }
            },
            less: {
                production: {
                    options: {
                        paths: ['app/css/'],
                        cleancss: true
                    },
                    files: {
                        'app/css/main.css': 'src/less/main.less'
                    }
                }
            },
            copy: {
                fonts: {
                    expand: true,
                    src: ['bower_components/bootstrap/fonts/*'],
                    dest: 'app/fonts/',
                    filter: 'isFile',
                    flatten: true
                }
            },
            bower: {
                install: {
                    options: {
                        cleanTargetDir:false,
                        targetDir: './bower_components'
                    }
                }
            },
            browserify: {
                code: {
                    dest: 'app/js/main.min.js',
                    src: 'node_modules/weatherly/js/**/*.js',
                    options: {
                        transform: ['uglifyify']
                    }
                },
                test: {
                    dest: 'app/js/test.js',
                    src: 'tests/unit/**/*.js'
                }
            },
            karma: {
                dev: {
                    configFile: 'karma.conf.js'
                },
                ci: {
                    configFile: 'karma.conf.js',
                    singleRun: true,
                    autoWatch: false,
                    reporters: ['progress']
                }
            }
        });
        grunt.loadNpmTasks('grunt-express-server');
        grunt.loadNpmTasks('grunt-selenium-webdriver');
        grunt.loadNpmTasks('grunt-cucumber');
        grunt.loadNpmTasks('grunt-contrib-less');
        grunt.loadNpmTasks('grunt-contrib-copy');
        grunt.loadNpmTasks('grunt-browserify');
        grunt.loadNpmTasks('grunt-bower-task');
        grunt.loadNpmTasks('grunt-karma');
        grunt.registerTask('generate', ['less:production', 'copy:fonts', 'browserify:code']);
        grunt.registerTask('build', ['bower:install', 'generate']);
        grunt.registerTask('e2e', [
            'selenium_start',
            'express:test',
            'cucumberjs',
            'selenium_stop',
            'express:test:stop'
        ]);
        grunt.registerTask('test', ['build', 'karma:ci', 'e2e']);
        grunt.registerTask('heroku:production', 'build');
    };

It's the Gruntfile for the project in [my book](https://leanpub.com/building-a-web-app-guided-by-tests/). I'll be honest the principle reason I want to refactor this file is because it makes the book editing quite painful and for the reader being able to make changes is quite difficult. However the same thing can be said for people working with the file, it's getting to be difficult to see what is happening in this file, so let's make this better for all.

Let's start with the karma tasks, these can be extracted to a file called `test.js` (I am keeping this generic, just in case I decide to switch testing frameworks at a later stage) and let's save it under a folder called `build`:

    (function (module) {
        'use strict';
        var config = {
            dev: {
                configFile: 'karma.conf.js'
            },
            ci: {
                configFile: 'karma.conf.js',
                singleRun: true,
                autoWatch: false,
                reporters: ['progress']
            }
        };
        module.exports = function (grunt) {
            grunt.loadNpmTasks('grunt-karma');

            grunt.config('karma', config);
        }
    })(module);

I have extracted the task configuration and the loading of the task from the `Gruntfile.js`, leaving us with:

     module.exports = function (grunt) {
        'use strit';
        grunt.initConfig({
            express: {
                test: {
                    options: {
                        script: './server.js'
                    }
                }
            },
            cucumberjs: {
                src: 'tests/e2e/features/',
                options: {
                    steps: 'tests/e2e/steps/'
                }
            },
            less: {
                production: {
                    options: {
                        paths: ['app/css/'],
                        cleancss: true
                    },
                    files: {
                        'app/css/main.css': 'src/less/main.less'
                    }
                }
            },
            copy: {
                fonts: {
                    expand: true,
                    src: ['bower_components/bootstrap/fonts/*'],
                    dest: 'app/fonts/',
                    filter: 'isFile',
                    flatten: true
                }
            },
            bower: {
                install: {
                    options: {
                        cleanTargetDir:false,
                        targetDir: './bower_components'
                    }
                }
            },
            browserify: {
                code: {
                    dest: 'app/js/main.min.js',
                    src: 'node_modules/weatherly/js/**/*.js',
                    options: {
                        transform: ['uglifyify']
                    }
                },
                test: {
                    dest: 'app/js/test.js',
                    src: 'tests/unit/**/*.js'
                }
            }
        });

        grunt.loadTasks('build');

        grunt.loadNpmTasks('grunt-express-server');
        grunt.loadNpmTasks('grunt-selenium-webdriver');
        grunt.loadNpmTasks('grunt-cucumber');
        grunt.loadNpmTasks('grunt-contrib-less');
        grunt.loadNpmTasks('grunt-contrib-copy');
        grunt.loadNpmTasks('grunt-browserify');
        grunt.loadNpmTasks('grunt-bower-task');

        grunt.registerTask('generate', ['less:production', 'copy:fonts', 'browserify:code']);
        grunt.registerTask('build', ['bower:install', 'generate']);

        grunt.registerTask('e2e', [
            'selenium_start',
            'express:test',
            'cucumberjs',
            'selenium_stop',
            'express:test:stop'
        ]);

        grunt.registerTask('test', ['build', 'karma:ci', 'e2e']);

        grunt.registerTask('heroku:production', 'build');
    };

Apart from removing the code for Karma, I also added the `grunt.loadTasks` directive pointing it to our new created `build` folder. To validate that everything is still ok, just run `grunt karma:dev`. Let's do the same for our `browserify` task, once again create a new file (called `browserify.js`) and save it under our build folder:

    (function(module) {
        'use strict';
        var config = {
            code: {
                dest: 'app/js/main.min.js',
                src: 'node_modules/weatherly/js/**/*.js',
                options: {
                    transform: ['uglifyify']
                }
            },
            test: {
                dest: 'app/js/test.js',
                src: 'tests/unit/**/*.js'
            }
        };
        
        module.exports = function(grunt) {
            grunt.loadNpmTasks('grunt-browserify');
            grunt.config('browserify', config);
        }
    })(module);

And remove the code from the `Gruntfile.js`:

    module.exports = function (grunt) {
        'use strit';
        grunt.initConfig({
            express: {
                test: {
                    options: {
                        script: './server.js'
                    }
                }
            },
            cucumberjs: {
                src: 'tests/e2e/features/',
                options: {
                    steps: 'tests/e2e/steps/'
                }
            },
            less: {
                production: {
                    options: {
                        paths: ['app/css/'],
                        cleancss: true
                    },
                    files: {
                        'app/css/main.css': 'src/less/main.less'
                    }
                }
            },
            copy: {
                fonts: {
                    expand: true,
                    src: ['bower_components/bootstrap/fonts/*'],
                    dest: 'app/fonts/',
                    filter: 'isFile',
                    flatten: true
                }
            },
            bower: {
                install: {
                    options: {
                        cleanTargetDir:false,
                        targetDir: './bower_components'
                    }
                }
            }
        });
        
        grunt.loadTasks('build');
        
        grunt.loadNpmTasks('grunt-express-server');
        grunt.loadNpmTasks('grunt-selenium-webdriver');
        grunt.loadNpmTasks('grunt-cucumber');
        grunt.loadNpmTasks('grunt-contrib-less');
        grunt.loadNpmTasks('grunt-contrib-copy');
        grunt.loadNpmTasks('grunt-bower-task');


        grunt.registerTask('generate', ['less:production', 'copy:fonts', 'browserify:code']);
        grunt.registerTask('build', ['bower:install', 'generate']);
        
        grunt.registerTask('e2e', [
            'selenium_start',
            'express:test',
            'cucumberjs',
            'selenium_stop',
            'express:test:stop'
        ]);
        
        grunt.registerTask('test', ['build', 'karma:ci', 'e2e']);
        grunt.registerTask('heroku:production', 'build');
    };

Let's test our task by running `grunt browserify:code` or `grunt browserify:test`. To speed things up a little in the following I am just going to show the extracted code.

Bower.js

    (function(module) {
        'use strict';
        var config = {
            install: {
                options: {
                    cleanTargetDir: false,
                    targetDir: './bower_components'
                }
            }
        };
        
        module.exports = function(grunt) {
            grunt.loadNpmTasks('grunt-bower-task');
            grunt.config('bower', config);
        }
    })(module);

Copy.js

    (function(module) {
        'use strict';
        var config = {
            fonts: {
                expand: true,
                src: ['bower_components/bootstrap/fonts/*'],
                dest: 'app/fonts/',
                filter: 'isFile',
                flatten: true
            }
        };
        
        module.exports = function(grunt) {
            grunt.loadNpmTasks('grunt-contrib-copy');
            
            grunt.config('copy', config);
        }
    })(module);

Less.js

    (function(module) {
        'use strict';
        var config = {
            production: {
                options: {
                    paths: ['app/css/'],
                    cleancss: true
                },
                files: {
                    'app/css/main.css': 'src/less/main.less'
                }
            }
        };
        
        module.exports = function(grunt) {
            grunt.loadNpmTasks('grunt-contrib-less');
            
            grunt.config('less', config);
        }
    })(module);

Cucumber.js

    (function(module) {
        'use strict';
        var config = {
            src: 'tests/e2e/features/',
            options: {
                steps: 'tests/e2e/steps/'
            }
        };
        
        module.exports = function(grunt) {
            grunt.loadNpmTasks('grunt-selenium-webdriver');
            grunt.loadNpmTasks('grunt-cucumber');
            
            grunt.config('cucumberjs', config);
        }
    })(module);

Express.js

    (function(module) {
        'use strict';
        var config = {
            test: {
                options: {
                    script: './server.js'
                }
            }
        };
        
        module.exports = function(grunt) {
            grunt.loadNpmTasks('grunt-express-server');
            
            grunt.config('express', config);
        }
    })(module);

Leaving us now with a `Gruntfile` that is so much more lightweight and only concerns itself with loading and registering tasks:

    module.exports = function (grunt) {
        'use strit';
        grunt.loadTasks('build');
        
        grunt.registerTask('generate', ['less:production', 'copy:fonts', 'browserify:code']);
        grunt.registerTask('build', ['bower:install', 'generate']);
        
        grunt.registerTask('e2e', [
            'selenium_start',
            'express:test',
            'cucumberjs',
            'selenium_stop',
            'express:test:stop'
        ]);
        
        grunt.registerTask('test', ['build', 'karma:ci', 'e2e']);
        grunt.registerTask('heroku:production', 'build');
    };
