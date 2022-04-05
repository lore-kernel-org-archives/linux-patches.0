Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292A6321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:23:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EDEDC385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:23:53 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:23:50 +0100
Resent-Message-ID: <Ykx7Jk9dl/3tO27T@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:59:28 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmWc-007VCL-IE
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:59:28 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 4ED40B81EA9
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 2C8E5C385A1; Tue,  5 Apr 2022 16:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25953C385A0
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 25953C385A0
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.108.16.135])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id 538D722E72
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:21 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id F24EE293E366C;
	Tue,  5 Apr 2022 16:59:15 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R0069cd6cc63-6d12-4d77-a5d0-44e51e431b9e,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:23 +0200
Message-Id: <20220405165836.2165310-2-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20220405165836.2165310-1-steve@sk2.org>
References: <20220405165836.2165310-1-steve@sk2.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8460293375399265926
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 01/14] ASoC: ak4*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: Z8P+y9OWX5v0

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/ak4118.c | 5 ++---
 sound/soc/codecs/ak4535.c | 5 ++---
 sound/soc/codecs/ak4641.c | 5 ++---
 sound/soc/codecs/ak4671.c | 5 ++---
 4 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/sound/soc/codecs/ak4118.c b/sound/soc/codecs/ak4118.c
index 2e6bafd2a821..5c4a78c16733 100644
--- a/sound/soc/codecs/ak4118.c
+++ b/sound/soc/codecs/ak4118.c
@@ -356,8 +356,7 @@ static const struct regmap_config ak4118_regmap = {
 	.max_register = AK4118_REG_MAX - 1,
 };
 
-static int ak4118_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int ak4118_i2c_probe(struct i2c_client *i2c)
 {
 	struct ak4118_priv *ak4118;
 	int ret;
@@ -416,7 +415,7 @@ static struct i2c_driver ak4118_i2c_driver = {
 		.of_match_table = of_match_ptr(ak4118_of_match),
 	},
 	.id_table = ak4118_id_table,
-	.probe  = ak4118_i2c_probe,
+	.probe_new = ak4118_i2c_probe,
 };
 
 module_i2c_driver(ak4118_i2c_driver);
diff --git a/sound/soc/codecs/ak4535.c b/sound/soc/codecs/ak4535.c
index 91e7a57c43da..cc803e730c6e 100644
--- a/sound/soc/codecs/ak4535.c
+++ b/sound/soc/codecs/ak4535.c
@@ -405,8 +405,7 @@ static const struct snd_soc_component_driver soc_component_dev_ak4535 = {
 	.non_legacy_dai_naming	= 1,
 };
 
-static int ak4535_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int ak4535_i2c_probe(struct i2c_client *i2c)
 {
 	struct ak4535_priv *ak4535;
 	int ret;
@@ -441,7 +440,7 @@ static struct i2c_driver ak4535_i2c_driver = {
 	.driver = {
 		.name = "ak4535",
 	},
-	.probe =    ak4535_i2c_probe,
+	.probe_new = ak4535_i2c_probe,
 	.id_table = ak4535_i2c_id,
 };
 
diff --git a/sound/soc/codecs/ak4641.c b/sound/soc/codecs/ak4641.c
index 04aef0e72aa5..d8d9cc712d67 100644
--- a/sound/soc/codecs/ak4641.c
+++ b/sound/soc/codecs/ak4641.c
@@ -548,8 +548,7 @@ static const struct regmap_config ak4641_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int ak4641_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int ak4641_i2c_probe(struct i2c_client *i2c)
 {
 	struct ak4641_platform_data *pdata = i2c->dev.platform_data;
 	struct ak4641_priv *ak4641;
@@ -632,7 +631,7 @@ static struct i2c_driver ak4641_i2c_driver = {
 	.driver = {
 		.name = "ak4641",
 	},
-	.probe =    ak4641_i2c_probe,
+	.probe_new = ak4641_i2c_probe,
 	.remove =   ak4641_i2c_remove,
 	.id_table = ak4641_i2c_id,
 };
diff --git a/sound/soc/codecs/ak4671.c b/sound/soc/codecs/ak4671.c
index e9d1251c4265..60edcbe56014 100644
--- a/sound/soc/codecs/ak4671.c
+++ b/sound/soc/codecs/ak4671.c
@@ -629,8 +629,7 @@ static const struct regmap_config ak4671_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int ak4671_i2c_probe(struct i2c_client *client,
-			    const struct i2c_device_id *id)
+static int ak4671_i2c_probe(struct i2c_client *client)
 {
 	struct regmap *regmap;
 	int ret;
@@ -657,7 +656,7 @@ static struct i2c_driver ak4671_i2c_driver = {
 	.driver = {
 		.name = "ak4671-codec",
 	},
-	.probe = ak4671_i2c_probe,
+	.probe_new = ak4671_i2c_probe,
 	.id_table = ak4671_i2c_id,
 };
 
-- 
2.27.0

