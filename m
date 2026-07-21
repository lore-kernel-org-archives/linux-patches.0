Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8429746C4CC;
	Tue, 21 Jul 2026 15:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649438; cv=none; b=Qe1Yh8jljQNcGOHqMGaTG2dmlrhuGLewluFmKLYPkrtSxHxpnHzgvV8EMmXSAUQO/2879cW/C4MiqH8ounvm2UvRmRi8a9pYLIdOSxO40guUrAwfbmpvviUTxM7OTNk/o496zqKRq4pazkv76qKlgrSKlny7czXOloA1i2akT4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649438; c=relaxed/simple;
	bh=yTcCGFLV+/GKW+kI5yCRfyyKafti4ie1ZESiCI6vdhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmJZHTXgNXmD7WW9ceTH8zxGPT/+qgDei7KrSP0drdHQfR4O8DoFhJof8MfIGnolNxHFq6IoF1e1Bgho0u2wRcb+WiR3ClW1pH3aPr/y+l+rforhidlyqEeN/FGGG630gAIY4puwFHN+FfXNQN/+g5jZNjRUJp1a5NKgBOx5GVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iBGh71W3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iBGh71W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2551F000E9;
	Tue, 21 Jul 2026 15:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649437;
	bh=vCP989MYa77fI6fBMlN9ry6u5wHDIuqyTM//Tqgn9JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBGh71W3f6rmNryNkFe4AKaxD43dmq0bspAAIi/zMZnG6jr3iQFfhAMImYLYUtU+D
	 An4xTqnyxiuZ1vHcKC/h7HIQO8488NryZ8Pjv+IY+eo4ue7gB6NNQiLsuwklWITk2e
	 zyXm+NRwmL71HA3FXo3Azl4+hfoAvp1pR/MP8tx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Richard Cheng <icheng@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0577/2077] ARM: configs: Drop duplicated CONFIG_EXT4_FS
Date: Tue, 21 Jul 2026 17:04:10 +0200
Message-ID: <20260721152606.417104251@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit ae371a58117d30a496e3be27cce8d9d13acdd740 ]

Remove redundant, duplicated CONFIG_EXT4_FS to fix warnings like:

  axm55xx_defconfig:198:warning: override: reassigning to symbol EXT4_FS

Fixes: c065b6046b34 ("Use CONFIG_EXT4_FS instead of CONFIG_EXT3_FS in all of the defconfigs")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
Link: https://lore.kernel.org/r/20260603072726.19404-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/configs/axm55xx_defconfig | 1 -
 arch/arm/configs/dove_defconfig    | 1 -
 arch/arm/configs/ep93xx_defconfig  | 1 -
 arch/arm/configs/mmp2_defconfig    | 1 -
 arch/arm/configs/mv78xx0_defconfig | 1 -
 5 files changed, 5 deletions(-)

diff --git a/arch/arm/configs/axm55xx_defconfig b/arch/arm/configs/axm55xx_defconfig
index 22b189090e15f4..0952e5e94c5e7f 100644
--- a/arch/arm/configs/axm55xx_defconfig
+++ b/arch/arm/configs/axm55xx_defconfig
@@ -195,7 +195,6 @@ CONFIG_PL320_MBOX=y
 # CONFIG_IOMMU_SUPPORT is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT4_FS=y
-CONFIG_EXT4_FS=y
 CONFIG_AUTOFS_FS=y
 CONFIG_FUSE_FS=y
 CONFIG_CUSE=y
diff --git a/arch/arm/configs/dove_defconfig b/arch/arm/configs/dove_defconfig
index e98c35df675e65..3d978ce34b54f0 100644
--- a/arch/arm/configs/dove_defconfig
+++ b/arch/arm/configs/dove_defconfig
@@ -97,7 +97,6 @@ CONFIG_MV_XOR=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT4_FS=y
 # CONFIG_EXT4_FS_XATTR is not set
-CONFIG_EXT4_FS=y
 CONFIG_ISO9660_FS=y
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
diff --git a/arch/arm/configs/ep93xx_defconfig b/arch/arm/configs/ep93xx_defconfig
index 9f3c7324d1cf48..ce41dc8c435cb5 100644
--- a/arch/arm/configs/ep93xx_defconfig
+++ b/arch/arm/configs/ep93xx_defconfig
@@ -105,7 +105,6 @@ CONFIG_EP93XX_DMA=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT4_FS=y
 # CONFIG_EXT4_FS_XATTR is not set
-CONFIG_EXT4_FS=y
 CONFIG_VFAT_FS=y
 CONFIG_TMPFS=y
 CONFIG_JFFS2_FS=y
diff --git a/arch/arm/configs/mmp2_defconfig b/arch/arm/configs/mmp2_defconfig
index a9a212abfd69ad..0ea608c75f2263 100644
--- a/arch/arm/configs/mmp2_defconfig
+++ b/arch/arm/configs/mmp2_defconfig
@@ -54,7 +54,6 @@ CONFIG_RTC_DRV_MAX8925=y
 # CONFIG_RESET_CONTROLLER is not set
 CONFIG_EXT2_FS=y
 CONFIG_EXT4_FS=y
-CONFIG_EXT4_FS=y
 # CONFIG_DNOTIFY is not set
 CONFIG_MSDOS_FS=y
 CONFIG_FAT_DEFAULT_CODEPAGE=437
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index d3a26efe766c4c..c6b46141cb697f 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -93,7 +93,6 @@ CONFIG_RTC_DRV_M41T80=y
 CONFIG_EXT2_FS=y
 CONFIG_EXT4_FS=y
 # CONFIG_EXT4_FS_XATTR is not set
-CONFIG_EXT4_FS=m
 CONFIG_ISO9660_FS=m
 CONFIG_JOLIET=y
 CONFIG_UDF_FS=m
-- 
2.53.0



