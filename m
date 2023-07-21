Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227991F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:11:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96215C433C8;
	Fri, 21 Jul 2023 16:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955915;
	bh=vXPDJvcLKnoGF4uR2COdZjXKsH/WrlKNtGKTEPrF/MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8nP0NoMxSb0n/ctenLyGkx6Ty1+TK/d2kHQxJ/Qq6vjq2ZAeQkpjpoQxOhqgXM6e
	 pvrBYf33A7APID/z1ri3dxrl8g8hY2YxseSsZk14D5v5zpt2lopYgd39XlsluniR7E
	 skchFYD/MMFoAF52nYrYTF/ODf4BQjFrFm7XB4Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 047/292] drm/fbdev-dma: Fix documented default preferred_bpp value
Date: Fri, 21 Jul 2023 18:02:36 +0200
Message-ID: <20230721160530.825171337@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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

[ Upstream commit 15008052b34efaa86c1d56190ac73c4bf8c462f9 ]

As of commit 6c80a93be62d398e ("drm/fb-helper: Initialize fb-helper's
preferred BPP in prepare function"), the preferred_bpp parameter of
drm_fb_helper_prepare() defaults to 32 instead of
drm_mode_config.preferred_depth.  Hence this also applies to
drm_fbdev_dma_setup(), which just passes its own preferred_bpp
parameter.

Fixes: b79fe9abd58bab73 ("drm/fbdev-dma: Implement fbdev emulation for GEM DMA helpers")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/91f093ffe436a9f94d58fb2bfbc1407f1ebe8bb0.1688656591.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fbdev_dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fbdev_dma.c b/drivers/gpu/drm/drm_fbdev_dma.c
index 728deffcc0d92..e85cdf69cd6c4 100644
--- a/drivers/gpu/drm/drm_fbdev_dma.c
+++ b/drivers/gpu/drm/drm_fbdev_dma.c
@@ -218,7 +218,7 @@ static const struct drm_client_funcs drm_fbdev_dma_client_funcs = {
  * drm_fbdev_dma_setup() - Setup fbdev emulation for GEM DMA helpers
  * @dev: DRM device
  * @preferred_bpp: Preferred bits per pixel for the device.
- *                 @dev->mode_config.preferred_depth is used if this is zero.
+ *                 32 is used if this is zero.
  *
  * This function sets up fbdev emulation for GEM DMA drivers that support
  * dumb buffers with a virtual address and that can be mmap'ed.
-- 
2.39.2



