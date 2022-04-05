Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F7D321B
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6FEC385A1
	for <patches@lists.linux.dev>; Tue,  5 Apr 2022 17:24:48 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 5 Apr 2022 18:24:45 +0100
Resent-Message-ID: <Ykx7XcoridskNaCt@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 05 Apr 2022 18:12:33 +0100
Received: from dfw.source.kernel.org ([139.178.84.217])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=B7gE=UP=sk2.org=steve@kernel.org>)
	id 1nbmjH-007VHy-CG
	for broonie@sirena.co.uk; Tue, 05 Apr 2022 18:12:33 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.source.kernel.org (Postfix) with ESMTPS id 198596181A
	for <broonie@sirena.co.uk>; Tue,  5 Apr 2022 17:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 934F8C385A0; Tue,  5 Apr 2022 17:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C6FADC385A4
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:12:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org C6FADC385A4
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=sk2.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=sk2.org
Received: from player762.ha.ovh.net (unknown [10.109.156.142])
	by mo550.mail-out.ovh.net (Postfix) with ESMTP id 1BF1623474
	for <broonie@kernel.org>; Tue,  5 Apr 2022 17:12:25 +0000 (UTC)
Received: from sk2.org (82-65-25-201.subs.proxad.net [82.65.25.201])
	(Authenticated sender: steve@sk2.org)
	by player762.ha.ovh.net (Postfix) with ESMTPSA id 61C2F29206EEE;
	Tue,  5 Apr 2022 17:12:21 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-97G002ee460736-7180-41c2-ae20-0f3875438c60,
                    8AF55017BACD44284FC599BC4826E0280D36FCC4) smtp.auth=steve@sk2.org
X-OVh-ClientIp:82.65.25.201
From: Stephen Kitt <steve@sk2.org>
To: Liam Girdwood <lgirdwood@gmail.com>,
	Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Stephen Kitt <steve@sk2.org>
Date: Tue,  5 Apr 2022 19:11:58 +0200
Message-Id: <20220405171158.2168762-1-steve@sk2.org>
X-Mailer: git-send-email 2.27.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 8680688283019937414
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedvvddrudejgedguddtiecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepufhtvghphhgvnhcumfhithhtuceoshhtvghvvgesshhkvddrohhrgheqnecuggftrfgrthhtvghrnhepteegudfgleekieekteeggeetveefueefteeugfduieeitdfhhedtfeefkedvfeefnecukfhppedtrddtrddtrddtpdekvddrieehrddvhedrvddtudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhhouggvpehsmhhtphhouhhtpdhhvghlohepphhlrgihvghrjeeivddrhhgrrdhovhhhrdhnvghtpdhinhgvtheptddrtddrtddrtddpmhgrihhlfhhrohhmpehsthgvvhgvsehskhdvrdhorhhgpdhnsggprhgtphhtthhopedupdhrtghpthhtohepsghrohhonhhivgeskhgvrhhnvghlrdhorhhg
X-SA-Exim-Connect-IP: 139.178.84.217
X-SA-Exim-Mail-From: SRS0=B7gE=UP=sk2.org=steve@kernel.org
Subject: [PATCH] ASoC: rt1016: enable building
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: FMV5h+gt+I39

The rt1016 driver wasn't listed in Kconfig and Makefile, which AFAICT
means it isn't ever built. This patch adds the appropriate entries to
Kconfig and Makefile.

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 sound/soc/codecs/Kconfig  | 5 +++++
 sound/soc/codecs/Makefile | 2 ++
 2 files changed, 7 insertions(+)

diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index f46a22660103..986aec12d5e4 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -168,6 +168,7 @@ config SND_SOC_ALL_CODECS
 	imply SND_SOC_RT1011
 	imply SND_SOC_RT1015
 	imply SND_SOC_RT1015P
+	imply SND_SOC_RT1016
 	imply SND_SOC_RT1019
 	imply SND_SOC_RT1305
 	imply SND_SOC_RT1308
@@ -1215,6 +1216,10 @@ config SND_SOC_RT1015P
 	tristate
 	depends on GPIOLIB
 
+config SND_SOC_RT1016
+	tristate
+	depends on I2C
+
 config SND_SOC_RT1019
 	tristate
 	depends on I2C
diff --git a/sound/soc/codecs/Makefile b/sound/soc/codecs/Makefile
index 8637e9e869e3..a955cd5a8cff 100644
--- a/sound/soc/codecs/Makefile
+++ b/sound/soc/codecs/Makefile
@@ -181,6 +181,7 @@ snd-soc-rl6347a-objs := rl6347a.o
 snd-soc-rt1011-objs := rt1011.o
 snd-soc-rt1015-objs := rt1015.o
 snd-soc-rt1015p-objs := rt1015p.o
+snd-soc-rt1016-objs := rt1016.o
 snd-soc-rt1019-objs := rt1019.o
 snd-soc-rt1305-objs := rt1305.o
 snd-soc-rt1308-objs := rt1308.o
@@ -520,6 +521,7 @@ obj-$(CONFIG_SND_SOC_RL6347A)	+= snd-soc-rl6347a.o
 obj-$(CONFIG_SND_SOC_RT1011)	+= snd-soc-rt1011.o
 obj-$(CONFIG_SND_SOC_RT1015)	+= snd-soc-rt1015.o
 obj-$(CONFIG_SND_SOC_RT1015P)	+= snd-soc-rt1015p.o
+obj-$(CONFIG_SND_SOC_RT1016)	+= snd-soc-rt1016.o
 obj-$(CONFIG_SND_SOC_RT1019)	+= snd-soc-rt1019.o
 obj-$(CONFIG_SND_SOC_RT1305)	+= snd-soc-rt1305.o
 obj-$(CONFIG_SND_SOC_RT1308)	+= snd-soc-rt1308.o
-- 
2.27.0

