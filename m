Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97AA32F5E
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCC9C385A1
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:09 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:05 +0100
Resent-Message-ID: <Ykx7NbfphBWabl0u@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:59:58 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmX6-007VDC-DF
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:59:58 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 57535617D2
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D15F7C385A5; Tue,  5 Apr 2022 16:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7E18EC385A4
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 7E18EC385A4
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.110.103.225])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id B1B15230A5
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:42 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id 593F3293E36F1;
	Tue,  5 Apr 2022 16:59:37 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R006674b4758-f566-458a-9f6a-2a4a5c2e66b3,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:27 +0200
Message-Id: <20220405165836.2165310-6-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8466204352922355334
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 05/14] ASoC: max9*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 3HEQl8/EDVYm

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/max9768.c      | 5 ++---
 sound/soc/codecs/max98371.c     | 5 ++---
 sound/soc/codecs/max98373-i2c.c | 5 ++---
 sound/soc/codecs/max98390.c     | 5 ++---
 sound/soc/codecs/max9850.c      | 5 ++---
 sound/soc/codecs/max98504.c     | 5 ++---
 sound/soc/codecs/max98520.c     | 4 ++--
 sound/soc/codecs/max9867.c      | 5 ++---
 sound/soc/codecs/max9877.c      | 5 ++---
 sound/soc/codecs/max98925.c     | 5 ++---
 sound/soc/codecs/max98926.c     | 5 ++---
 sound/soc/codecs/max98927.c     | 5 ++---
 12 files changed, 24 insertions(+), 35 deletions(-)

