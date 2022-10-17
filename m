Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1042C2568
	for <patches@lists.linux.dev>; Mon, 17 Oct 2022 14:42:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14137C433D7
	for <patches@lists.linux.dev>; Mon, 17 Oct 2022 14:42:04 +0000 (UTC)
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Mon, 17 Oct 2022 15:42:01 +0100
Resent-Message-ID: <Y01puQRVKJYMiQhB@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Mon, 17 Oct 2022 15:18:40 +0100
Received: from ams.source.kernel.org ([145.40.68.75])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=CBIs=2S=cdjrlc.com=dengshaomin@kernel.org>)
	id 1okQwv-004Kb3-OU
	for broonie@sirena.co.uk; Mon, 17 Oct 2022 15:18:40 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id CB404B8188E
	for <broonie@sirena.co.uk>; Mon, 17 Oct 2022 14:18:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 91E09C433D7; Mon, 17 Oct 2022 14:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51B23C433D6
	for <broonie@kernel.org>; Mon, 17 Oct 2022 14:18:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org 51B23C433D6
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=cdjrlc.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=cdjrlc.com
X-QQ-mid: bizesmtp71t1666016302tkpi2ar1
Received: from localhost.localdomain ( [182.148.15.91])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 17 Oct 2022 22:18:13 +0800 (CST)
X-QQ-SSF: 01000000002000C0D000B00A0000000
X-QQ-FEAT: kN2ypXZVqgznr745HoYYfcjbnqt2IYXJ8zNUqQQ2jXHXV0/U9Z3y1pXHjWP4l
	Cvg3cRQBBPOsq6BI0feA4p8qdnry0QrOxSEQCZGSJbsJ8YOV3Ai/g6617jwq/mRFKiz8bAw
	1HksSdHkfYntui5RwBa6vxvnvjRCj7mFPn0xD5unW6jEzzcFBlhXnho6QANQNu+wOgcDTNS
	5TIchWRVKd85eQFCJF6DQrH9QEcosPBPcygqvURV+qh3Y3jCKkJ2sZxZpaU0U7EeL/oXbD4
	JAF44i+eYMBiQ8aj3TPAONuALV7rcgJmyr2qi7fsQBd4G7QKV6BkHMKzzsCmI0pi2PrHN/y
	LJOIwzPXrTLpD5dVgDvJuv+s061UNswsUGDQJqn9v7iNyR1GabtEyRTXTE+/hgxzVBEv0e7
X-QQ-GoodBg: 0
From: Shaomin Deng <dengshaomin@cdjrlc.com>
To: jbrunet@baylibre.com,
	perex@perex.cz,
	tiwai@suse.com,
	neil.armstrong@linaro.org,
	khilman@baylibre.com
Cc: lgirdwood@gmail.com,
	broonie@kernel.org,
	Shaomin Deng <dengshaomin@cdjrlc.com>
Date: Mon, 17 Oct 2022 10:18:12 -0400
Message-Id: <20221017141812.6867-1-dengshaomin@cdjrlc.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-SA-Exim-Connect-IP: 145.40.68.75
X-SA-Exim-Mail-From: SRS0=CBIs=2S=cdjrlc.com=dengshaomin@kernel.org
Subject: [PATCH] ASoC: meson: axg-pdm: Fix double word in comments
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: hmkHrgLDSToj

Delete the doubled word "for" in comments.

Signed-off-by: Shaomin Deng <dengshaomin@cdjrlc.com>
---
 sound/soc/meson/axg-pdm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/meson/axg-pdm.c b/sound/soc/meson/axg-pdm.c
index 88ac58272f95..ad43cb2a1e3f 100644
--- a/sound/soc/meson/axg-pdm.c
+++ b/sound/soc/meson/axg-pdm.c
@@ -169,7 +169,7 @@ static int axg_pdm_set_sysclk(struct axg_pdm *priv, unsigned int os,
 
 	/*
 	 * Set the default system clock rate unless it is too fast for
-	 * for the requested sample rate. In this case, the sample pointer
+	 * the requested sample rate. In this case, the sample pointer
 	 * counter could overflow so set a lower system clock rate
 	 */
 	if (sys_rate < priv->cfg->sys_rate)
-- 
2.35.1

