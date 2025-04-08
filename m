Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468D51B87CF;
	Tue,  8 Apr 2025 12:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113999; cv=none; b=eQK551siQ9P9zJ7a6WRdQ+MC1WOi+ueWlwmoz6I/WMCyBjaPc7gq7EOquIgCem4JgVEOFUoMp2ZK7BkQpxOGO4wOilOU7fbiFrqfwCPYXoK8Mzh8jKanhYnZALF5uBaXwVPWUJZmqBhD6Z5KTN7Zd3trdwstRdKEK8Deosh3r2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113999; c=relaxed/simple;
	bh=ukVrrNSPxfYDXXT/FyYTwGfMMu1PQ7mLflcpm5Eahfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TTotNGIYMH4X3/SozAYm4eHbSHbXP4G8jxVpMI8yrZ3YLBNsu0lpT2AKdHz1PO2LHh3gaI53UVbxWth2D9fsK9Vo7WtJc9hv9yZIoP9HJMCTZn8BVpPEdfAb/GkHeTUVQ5/+h55HuXD8hNke8FovEGGgh7UINVxtRhcC13OMEx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+dfyKZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+dfyKZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C90AFC4CEE5;
	Tue,  8 Apr 2025 12:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113999;
	bh=ukVrrNSPxfYDXXT/FyYTwGfMMu1PQ7mLflcpm5Eahfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+dfyKZ038GvzXNPQRe8pv4XI0FZF6/+WM7jghR2CPKbF+EwVa0tJPMJ5hRgFN4Ea
	 gcAlmxV/SCtHZgSmBTGQ0Ii/fNhLwbUOyt1BWKDpN/DoGxOldpUu6UyUY5HLEyO0Qi
	 0phVM2WiraLaebaHCHrcjD+NtuCSr6LOV1efMqo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <elfring@users.sourceforge.net>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/154] fbdev: au1100fb: Move a variable assignment behind a null pointer check
Date: Tue,  8 Apr 2025 12:50:39 +0200
Message-ID: <20250408104818.465989077@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Elfring <elfring@users.sourceforge.net>

[ Upstream commit 2df2c0caaecfd869b49e14f2b8df822397c5dd7f ]

The address of a data structure member was determined before
a corresponding null pointer check in the implementation of
the function “au1100fb_setmode”.

This issue was detected by using the Coccinelle software.

Fixes: 3b495f2bb749 ("Au1100 FB driver uplift for 2.6.")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Acked-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/au1100fb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/au1100fb.c b/drivers/video/fbdev/au1100fb.c
index 99941ae1f3a1c..514bd874a627e 100644
--- a/drivers/video/fbdev/au1100fb.c
+++ b/drivers/video/fbdev/au1100fb.c
@@ -137,13 +137,15 @@ static int au1100fb_fb_blank(int blank_mode, struct fb_info *fbi)
 	 */
 int au1100fb_setmode(struct au1100fb_device *fbdev)
 {
-	struct fb_info *info = &fbdev->info;
+	struct fb_info *info;
 	u32 words;
 	int index;
 
 	if (!fbdev)
 		return -EINVAL;
 
+	info = &fbdev->info;
+
 	/* Update var-dependent FB info */
 	if (panel_is_active(fbdev->panel) || panel_is_color(fbdev->panel)) {
 		if (info->var.bits_per_pixel <= 8) {
-- 
2.39.5



