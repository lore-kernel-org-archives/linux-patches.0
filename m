Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061187;
	b=Y81lk5Gd/tWUIe/4uM9XxWVGuYDEDF25rdRflbGpHHDlmc2+b55WYuqhfG/G4RJ32hi0
	 iSw7mRWlr6KtKmKMDhNCHfVL9KMKtYyrHwXSIGO/kFtKeQ0NqzqjlRNP2DKpZ8kopvO2o
	 DfAuw+I4m85n1ykB8JoTZmkbh95kjzb3F2aFMAVvH4+J2SjwASsjdd4ZQePLn/GGKeQtD
	 vKhpur2jQK6wJ1FDABzwcYic1f7PeHTFekmUR5hfMxxQwOTd52YGUZkTLVdCRSJI7hvSJ
	 qx+fF3vog/DLFcjg1yMF6fkca7fUiYs0qJD2uMxg6ZRgrCb3xKCv1l4+AuYxFwjrc4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dKviyi1xu4fsKsuaJTfd1BmmAzWj+k5mnT7Zl8bbDIc=;
	b=cr7gcV1sua3NmuvbrHaZoPChgnQgyrklVkQdYNtBriO8/WqrA55vS71n6oi6iES+5/70
	 a7fsQctyCLwRus5Sf8hP4uUvG9vH6JoaoCIbPg/dI1arVqP0WGoaHw5CYFlsGD9Kq5Vhd
	 dbE3zJJj1fZyHKpIljddSL/asUvZZAs7Z//MmpmD8tBPUmhvc4srDKjxykrsAnJj0zkTt
	 JdCjWSjx9QHKG5Iy6/7uAHuyQ7Zhq0tS0NuM+3/QqyPG3fwFTtrjzwzjN7J4NzVXEMmoG
	 NVmsCUDsE+NN0STRW6CblYFlMp+o+s+fF75Fc9hJbBHEfkI/ejtqhgBJRM+F0f0zqtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TE8WAP5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619BC606A326;
	Thu, 19 Nov 2026 04:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TE8WAP5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DD21F000C4;
	Thu, 19 Nov 2026 04:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061187;
	bh=dKviyi1xu4fsKsuaJTfd1BmmAzWj+k5mnT7Zl8bbDIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TE8WAP5+/IIguELTRMRe5p924sXvW3OF6MXWWrWkPkpt4eJfIlfFSy/WHdfBQ7Kel
	 YMQgVZBNYe/rIludT4omJuuB+uN5Q5dg9Ac8cLkFDawfQYotnmpZQbdgfbJveZDjRp
	 TmKoRNfi5zrr9UgVuKBw8FSoyMRC1poV96jQ0xZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1422/1848] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:57:40 +0100
Message-ID: <20261118150018.999574533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1701aade50348..ba379b6729e54 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -865,6 +865,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
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
@@ -951,6 +956,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -977,12 +983,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
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



