Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C485A1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42239C433C8;
	Mon, 11 Sep 2023 14:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694441103;
	bh=yB2kiHdc0SYAkpN8vYLLR1ZLLbOk3s3vCLD3ZkBPsy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lLXs94JsNkFh+axNRVgVHxhNwk8YeFKzxSZVhqJNum+TeHjSon3IpwhwqsYL0H+wT
	 CTWl8ld5O8An4EN/jv50VHrGtwKR0BoVauXrqBFUNR4tS5meO6pYysSFuDJXY0BEG0
	 oThuvVV6fwEXUOHLpNNP2NDn+KzW3flTqbCSBHJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 297/739] drm/repaper: Reduce temporary buffer size in repaper_fb_dirty()
Date: Mon, 11 Sep 2023 15:41:36 +0200
Message-ID: <20230911134659.426026692@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index c2677d081a7b6..13ae148f59b9b 100644
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



