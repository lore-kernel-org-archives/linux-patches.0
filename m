Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01D2321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083AFC385A1
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:21 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:18 +0100
Resent-Message-ID: <Ykx7QkslnwughijR@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 18:00:06 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmXD-007VDa-U6
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 18:00:06 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id E803C617D2
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 17:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 694F8C385A0; Tue,  5 Apr 2022 17:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49554C385A1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:00:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 49554C385A1
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.108.20.237])
	by mo560.mail-out.ovh.net (Postfix) with ESMTP id BBEA5225C4
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:58 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id 77921293E37E1;
	Tue,  5 Apr 2022 16:59:53 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R006b5e70ec5-e3d9-4a7c-9fc2-75e77b066929,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:30 +0200
Message-Id: <20220405165836.2165310-9-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8470707952104474246
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 08/14] ASoC: pcm*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: EGotutCKfAoS

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/pcm1681.c      | 5 ++---
 sound/soc/codecs/pcm1789-i2c.c  | 5 ++---
 sound/soc/codecs/pcm179x-i2c.c  | 5 ++---
 sound/soc/codecs/pcm3168a-i2c.c | 5 ++---
 sound/soc/codecs/pcm512x-i2c.c  | 5 ++---
 5 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/sound/soc/codecs/pcm1681.c b/sound/soc/codecs/pcm1681.c
index 9eb65f94fc4d..20eb04c8a41a 100644
--- a/sound/soc/codecs/pcm1681.c
+++ b/sound/soc/codecs/pcm1681.c
@@ -299,8 +299,7 @@ static const struct i2c_device_id pcm1681_i2c_id[] = {
 };
 MODULE_DEVICE_TABLE(i2c, pcm1681_i2c_id);
 
-static int pcm1681_i2c_probe(struct i2c_client *client,
-			      const struct i2c_device_id *id)
+static int pcm1681_i2c_probe(struct i2c_client *client)
 {
 	int ret;
 	struct pcm1681_private *priv;
@@ -329,7 +328,7 @@ static struct i2c_driver pcm1681_i2c_driver = {
 		.of_match_table = of_match_ptr(pcm1681_dt_ids),
 	},
 	.id_table	= pcm1681_i2c_id,
-	.probe		= pcm1681_i2c_probe,
+	.probe_new	= pcm1681_i2c_probe,
 };
 
 module_i2c_driver(pcm1681_i2c_driver);
diff --git a/sound/soc/codecs/pcm1789-i2c.c b/sound/soc/codecs/pcm1789-i2c.c
index 7a6be45f8149..28e6ca2ad3a4 100644
--- a/sound/soc/codecs/pcm1789-i2c.c
+++ b/sound/soc/codecs/pcm1789-i2c.c
@@ -12,8 +12,7 @@
 
 #include "pcm1789.h"
 
-static int pcm1789_i2c_probe(struct i2c_client *client,
-			     const struct i2c_device_id *id)
+static int pcm1789_i2c_probe(struct i2c_client *client)
 {
 	struct regmap *regmap;
 	int ret;
@@ -53,7 +52,7 @@ static struct i2c_driver pcm1789_i2c_driver = {
 		.of_match_table = of_match_ptr(pcm1789_of_match),
 	},
 	.id_table	= pcm1789_i2c_ids,
-	.probe		= pcm1789_i2c_probe,
+	.probe_new	= pcm1789_i2c_probe,
 	.remove	= pcm1789_i2c_remove,
 };
 
diff --git a/sound/soc/codecs/pcm179x-i2c.c b/sound/soc/codecs/pcm179x-i2c.c
index 34a3d596f288..e20fe3a85af8 100644
--- a/sound/soc/codecs/pcm179x-i2c.c
+++ b/sound/soc/codecs/pcm179x-i2c.c
@@ -14,8 +14,7 @@
 
 #include "pcm179x.h"
 
-static int pcm179x_i2c_probe(struct i2c_client *client,
-			      const struct i2c_device_id *id)
+static int pcm179x_i2c_probe(struct i2c_client *client)
 {
 	struct regmap *regmap;
 	int ret;
@@ -50,7 +49,7 @@ static struct i2c_driver pcm179x_i2c_driver = {
 		.of_match_table = of_match_ptr(pcm179x_of_match),
 	},
 	.id_table	= pcm179x_i2c_ids,
-	.probe		= pcm179x_i2c_probe,
+	.probe_new	= pcm179x_i2c_probe,
 };
 
 module_i2c_driver(pcm179x_i2c_driver);
diff --git a/sound/soc/codecs/pcm3168a-i2c.c b/sound/soc/codecs/pcm3168a-i2c.c
index 1f75933e74fa..c0fa0dc80e8f 100644
--- a/sound/soc/codecs/pcm3168a-i2c.c
+++ b/sound/soc/codecs/pcm3168a-i2c.c
@@ -15,8 +15,7 @@
 
 #include "pcm3168a.h"
 
-static int pcm3168a_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int pcm3168a_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
 
@@ -47,7 +46,7 @@ static const struct of_device_id pcm3168a_of_match[] = {
 MODULE_DEVICE_TABLE(of, pcm3168a_of_match);
 
 static struct i2c_driver pcm3168a_i2c_driver = {
-	.probe		= pcm3168a_i2c_probe,
+	.probe_new	= pcm3168a_i2c_probe,
 	.remove		= pcm3168a_i2c_remove,
 	.id_table	= pcm3168a_i2c_id,
 	.driver		= {
diff --git a/sound/soc/codecs/pcm512x-i2c.c b/sound/soc/codecs/pcm512x-i2c.c
index 633f7ebe29a3..81754e141a55 100644
--- a/sound/soc/codecs/pcm512x-i2c.c
+++ b/sound/soc/codecs/pcm512x-i2c.c
@@ -13,8 +13,7 @@
 
 #include "pcm512x.h"
 
-static int pcm512x_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int pcm512x_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
 	struct regmap_config config = pcm512x_regmap;
@@ -68,7 +67,7 @@ MODULE_DEVICE_TABLE(acpi, pcm512x_acpi_match);
 #endif
 
 static struct i2c_driver pcm512x_i2c_driver = {
-	.probe 		= pcm512x_i2c_probe,
+	.probe_new	= pcm512x_i2c_probe,
 	.remove 	= pcm512x_i2c_remove,
 	.id_table	= pcm512x_i2c_id,
 	.driver		= {
-- 
2.27.0

