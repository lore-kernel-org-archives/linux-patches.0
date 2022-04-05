Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13BD321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AACAC385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:37 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:34 +0100
Resent-Message-ID: <Ykx7UvHp2ghc4vjs@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 18:00:34 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmXg-007VEF-IY
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 18:00:34 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 829DA61867
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 17:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 09895C385A5; Tue,  5 Apr 2022 17:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EE6EC385A1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:00:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 6EE6EC385A1
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.110.103.23])
	by mo582.mail-out.ovh.net (Postfix) with ESMTP id 398FF23D98
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:00:20 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id D300B293E393F;
	Tue,  5 Apr 2022 17:00:14 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R00631340dfc-6f6e-4f91-9fd8-9d7b05e15ce0,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:34 +0200
Message-Id: <20220405165836.2165310-13-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8476900402881857158
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 12/14] ASoC: tlv320*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: r3mhBfeqt2IQ

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/tlv320adcx140.c   | 5 ++---
 sound/soc/codecs/tlv320aic23-i2c.c | 5 ++---
 sound/soc/codecs/tlv320dac33.c     | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 32b120d624b2..0b06fbb14171 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -1083,8 +1083,7 @@ static const struct of_device_id tlv320adcx140_of_match[] = {
 MODULE_DEVICE_TABLE(of, tlv320adcx140_of_match);
 #endif
 
-static int adcx140_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int adcx140_i2c_probe(struct i2c_client *i2c)
 {
 	struct adcx140_priv *adcx140;
 	int ret;
@@ -1143,7 +1142,7 @@ static struct i2c_driver adcx140_i2c_driver = {
 		.name	= "tlv320adcx140-codec",
 		.of_match_table = of_match_ptr(tlv320adcx140_of_match),
 	},
-	.probe		= adcx140_i2c_probe,
+	.probe_new	= adcx140_i2c_probe,
 	.id_table	= adcx140_i2c_id,
 };
 module_i2c_driver(adcx140_i2c_driver);
diff --git a/sound/soc/codecs/tlv320aic23-i2c.c b/sound/soc/codecs/tlv320aic23-i2c.c
index dbb8f969274c..1f97673a1cc0 100644
--- a/sound/soc/codecs/tlv320aic23-i2c.c
+++ b/sound/soc/codecs/tlv320aic23-i2c.c
@@ -16,8 +16,7 @@
 
 #include "tlv320aic23.h"
 
-static int tlv320aic23_i2c_probe(struct i2c_client *i2c,
-				 const struct i2c_device_id *i2c_id)
+static int tlv320aic23_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
 
@@ -48,7 +47,7 @@ static struct i2c_driver tlv320aic23_i2c_driver = {
 		   .name = "tlv320aic23-codec",
 		   .of_match_table = of_match_ptr(tlv320aic23_of_match),
 		   },
-	.probe = tlv320aic23_i2c_probe,
+	.probe_new = tlv320aic23_i2c_probe,
 	.id_table = tlv320aic23_id,
 };
 
diff --git a/sound/soc/codecs/tlv320dac33.c b/sound/soc/codecs/tlv320dac33.c
index 48572d66cb3b..66f1d1cd6cf0 100644
--- a/sound/soc/codecs/tlv320dac33.c
+++ b/sound/soc/codecs/tlv320dac33.c
@@ -1463,8 +1463,7 @@ static struct snd_soc_dai_driver dac33_dai = {
 	.ops = &dac33_dai_ops,
 };
 
-static int dac33_i2c_probe(struct i2c_client *client,
-			   const struct i2c_device_id *id)
+static int dac33_i2c_probe(struct i2c_client *client)
 {
 	struct tlv320dac33_platform_data *pdata;
 	struct tlv320dac33_priv *dac33;
@@ -1566,7 +1565,7 @@ static struct i2c_driver tlv320dac33_i2c_driver = {
 	.driver = {
 		.name = "tlv320dac33-codec",
 	},
-	.probe		= dac33_i2c_probe,
+	.probe_new	= dac33_i2c_probe,
 	.remove		= dac33_i2c_remove,
 	.id_table	= tlv320dac33_i2c_id,
 };
-- 
2.27.0

