Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9437E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:45:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14945C433C1;
	Wed,  2 Nov 2022 02:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357140;
	bh=l4t+YWaFDJ3YvxRDOssbbrv7f4zHdvbXQOL+NQ1GlSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KjOcNDF92kR4mla8e+2xUmongWAig5ksqpEcdETKFJRXX/TE6F71/ygdJL9e2zpNN
	 0lx3F9HxPBMEJy2wQojPYMqQ2I9AUOEB3Mo90IrzeoDnDPoms5aVf776RO09Qtdr3T
	 tKOwVtvRpEskT0CJCAQahb2NN4L4/TprAcpWumq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	kernel test robot <lkp@intel.com>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 118/240] media: sun6i-mipi-csi2: Add a Kconfig dependency on RESET_CONTROLLER
Date: Wed,  2 Nov 2022 03:31:33 +0100
Message-Id: <20221102022114.055013757@linuxfoundation.org>
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

From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>

[ Upstream commit d0734dab5480325fd67548aa51ee126570d48574 ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

It also selects PHY_SUN6I_MIPI_DPHY, which depends on RESET_CONTROLLER.

Fixes: af54b4f4c17f ("media: sunxi: Add support for the A31 MIPI CSI-2 controller")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Reported-by: kernel test robot <lkp@intel.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig b/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
index 4d072abdfb70..08852f63692b 100644
--- a/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
+++ b/drivers/media/platform/sunxi/sun6i-mipi-csi2/Kconfig
@@ -3,7 +3,7 @@ config VIDEO_SUN6I_MIPI_CSI2
 	tristate "Allwinner A31 MIPI CSI-2 Controller Driver"
 	depends on V4L_PLATFORM_DRIVERS && VIDEO_DEV
 	depends on ARCH_SUNXI || COMPILE_TEST
-	depends on PM && COMMON_CLK
+	depends on PM && COMMON_CLK && RESET_CONTROLLER
 	depends on PHY_SUN6I_MIPI_DPHY
 	select MEDIA_CONTROLLER
 	select VIDEO_V4L2_SUBDEV_API
-- 
2.35.1



