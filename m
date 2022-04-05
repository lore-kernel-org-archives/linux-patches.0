Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 558C62F5E
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3999C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:25 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:22 +0100
Resent-Message-ID: <Ykx7Rv/9urbcCRuw@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 18:00:13 +0100
Received: from sin.source.kernel.org ([145.40.73.55])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmXL-007VDq-91
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 18:00:13 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.source.kernel.org (Postfix) with ESMTPS id A30E4CE1EC6
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 17:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 2C46CC385A0; Tue,  5 Apr 2022 17:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 332E0C385A1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:00:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 332E0C385A1
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.111.208.131])
	by mo576.mail-out.ovh.net (Postfix) with ESMTP id 22D5723EF1
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:00:04 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id BF89D293E3800;
	Tue,  5 Apr 2022 16:59:58 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R006437fb18a-a5e4-41d7-ba4a-0e7824ff30f8,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:31 +0200
Message-Id: <20220405165836.2165310-10-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8472396801019709062
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 145.40.73.55
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 09/14] ASoC: sta*: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: aWZ77C4MwpbX

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/sta32x.c | 5 ++---
 sound/soc/codecs/sta350.c | 5 ++---
 sound/soc/codecs/sta529.c | 5 ++---
 3 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/sta32x.c b/sound/soc/codecs/sta32x.c
index 86528b930de8..0ba6eab991c4 100644
--- a/sound/soc/codecs/sta32x.c
+++ b/sound/soc/codecs/sta32x.c
@@ -1094,8 +1094,7 @@ static int sta32x_probe_dt(struct device *dev, struct sta32x_priv *sta32x)
 }
 #endif
 
-static int sta32x_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int sta32x_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
 	struct sta32x_priv *sta32x;
@@ -1175,7 +1174,7 @@ static struct i2c_driver sta32x_i2c_driver = {
 		.name = "sta32x",
 		.of_match_table = of_match_ptr(st32x_dt_ids),
 	},
-	.probe =    sta32x_i2c_probe,
+	.probe_new = sta32x_i2c_probe,
 	.id_table = sta32x_i2c_id,
 };
 
diff --git a/sound/soc/codecs/sta350.c b/sound/soc/codecs/sta350.c
index 75d3b0618ab5..1fb370fc0ae3 100644
--- a/sound/soc/codecs/sta350.c
+++ b/sound/soc/codecs/sta350.c
@@ -1187,8 +1187,7 @@ static int sta350_probe_dt(struct device *dev, struct sta350_priv *sta350)
 }
 #endif
 
-static int sta350_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int sta350_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
 	struct sta350_priv *sta350;
@@ -1263,7 +1262,7 @@ static struct i2c_driver sta350_i2c_driver = {
 		.name = "sta350",
 		.of_match_table = of_match_ptr(st350_dt_ids),
 	},
-	.probe =    sta350_i2c_probe,
+	.probe_new = sta350_i2c_probe,
 	.remove =   sta350_i2c_remove,
 	.id_table = sta350_i2c_id,
 };
diff --git a/sound/soc/codecs/sta529.c b/sound/soc/codecs/sta529.c
index 97b5f34027c0..d90e5512a731 100644
--- a/sound/soc/codecs/sta529.c
+++ b/sound/soc/codecs/sta529.c
@@ -337,8 +337,7 @@ static const struct regmap_config sta529_regmap = {
 	.num_reg_defaults = ARRAY_SIZE(sta529_reg_defaults),
 };
 
-static int sta529_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int sta529_i2c_probe(struct i2c_client *i2c)
 {
 	struct sta529 *sta529;
 	int ret;
@@ -381,7 +380,7 @@ static struct i2c_driver sta529_i2c_driver = {
 		.name = "sta529",
 		.of_match_table = sta529_of_match,
 	},
-	.probe		= sta529_i2c_probe,
+	.probe_new	= sta529_i2c_probe,
 	.id_table	= sta529_i2c_id,
 };
 
-- 
2.27.0

