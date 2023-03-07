Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FF9BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAF1C433D2;
	Tue,  7 Mar 2023 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209880;
	bh=S44YbCTOg4qaio8+Q0lxhklfMmScvyF6R6M3WLVfHkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ptx3D+qTvNG4UkIAUkoCM7lpYQ1npmPcv3NvVzs9J9oORX5QhFbU4r+kvDwcgMutr
	 XXEpFUdXT4iTVeQXHnRcrfY8Xy9a21R2OqkDyEG43VW7s/uTLg9MQ0XdA36LY/vDfP
	 gj6o6VWEwgAblkQlkJfdGoIevcAaIdx2rt8oo0WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Marek Vasut <marex@denx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0331/1001] drm: mxsfb: DRM_MXSFB should depend on ARCH_MXS || ARCH_MXC
Date: Tue,  7 Mar 2023 17:51:43 +0100
Message-Id: <20230307170035.859200437@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 7783cc67862f9166c901bfa0f80b717aa8d354dd ]

Freescale/NXP i.MX LCDIF and eLCDIF LCD controllers are only present on
Freescale/NXP i.MX SoCs.  Hence add a dependency on ARCH_MXS ||
ARCH_MXC, to prevent asking the user about this driver when configuring
a kernel without Freescale/NXP i.MX support.

Fixes: 45d59d704080cc0c ("drm: Add new driver for MXSFB controller")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Marek Vasut <marex@denx.de>
Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://patchwork.freedesktop.org/patch/msgid/98e74779ca2bc575d91afff03369e86b080c01ac.1669046358.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index aa4b0eb2a562b..518b533453548 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -8,6 +8,7 @@ config DRM_MXSFB
 	tristate "i.MX (e)LCDIF LCD controller"
 	depends on DRM && OF
 	depends on COMMON_CLK
+	depends on ARCH_MXS || ARCH_MXC || COMPILE_TEST
 	select DRM_MXS
 	select DRM_KMS_HELPER
 	select DRM_GEM_DMA_HELPER
-- 
2.39.2



