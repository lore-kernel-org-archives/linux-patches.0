Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B648F19DF6B;
	Thu,  6 Jun 2024 14:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683497; cv=none; b=AICE+L3kyq7IP2996zJAR3pQiJUJke9BijNdtFbiJSWimQRkQtdYQ5kmhWJ7zF0sRnC6GILXY5JlGAkPsP+h4uj+iDgaKK0hAi7lX6dYs7wJGgfmAeGjFbKXq3LjeN9mJDrx6bZH7oJ2DPbRN2WYJxmwoGtobepJfGY+N4tdflU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683497; c=relaxed/simple;
	bh=TNNt4GPtA88Qg8VzOgX3Zwhn8+aM//exB3zQDTlzc+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jx6V8sSRvKn064zCC46eBfIoOVNt7G/fKtDheF8pr2t6VwlfvIn7vk0eNazj/E6MKlbJab9WLPT0Se0dAgzEL1sDyOoPm0RbZXpavvc6hPg63mtR9SaNIFA9PIBBg5fA5o52qplkvH2OwWRZ/HSWUCJoPmkD+z0MkKFVNFi8658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NUOvuULL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NUOvuULL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9135FC2BD10;
	Thu,  6 Jun 2024 14:18:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683497;
	bh=TNNt4GPtA88Qg8VzOgX3Zwhn8+aM//exB3zQDTlzc+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NUOvuULLSYzdRTgLda8rVjHSirmN9DcDDwD6ZnZigZFyeLSNRQzcwTb7P/s+BI3Fh
	 +hQqjzPZQOyi2I6CkNz/GrOc2gIZRKzgTvdNOrE7xGNgtKJwcecbuCvYMCseQa6KcN
	 khZySegKFF3vGIWty+reh9dqIptiJm3gJyqLvU/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 387/473] media: sunxi: a83-mips-csi2: also select GENERIC_PHY
Date: Thu,  6 Jun 2024 16:05:16 +0200
Message-ID: <20240606131712.649369955@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



