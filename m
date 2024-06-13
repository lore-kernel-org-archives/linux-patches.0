Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847B5144D10;
	Thu, 13 Jun 2024 12:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280438; cv=none; b=H5IQRWkhls6X7yUy2ZJWWtpc38wOh04oWgbxSRUjOZZR7hdFNSZ+aCnY0swwVYn43IaopWbWaKGoLpS8yUydXsCfADpSA8QiYD9fXsJq4MycZP0EKt4qjRqi/YKn3lT3F4XJ4ezK9l3U//a02nIEpEh+U+DYaaRyMxD4EegT7Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280438; c=relaxed/simple;
	bh=c5xF1COYGRrqK3GIu6s6GqLb6nx+IfuMVtQwqUr8W28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7kxgknlmQinvULDSJWyb8VK0TqPcrWynIaf8d8FoulavAwzqP0M0NeDR8HogKW6HdWlMMJNvyenYcBqF5j3scLA04CURiUNzGbONA1stcUGagq3bn+basHEg8Fy15QJ/Yr5bs1bX2ouqAMTqP24O5FRJ831eunY3rA9xsp57Ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eR73AFrg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eR73AFrg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02744C2BBFC;
	Thu, 13 Jun 2024 12:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280438;
	bh=c5xF1COYGRrqK3GIu6s6GqLb6nx+IfuMVtQwqUr8W28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eR73AFrgoMnCRpNO2mxpyjmCGrtTmX/HkwNtjVbUYrwFJnoh6FufWqxomp4bWgxKv
	 gaZxBMK4+YopDLhD/sUitImWEQwlNT/zMSnfxcusLgeBusTFZ8xBZ+0dVGj6JvYQAn
	 exv+wXB8ZkioQxjWbfIBqNJIcCYQQZL/AJhDFxNA=
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
Subject: [PATCH 6.6 054/137] drm/fbdev-generic: Do not set physical framebuffer address
Date: Thu, 13 Jun 2024 13:33:54 +0200
Message-ID: <20240613113225.388160796@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/gpu/drm/drm_fbdev_generic.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_fbdev_generic.c b/drivers/gpu/drm/drm_fbdev_generic.c
index be357f926fae..97e579c33d84 100644
--- a/drivers/gpu/drm/drm_fbdev_generic.c
+++ b/drivers/gpu/drm/drm_fbdev_generic.c
@@ -113,7 +113,6 @@ static int drm_fbdev_generic_helper_fb_probe(struct drm_fb_helper *fb_helper,
 	/* screen */
 	info->flags |= FBINFO_VIRTFB | FBINFO_READS_FAST;
 	info->screen_buffer = screen_buffer;
-	info->fix.smem_start = page_to_phys(vmalloc_to_page(info->screen_buffer));
 	info->fix.smem_len = screen_size;
 
 	/* deferred I/O */
-- 
2.45.2



