Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921C37E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:48:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1B9C433C1;
	Wed,  2 Nov 2022 02:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357318;
	bh=O0yOEhTdeaZXFNDWdVfkyMA6oUScz5Yu3idsXP5+wkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ndEEj7PZ4sMgitVvKV3yl5Z09SrVeBuDQvo/hPZbfseaopgsry7mtjEjm0tl7Pgmq
	 X5muGmbuiKlXhsTDkrR34tiWBfxDO9wS5+I4B6A2p5hLqUR3tMpq200K/iz03tdddU
	 qQk4+m6ozdC0WZxmCVJ/boFxIsnNonOfHb/p9gG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 122/240] media: sun8i-di: Add a Kconfig dependency on RESET_CONTROLLER
Date: Wed,  2 Nov 2022 03:31:37 +0100
Message-Id: <20221102022114.142880691@linuxfoundation.org>
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

[ Upstream commit c2a46b19f0340e6647168f4ceac4e5e4cb9197d8 ]

The driver relies on the reset controller API to work, so add
RESET_CONTROLLER as one of its Kconfig dependencies.

Fixes: a4260ea49547 ("media: sun4i: Add H3 deinterlace driver")
Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/sunxi/sun8i-di/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/sunxi/sun8i-di/Kconfig b/drivers/media/platform/sunxi/sun8i-di/Kconfig
index ff71e06ee2df..f688396913b7 100644
--- a/drivers/media/platform/sunxi/sun8i-di/Kconfig
+++ b/drivers/media/platform/sunxi/sun8i-di/Kconfig
@@ -4,7 +4,7 @@ config VIDEO_SUN8I_DEINTERLACE
 	depends on V4L_MEM2MEM_DRIVERS
 	depends on VIDEO_DEV
 	depends on ARCH_SUNXI || COMPILE_TEST
-	depends on COMMON_CLK && OF
+	depends on COMMON_CLK && RESET_CONTROLLER && OF
 	depends on PM
 	select VIDEOBUF2_DMA_CONTIG
 	select V4L2_MEM2MEM_DEV
-- 
2.35.1



