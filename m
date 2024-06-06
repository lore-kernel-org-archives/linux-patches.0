Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5000F197A65;
	Thu,  6 Jun 2024 14:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682997; cv=none; b=CZ7vFOcDoO7c8ANTpvE38aoMZQon1v7DLWED1iF56Z2XsmngHZug+/Yo3xj28QXIbSWxYSPCWV34Mpf/w1Eew0lzjBsFZSO5eRNqttf+T3uIMFqemVj4xQRKXHQPZpWuA/mhBg7dpEAvJuKOG5IISJjTjPLw2Yp82Pc0gdgeOgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682997; c=relaxed/simple;
	bh=CexMuudCj3dQuhPqNh7oU7rB0S0fm5ghnNdsMcdF9Ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvQNrqldiQBsBel/ai52BTguoDh95PHhRGH1abEs2R/lcUT/yTeEh/N6KSRiVDhSVAbOBlhRW7MN4PMAQLYg8WMMTdJ7Xe3qPrmTAcBN6FIOAIu8wxZPT94uMVH5Oz6wWDN6vrkk/M3rdPWdFBzZsQktjNHMGFOrLcyd+W3cVYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v6S22Fwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v6S22Fwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257AFC2BD10;
	Thu,  6 Jun 2024 14:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682997;
	bh=CexMuudCj3dQuhPqNh7oU7rB0S0fm5ghnNdsMcdF9Ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v6S22FwiVhV8AmB7y7suQNIbtsNTwFHEAHFB9M5jixLtPJ3dlxQNZdFjrvCwi1Avi
	 fCRgu61iHGsJGeBYCiUeXb25uW6WZtHEYsbzrlF4aPOVSWZ258GHBFdbAFffsOhKsA
	 qKs+chbKq+l7fTlci0/EN8v7GXC5neiw7eTnTwEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 197/374] media: sunxi: a83-mips-csi2: also select GENERIC_PHY
Date: Thu,  6 Jun 2024 16:02:56 +0200
Message-ID: <20240606131658.448395788@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 8237026159cb6760ad22e28d57b9a1c53b612d3a ]

When selecting GENERIC_PHY_MIPI_DPHY, also select GENERIC_PHY to
prevent kconfig warnings:

WARNING: unmet direct dependencies detected for GENERIC_PHY_MIPI_DPHY
  Depends on [n]: GENERIC_PHY [=n]
  Selected by [y]:
  - VIDEO_SUN8I_A83T_MIPI_CSI2 [=y] && MEDIA_SUPPORT [=y] && MEDIA_PLATFORM_SUPPORT [=y] && MEDIA_PLATFORM_DRIVERS [=y] && V4L_PLATFORM_DRIVERS [=y] && VIDEO_DEV [=y] && (ARCH_SUNXI || COMPILE_TEST [=y]) && PM [=y] && COMMON_CLK [=y] && RESET_CONTROLLER [=y]

Fixes: 94d7fd9692b5 ("media: sunxi: Depend on GENERIC_PHY_MIPI_DPHY")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/r/ZQ/WS8HC1A3F0Qn8@rli9-mobl
Link: https://lore.kernel.org/linux-media/20230927040438.5589-1-rdunlap@infradead.org

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig
index 47a8c0fb7eb9f..99c401e653bc4 100644
--- a/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig
+++ b/drivers/media/platform/sunxi/sun8i-a83t-mipi-csi2/Kconfig
@@ -8,6 +8,7 @@ config VIDEO_SUN8I_A83T_MIPI_CSI2
 	select VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
 	select REGMAP_MMIO
+	select GENERIC_PHY
 	select GENERIC_PHY_MIPI_DPHY
 	help
 	   Support for the Allwinner A83T MIPI CSI-2 controller and D-PHY.
-- 
2.43.0



