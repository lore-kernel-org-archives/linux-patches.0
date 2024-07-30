Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F233218801C;
	Tue, 30 Jul 2024 16:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358361; cv=none; b=K5YHnhUhctvfi5rHmG1pq0DFiBqNW+LxZDWkRGeZ6tsH1yeYs6l1kEJ9tAiEFLyb60HYyTpB9RzQf2jRQBI+T0xjzkLkqFW9hqQx4gjVbOmVSm3/n49h3/tzSlsuuiXksZhmCoJxxyihkc4zwAA0bl3wv5kH7qAmuQE1oZf6d0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358361; c=relaxed/simple;
	bh=yRFkhwYiUrHZ45xyWsiq83+vAwMK88rm0BI/28RJfsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZcNo11s75xyzwblSK3r0h+xzynriVHsmudHNGhzB2ly20811PKuA7ZQtN0Ckwie2LOQNWZ3KtOyZyeLYYhQvxylfKOAoR0rsfayw0fqKIAHN2qrSDltv2LTPbP2LdGx3a0rQgWPgr0bPdpDG1hgR2XrmQgI1J0pcoUvafgyuk5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A055Fj8k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A055Fj8k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767DFC32782;
	Tue, 30 Jul 2024 16:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358360;
	bh=yRFkhwYiUrHZ45xyWsiq83+vAwMK88rm0BI/28RJfsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A055Fj8kFDv3GySEhBHwGXxL3GfvN6poNJKbXeqqimi0vqZJ3gI6QyVnhS3hd07sb
	 EGco8GKCRuxf2vd4N9NDpTR+mAR3sEXAnxIf6iQ55bUycmpglYqSQyyBsiQVZq0G2d
	 dsuNG1l6rd8pcvVE0u0eWG7S6TLXj4hCGLje5dBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Javier Martinez Canillas <javierm@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 352/809] drm/panic: depends on !VT_CONSOLE
Date: Tue, 30 Jul 2024 17:43:48 +0200
Message-ID: <20240730151738.540154891@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 1ac6ac9ec069ed0cfdb1c207ae23f6c40ac57437 ]

The race condition between fbcon and drm_panic can only occurs if
VT_CONSOLE is set. So update drm_panic dependency accordingly.
This will make it easier for Linux distributions to enable drm_panic
by disabling VT_CONSOLE, and keeping fbcon terminal.
The only drawback is that fbcon won't display the boot kmsg, so it
should rely on userspace to do that.
At least plymouth already handle this case with
https://gitlab.freedesktop.org/plymouth/plymouth/-/merge_requests/224

Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240613154041.325964-1-jfalempe@redhat.com
Stable-dep-of: e044e707fc97 ("drm/panic: Do not select DRM_KMS_HELPER")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index d0aa277fc3bff..3e286236aa430 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -106,7 +106,7 @@ config DRM_KMS_HELPER
 
 config DRM_PANIC
 	bool "Display a user-friendly message when a kernel panic occurs"
-	depends on DRM && !FRAMEBUFFER_CONSOLE
+	depends on DRM && !(FRAMEBUFFER_CONSOLE && VT_CONSOLE)
 	select DRM_KMS_HELPER
 	select FONT_SUPPORT
 	help
-- 
2.43.0



