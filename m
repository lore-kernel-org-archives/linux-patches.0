Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2D2321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E10C385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:45:39 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:45:36 +0100
Resent-Message-ID: <YkyAQL74OV4fLHmn@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 18:40:46 +0100
Received: from sin.source.kernel.org ([2604:1380:40e1:4800::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbnAZ-007VdZ-Lr
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 18:40:46 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sin.source.kernel.org (Postfix) with ESMTPS id F282CCE1CA7
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 17:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 86176C385A4; Tue,  5 Apr 2022 17:40:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C3B3C385A5
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:40:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 5C3B3C385A5
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player691.ha.ovh.net (unknown [10.111.208.235])
	by mo584.mail-out.ovh.net (Postfix) with ESMTP id A333C2391D
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:40:26 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player691.ha.ovh.net (Postfix) with ESMTPSA id 271F5293C8F1F;
	Tue,  5 Apr 2022 17:40:21 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-101G004618b8f4f-e2e9-40cb-b8ab-e15530b48acd,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: patches@opensource.cirrus.com,
	Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 19:39:52 +0200
Message-Id: <20220405173952.2180743-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9154129193012921990
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedgudduvdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepteegudfgleekieekteeggeetveefueefteeugfduieeitdfhhedtfeefkedvfeefnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrieeluddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 2604:1380:40e1:4800::1
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH v2] ASoC: wm8731: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: +00LBubll5Js

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
Changes since v1:
  - rebased on sound/for-next instead of v5.18-rc1
---
 sound/soc/codecs/wm8731-i2c.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/wm8731-i2c.c b/sound/soc/codecs/wm8731-i2c.c
index c70f5db891e7..fdf03bf91606 100644
--- a/sound/soc/codecs/wm8731-i2c.c
+++ b/sound/soc/codecs/wm8731-i2c.c
@@ -23,8 +23,7 @@ static const struct of_device_id wm8731_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, wm8731_of_match);
 
-static int wm8731_i2c_probe(struct i2c_client *i2c,
-			    const struct i2c_device_id *id)
+static int wm8731_i2c_probe(struct i2c_client *i2c)
 {
 	struct wm8731_priv *wm8731;
 	int ret;
@@ -58,7 +57,7 @@ static struct i2c_driver wm8731_i2c_driver = {
 		.name = "wm8731",
 		.of_match_table = wm8731_of_match,
 	},
-	.probe =    wm8731_i2c_probe,
+	.probe_new = wm8731_i2c_probe,
 	.id_table = wm8731_i2c_id,
 };
 

base-commit: b66751b6e3591eafe5c9cbabd68a45731b0083e3
-- 
2.27.0

