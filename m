Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018029;
	b=wa0+YbpU3tAUd8eZw7IOLkXYZkOUFkTwZEllGld1yOOqHbr6dfeJd8DRmz8DbIRLQwr5
	 7YkeM4cqqfsGd1Jsn68d/sqKYWv+hyB0t0ajXOzNfgc4ztZqGWDg/K/4PwWlC/b7gzy/f
	 EScYBP6Cp3RyxByi9b7TPD6vpQct7Lv6OuiUdiImaXxDf6OXuBehA4nYFwllXlZl7qBb/
	 /KEFtsjOX+GjAYniOdcw9L47Hp261aSp1GSnREvJKzVCDgHOFddve3sHu5csCFOWjqnzw
	 ufGSnQhA5Lv6eH9dXB8Ju8xLqyQR1bVcwAnG7rtYfAImH6sDrV+5V9T89NBoMnfxp1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018029;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9aao0JzUiN4BAa2or9xVtiwHzEn2Prbx/hanSe4YJ7o=;
	b=AELLjLysn+u4It3WmErELhA4H4PwzToNHk9p0TBwMPwHng+iZcz6r8c7DwYmeBCA0K1S
	 Fb7xhUjwG/B4KJ7Gn4DpIRCd5kMJ4nMJ3bCDIGpZTrqmp5KHbQwMrf/r/71B/ufn2b+Q0
	 UC3oCDfpEgZ+aTgwzT9L3QtT42j1erHJUgo0tf++eBYbIFM48z/OcQ76bg4zeWJ7LWkLc
	 RLuXVkvjujNpRQFHqdq51Mj7BcvEWkj2CYhR7rwe8ZaqOONeFgYO9oLyOJUCQ1GbK6rPk
	 zfeAXvlWVujAY3LbW7e8Y72IL4nBxwvxtWyHSp+5lxkpM5XUCm8ITNjLkiiBXqW+i+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOeaZIqf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F4D606A31C;
	Wed, 18 Nov 2026 16:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nOeaZIqf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2A981F000C4;
	Wed, 18 Nov 2026 16:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018029;
	bh=9aao0JzUiN4BAa2or9xVtiwHzEn2Prbx/hanSe4YJ7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOeaZIqf5ftuMP5+bl7t07XxzMFv1i3jv6aNE8hBIkLwwgw23TPiYQ1dNrBB8Hx1c
	 iW9PHs0eKt9W0uMvhtKUFS19d3wYxuJKvdBQItAY6DGB8+hkjw5jTgqxGp+2ZwDXgq
	 DCgrwdBbYjkpFuKPKp9x8+VlbT8riEu8ySP1UJwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Lucas Costa <2000.costalucas@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1096/2651] staging: sm750fb: free cmap on framebuffer release
Date: Wed, 18 Nov 2026 15:38:56 +0100
Message-ID: <20261118150327.456199196@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 8b93bfeb217bb..68b6d4fe79ca8 100644
--- a/drivers/staging/sm750fb/sm750.c
+++ b/drivers/staging/sm750fb/sm750.c
@@ -825,6 +825,11 @@ static int lynxfb_set_fbinfo(struct fb_info *info, int index)
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
@@ -910,6 +915,7 @@ static void sm750fb_framebuffer_release(struct sm750_dev *sm750_dev)
 	while (sm750_dev->fb_count) {
 		fb_info = sm750_dev->fbinfo[sm750_dev->fb_count - 1];
 		unregister_framebuffer(fb_info);
+		lynxfb_unset_fbinfo(fb_info);
 		framebuffer_release(fb_info);
 		sm750_dev->fb_count--;
 	}
@@ -936,12 +942,14 @@ static int sm750fb_framebuffer_alloc(struct sm750_dev *sm750_dev, int fbidx)
 
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



