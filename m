Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB957E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0B4C43470;
	Wed,  2 Nov 2022 02:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357111;
	bh=56fgF7glm+tF5wxP8ChM8F2dw51U2KfXP21d7uUtnsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrFBBseDF0Qel2v5AeBIuNdewO6onXrdyE5GpN/YkkWK2XC6rZ2Kcl1rWvQ2Ea+cc
	 c8Lg17KqxljIYBg1lNYcUOPAXzkVCyLXYTLB8F3nDqbrgvQ3dD8YzyINfjbz1jqenD
	 OGkaN8FAjQtZWCxy1UpkYgT24adaIurY1MsUUlpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 114/240] media: sun6i-mipi-csi2: Depend on PHY_SUN6I_MIPI_DPHY
Date: Wed,  2 Nov 2022 03:31:29 +0100
Message-Id: <20221102022113.966000593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit ff37bc8c7099b673e9838bfbd0de78eff740316b ]

PHY_SUN6I_MIPI_DPHY is not a freely selectable option and so may not
always be available. Depend on it instead.

Fixes: 94d7fd9692b5 ("media: sunxi: Depend on GENERIC_PHY_MIPI_DPHY")
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig b/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
index eb982466abd3..4d072abdfb70 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
@@ -4,10 +4,10 @@ config VIDEO_SUN6I_MIPI_CSI2
 	depends on V4L_PLATFORM_DRIVERS && VIDEO_DEV
 	depends on ARCH_SUNXI || COMPILE_TEST
 	depends on PM && COMMON_CLK
+	depends on PHY_SUN6I_MIPI_DPHY
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
 	select V4L2_FWNODE
-	select PHY_SUN6I_MIPI_DPHY
 	select GENERIC_PHY_MIPI_DPHY
 	select REGMAP_MMIO
 	help
-- 
2.35.1



