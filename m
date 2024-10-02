Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D66B1D07B8;
	Wed,  2 Oct 2024 13:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876212; cv=none; b=aKeugbBqroewqpQ6QGosZK7kHn90has3QjA3nphGSF0BXMB1o/CbM97++FW8quEJr4IU4t2VB9QOY1L5B0jrgf9X2Us7b5+CPhHKcMUMAE1Dfp+EiGT62qELRwRmDgj3pPGe4n3GOYIglireqENux0s3/YsbeXfrIZjTuh+0g/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876212; c=relaxed/simple;
	bh=8WpS7GA2QmRo5AcUnxvJy8H98dvAVp+D8olyT45zOQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W7jCnClv9lB4xDJjFGS/UAF2un1TKmBAl+qlqnFFZEjjZhFvuxvfOm0HDVBnr0jkcPSgs0OuKeSr8kyTKWSPDTKIrxgsTyf6u0wlgEwq7s505K+wP+9/4jSnvTvINXdH6g+skE4ZpnOacerFk+Ks3Getp9+K2yStUggFuMpPV2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FTMf3SuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FTMf3SuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A9FFC4CEC5;
	Wed,  2 Oct 2024 13:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876211;
	bh=8WpS7GA2QmRo5AcUnxvJy8H98dvAVp+D8olyT45zOQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FTMf3SuUSBxjXVIvGKtxr71tc+2QDW4sHwDdPv/PaeR7jwCTUa7H4h780XUVSy2Uy
	 AN9sdHf0ojGw2OptBp0m7B7m2guHVJjN18KgewLgxDnzTN7Hg+aDywoUWRdgH33TwF
	 oyuStfmq+4QLF/gIxply8mmM9g4XDhZ4xPIloqms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	FLorian Fainelli <florian.fainelli@broadcom.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 367/695] media: raspberrypi: VIDEO_RASPBERRYPI_PISP_BE should depend on ARCH_BCM2835
Date: Wed,  2 Oct 2024 14:56:05 +0200
Message-ID: <20241002125837.098240949@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit c8ad75010c5bafe014860f33fc73a887ab561209 ]

Currently, the Raspberry Pi PiSP Backend (BE) ISP is only present on the
Broadcom BCM2712-based Raspberry Pi 5.  Hence add a dependency on
ARCH_BCM2835, to prevent asking the user about this driver when
configuring a kernel without Broadcom BCM2835 family support.  The
dependency can be relaxed if/when the encoder appears on other SoC
families.

Fixes: 12187bd5d4f8 ("media: raspberrypi: Add support for PiSP BE")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: FLorian Fainelli <florian.fainelli@broadcom.com>
Acked-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/raspberrypi/pisp_be/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/raspberrypi/pisp_be/Kconfig b/drivers/media/platform/raspberrypi/pisp_be/Kconfig
index 38c0f8305d620..46765a2e4c4d1 100644
--- a/drivers/media/platform/raspberrypi/pisp_be/Kconfig
+++ b/drivers/media/platform/raspberrypi/pisp_be/Kconfig
@@ -2,6 +2,7 @@ config VIDEO_RASPBERRYPI_PISP_BE
 	tristate "Raspberry Pi PiSP Backend (BE) ISP driver"
 	depends on V4L_PLATFORM_DRIVERS
 	depends on VIDEO_DEV
+	depends on ARCH_BCM2835 || COMPILE_TEST
 	select VIDEO_V4L2_SUBDEV_API
 	select MEDIA_CONTROLLER
 	select VIDEOBUF2_DMA_CONTIG
-- 
2.43.0



