Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65CDF7C
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B78C385A1
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:33 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 17:43:30 +0100
Resent-Message-ID: <YkxxspmWEKPWSZVy@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:35:58 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbm9s-007V4R-MK
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:35:58 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id F286BB81E8B
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id D5794C385A0; Tue,  5 Apr 2022 16:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 557F8C385A4
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:35:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 557F8C385A4
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player734.ha.ovh.net (unknown [10.109.146.168])
	by mo581.mail-out.ovh.net (Postfix) with ESMTP id E47EE23A81
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:35:42 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player734.ha.ovh.net (Postfix) with ESMTPSA id 85D1D28FEBF99;
	Tue,  5 Apr 2022 16:35:36 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-102R004d61553c7-e202-4547-945e-565ecbb11848,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: M R Swami Reddy <mr.swami.reddy@ti.com>,
	Vishwas A Deshpande <vishwas.a.deshpande@ti.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:35:33 +0200
Message-Id: <20220405163533.2157401-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8060880383069685382
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedgleelucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhephffvufffkffoggfgsedtkeertdertddtnecuhfhrohhmpefuthgvphhhvghnucfmihhtthcuoehsthgvvhgvsehskhdvrdhorhhgqeenucggtffrrghtthgvrhhnpeetgedugfelkeeikeetgeegteevfeeufeetuefgudeiiedthfehtdeffeekvdeffeenucfkpheptddrtddrtddrtddpkedvrdeihedrvdehrddvtddunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmohguvgepshhmthhpohhuthdphhgvlhhopehplhgrhigvrhejfeegrdhhrgdrohhvhhdrnhgvthdpihhnvghtpedtrddtrddtrddtpdhmrghilhhfrhhomhepshhtvghvvgesshhkvddrohhrghdpnhgspghrtghpthhtohepuddprhgtphhtthhopegsrhhoohhnihgvsehkvghrnhgvlhdrohhrgh
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: lm49xxx: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: rEIf900PDcib

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/isabelle.c | 5 ++---
 sound/soc/codecs/lm49453.c  | 5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/isabelle.c b/sound/soc/codecs/isabelle.c
index 1d86b6a0eb9d..39be31e1282e 100644
--- a/sound/soc/codecs/isabelle.c
+++ b/sound/soc/codecs/isabelle.c
@@ -1108,8 +1108,7 @@ static const struct regmap_config isabelle_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int isabelle_i2c_probe(struct i2c_client *i2c,
-			      const struct i2c_device_id *id)
+static int isabelle_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *isabelle_regmap;
 	int ret = 0;
@@ -1144,7 +1143,7 @@ static struct i2c_driver isabelle_i2c_driver = {
 	.driver = {
 		.name = "isabelle",
 	},
-	.probe = isabelle_i2c_probe,
+	.probe_new = isabelle_i2c_probe,
 	.id_table = isabelle_i2c_id,
 };
 
diff --git a/sound/soc/codecs/lm49453.c b/sound/soc/codecs/lm49453.c
index 973d781b4b6a..bd0078e4499b 100644
--- a/sound/soc/codecs/lm49453.c
+++ b/sound/soc/codecs/lm49453.c
@@ -1412,8 +1412,7 @@ static const struct regmap_config lm49453_regmap_config = {
 	.cache_type = REGCACHE_RBTREE,
 };
 
-static int lm49453_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int lm49453_i2c_probe(struct i2c_client *i2c)
 {
 	struct lm49453_priv *lm49453;
 	int ret = 0;
@@ -1458,7 +1457,7 @@ static struct i2c_driver lm49453_i2c_driver = {
 	.driver = {
 		.name = "lm49453",
 	},
-	.probe = lm49453_i2c_probe,
+	.probe_new = lm49453_i2c_probe,
 	.remove = lm49453_i2c_remove,
 	.id_table = lm49453_i2c_id,
 };
-- 
2.27.0

