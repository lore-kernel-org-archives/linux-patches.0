Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F42321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2720BC385A1
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:00 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:23:57 +0100
Resent-Message-ID: <Ykx7LSPujckV0V1p@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:59:48 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmWw-007VCr-GM
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:59:48 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id BC655B81EA8
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 947F0C385A4; Tue,  5 Apr 2022 16:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EFE2C385A1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 9EFE2C385A1
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.110.208.131])
	by mo584.mail-out.ovh.net (Postfix) with ESMTP id 1992F22D07
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:32 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id C1050293E36B7;
	Tue,  5 Apr 2022 16:59:26 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R00643b1e07f-95df-4e95-9a98-f3cede4a735b,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:25 +0200
Message-Id: <20220405165836.2165310-4-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8463108128444155526
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 03/14] ASoC: es83*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: WhAQuEcwYAjC

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/es8316.c     | 5 ++---
 sound/soc/codecs/es8328-i2c.c | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/es8316.c b/sound/soc/codecs/es8316.c
index ff33eab6f9de..4407166bb338 100644
--- a/sound/soc/codecs/es8316.c
+++ b/sound/soc/codecs/es8316.c
@@ -789,8 +789,7 @@ static const struct regmap_config es8316_regmap = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int es8316_i2c_probe(struct i2c_client *i2c_client,
-			    const struct i2c_device_id *id)
+static int es8316_i2c_probe(struct i2c_client *i2c_client)
 {
 	struct device *dev = &i2c_client->dev;
 	struct es8316_priv *es8316;
@@ -852,7 +851,7 @@ static struct i2c_driver es8316_i2c_driver = {
 		.acpi_match_table	= ACPI_PTR(es8316_acpi_match),
 		.of_match_table		= of_match_ptr(es8316_of_match),
 	},
-	.probe		= es8316_i2c_probe,
+	.probe_new	= es8316_i2c_probe,
 	.id_table	= es8316_i2c_id,
 };
 module_i2c_driver(es8316_i2c_driver);
diff --git a/sound/soc/codecs/es8328-i2c.c b/sound/soc/codecs/es8328-i2c.c
index 6b0df0d750dc..68072e99fcc7 100644
--- a/sound/soc/codecs/es8328-i2c.c
+++ b/sound/soc/codecs/es8328-i2c.c
@@ -29,8 +29,7 @@ static const struct of_device_id es8328_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, es8328_of_match);
 
-static int es8328_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int es8328_i2c_probe(struct i2c_client *i2c)
 {
 	return es8328_probe(&i2c->dev,
 			devm_regmap_init_i2c(i2c, &es8328_regmap_config));
@@ -41,7 +40,7 @@ static struct i2c_driver es8328_i2c_driver = {
 		.name		= "es8328",
 		.of_match_table = es8328_of_match,
 	},
-	.probe    = es8328_i2c_probe,
+	.probe_new = es8328_i2c_probe,
 	.id_table = es8328_id,
 };
 
-- 
2.27.0