diff --git a/sound/soc/codecs/max9768.c b/sound/soc/codecs/max9768.c
index 39dda1b03b3d..d711eb1da0a8 100644
--- a/sound/soc/codecs/max9768.c
+++ b/sound/soc/codecs/max9768.c
@@ -167,8 +167,7 @@ static const struct regmap_config max9768_i2c_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int max9768_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int max9768_i2c_probe(struct i2c_client *client)
 {
 	struct max9768 *max9768;
 	struct max9768_pdata *pdata = client->dev.platform_data;
@@ -215,7 +214,7 @@ static struct i2c_driver max9768_i2c_driver = {
 	.driver = {
 		.name = "max9768",
 	},
-	.probe = max9768_i2c_probe,
+	.probe_new = max9768_i2c_probe,
 	.id_table = max9768_i2c_id,
 };
 module_i2c_driver(max9768_i2c_driver);
diff --git a/sound/soc/codecs/max98371.c b/sound/soc/codecs/max98371.c
index 8d42f523e420..800f2bca6a0f 100644
--- a/sound/soc/codecs/max98371.c
+++ b/sound/soc/codecs/max98371.c
@@ -365,8 +365,7 @@ static const struct regmap_config max98371_regmap = {
 	.cache_type       = REGCACHE_RBTREE,
 };
 
-static int max98371_i2c_probe(struct i2c_client *i2c,
-		const struct i2c_device_id *id)
+static int max98371_i2c_probe(struct i2c_client *i2c)
 {
 	struct max98371_priv *max98371;
 	int ret, reg;
@@ -421,7 +420,7 @@ static struct i2c_driver max98371_i2c_driver = {
 		.name = "max98371",
 		.of_match_table = of_match_ptr(max98371_of_match),
 	},
-	.probe  = max98371_i2c_probe,
+	.probe_new  = max98371_i2c_probe,
 	.id_table = max98371_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max98373-i2c.c b/sound/soc/codecs/max98373-i2c.c
index ddb6436835d7..4fe065ece17c 100644
--- a/sound/soc/codecs/max98373-i2c.c
+++ b/sound/soc/codecs/max98373-i2c.c
@@ -516,8 +516,7 @@ static const struct regmap_config max98373_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int max98373_i2c_probe(struct i2c_client *i2c,
-			      const struct i2c_device_id *id)
+static int max98373_i2c_probe(struct i2c_client *i2c)
 {
 	int ret = 0;
 	int reg = 0;
@@ -622,7 +621,7 @@ static struct i2c_driver max98373_i2c_driver = {
 		.acpi_match_table = ACPI_PTR(max98373_acpi_match),
 		.pm = &max98373_pm,
 	},
-	.probe = max98373_i2c_probe,
+	.probe_new = max98373_i2c_probe,
 	.id_table = max98373_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max98390.c b/sound/soc/codecs/max98390.c
index 40fd6f363f35..d1fed8e2bded 100644
--- a/sound/soc/codecs/max98390.c
+++ b/sound/soc/codecs/max98390.c
@@ -1014,8 +1014,7 @@ static void max98390_slot_config(struct i2c_client *i2c,
 		max98390->i_l_slot = 1;
 }
 
-static int max98390_i2c_probe(struct i2c_client *i2c,
-		const struct i2c_device_id *id)
+static int max98390_i2c_probe(struct i2c_client *i2c)
 {
 	int ret = 0;
 	int reg = 0;
@@ -1121,7 +1120,7 @@ static struct i2c_driver max98390_i2c_driver = {
 		.acpi_match_table = ACPI_PTR(max98390_acpi_match),
 		.pm = &max98390_pm,
 	},
-	.probe = max98390_i2c_probe,
+	.probe_new = max98390_i2c_probe,
 	.id_table = max98390_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max9850.c b/sound/soc/codecs/max9850.c
index e073f0e029be..9ca6fc254883 100644
--- a/sound/soc/codecs/max9850.c
+++ b/sound/soc/codecs/max9850.c
@@ -299,8 +299,7 @@ static const struct snd_soc_component_driver soc_component_dev_max9850 = {
 	.non_legacy_dai_naming	= 1,
 };
 
-static int max9850_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int max9850_i2c_probe(struct i2c_client *i2c)
 {
 	struct max9850_priv *max9850;
 	int ret;
@@ -331,7 +330,7 @@ static struct i2c_driver max9850_i2c_driver = {
 	.driver = {
 		.name = "max9850",
 	},
-	.probe = max9850_i2c_probe,
+	.probe_new = max9850_i2c_probe,
 	.id_table = max9850_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max98504.c b/sound/soc/codecs/max98504.c
index a5aa124c4a2e..9da7381472e3 100644
--- a/sound/soc/codecs/max98504.c
+++ b/sound/soc/codecs/max98504.c
@@ -304,8 +304,7 @@ static const struct regmap_config max98504_regmap = {
 	.cache_type		= REGCACHE_RBTREE,
 };
 
-static int max98504_i2c_probe(struct i2c_client *client,
-			      const struct i2c_device_id *id)
+static int max98504_i2c_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
 	struct device_node *node = dev->of_node;
@@ -371,7 +370,7 @@ static struct i2c_driver max98504_i2c_driver = {
 		.name = "max98504",
 		.of_match_table = of_match_ptr(max98504_of_match),
 	},
-	.probe = max98504_i2c_probe,
+	.probe_new = max98504_i2c_probe,
 	.id_table = max98504_i2c_id,
 };
 module_i2c_driver(max98504_i2c_driver);
diff --git a/sound/soc/codecs/max98520.c b/sound/soc/codecs/max98520.c
index bb8649cd421c..f0f085ecab55 100644
--- a/sound/soc/codecs/max98520.c
+++ b/sound/soc/codecs/max98520.c
@@ -677,7 +677,7 @@ static void max98520_power_on(struct max98520_priv *max98520, bool poweron)
 		gpiod_set_value_cansleep(max98520->reset_gpio, !poweron);
 }
 
-static int max98520_i2c_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
+static int max98520_i2c_probe(struct i2c_client *i2c)
 {
 	int ret;
 	int reg = 0;
@@ -757,7 +757,7 @@ static struct i2c_driver max98520_i2c_driver = {
 		.of_match_table = of_match_ptr(max98520_of_match),
 		.pm = &max98520_pm,
 	},
-	.probe = max98520_i2c_probe,
+	.probe_new = max98520_i2c_probe,
 	.id_table = max98520_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max9867.c b/sound/soc/codecs/max9867.c
index c2b1151c75cc..eb628b7e84f5 100644
--- a/sound/soc/codecs/max9867.c
+++ b/sound/soc/codecs/max9867.c
@@ -613,8 +613,7 @@ static const struct regmap_config max9867_regmap = {
 	.cache_type	= REGCACHE_RBTREE,
 };
 
-static int max9867_i2c_probe(struct i2c_client *i2c,
-		const struct i2c_device_id *id)
+static int max9867_i2c_probe(struct i2c_client *i2c)
 {
 	struct max9867_priv *max9867;
 	int ret, reg;
@@ -662,7 +661,7 @@ static struct i2c_driver max9867_i2c_driver = {
 		.name = "max9867",
 		.of_match_table = of_match_ptr(max9867_of_match),
 	},
-	.probe  = max9867_i2c_probe,
+	.probe_new  = max9867_i2c_probe,
 	.id_table = max9867_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max9877.c b/sound/soc/codecs/max9877.c
index 71fede9224c4..3bf86328d5cd 100644
--- a/sound/soc/codecs/max9877.c
+++ b/sound/soc/codecs/max9877.c
@@ -133,8 +133,7 @@ static const struct regmap_config max9877_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int max9877_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int max9877_i2c_probe(struct i2c_client *client)
 {
 	struct regmap *regmap;
 	int i;
@@ -161,7 +160,7 @@ static struct i2c_driver max9877_i2c_driver = {
 	.driver = {
 		.name = "max9877",
 	},
-	.probe = max9877_i2c_probe,
+	.probe_new = max9877_i2c_probe,
 	.id_table = max9877_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max98925.c b/sound/soc/codecs/max98925.c
index f34fa274ae4f..63849ebcfd35 100644
--- a/sound/soc/codecs/max98925.c
+++ b/sound/soc/codecs/max98925.c
@@ -558,8 +558,7 @@ static const struct regmap_config max98925_regmap = {
 	.cache_type       = REGCACHE_RBTREE,
 };
 
-static int max98925_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int max98925_i2c_probe(struct i2c_client *i2c)
 {
 	int ret, reg;
 	u32 value;
@@ -637,7 +636,7 @@ static struct i2c_driver max98925_i2c_driver = {
 		.name = "max98925",
 		.of_match_table = of_match_ptr(max98925_of_match),
 	},
-	.probe  = max98925_i2c_probe,
+	.probe_new  = max98925_i2c_probe,
 	.id_table = max98925_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max98926.c b/sound/soc/codecs/max98926.c
index 1fbbc62bb0a2..56e0a87c7112 100644
--- a/sound/soc/codecs/max98926.c
+++ b/sound/soc/codecs/max98926.c
@@ -510,8 +510,7 @@ static const struct regmap_config max98926_regmap = {
 	.cache_type		= REGCACHE_RBTREE,
 };
 
-static int max98926_i2c_probe(struct i2c_client *i2c,
-		const struct i2c_device_id *id)
+static int max98926_i2c_probe(struct i2c_client *i2c)
 {
 	int ret, reg;
 	u32 value;
@@ -584,7 +583,7 @@ static struct i2c_driver max98926_i2c_driver = {
 		.name = "max98926",
 		.of_match_table = of_match_ptr(max98926_of_match),
 	},
-	.probe	= max98926_i2c_probe,
+	.probe_new = max98926_i2c_probe,
 	.id_table = max98926_i2c_id,
 };
 
diff --git a/sound/soc/codecs/max98927.c b/sound/soc/codecs/max98927.c
index bf78d3c98514..b7cff76d7b5b 100644
--- a/sound/soc/codecs/max98927.c
+++ b/sound/soc/codecs/max98927.c
@@ -863,8 +863,7 @@ static void max98927_slot_config(struct i2c_client *i2c,
 		max98927->i_l_slot = 1;
 }
 
-static int max98927_i2c_probe(struct i2c_client *i2c,
-	const struct i2c_device_id *id)
+static int max98927_i2c_probe(struct i2c_client *i2c)
 {
 
 	int ret = 0, value;
@@ -977,7 +976,7 @@ static struct i2c_driver max98927_i2c_driver = {
 		.acpi_match_table = ACPI_PTR(max98927_acpi_match),
 		.pm = &max98927_pm,
 	},
-	.probe  = max98927_i2c_probe,
+	.probe_new = max98927_i2c_probe,
 	.remove = max98927_i2c_remove,
 	.id_table = max98927_i2c_id,
 };
-- 
2.27.0

