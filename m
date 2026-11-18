Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050910;
	b=43k04uH94fPO6MQaJW2hI042o07VMe0ivFeUvi08C5OQo+sfrGI8eQpkRxQj3XSIzC6o
	 ugL3N6bgS4TJ9GQddVEth5/PJ+xTR/POv5r54oEePXZ5NXfdxFnvuEetdgehz6LBC583+
	 fTGU/HiJI3pFp8Fz1ro//fIsWm95VvgKFbgZ4ULH7PYKKYYuBr+SWM+TtHIIduCktq/sT
	 h2YOWz1guP/SZoEu/f1rZmXwzGdvvXgq5xMc0Zz/lKPAzqbSinRpdrSEkwiMTo/im8s97
	 eSVFtsiH1zvbshzd5c2llcEVQgaMTro9xvlKuc0JANu/n6cf5Xt2tWDtR2zdrF1W9Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+h3cs9EmCaTDzQAhPtyboRCQVV2F+14O506gDgCL6Uk=;
	b=RtUVV+9lchHajCobwL/BG1mllK915NAsYEt82bPJj7DwcXp1a+oF2Jx+uzBDIxo7n9gG
	 go7kuqbziqDrxSfEFrRYM4IfFiuqSrutyaGAco3PU2zDBFocAthAt8XPJjTIOo6kNE3wG
	 OcaK0JbDhT4STZcH+ben157aHJwBTDu7jB1drtw+cFlvyZSXjRxuVOaepVlVVxShXISJ/
	 RpP3j3vgGzbImwYeqqPRPXN4Mo6ojWu+hGwzIMnvk5rkqUTpk7v0QZ+5fCyzOLnd5lERf
	 L6NrAb6hh5lduRNKLxD0WhU7mEill4a9ryLyNtTcuzGvAlEXVGTJaBTbZCmk6mSqipQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="1fh/gUGJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202B6606A31C;
	Thu, 19 Nov 2026 01:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1fh/gUGJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 773BD1F000C4;
	Thu, 19 Nov 2026 01:15:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050910;
	bh=+h3cs9EmCaTDzQAhPtyboRCQVV2F+14O506gDgCL6Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1fh/gUGJbZq9kdMsdFur14uzw2j4VGIYBdzPgMNDoOIFI6E6KI2iihJWnf+05b2eF
	 oINS9kijDRachPPnGt5htU3uTBLCW+/NVCgLNbDWPPgMWQqIWL/cHal+ipErNyGLGI
	 kTVPqgRgNjtupDr1Arzd4HHc3lEPL2P620hsxL70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.15 0022/2214] drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array
Date: Wed, 18 Nov 2026 15:28:18 +0100
Message-ID: <20261118150011.019186500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

commit c4ac100e9ae252b09986766ad23b1f83ca3a369d upstream.

Replace kvmalloc_array() + copy_from_user() with vmemdup_array_user() on
the fast path.

This shrinks the source code and improves separation between the kernel
and userspace slabs.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: c833d6c7199c ("drm/amdgpu: Limit BO list entry count to prevent resource exhaustion")
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c |   43 +++++++++++-----------------
 1 file changed, 18 insertions(+), 25 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -224,43 +224,36 @@ void amdgpu_bo_list_put(struct amdgpu_bo
 int amdgpu_bo_create_list_entry_array(struct drm_amdgpu_bo_list_in *in,
 				      struct drm_amdgpu_bo_list_entry **info_param)
 {
-	const void __user *uptr = u64_to_user_ptr(in->bo_info_ptr);
 	const uint32_t info_size = sizeof(struct drm_amdgpu_bo_list_entry);
+	const void __user *uptr = u64_to_user_ptr(in->bo_info_ptr);
+	const uint32_t bo_info_size = in->bo_info_size;
+	const uint32_t bo_number = in->bo_number;
 	struct drm_amdgpu_bo_list_entry *info;
-	int r;
-
-	info = kvmalloc_array(in->bo_number, info_size, GFP_KERNEL);
-	if (!info)
-		return -ENOMEM;
 
 	/* copy the handle array from userspace to a kernel buffer */
-	r = -EFAULT;
-	if (likely(info_size == in->bo_info_size)) {
-		unsigned long bytes = in->bo_number *
-			in->bo_info_size;
-
-		if (copy_from_user(info, uptr, bytes))
-			goto error_free;
-
+	if (likely(info_size == bo_info_size)) {
+		info = vmemdup_array_user(uptr, bo_number, info_size);
+		if (IS_ERR(info))
+			return PTR_ERR(info);
 	} else {
-		unsigned long bytes = min(in->bo_info_size, info_size);
+		const uint32_t bytes = min(bo_info_size, info_size);
 		unsigned i;
 
-		memset(info, 0, in->bo_number * info_size);
-		for (i = 0; i < in->bo_number; ++i) {
-			if (copy_from_user(&info[i], uptr, bytes))
-				goto error_free;
-
-			uptr += in->bo_info_size;
+		info = kvmalloc_array(bo_number, info_size, GFP_KERNEL);
+		if (!info)
+			return -ENOMEM;
+
+		memset(info, 0, bo_number * info_size);
+		for (i = 0; i < bo_number; ++i, uptr += bo_info_size) {
+			if (copy_from_user(&info[i], uptr, bytes)) {
+				kvfree(info);
+				return -EFAULT;
+			}
 		}
 	}
 
 	*info_param = info;
 	return 0;
-
-error_free:
-	kvfree(info);
-	return r;
 }
 
 int amdgpu_bo_list_ioctl(struct drm_device *dev, void *data,


