Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7415F19CD07;
	Tue, 27 May 2025 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366999; cv=none; b=fCaMa3EoWggexmdw4wMr6Ohj1ewRXqVFXCoHioIGobDTdkU4LT+HnPbMaCxpKi8VVsqsIcBSkYvqDC2izrpmcrpI5w9yac+T6kZ/mTsLRcTXWmSBaCViVzgFa8eTBC+bYxGOmMTA2NwTT/ot5O9HNZ1PSE/PcwUk5pdgnQIkJhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366999; c=relaxed/simple;
	bh=UwGLYJDkmMH21MD7kQJQtUIafV8neAt6UnTLogqa+tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rOHghA/W0ufqqPwipTPrdZaaEmt9JDjSvRpsWkxVvhduLPJ817vVBu50tAuXwUjAeefujEtz3kbq9p/UrkzaZBSquaOWMycSiNBpdLibQSurZZDhPH3Swavk2ugxNvGVX7ezwvUaOesKG5ltdXofhP5xRivgCD6a9SmR5JEne78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=flyMfuQP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="flyMfuQP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E65E4C4CEE9;
	Tue, 27 May 2025 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366999;
	bh=UwGLYJDkmMH21MD7kQJQtUIafV8neAt6UnTLogqa+tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=flyMfuQPfJIKVPx7cuhdY6iFT93IQ6Fxd13EgV9eysyIt5RqEy4AjHRXsZtSwtaNB
	 KEIF1MNWlSCw6Y4JK9+rw4SfSOF6mG9hdKCKwDGhXEg7Dry2okC11CLaTpRbQx6ymh
	 XI0eEsvx/Wl1XSqJDGTrpGpaJ6Vf6eHfgkQ6s+DU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyunghwan Seo <khwan.seo@samsung.com>,
	Sangwook Shin <sw617.shin@samsung.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 244/783] watchdog: s3c2410_wdt: Fix PMU register bits for ExynosAutoV920 SoC
Date: Tue, 27 May 2025 18:20:41 +0200
Message-ID: <20250527162523.046453412@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyunghwan Seo <khwan.seo@samsung.com>

[ Upstream commit 480ee8a260e6f87cbcdaff77ac2cbf6dc03f0f4f ]

Fix the PMU register bits for the ExynosAutoV920 SoC.
This SoC has different bit information compared to its previous
version, ExynosAutoV9, and we have made the necessary adjustments.

rst_stat_bit:
    - ExynosAutoV920 cl0 : 0
    - ExynosAutoV920 cl1 : 1

cnt_en_bit:
    - ExynosAutoV920 cl0 : 8
    - ExynosAutoV920 cl1 : 8

Signed-off-by: Kyunghwan Seo <khwan.seo@samsung.com>
Signed-off-by: Sangwook Shin <sw617.shin@samsung.com>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20250213004104.3881711-1-sw617.shin@samsung.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/s3c2410_wdt.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/watchdog/s3c2410_wdt.c b/drivers/watchdog/s3c2410_wdt.c
index 30450e99e5e9d..bdd81d8074b24 100644
--- a/drivers/watchdog/s3c2410_wdt.c
+++ b/drivers/watchdog/s3c2410_wdt.c
@@ -72,6 +72,8 @@
 #define EXYNOS850_CLUSTER1_WDTRESET_BIT		23
 #define EXYNOSAUTOV9_CLUSTER0_WDTRESET_BIT	25
 #define EXYNOSAUTOV9_CLUSTER1_WDTRESET_BIT	24
+#define EXYNOSAUTOV920_CLUSTER0_WDTRESET_BIT	0
+#define EXYNOSAUTOV920_CLUSTER1_WDTRESET_BIT	1
 
 #define GS_CLUSTER0_NONCPU_OUT			0x1220
 #define GS_CLUSTER1_NONCPU_OUT			0x1420
@@ -312,9 +314,9 @@ static const struct s3c2410_wdt_variant drv_data_exynosautov920_cl0 = {
 	.mask_bit = 2,
 	.mask_reset_inv = true,
 	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
-	.rst_stat_bit = EXYNOSAUTOV9_CLUSTER0_WDTRESET_BIT,
+	.rst_stat_bit = EXYNOSAUTOV920_CLUSTER0_WDTRESET_BIT,
 	.cnt_en_reg = EXYNOSAUTOV920_CLUSTER0_NONCPU_OUT,
-	.cnt_en_bit = 7,
+	.cnt_en_bit = 8,
 	.quirks = QUIRK_HAS_WTCLRINT_REG | QUIRK_HAS_PMU_MASK_RESET |
 		  QUIRK_HAS_PMU_RST_STAT | QUIRK_HAS_PMU_CNT_EN |
 		  QUIRK_HAS_DBGACK_BIT,
@@ -325,9 +327,9 @@ static const struct s3c2410_wdt_variant drv_data_exynosautov920_cl1 = {
 	.mask_bit = 2,
 	.mask_reset_inv = true,
 	.rst_stat_reg = EXYNOS5_RST_STAT_REG_OFFSET,
-	.rst_stat_bit = EXYNOSAUTOV9_CLUSTER1_WDTRESET_BIT,
+	.rst_stat_bit = EXYNOSAUTOV920_CLUSTER1_WDTRESET_BIT,
 	.cnt_en_reg = EXYNOSAUTOV920_CLUSTER1_NONCPU_OUT,
-	.cnt_en_bit = 7,
+	.cnt_en_bit = 8,
 	.quirks = QUIRK_HAS_WTCLRINT_REG | QUIRK_HAS_PMU_MASK_RESET |
 		  QUIRK_HAS_PMU_RST_STAT | QUIRK_HAS_PMU_CNT_EN |
 		  QUIRK_HAS_DBGACK_BIT,
-- 
2.39.5



