<?php
if (!defined('GNUSOCIAL')) { exit(1); }

$config['site']['name'] = 'gnusocial.cardina1.red';

# CHANGEME
$config['site']['server'] = 'gnusocial.cardina1.red';
$config['site']['path'] = false;

$config['site']['ssl'] = 'never';

$config['site']['fancy'] = true;

# CHANGEME
$config['db']['database'] = 'mysqli://gnusocial:MariadbGnusocialUserPassword@mariadb-gnusocial/gnusocial';

$config['db']['type'] = 'mysql';

// Uncomment below for better performance. Just remember you must run
// php scripts/checkschema.php whenever your enabled plugins change!
$config['db']['schemacheck'] = 'script';

$config['site']['profile'] = 'community';

// Codes below are added by the admin.

// Global.
$config['site']['sslproxy'] = true;
# CHANGEME
$config['integration']['source'] = 'gnusocial.cardina1.red';
$config['follow_redirects'] = true;

// Queue daemon.
// See:
//   * https://git.gnu.io/gnu/gnu-social/blob/master/INSTALL
//   * https://wiki.loadaverage.org/gnusocial/configuration#queues
//   * https://www.codeword.xyz/2015/09/27/self-hosting-gnu-social/
$config['queue']['enabled'] = true;
$config['queue']['subsystem'] = 'db';
$config['queue']['daemon'] = true;
unset($config['plugins']['default']['OpportunisticQM']);
unset($config['plugins']['core']['Cronish']);

// Use curl.
// 2017-07-12: This setting may cause accidental mojibake...
// $config['http']['curl'] = true;
// $config['http']['ssl_verify_host'] = CURLOPT_SSL_VERIFYHOST;

// TwitterBridge.
# CHANGEME (or disable `addPlugin`)
addPlugin(
	'TwitterBridge',
	array(
		'consumer_key' => 'ConsumerKey',
		'consumer_secret' => 'ConsumerSecret'
	)
);

// InfiniteScroll.
addPlugin('InfiniteScroll');

// ModPlus.
addPlugin('ModPlus');

// Qvitter.
addPlugin('Qvitter');
// Qvitter-settings
$config['site']['qvitter']['enabledbydefault'] = true;
$config['site']['qvitter']['defaultbackgroundcolor'] = '#f4f4f4';
$config['site']['qvitter']['defaultlinkcolor'] = '#0084B4';
$config['site']['qvitter']['timebetweenpolling'] = 5000;
//$config['site']['qvitter']['urlshortenerapiurl'] = 'http://qttr.at/yourls-api.php'; // if your site is on HTTPS, use url to shortener.php here
//$config['site']['qvitter']['urlshortenersignature'] = 'b6afeec983';
$config['site']['qvitter']['sitebackground'] = 'img/vagnsmossen.jpg';
$config['site']['qvitter']['favicon'] = 'img/favicon.ico?v=4';
$config['site']['qvitter']['sprite'] = Plugin::staticPath('Qvitter', '').'img/sprite.png?v=40';
$config['site']['qvitter']['enablewelcometext'] = true;
$config['site']['qvitter']['customwelcometext']['en'] = '<h1>Welcome to gnusocial.cardina1.red</h1><p>You can follow accounts on this instance from GNU Social or Mastodon.</p>';
$config['site']['qvitter']['customwelcometext']['ja'] = '<h1>gnusocial.cardina1.red へよーこそ</h1><p>GNU Social や Mastodon からフォローできます。</p>';
$config['site']['qvitter']['blocked_ips'] = array();

// Recommended GNU social settings
$config['thumbnail']['maxsize'] = 3000; // recommended setting to get more high-res image previews
$config['profile']['delete'] = true; // twitter users are used to being able to remove their accounts
$config['profile']['changenick'] = true; // twitter users are used to being able to change their nicknames
$config['public']['localonly'] = true; // only local users in the public timeline (qvitter always has a timeline for the whole known network)
addPlugin('StoreRemoteMedia'); // makes remote images appear in the feed

//$config['site']['attachments']['user_quota'] = 5000000000;
//$config['site']['attachments']['monthly_quota'] = 15000000000;

// QvitterPlus.
// See https://gitgud.io/panjoozek413/qvitterplus .
//addPlugin('QvitterPlus');
// //$config['site']['qvitterplus']['schemafix'] = true;

// GSGreenText
addPlugin('GSGreenText');

// Debug.
//$config['site']['logdebug'] = true;
//$config['site']['logfile'] = '/var/log/gnusocial/gnusocial.log';
