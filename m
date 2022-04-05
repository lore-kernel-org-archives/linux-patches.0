Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CE82F5E
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C655C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:04 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:01 +0100
Resent-Message-ID: <Ykx7MVPJK91imDdo@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:59:55 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmX3-007VD3-A5
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:59:55 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 117F361867
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:59:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 8A9E7C385A4; Tue,  5 Apr 2022 16:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A6BBC385A5
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 6A6BBC385A5
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.109.146.168])
	by mo560.mail-out.ovh.net (Postfix) with ESMTP id 578A223C10
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:37 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id 130DE293E36D4;
	Tue,  5 Apr 2022 16:59:32 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R006684d1db8-587c-4aa8-aced-ea8bd21a0cfc,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:26 +0200
Message-Id: <20220405165836.2165310-5-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8464796978746656390
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 04/14] ASoC: lm4857: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: +xbiJLQcCBpc

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/lm4857.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/lm4857.c b/sound/soc/codecs/lm4857.c
index 300b325e2fdd..dba161305de8 100644
--- a/sound/soc/codecs/lm4857.c
+++ b/sound/soc/codecs/lm4857.c
@@ -115,8 +115,7 @@ static const struct regmap_config lm4857_regmap_config = {
 	.num_reg_defaults = ARRAY_SIZE(lm4857_default_regs),
 };
 
-static int lm4857_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int lm4857_i2c_probe(struct i2c_client *i2c)
 {
 	struct regmap *regmap;
 
@@ -138,7 +137,7 @@ static struct i2c_driver lm4857_i2c_driver = {
 	.driver = {
 		.name = "lm4857",
 	},
-	.probe = lm4857_i2c_probe,
+	.probe_new = lm4857_i2c_probe,
 	.id_table = lm4857_i2c_id,
 };
 
-- 
2.27.0

