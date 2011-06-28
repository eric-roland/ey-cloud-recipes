Sphinx Chef Cookbook for CLI Users -- Sphinx 1.1.0Beta
=========
Sphinx is a full-text search engine, distributed under GPL version 2. Commercial licensing (eg. for embedded use) is also available upon request.

Generally, it's a standalone search engine, meant to provide fast, size-efficient and relevant full-text search functions to other applications. Sphinx was specially designed to integrate well with SQL databases and scripting languages.

Currently built-in data source drivers support fetching data either via direct connection to MySQL, or PostgreSQL, or from a pipe in a custom XML format. Adding new drivers (eg. to natively support some other DBMSes) is designed to be as easy as possible.

Search API is natively ported to PHP, Python, Perl, Ruby, Java, and also available as a pluggable MySQL storage engine. API is very lightweight so porting it to new language is known to take a few hours.

As for the name, Sphinx is an acronym which is officially decoded as SQL Phrase Index. Yes, I know about CMU's Sphinx project. 

Description
--------

This recipe installs [sphinx][1] 1.1.0Beta

Design
--------

This recipe configures [sphinx][1] and searchd on the 'solo|app_master' instance.  It creates a sphinx.yml that is usable on the app instances to communicate with the searchd instance running on the app_master.  This Cookbook should be able to support multiple [sphinx][1] daemons for multiple applications.

Configuration
--------

* By modigying [searchd_file_path][6] you can configure where sphinx
  stores the indexes.
* By modifying [cron_interval][7] you can configure when the index task
  runs on your 'solo|app_master'


Warnings
--------

You **MUST** update the [deloy hook][3] application name in order for sphinx to be monitored properly.  Failure to do so may cause searchd to be unmonitored and cause unacceptable behavior.  Additionally the [deploy hook][3] assumes that thinking_sphinx is configured in Bundler.  If you do not follow this behavior you will need to remove the 'bundle exec' in the [deploy hook][3].

Usage
--------

To enable this recipe you first must uncomment the [require_recipe][9] statement in main/recipes/default.rb.

``ey recipes upload -e <environment>``.  

Then either apply the recipes,

``ey recipes apply -e <environment>``. 

or boot the environment in question.  Then install the [deploy hook][3] in question in your application root in a folder called 'deploy' called before_migrate.rb with the modified [appname][3] and commit that to your application repo and then deploy.  On an **initial** environment it may **fail** to start searchd initially until deploying. 


Notes
--------

If you wish to change the behavior of how searchd is restarted to a more graceful restart you are more then welcome to modify the [deploy hook][3] to your tastes.  Suggestions are open on this for an default of course.   


Bugs / Comments
--------

If you have any problems with this [recipe][5] please either comment and supply a pull with the patched code.  **THIS RECIPE COMES AS IS WITH NO SUPPORT OR WARRANTY**

[1]: http://sphinxsearch.com/
[2]: http://dev.null
[3]: https://github.com/damm/appcloud-tsphinx2/blob/master/before_migrate.rb
[4]: http://docs.engineyard.com/appcloud/howtos/customizations/custom-chef-recipes
[5]: https://github.com/damm/appcloud-tsphinx2
[6]: https://github.com/damm/appcloud-tsphinx2/blob/master/attributes/tsphinx2.rb#L16
[7]: https://github.com/damm/appcloud-tsphinx2/blob/master/attributes/tsphinx2.rb#L8
[9]: http://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/main/recipes/default.rb
[10]: http://docs.engineyard.com/appcloud/guides/deployment/home#engine-yard-cli-user-guide
