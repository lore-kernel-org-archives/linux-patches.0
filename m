Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652B1335BD4;
	Mon, 18 Aug 2025 13:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525222; cv=none; b=Y+Dt9V9CvMkIsyBAPSpk3IgWDVeXHr1gb8JLJG4MVOZwXEKTsir9UeF65ja3HXF12NxKeIQKtyWLxZ8ORYfcISw5t2CrDelZQjNjmnM09ioD058LKyG3MihMhyLWfcGDliRdNFG0Du/NAuh+B4o/TSnz2Go5YIPxOFXAZqPMyBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525222; c=relaxed/simple;
	bh=JAIXG6+2etU7O0+ofvWTwWDFsiJkxvhuzK9mfXUHNGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EwzOKOMiMACW5pv88WEqgJ/ccPbu8fH7Imng0+UL+djkzE7DqxeLKDoIsMkpUXA1B9dVeySRWaDprmlP9u2o8XT68Fq3ARUKjUBAg3uxISGUnfK/gc+r0q6zVoE+AlFDLvW/Tfbtm41B3vr0uxSCdKFUShLc0rNzir1/R8mFhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEkxUHbo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEkxUHbo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D8DC4CEEB;
	Mon, 18 Aug 2025 13:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525222;
	bh=JAIXG6+2etU7O0+ofvWTwWDFsiJkxvhuzK9mfXUHNGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEkxUHboIbq9vRetqE1ubqcVEGFBkgPO/4PL5jPoegSlFBExWc5kI+DneUnV6O5Q2
	 /VJfJzlLF122mXupk6Dp6M78rqU+GddKtTWOopS2cgpDc0ceezrOIpM8SxOoA1pVe4
	 6nL41KNqaWfN0jCTnUM5QoYIGNEbacyVN3sZH7Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Krzysztof=20Ha=C5=82asa?= <khalasa@piap.pl>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 195/570] imx8m-blk-ctrl: set ISI panic write hurry level
Date: Mon, 18 Aug 2025 14:43:02 +0200
Message-ID: <20250818124513.312839829@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Hałasa <khalasa@piap.pl>

[ Upstream commit c01fba0b4869cada5403fffff416cd1675dba078 ]

Apparently, ISI needs cache settings similar to LCDIF.
Otherwise we get artefacts in the image.
Tested on i.MX8MP.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>
Link: https://lore.kernel.org/r/m3ldr69lsw.fsf@t19.piap.pl
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/pmdomain/imx/imx8m-blk-ctrl.c b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
index 912802b5215b..5c83e5599f1e 100644
--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -665,6 +665,11 @@ static const struct imx8m_blk_ctrl_data imx8mn_disp_blk_ctl_dev_data = {
 #define  LCDIF_1_RD_HURRY	GENMASK(15, 13)
 #define  LCDIF_0_RD_HURRY	GENMASK(12, 10)
 
+#define ISI_CACHE_CTRL		0x50
+#define  ISI_V_WR_HURRY		GENMASK(28, 26)
+#define  ISI_U_WR_HURRY		GENMASK(25, 23)
+#define  ISI_Y_WR_HURRY		GENMASK(22, 20)
+
 static int imx8mp_media_power_notifier(struct notifier_block *nb,
 				unsigned long action, void *data)
 {
@@ -694,6 +699,11 @@ static int imx8mp_media_power_notifier(struct notifier_block *nb,
 		regmap_set_bits(bc->regmap, LCDIF_ARCACHE_CTRL,
 				FIELD_PREP(LCDIF_1_RD_HURRY, 7) |
 				FIELD_PREP(LCDIF_0_RD_HURRY, 7));
+		/* Same here for ISI */
+		regmap_set_bits(bc->regmap, ISI_CACHE_CTRL,
+				FIELD_PREP(ISI_V_WR_HURRY, 7) |
+				FIELD_PREP(ISI_U_WR_HURRY, 7) |
+				FIELD_PREP(ISI_Y_WR_HURRY, 7));
 	}
 
 	return NOTIFY_OK;
-- 
2.39.5



