Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC2B197542;
	Thu,  6 Jun 2024 14:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683694; cv=none; b=uYyWVLdZEm2OIyQTwDc5oqjCt/JGvUn1G8JpaGiraw34cKhKdpse70vkH4kOB5tZI2g7SLNOSP4yP/JfTxdsa/dVfXU1xlbPF9t4DZdJknkJKzr60WyitI1DsZXlyYfHZpk8garUdAFdcYFEsBB+FMiDfQieJyFKuvqXwi/xVaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683694; c=relaxed/simple;
	bh=VeqAjJ4hyYCjMILq31zNiuYu1OC2jfyVX+Jz2+5nNz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YHYkIfbUsl1AkruwLTOr6wS9Q89ICBcMXfDLZ6t+2ABxtosxcods0O3azMdSBAdMSeMlaNJAHtKmYjhZZgDcphrva+TG1vbWGQ8sC1ejShNfjMHYjqDLO1vzSqFp7Zp39BYti/eezKAXrYOr/G0r1x3e5IXtdC9OcZ+P9iXjmpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eSzSfD+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eSzSfD+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC563C4AF0C;
	Thu,  6 Jun 2024 14:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683694;
	bh=VeqAjJ4hyYCjMILq31zNiuYu1OC2jfyVX+Jz2+5nNz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eSzSfD+Rxe8xp4tqbu4q6i0R00mmwuur/0dMgSfgPka32Nan1QXTdWBsiEza2gLKD
	 QKX5lHvjtrxEMrM2AsgmkXDAJtsAxgAvvjgx0PsLh8Xo4CVMxCO0Y7ujzP4EkJgg50
	 TvABePpo1NQ0sEsjfA7f0s4u9RLhd2eiXjCqNrW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 606/744] media: sunxi: a83-mips-csi2: also select GENERIC_PHY
Date: Thu,  6 Jun 2024 16:04:38 +0200
Message-ID: <20240606131751.922634643@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



