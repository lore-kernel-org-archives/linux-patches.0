Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C6043F0B0;
	Thu, 30 Jul 2026 15:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424267; cv=none; b=E9KK/+hj6rwpCj/P1qypcYK8yTLeBBwgaEBjWQEUT2NfIJ/X3NGq284dRMCSgRRxitXG77zwLdkJpO4iOY68XBNZdibQ1Q7YBLmFE3vahI3LRFHgg+3YwwS9b8OgIsuMsRr+Qrkr8wdq2zycp9elsMj59REaYmpuBt68UV+aNHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424267; c=relaxed/simple;
	bh=1D57EayaENMamQYLaQIoDbCWSB+4Uvn9SI98xI6js8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GB2MTER/e6bFx5kN3aJfXeTMlqFkuVhA4pll6au/G5UvBJDNXJFpL30MNajkRnLSiJnyoNm22Gma8ehlyeZtVSZziadUaaTdtQt26eUzVit+YR8UhjI7rEyDSF93ZtDLxn8mHYaH0QOhgNLtP3u8t9x62xxf3ENOY1F8J8ioVUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JaRYSLIT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JaRYSLIT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DD671F00A3E;
	Thu, 30 Jul 2026 15:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424264;
	bh=7e43aBoShE4ndUgtGkm9x1dx5pyEwXiy4gQyVwoPCZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JaRYSLIT1Hs07mv6Rcn2s0ScXoGgXa+TIGMDIr/br9FzrVo68msZNi+B/4vF4lmIG
	 +ozyNp9FiFyr/tyIiZjd0cP7YUPDg7RNnIAfRrkA3GfjvB0CubTNYGGw3+g5t9rr4c
	 71L8hhF4yb3q9FGKdXbJICabUZNUKfsy3SdmuAQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Javier Martinez Canillas <javierm@redhat.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.18 333/675] drm/sysfb: Do not page-align visible size of the framebuffer
Date: Thu, 30 Jul 2026 16:11:03 +0200
Message-ID: <20260730141452.206290222@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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


