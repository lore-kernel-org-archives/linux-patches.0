Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6937470432;
	Tue, 21 Jul 2026 17:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656470; cv=none; b=nfww4+ezWvrtvGcktRl1iJ8Rh0XaLKc3QoOCde8/aPWiFTJLSIR4VjSv8koytk+SSr3TO/uEEyqg3CBSMiYUzijtP6L53kMbV9kI86ENM0UXeb5nf+jYx3qrq/3Hh87aiODcJjflmZiUpZB7g8fF4cAOb+UNsM04ZCSOF5waMN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656470; c=relaxed/simple;
	bh=O7D2IwxbRwFf6fV1XBaTxx6TJBUYrF4Ur4JWOL3lUCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0BjjuFM+ATPYr9oOxElc/dpimR+0Jr+UkYNzP8Wa/31QN/uJSgnFDwop6fK2sI8vcxZOzbyvFGz8SCO9HVkbyACkfUyq22TDz6HcT1/u7sxUrZhqgn0E3Vu9+M6Wg7EGrjyw2Zk7KYkmBbDTbtUuBsIp4cP6j+E/Ucl8XhPooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsYxauwV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsYxauwV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5936B1F000E9;
	Tue, 21 Jul 2026 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656468;
	bh=mA7v7HQ8+s86LoEVLJcq9k1juEnwkbhCZGyQjo6Ws7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GsYxauwVBfKQQ183gPfpxbibLzofL8vphnmH5KdXtd4j67pNqyyWmVwuMKNIQwZEU
	 EqL74HyuG1IOx32W66oWsxtPUAZiFekF7vS9s0olh43Phc8TLu8+ULynoDqPo1yOdq
	 7Rhye+Pk8y7fiv8ob7KTy9Wb8nA5IKjdLHR0GLEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Richard Cheng <icheng@nvidia.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0399/1611] ARM: configs: Drop duplicated CONFIG_EXT4_FS
Date: Tue, 21 Jul 2026 17:08:35 +0200
Message-ID: <20260721152524.205664659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 242a61208a0f80..631236c3ec3b5d 100644
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
index bb6c4748bfc80a..c7d0d531f0e0be 100644
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
index 7f3756d8b086d2..cd168dd85191a3 100644
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
index f67e9cda73e24f..82cc5e32e12cfe 100644
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
index 55f4ab67a30681..5f6272f06daccc 100644
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



