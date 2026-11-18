Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057137;
	b=Oc/eNIvpzfE1qizGUvqzLhCqDtHhhrw/bu5XznCDnPsa4HOttKzTCZWt8x/ONPl/wOKn
	 IVwwSlOo827+Q3y0r6KqRhnKg/Sm/0FrvydK+rMecbKWgKg8nBrLyphc+4MWh/uwA/wXB
	 vuMk7xX7KbB6y/3wgMf4knOfYxzckMpAFojMiYQrriinNI5IfOBqc+dHARx7AVEpkhT/J
	 rHd0OyRee9H9EQfSTYYtnRhnCgwv3aKrfc7jOvkkFtsCUQzLYw0ygp2Sy+duP/k5QHUwc
	 4/9cA/hOrosYkXf/PoMUeNfRrbWvMzs06ULoOI8PMIicmUs6Q2Kcmv/2BRlJNqwngSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ptYkl1WPUAr6TklxOydCvVCxxG88R/w2IQK6ilRXWw0=;
	b=4UQoy5Q+wY1lO8Q/ePe+d4rSDiVde/QMcSmjPQdd/InqXSQ7kinWzi3MNssuTccsLleU
	 iP+aMIo84KG1XhCT+AeJxqPyAlPSd+4zJ7XSgZi/UJ3Og3NtygyGlPJzUkozc76SS89N3
	 +oMn+JbbyV5pQk8nH620ZtUIQQjCdbd6PNzS60EiNK/gU3K9rp71oFmqH8XuNMslNqFQK
	 KE7hqpCNZab2TQFBwr3/1AcsIlThm3A5Ay9uk6YMioNEq9yEY1Fk/woDnNavWAqUcnWoK
	 anP/EGblCF60SA48kME68rl96wyql00h/ZFzqyBZGMvSs1ml+gu5FVukBTBVI0t5uLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHCgKPco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283CE606A320;
	Thu, 19 Nov 2026 02:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iHCgKPco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762981F000C4;
	Thu, 19 Nov 2026 02:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057137;
	bh=ptYkl1WPUAr6TklxOydCvVCxxG88R/w2IQK6ilRXWw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iHCgKPcon0dxf+XA1FOzKzck6gaffDdu7eA8qLspf/qjeTTrq2ZH5flrtcjnV6tES
	 CPTQUZLUyiUjdHK9PaRhd17j92RtJ+CIqM2ekOELXXPOtDXcjI8AA/4MPehr3eipNY
	 B6wjb/aEShxO3yRw7F7xN6/k/AAV4sOcDed2AZxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 0024/1848] drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array
Date: Wed, 18 Nov 2026 15:34:22 +0100
Message-ID: <20261118145912.071611932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


