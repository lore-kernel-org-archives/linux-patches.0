Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257B41D0949;
	Wed,  2 Oct 2024 14:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879063; cv=none; b=rRJNNFpPHkpkEiZAbR9Clm5f9uH1+YB2XtYJKfYMHDaQCjVv3UC6Ul6TuaDOSSPrZrz2kk3F/8alcZuk5r2MJx0WN9rPq0GduleMkBjLHn7O5E7m2K4eB6hRqkNESpRAawdnimGzYOHQJ6BecM39v/D4/vaYHn/pA0Ein2KasnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879063; c=relaxed/simple;
	bh=NaGPaQnC3AgrPjPpnS0XRac76bHNxWgzWf/UxuUKnQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQGwGKOlHrx9XE9N0T08HR5HfFxSzJC5Nh8pIaOKilcINo8IjR0OcY1SicOI1amVPbGhQKDUQzK+yoS+5baWH0kk7paxyfxB3s/ojpTA7YKwexRbtVOJeUS70CrNy3epVo1z1sKx1qte4Rzyo5EV03oC9LPwC75z7S2GZ74zehc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8/Gv7Jn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8/Gv7Jn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A04C4CECD;
	Wed,  2 Oct 2024 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879062;
	bh=NaGPaQnC3AgrPjPpnS0XRac76bHNxWgzWf/UxuUKnQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8/Gv7Jn6HBwY6aDOyzVIEMogwdxQOAqmkQtBvYV6FH3KqhmEjN8a+JqKWZxb+gtb
	 3vpi/dRxV481LIwrAVECHWUdJmBUBq2+pojSZDA7lBaqzPT0M32kz7irYtVKYxbCvC
	 Jj/F1GnrwJdN+yvVCesvVhQqlGW2wAPnjqbhleRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Borsboom <arthurborsboom@gmail.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.10 625/634] fbdev: xen-fbfront: Assign fb_info->device
Date: Wed,  2 Oct 2024 15:02:05 +0200
Message-ID: <20241002125835.795329165@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Andryuk <jason.andryuk@amd.com>

commit c2af2a45560bd4046c2e109152acde029ed0acc2 upstream.

Probing xen-fbfront faults in video_is_primary_device().  The passed-in
struct device is NULL since xen-fbfront doesn't assign it and the
memory is kzalloc()-ed.  Assign fb_info->device to avoid this.

This was exposed by the conversion of fb_is_primary_device() to
video_is_primary_device() which dropped a NULL check for struct device.

Fixes: f178e96de7f0 ("arch: Remove struct fb_info from video helpers")
Reported-by: Arthur Borsboom <arthurborsboom@gmail.com>
Closes: https://lore.kernel.org/xen-devel/CALUcmUncX=LkXWeiSiTKsDY-cOe8QksWhFvcCneOKfrKd0ZajA@mail.gmail.com/
Tested-by: Arthur Borsboom <arthurborsboom@gmail.com>
CC: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jason.andryuk@amd.com>
Reviewed-by: Roger Pau Monné <roger.pau@citrix.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/xen-fbfront.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index 66d4628a96ae..c90f48ebb15e 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -407,6 +407,7 @@ static int xenfb_probe(struct xenbus_device *dev,
 	/* complete the abuse: */
 	fb_info->pseudo_palette = fb_info->par;
 	fb_info->par = info;
+	fb_info->device = &dev->dev;
 
 	fb_info->screen_buffer = info->fb;
 
-- 
2.46.2



