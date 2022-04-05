Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28682321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64578C385A4
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:14 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:10 +0100
Resent-Message-ID: <Ykx7Oj39tP1JGpnU@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 18:00:02 +0100
Received: from dfw.source.kernel.org ([2604:1380:4641:c500::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmXA-007VDJ-FZ
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 18:00:02 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 31EFC61867
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id AA27DC385A1; Tue,  5 Apr 2022 16:59:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FD82C385A0
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 4FD82C385A0
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player771.ha.ovh.net (unknown [10.110.115.149])
	by mo576.mail-out.ovh.net (Postfix) with ESMTP id 2CB6A23CC8
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:59:48 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player771.ha.ovh.net (Postfix) with ESMTPSA id B524C293E3734;
	Tue,  5 Apr 2022 16:59:42 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-106R006cace6e1e-5535-4ebc-b9b4-33a127aeb55d,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:58:28 +0200
Message-Id: <20220405165836.2165310-7-steve@sk2.org>
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
X-Ovh-Tracer-Id: 8467893201618044550
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtgecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgjfhgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepjeelledvfeeiiedutdefveekgeeuheekkedvffegvdehudegkefgjeejkefgueegnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeejuddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 2604:1380:4641:c500::1
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH 06/14] ASoC: ml26124: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: DcWvACwOvtuh

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/ml26124.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/ml26124.c b/sound/soc/codecs/ml26124.c
index 0823527e4a75..de8fcbdd85be 100644
--- a/sound/soc/codecs/ml26124.c
+++ b/sound/soc/codecs/ml26124.c
@@ -550,8 +550,7 @@ static const struct regmap_config ml26124_i2c_regmap = {
 	.write_flag_mask = 0x01,
 };
 
-static int ml26124_i2c_probe(struct i2c_client *i2c,
-			     const struct i2c_device_id *id)
+static int ml26124_i2c_probe(struct i2c_client *i2c)
 {
 	struct ml26124_priv *priv;
 	int ret;
@@ -583,7 +582,7 @@ static struct i2c_driver ml26124_i2c_driver = {
 	.driver = {
 		.name = "ml26124",
 	},
-	.probe = ml26124_i2c_probe,
+	.probe_new = ml26124_i2c_probe,
 	.id_table = ml26124_i2c_id,
 };
 
-- 
2.27.0

