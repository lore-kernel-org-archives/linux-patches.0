Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9927C
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020DFC385A0
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 16:43:44 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 17:43:41 +0100
Resent-Message-ID: <YkxxvatOaCJS5fTs@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 17:41:09 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmEs-007V6B-UH
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 17:41:09 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 89FD26187A
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 16:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 084DCC385A4; Tue,  5 Apr 2022 16:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7DBBFC385A0
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:41:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 7DBBFC385A0
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player715.ha.ovh.net (unknown [10.108.4.73])
	by mo575.mail-out.ovh.net (Postfix) with ESMTP id 5F8FE22E52
	for <broonie@kernel.org>; Tue,  5 Apr 2022 16:40:54 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player715.ha.ovh.net (Postfix) with ESMTPSA id F12DC2900AE2A;
	Tue,  5 Apr 2022 16:40:48 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-98R002e7e3a593-6777-45c4-9110-c0244ab646ae,
                    8BB3F008109FF1ACF458F8D30695C50246D29715) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Fabio Estevam <festevam@gmail.com>,
	Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: Wolfram Sang <wsa@kernel.org>,
	linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 18:40:31 +0200
Message-Id: <20220405164031.2160888-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8148700579943122566
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddttdcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepteegudfgleekieekteeggeetveefueefteeugfduieeitdfhhedtfeefkedvfeefnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeduhedrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: sgtl5000: use simple i2c probe function
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: 6QgnCAGF4Fip

The i2c probe functions here don't use the id information provided in
their second argument, so the single-parameter i2c probe function
("probe_new") can be used instead.

This avoids scanning the identifier tables during probes.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/sgtl5000.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index 8eebf27d0ea2..2aa48aef6a97 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1579,8 +1579,7 @@ static void sgtl5000_fill_defaults(struct i2c_client *client)
 	}
 }
 
-static int sgtl5000_i2c_probe(struct i2c_client *client,
-			      const struct i2c_device_id *id)
+static int sgtl5000_i2c_probe(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000;
 	int ret, reg, rev;
@@ -1821,7 +1820,7 @@ static struct i2c_driver sgtl5000_i2c_driver = {
 		.name = "sgtl5000",
 		.of_match_table = sgtl5000_dt_ids,
 	},
-	.probe = sgtl5000_i2c_probe,
+	.probe_new = sgtl5000_i2c_probe,
 	.remove = sgtl5000_i2c_remove,
 	.id_table = sgtl5000_id,
 };
-- 
2.27.0

