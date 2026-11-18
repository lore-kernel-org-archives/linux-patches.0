Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040524;
	b=jqrqh/nZGMg33Rba4UpWW0gOtR3ozlxiKu1JrhhF6MK/xkpHv1iUtIk/FW2OISbCyuCT
	 OBt50nRmaq0ns2q/dl5APGEA1ZWMlwqSz9AFkZ/aRAUTjXcF16rbhh33pR7BVMeB2meaG
	 UqGjpIG0+V4wpJ4e6gXRW/XcL237PIxO+Df8TheE7yM6GZNPZFRRUb1JS+SSy2J5r/L+U
	 Zw5dYCH5gkLEcAiTNw83k/Kjx1W+h41Wc/9X3QeeXGd4mIGLuZmGKA69viI7wNN82nIou
	 Y5vi2AWvCrbe+Yx9qlWlzV2rheghddQYpeSgWiys6dudMgF53ckD495rjQGZ0HYc8OQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BytMfGAkfnIeL6apU9qwmmE0VHmKyLcGyirEDuBNjz8=;
	b=lrvrbCTtBO9d0TVrhc1AF1lvaSMH2h+Hs+xYMXcCcBTDIZTnVMjBkDFOqj6bNcZkC/Qk
	 YzAQxXF9/ysohmu5muja4G1KmwDLOoAdLTnkKxi8jbSx7UpIasoNUflV4u3Ewwwt2cYX6
	 47Cvuavskcqu5qDBD+U0YHtbrDfvI/uNeGWJ4J0SreUO9EwIHIepI1OrSTG3vReAd4nMX
	 4sOamX0iII5q/plO4TmGEPKiTKHUD5xx3V7j2jlOEgfB2ac//YeGcIJfdeNRWTwe/jIjg
	 rrukj4tDdnOfy6aRTMX2APE1hALgyykTlp3AHRKneDFL1F/oiIHHWBGkJAdDtvFdZ9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LAd2BLis;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9872606A320;
	Wed, 18 Nov 2026 22:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LAd2BLis
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25E881F000C5;
	Wed, 18 Nov 2026 22:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040524;
	bh=BytMfGAkfnIeL6apU9qwmmE0VHmKyLcGyirEDuBNjz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LAd2BLissJgOso2ujuqQBBYVKCK/2GYHYVoQi63xH1WST7dqUDqTZlF8d6USP7Uha
	 kSQXBGfCgUkgtvXDXSPwIU/oZqSoTK6lyB+gLuA5/wgmxjevTv9v0Ogn7Ryax9Ygy4
	 7YTOLYnAuyBB1tIvm2WNNqoHwInauUTZ9cAoNBw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2486/3318] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:51:48 +0100
Message-ID: <20261118150435.978020425@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Costa <2000.costalucas@gmail.com>

[ Upstream commit b7c885194b81a0376d1fdb457eac40d21d6fb65f ]

The cmap is allocated by lynxfb_set_fbinfo() but never freed, so it is
leaked when the framebuffer is torn down.  This happens on every unbind,
and on the register_framebuffer() error path in
sm750fb_framebuffer_alloc().

Add a lynxfb_unset_fbinfo() cleanup counterpart to lynxfb_set_fbinfo()
which deallocates the cmap, and call it on teardown.  In the alloc error
path it is only called once lynxfb_set_fbinfo() has succeeded, so the
cmap is only freed when it was actually allocated.

Fixes: 81dee67e215b ("staging: sm750fb: add sm750 to staging")
Suggested-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Lucas Costa <2000.costalucas@gmail.com>
Link: https://patch.msgid.link/20260922142851.46724-1-2000.costalucas@gmail.com
Reviewed-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/sm750fb/sm750.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/sm750fb/sm750.c b/drivers/staging/sm750fb/sm750.c
index c2202bab0ce54..c947af9beb9e1 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -867,6 +867,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
 	return ret;
 }
 
+static void lynxfb_unset_fbinfo(struct fb_info *info)
+{
+	fb_dealloc_cmap(&info->cmap);
+}
+
 /*	chip specific g_option configuration routine */
 static void sm750fb_setup(struct sm750_dev *sm750_dev, char *src)
 {
@@ -953,6 +958,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -979,12 +985,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
 	err = register_framebuffer(fb_info);
 	if (err < 0)
-		goto release_fb;
+		goto unset_fb;
 
 	sm750_dev->fb_count++;
 
 	return 0;
 
+unset_fb:
+	lynxfb_unset_fbinfo(fb_info);
 release_fb:
 	framebuffer_release(fb_info);
 	return err;
-- 
2.53.0



