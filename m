Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C482714386B;
	Thu, 13 Jun 2024 11:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718279363; cv=none; b=dcIuG8rfLK5jbFRQxDI12Mbvv6RKlhwxw5xCWqFMIGZoIXXWwT9KiVn48Sp7M7keOc1I5bmEBWJcHD2SRijSdOTmNyL7eUL6ypUMOmEW3o84Z4z5W+rE9L3ndXTZOJJyTJ0XVCWt47FLMFZoTf19zY2rosaMtCyCuVuo0K4nRyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718279363; c=relaxed/simple;
	bh=b1M8AoBDXW5+alfCEzDSP9Stef5+DsD4ws0CjAbjlN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUHvy5S/V0b1uQ2XFRlY1oiqUddAxOVGVH7Sdy03P2Byu/HR3PP+27l6GySDVmy4FDEfQyXEsI2PWFMJ6RHxG/hMWHYhToIWfVYeuYSkNidCtPHcOzDYlnBksvxUNpjF+75LEgirUz9WNzVeONl7rrs+36B9IET3ZJv7robmCQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1BjeHEGt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1BjeHEGt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4666EC2BBFC;
	Thu, 13 Jun 2024 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718279363;
	bh=b1M8AoBDXW5+alfCEzDSP9Stef5+DsD4ws0CjAbjlN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1BjeHEGtWImVDk0baZChYSbpXDPqo+RHElWyviZKdQ8iGGJdfy5VSfd3HixH8YOw+
	 Yh6kyBTlgE85tBP69wH06SVHJxQ6/HGNzNvdVMEOwXtPcOHK8xdY35s04/i2zKSgOV
	 VUIGpypfQEqSZ0+kH+VqEDauVG5v2egf0Eiby+z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Zack Rusin <zackr@vmware.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sui Jingfeng <sui.jingfeng@linux.dev>
Subject: [PATCH 6.9 050/157] drm/fbdev-generic: Do not set physical framebuffer address
Date: Thu, 13 Jun 2024 13:32:55 +0200
Message-ID: <20240613113229.361100016@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
References: <20240613113227.389465891@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 87cb4a612a89690b123e68f6602d9f6581b03597 upstream.

Framebuffer memory is allocated via vzalloc() from non-contiguous
physical pages. The physical framebuffer start address is therefore
meaningless. Do not set it.

The value is not used within the kernel and only exported to userspace
on dedicated ARM configs. No functional change is expected.

v2:
- refer to vzalloc() in commit message (Javier)

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: a5b44c4adb16 ("drm/fbdev-generic: Always use shadow buffering")
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: Zack Rusin <zackr@vmware.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: <stable@vger.kernel.org> # v6.4+
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Reviewed-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Tested-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240419083331.7761-2-tzimmermann@suse.de
(cherry picked from commit 73ef0aecba78aa9ebd309b10b6cd17d94e632892)
Signed-off-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_fbdev_generic.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/drm_fbdev_generic.c
+++ b/drivers/gpu/drm/drm_fbdev_generic.c
@@ -113,7 +113,6 @@ static int drm_fbdev_generic_helper_fb_p
 	/* screen */
 	info->flags |= FBINFO_VIRTFB | FBINFO_READS_FAST;
 	info->screen_buffer = screen_buffer;
-	info->fix.smem_start = page_to_phys(vmalloc_to_page(info->screen_buffer));
 	info->fix.smem_len = screen_size;
 
 	/* deferred I/O */


