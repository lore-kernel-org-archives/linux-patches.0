Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A64023890F9
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 06:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272809; cv=none; b=vADtwiNJPwCxnZEPCGDDNnGlI7on0g0s7UhAwrwWZkU8vnWhPY723WFezx82V6B6Qm82t3x1/g9baXF7CanAvmBgbWy9ntzwaVJutrhw6NNnyoHbOELVI/G2s+YSehakQ875pjNyQQKa5gFTyejWrVMNmDedru26wFxWHuwZ/9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272809; c=relaxed/simple;
	bh=lgsCrfPPkyLr4YTRjW2HIzkubwkhU9blJZGzYQm69SE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=sroKQib2bFbTmM0P+IwbKXiTanWr1ZreUhxM0A52roJSV/nCJNIAaAXx4xQU+NGzr/UGUVMzuwK9nXXmgsHtrBptqDll4O1QhR8N4JAvISHrgCfjlP5Fsze3jcC8daAsz3pYLifYogGMwMacTFGCtEeb0zXIOLnRNiXKSOULggU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=hTKL40h5; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="hTKL40h5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777272802; bh=0mkejxnsTB23Jp3d1Q3P2kz8sbot759qpDDeqcIrlvA=;
	h=From:To:Cc:Subject:Date;
	b=hTKL40h5sr0Kd28T8QUNfjkkgu/qhjMXQNMEx8FWzJzxW8tD2DLBYEz7YM5LzqQtN
	 tA74iaqYhbO6wnQ0OilgkSTzD026TkbY85pOxDGF2JKDMOYwCkF/Hs8jRgj3ummIg6
	 vfNMzPe71LQsyjeClDNto7HEMHeKkeoY5cFR+ayQ=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrszc43-0.qq.com (NewEsmtp) with SMTP
	id D53116DB; Mon, 27 Apr 2026 14:53:19 +0800
X-QQ-mid: xmsmtpt1777272799tb3gjvyp1
Message-ID: <tencent_1AC70A6F0BF843C72D2291E585D1CE675308@qq.com>
X-QQ-XMAILINFO: OIJV+wUmQOUA22oh1Yi6MfhtC+CyTmbj2Vcjz9/btNRB0f31GKlTZwg7PCGBEE
	 3JDBXbeS5GQrwmCAkIuzRpyeW0Y3Z3+Qo9HbcRLgNMiYBsHLQWJf9lnrb7vOBFn4tjku9COlH7Fk
	 e7+hK7C4EdvEgnXJ4k/pdFbMeEeU8BDWD8qXKxUlnxiiGDON8gewjeVWfGA4hmwIjr/7hNefnuAt
	 eGOUcYiztH6YBku8fE13OC+DAiX1X2Qc+N2i2+DAFdb1Ua/7eQVB0XCfVONMTpg5b1VAF4GEa94j
	 xC0w+ViNCnJNXA9dMMNjDzqPGXBdTUuFXQVkKcJYEOxw5+fUixeze53lzuSw0O0Zq9q5SZc0ehvB
	 nNUiDLk+7Yn8/xNf7CSq6N8FlGIRGYHXldCqhsQKafp7sCB8ekNM2eix9/8ooNAqaL3ydYfl19e8
	 Mi3uKJafFyOVVatmMhw37MCHYb4kZVbg1T6J2yHc0yZupMU48QeonWqnu7+ke4QscdWzpPhvAUnZ
	 y8rAITOkCtrNho3BUqjacVh3l0ienv/lUURKigXKX+4g5O0hRr4+YQGednJuvmUankmU/vQgXD74
	 EQrdo5BOCJgVKP27HzKLPn5HoeSIiEua6SOFtqqIdBHekS59jYmsHaMNlSqUafgF5kb+WSQEiOtZ
	 /0sY44ffdjW0EGK7JiBMeyMMYSHUldbZ04ncuHkCXG5kUw4IzH3tLDC6cn9A9AvQjn7cUtEtOWOQ
	 6/2dbQvT5HZR8Fo619DygET+UMLRN+QPP0645K2bZBl/5ZUfZAeeUHmgB0zFKohEjqH6wog/qX2q
	 3oXHr+w37hm6lfNlM/fZbVeRBMPA7GBCQajSeCur550PmjCoHq7A0KOsYNOEL3itnASXBtTLxn/x
	 xon7eICaSD/a5BCjb7xqL2uC/5FO4smbRFbnlBSfrPCWxQZBDw7XGNzX3lGKahMsYOIGIwCbOzRf
	 VK/C22thM8aETA8D2zhI+TphV2vyaSCnw76t9iZqX3sXqzlT6M66WF2zJCfdpAWKE9Sm8uBO4m21
	 zgm7HUN9J/J2uKMuY8tWPWJVoLtaMw5ECjBttLsuN/vqDMI35JFK031lMdHYWyDb//4H551tJO6h
	 oR5cnK
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	tvrtko.ursulin@igalia.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	alexander.deucher@amd.com,
	christian.koenig@amd.com,
	Xinhui.Pan@amd.com,
	airlied@gmail.com,
	simona@ffwll.ch,
	Jesse.Zhang@amd.com,
	amd-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 6.6.y 1/2] drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array
Date: Mon, 27 Apr 2026 14:53:18 +0800
X-OQ-MSGID: <20260427065318.4119528-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit c4ac100e9ae252b09986766ad23b1f83ca3a369d ]

Replace kvmalloc_array() + copy_from_user() with vmemdup_array_user() on
the fast path.

This shrinks the source code and improves separation between the kernel
and userspace slabs.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Fang Wang <32840572@qq.com>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c | 41 +++++++++------------
 1 file changed, 17 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
index 9a53ca555e70..db0a1c828fe1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -195,43 +195,36 @@ void amdgpu_bo_list_put(struct amdgpu_bo_list *list)
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
+		info = kvmalloc_array(bo_number, info_size, GFP_KERNEL);
+		if (!info)
+			return -ENOMEM;
 
-			uptr += in->bo_info_size;
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
-- 
2.34.1

