Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025022;
	b=tRZTJEtD1XQ5l0/lsP0RgD7DUPWs2FJHHFyKDoO2cd3MP9NTFz/4wMCa/7ZJ4AZ2vV8f
	 inVHoqWcbKhpOTFwmuluQtHJWYgxPPKh1ja12D4bSxMdyIy9GcpTqb69hOb0hBjEjCUN/
	 EVSiyUy8+hLH4k58Ija0fU5DxR8xsdshe5lA9DGBbn5JleKUjnElT+ayFUSlC0Epnt+bi
	 NkytwI0sluJ9jOrjFM8wHWn8DRz+ySvAfz/h2o3YTayx0YZ+olHfOXKjVigfGbzH2M9uT
	 S0oOEYrc2I5Te9XofcovPe79DYuysk1c1FuH7H/VwPHq306HBGzTrhoQZGcw94eUSEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CCny1yAvnEIm0RT0VTsik8oj0+5pBMA5SI+FgwQRdYE=;
	b=mXAg1YWGBRXvNw4n6+ANeEgMfFiuwplQ0qWddtGC1108EBbd4gikOzBE8Yej7EI8LH9R
	 MCyrPupcd210FgKhd/t5+R48HkQmw6f08tBSrMInSZhJ162ajDFOLrpCNbRVkjujqQXEx
	 B9v9m/Xt9LqKjo4hJxPtIROzOLoAt1KBRmXructBDR6/Br5ub87d3HPC3OGQlrHED6RXf
	 zsM1ulmTuN2JmS0Tl8+Hd7TP0Sv3BPVhCK2kLzlMoHnzxExG6NBeOI7ndpF74UJLds+O+
	 Kl53nl+TUDBD3fMP7T0G07ZkqTuz2hpHbaXga0HTulWlYP3b+0luLfc9y7CDwp6lo0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="gYIs/20C";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33919606A320;
	Wed, 18 Nov 2026 18:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gYIs/20C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 873141F000C4;
	Wed, 18 Nov 2026 18:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025022;
	bh=CCny1yAvnEIm0RT0VTsik8oj0+5pBMA5SI+FgwQRdYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gYIs/20CxbpsFvnvu2/XhK3dQRuMK83i0NlvAAfjaa09tcr7HKzjK1xxVnIpISMCM
	 pHNfAZEWus1/7F6JbmaWKT22+V873bpRFVF3xiBYs5tS6P2puXTCsbDhoiBgusZ2vt
	 zCWHEtCkMMVION2NkbA2juLEOI7bfPrIuGxMzb3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0917/2151] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:44:12 +0100
Message-ID: <20261118150155.788406907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 676ef44577248..a2efe3ea1bbee 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -908,6 +908,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
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
@@ -994,6 +999,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -1020,12 +1026,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
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



