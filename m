Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D5911710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5306FC433C8;
	Mon, 11 Sep 2023 15:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694445274;
	bh=gjtaWRS4iCVwGr0QJYek1EEKC6Zmjl7dNrZShyHWqcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oF40JuCESR49B7QNej1gZvxwLQ2CExfGYcakZR4P2Mw2IGF00WdREfvI48sRqqODp
	 ySfwlnKVf2meq+4PemSjHC34M3aphdNEuJmAbPtViuUx+j7pxqf/F7x8gdHELxLx+0
	 v7VcAs3Plx5BLeWaHHM3GJzyE7+FwuZ/zR+4WalI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 288/600] drm/repaper: Reduce temporary buffer size in repaper_fb_dirty()
Date: Mon, 11 Sep 2023 15:45:21 +0200
Message-ID: <20230911134642.111093075@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit fedf429e071f6dbbe7a69dfc342492e037692018 ]

As the temporary buffer is no longer used to store 8-bit grayscale data,
its size can be reduced to the size needed to store the monochrome
bitmap data.

Fixes: 24c6bedefbe71de9 ("drm/repaper: Use format helper for xrgb8888 to monochrome conversion")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Signed-off-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220317081830.1211400-6-geert@linux-m68k.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tiny/repaper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tiny/repaper.c b/drivers/gpu/drm/tiny/repaper.c
index e62f4d16b2c6b..7e2b0e2241358 100644
--- a/drivers/gpu/drm/tiny/repaper.c
+++ b/drivers/gpu/drm/tiny/repaper.c
@@ -533,7 +533,7 @@ static int repaper_fb_dirty(struct drm_framebuffer *fb)
 	DRM_DEBUG("Flushing [FB:%d] st=%ums\n", fb->base.id,
 		  epd->factored_stage_time);
 
-	buf = kmalloc_array(fb->width, fb->height, GFP_KERNEL);
+	buf = kmalloc(fb->width * fb->height / 8, GFP_KERNEL);
 	if (!buf) {
 		ret = -ENOMEM;
 		goto out_exit;
-- 
2.40.1



