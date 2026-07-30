Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A7733D4E2;
	Thu, 30 Jul 2026 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422258; cv=none; b=Ho42VIE+qX3DJRv1UjwvbwdW4d9UO+xAlS5CHyUIEysMeif/4x/kn5gFneKEwBcRmktfQqafntFqwt2QzSrKwDfkt7J9jqFhKepPMFoCuZmJKi0aQHEBKLdaxl8uEGVqnvtzQu1/enSJVLghND+lf9BOAHdhUChZQRr19abA4cg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422258; c=relaxed/simple;
	bh=KyZyKqBgDGj4S6Cs/VrRjntyTZk3ntl16b6HY9wrG1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tkfShw3GHjTtpmqcuZ5T8lB67mjU/0cmgQbx6DLQav2UwBeix1bjSQSJ5M6ZPKYvUcZqSd7T5cEzVC4FUgIvGdm6RrJa2YpUDJXjXW9AL+c5smES5rBPLqLh8nYrahq1FDOmkcjzf6v/vSrVO6mhan7AH3LxUpPyT2NQKK5KnZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lKcDP7D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lKcDP7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24A1B1F000E9;
	Thu, 30 Jul 2026 14:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422256;
	bh=u2qd8ui/mkACos4NHOo9K4PLC8jN/OMY62V2x80O+xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2lKcDP7D4dVhG1iSB7x1q8t+aJvK9AkN2r3AvcUycZtcDiuvCTE1rvMz04n3inImU
	 iymZjJ8rlYF5cdmsXlGyV4HG7ANa2GhMtOHxByvdDrWTtBtib6Ew/3NjUjGcpvVsq+
	 CdohL737l7J7TdltF23PVkDTBpaER8RoV37UJsNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 7.1 378/744] drm/sysfb: Do not page-align visible size of the framebuffer
Date: Thu, 30 Jul 2026 16:10:51 +0200
Message-ID: <20260730141452.321656098@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Zimmermann <tzimmermann@suse.de>

commit 134844856c399bfa9462a159dcf860bfdb748055 upstream.

Only return the actually visible size of the system framebuffer in
drm_sysfb_get_visible_size_si(). Drivers use this size value for
reserving access to framebuffer memory. Increasing the value can
make later attempts to do so fail.

Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Fixes: 32ae90c66fb6 ("drm/sysfb: Add efidrm for EFI displays")
Fixes: a84eb6abe2b6 ("drm/sysfb: Add vesadrm for VESA displays")
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Javier Martinez Canillas <javierm@redhat.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v6.16+
Link: https://patch.msgid.link/20260618084327.46567-2-tzimmermann@suse.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
+++ b/drivers/gpu/drm/sysfb/drm_sysfb_screen_info.c
@@ -67,7 +67,7 @@ EXPORT_SYMBOL(drm_sysfb_get_stride_si);
 u64 drm_sysfb_get_visible_size_si(struct drm_device *dev, const struct screen_info *si,
 				  unsigned int height, unsigned int stride, u64 size)
 {
-	u64 vsize = PAGE_ALIGN(height * stride);
+	u64 vsize = height * stride;
 
 	return drm_sysfb_get_validated_size0(dev, "visible size", vsize, size);
 }


