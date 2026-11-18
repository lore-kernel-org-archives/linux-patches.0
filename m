Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030501;
	b=nCWTULyynG/8Q2zfti+dKAM+Y/7L0SyZEJ8ckNHm7RWzKtqsok4WNmMmoqdfTeliyR8z
	 uHqQHNFiEpnySbXxVUqDOH1CjZuvOqTvPhLUBy9mXfkvOrcpmEMtQ1fWZawoDM9U9t8e8
	 RQRtpxjr8kufXjgPFyTfZlCNBEE8W3tl93pA1UA7h6nzY2UJTBLD9BEWvAzijHsnx4NPa
	 AUZp0CSVa8kyhHnSJ/Hr3VxunCSVcrzosuAWkckDkWqFLxCW3WzPG/8XR1pRlHiD3l77Z
	 q33yXG5U9CTsDYtGe1zY8P+sEMnwoBl35LkkObZMlNJ7DU7wH1gH+7ytuGVD6FDPOZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030501;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1WEVTv3oCtZ2NpNtRkYqKRu7D7aDV9MVFSqBuFl9ib8=;
	b=TrTM4w/WlJsCgZ9DaJ43tC4aV+7ns2anjX/5PPAvwjBgwjP84+T03MMRH0SHAyB838ZP
	 fWLVKLmM5ZFCbEcKtQop8PQJt8KNIUeCEJhCSAjFtP+IDW5LEJJt5P6FkyuNcinzyHiW3
	 ZHWaGX+WVQVrWJ0yoCgIWgEPzq4jFpY2Bu/d/Tc8VlLP93dIXiHGNd4fMvULK+d0wZqwB
	 J4oaoK57x2cEJU9KNgWkxis1Al9x3pU7D5u5nfrfhPJwoy437zztb2B7xTi6iEi8dgpJ5
	 W9QZmcB9QeO7oe3ncX5ikp3FRMasq83JlWKEXr0a9IYqzpk9h0Sm737nIQfx/R3PzSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uCZ8VRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533DA606A325;
	Wed, 18 Nov 2026 19:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1uCZ8VRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA1DB1F000C4;
	Wed, 18 Nov 2026 19:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030501;
	bh=1WEVTv3oCtZ2NpNtRkYqKRu7D7aDV9MVFSqBuFl9ib8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1uCZ8VRowZAu5o355zdqCi1uVJGt0okmG77MAWrP8iE4KgXdG9zdDHwv3sSUFeOvy
	 k0ymNw+1GR7IvccVDgkeiq7OckJS72rdtM/abjCtMq/ty3qgn7S7vdnilxpCFuk1Zl
	 vByEUR19eunFXYzteeWwX3B/qXnvFHpqBLn/6qeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0726/1756] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:47:33 +0100
Message-ID: <20261118150038.589666510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2d9eab9ad1171..e84d2114fcd51 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -906,6 +906,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
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
@@ -992,6 +997,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -1018,12 +1024,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
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



