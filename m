Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F88E29CE7;
	Wed,  2 Oct 2024 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877162; cv=none; b=DO8mecn+n96w45oczt60vqJmRU08+bG5yXvG77a11ypSPbvZ8PGUuFUVZ6K/xtTYVXhMEutB+ZCbsRiPmfFiJfcn83M4AnPSC8l/G7NTf2UYcRWnSHXhivUJAYadUjwEZVxUgn/1TnDNW96h6XG5mNVCcAPMb7IkE+tsgk3I9RM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877162; c=relaxed/simple;
	bh=nmzffPbUpnnIoUuci/tLBw0/coptqjwKBGBhceGU7dU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=emnrBAYpoUfXeQzyc2FN3V6MtjJj0EaVy9ub0xPCEKROd7Gck7CoCfunVPwL0Korl2N2HGHkbofG/ngRHiJQJgnbVxsAok2ZJ/OAfxzxDDjD7uQV58X2WsYHrec81aHbZrf0Im+QCSH13ag0yuYVNFvrQo9Mffs4SK9uh3JSiP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06dP/rvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06dP/rvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B83C4CEC2;
	Wed,  2 Oct 2024 13:52:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877162;
	bh=nmzffPbUpnnIoUuci/tLBw0/coptqjwKBGBhceGU7dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06dP/rvcCM6bVrJpnLXLl7mKB4D2d10q46QpO61iTU01wXg+kp/FNFCDQK2b7LC+3
	 phngJRqD+fgKScSJHc9nfjTswwXIj4dQHnM+SUf2LfXyLNTDrSXML5PWf5NuNFsOD7
	 RKUoNxJZmk1ifisYa1WbUsK58KJnNuFDG+hh36q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arthur Borsboom <arthurborsboom@gmail.com>,
	Jason Andryuk <jason.andryuk@amd.com>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.11 685/695] fbdev: xen-fbfront: Assign fb_info->device
Date: Wed,  2 Oct 2024 15:01:23 +0200
Message-ID: <20241002125849.863187006@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/video/fbdev/xen-fbfront.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -407,6 +407,7 @@ static int xenfb_probe(struct xenbus_dev
 	/* complete the abuse: */
 	fb_info->pseudo_palette = fb_info->par;
 	fb_info->par = info;
+	fb_info->device = &dev->dev;
 
 	fb_info->screen_buffer = info->fb;
 


