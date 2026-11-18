Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025520;
	b=v8sSSrLBEgoddZDGHBk8Cy/Qg0bjrC5bq7lfI7Qlh8CETC8ynoywLFGZSO8PqA6IYdnP
	 0M4kfUUcr8Ll3vXV+LAStRd8MzueEqcVXNZ6cHTuyXoQyfp1BU20lkiwuIsxEHkfqK0ju
	 mcDGAH3ujqoB189U7hcrjPRTmEU4WSJl3lKJyCxj/nbQDOfdtdlEHhvR3suJ7PohLAcfb
	 BoIewKxvUaE9NAJeBrW5U0JZCOb4ZNUi5oMPHT2f6w8oZW7V2TpMb7gGVEjj5CkOfunuM
	 tnUgZdfhT4CN3cLWko9WVNF4AHsCf8OXzLK6ghiJDgRoPyNwMmP5/YS+yJwYiFX9ftg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025520;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=df+Y0HBt8vnTURj+bOGZ3JZcDFjr7b9qVW+dvoSfLgc=;
	b=vhCMUtw5636LAaER/56l6v7bupaSWAIcrS1TziA6NzlIz5+3ngNL93w2XarAFac85ijP
	 JGGj4MzdqMs/c0Pv+J/F/XU5FRyGqDrkAnnxUW6izSsOc+l5oEenBVHYNgEjjOGe7mxby
	 FXrPvlU/YQ/8QgCu8jpaHfKMNvnAxWxGaAmS+O6p2UhyhB62vGN6cuPCj9EOpOIWZ0j7t
	 aeXnmwrEkPzSdQfg8ApzF3J0yt4gTunTZ2KKRjtBY7xsjgHgG+Xkc/r7vTifjbL1860mE
	 ZiojWwRg5P/fy6OTa7tyqdctpfys+ECShVd8wNp2B9QSrPPk642G48RuoSIou37bw/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLY6N7AE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09F93606A31C;
	Wed, 18 Nov 2026 18:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YLY6N7AE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6178B1F000C4;
	Wed, 18 Nov 2026 18:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025519;
	bh=df+Y0HBt8vnTURj+bOGZ3JZcDFjr7b9qVW+dvoSfLgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YLY6N7AElBo5njgbkI4tkrAec59IdSulDng3KedD/S5nniZjjq4UMezDYEKCHrbxN
	 zbd0X7U80VbKsjV/uWGCWpQIRlHlq4wxOnAHUctfdeSL/VOvQFqAOValIAIbthUgVP
	 W6ecInAk4JjixkgNhw7ImMPcbRn4xXI+GeOyDyP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nadim Kobeissi <nadim@symbolic.software>,
	Xia Yunan <imitoy@imitoy.top>,
	Munzir Taha <munzirtaha@gmail.com>,
	Marco Giunta <marco_giunta@outlook.it>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1066/2151] ASoC: aw88399: add per-instance BSTS status bypass flag
Date: Wed, 18 Nov 2026 15:46:41 +0100
Message-ID: <20261118150201.128167893@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Giunta <marco_giunta@outlook.it>

[ Upstream commit b4530a3e4895abfc308e2b45c0ea508f4dddd9f1 ]

Add a bsts_unreliable flag to struct aw88399 that, when set, causes
the startup status check (aw_dev_check_sysst) to skip the BSTS
(boost startup finished) requirement.

On some hardware, the BSTS bit in the SYSST register (0x01, bit 9)
does not reliably assert even during normal audio playback. Register
inspection on affected Lenovo Legion hardware shows both amplifiers
reporting BSTS=0 on both channels despite clean audio output.

Per the AW88399 datasheet, BSTS indicates boost startup completion.
If BSTS never reliably sets to 1, the chip is never allowed to start
by aw_dev_check_sysst, regardless of whether the boot failure is genuine.

The new flag defaults to false via kzalloc, preserving the original check
behavior for all existing users. No existing code path sets this flag;
it will be set by the forthcoming HDA side codec property driver for
affected hardware.

Tested-by: Nadim Kobeissi <nadim@symbolic.software>
Tested-by: Xia Yun'an <imitoy@imitoy.top>
Tested-by: Munzir Taha <munzirtaha@gmail.com>
Signed-off-by: Marco Giunta <marco_giunta@outlook.it>
Link: https://patch.msgid.link/DS7PR19MB77242B8E5BB8BFB5E69816E9FCC62@DS7PR19MB7724.namprd19.prod.outlook.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 664824782df6 ("ASoC: aw88399: skip BSTS check when boost converter is bypassed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/aw88399.h        |  1 +
 sound/soc/codecs/aw88399-lib.c | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/sound/aw88399.h b/include/sound/aw88399.h
index 3a2153f0ee924..dee91b540b81f 100644
--- a/include/sound/aw88399.h
+++ b/include/sound/aw88399.h
@@ -598,6 +598,7 @@ struct aw88399 {
 	unsigned int crc_init_val;
 	unsigned int vcalb_init_val;
 	unsigned int dither_st;
+	bool bsts_unreliable;
 };
 
 int aw_dev_check_syspll(struct aw_device *aw_dev);
diff --git a/sound/soc/codecs/aw88399-lib.c b/sound/soc/codecs/aw88399-lib.c
index 258d6efbf590c..cdb4f8241c6fc 100644
--- a/sound/soc/codecs/aw88399-lib.c
+++ b/sound/soc/codecs/aw88399-lib.c
@@ -167,8 +167,9 @@ int aw_dev_check_syspll(struct aw_device *aw_dev)
 }
 EXPORT_SYMBOL_GPL(aw_dev_check_syspll);
 
-static int aw_dev_check_sysst(struct aw_device *aw_dev)
+static int aw_dev_check_sysst(struct aw88399 *aw88399)
 {
+	struct aw_device *aw_dev = aw88399->aw_pa;
 	unsigned int check_val;
 	unsigned int reg_val;
 	int ret, i;
@@ -182,6 +183,14 @@ static int aw_dev_check_sysst(struct aw_device *aw_dev)
 	else
 		check_val = AW88399_BIT_SYSST_SWS_CHECK;
 
+	/*
+	 * On some hardware the BSTS (boost-finished) status bit does not
+	 * reliably assert even when audio output is working normally.
+	 * Allow per-instance bypass when flagged by the side-codec driver.
+	 */
+	if (aw88399->bsts_unreliable)
+		check_val &= ~AW88399_BSTS_FINISHED_VALUE;
+
 	for (i = 0; i < AW88399_DEV_SYSST_CHECK_MAX; i++) {
 		ret = regmap_read(aw_dev->regmap, AW88399_SYSST_REG, &reg_val);
 		if (ret)
@@ -710,7 +719,7 @@ static int aw88399_dev_start(struct aw88399 *aw88399)
 	usleep_range(AW88399_1000_US, AW88399_1000_US + 50);
 
 	/* check i2s status */
-	ret = aw_dev_check_sysst(aw_dev);
+	ret = aw_dev_check_sysst(aw88399);
 	if (ret) {
 		dev_err(aw_dev->dev, "sysst check failed");
 		goto sysst_check_fail;
-- 
2.53.0



