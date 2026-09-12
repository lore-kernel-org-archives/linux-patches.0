Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C57431E71;
	Sat, 12 Sep 2026 11:00:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210822; cv=none; b=Yv8xdjCFZcM62ZT9sDbwvvRVzriyoH7yfbc2ssLZdQISD/Ih0HHQn6cNFAABI633MqZojk5C9Z/e1/URsZRo7GIeoMo++bvbAvn45dGZDCb+vSiwCE8DldWbWMPVe5q7pCjpy0ceD6RvS8XPJfTOy1/7c6BlGrY2/U5sB9Kq3fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210822; c=relaxed/simple;
	bh=kwjNhqsZ/pcdfnhVTYxNuD766tB0ar8rouqhSTO+rvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHWDbGX6xY8ZdrYmAeMO3jbrHDO9OKYmOAPIxzjdhefAJdSIFyoAL4WqxImjlFo9YswB7/XXYOM4+GgzeAmfHXLXp6rh9GXraA9M+a6S7UkbgrIgkOIvxEvldbNjcYCng6CvJgTQAj+TvVLWSzRRzqhhxNG8/bWCEeYPv9gJmTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HAREJc3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HAREJc3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826F81F000FF;
	Sat, 12 Sep 2026 11:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210820;
	bh=EV/o2OATm98RGd3FXZ7dOolNsVhXHz6iMLqshXHquVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HAREJc3WQKEvZE2I2vXmmz2chHR+4/FJKbmLzFYunm6Mll3SzYQI17356M9mEFxWn
	 ViEhiDoz3u/z26jDI4BHQy7jRjg5Yet4Zp40utdKSTMreJ0oTlgITqPodSQflYrZ7M
	 //e6OwZqmsWJ01ia2XdAmCkZrTsFu9whQNSR66+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1061/1518] fbdev: clps711x-fb: Remove unreachable unregister_framebuffer() call
Date: Sat, 12 Sep 2026 08:53:50 +0200
Message-ID: <20260912065647.452470734@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 39dd7598fbe90c5b4bb77fb34d8f3dad8385d11c ]

The unregister_framebuffer() call in clps711x_fb_probe() is unreachable.
register_framebuffer() failure jumps to the unwind label, while success
returns immediately.

Remove it.

Found with Clang's -Wunreachable-code.

Fixes: 36462ac193088 ("fbdev: clps711x-fb: Replace check_fb in favor of struct fb_info.lcd_dev")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Acked-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/clps711x-fb.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/video/fbdev/clps711x-fb.c b/drivers/video/fbdev/clps711x-fb.c
index 5e61a349a4ab6..c350340fb7b95 100644
--- a/drivers/video/fbdev/clps711x-fb.c
+++ b/drivers/video/fbdev/clps711x-fb.c
@@ -332,8 +332,6 @@ static int clps711x_fb_probe(struct platform_device *pdev)
 
 	return 0;
 
-	unregister_framebuffer(info);
-
 out_fb_dealloc_cmap:
 	regmap_update_bits(cfb->syscon, SYSCON_OFFSET, SYSCON1_LCDEN, 0);
 	fb_dealloc_cmap(&info->cmap);
-- 
2.53.0



