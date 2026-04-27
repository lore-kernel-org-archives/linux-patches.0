Received: from out162-62-57-252.mail.qq.com (out162-62-57-252.mail.qq.com [162.62.57.252])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB9ED3890F9
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 06:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.252
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272875; cv=none; b=nZk/kTpUnXwXsIFEMi3d2rKA3/PABMYx4JBa3CqUPuTC5xX+bsEGs6BjhR3HAIj0HbV4K9Ek9y9U5o5GkWx6eO46MVpaAj7naVg34wix2zQQF1M7oYy8xrV9R1pdwfbD6Ct0dey4B/B9ifNqPr/+TXe20LxAV1Q62oMdqkAlg38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272875; c=relaxed/simple;
	bh=X2hNTM6XFAESO1jN77W+k3/SkY/iIVyy9KmHDLkswnM=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=JmSQom7XYj4RysG25Wbahjdz4r8lSBpKsv/gkQIuYFjB1X3gz/sS90wRC3XjOn7FSCjNULqEpbthkb5UBld9UWDe88buudAkQgDFqJKNRqqVZtZwQdO7BnPs9Tq5hRaOWywbnuZbRxe+1FWN0VM6KLjHZNcZf0k6f7ax8plMEoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=sphg3pzn; arc=none smtp.client-ip=162.62.57.252
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="sphg3pzn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777272868; bh=lHLU024aAwcguS5ARAG4kBqUfkxnD5hl6+Lo4kd7XPY=;
	h=From:To:Cc:Subject:Date;
	b=sphg3pznVc8Hk60CTIyI+ZYxz9pCeTnTV/tszP+CgxJMHzVRWuJP9DNurDM9rvvbN
	 JDV1ksstTv04LoxAARp2IvTMlmEV+JkbCh8wfsPEwYV2kqJzpXCpiV6+I8ZXIJhc9e
	 Fj9LNPm3e75SJEnULLm2MyKe4308FPIrFxX246jU=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id D99A8494; Mon, 27 Apr 2026 14:54:25 +0800
X-QQ-mid: xmsmtpt1777272865tepqw5bdl
Message-ID: <tencent_983388E3E437227CF3632311A472F9E89907@qq.com>
X-QQ-XMAILINFO: NGZp1yYNf7Y+XImPKHod7cmbUONk4HZ2f3rdMQkVnqsXgSgz30B4xqrsAGR7js
	 kFrpGcBqy7N9NtT1oJLAgLyFdGeXQeT4hTfZvvB3UIc+mwTT9w7+rcoCRedGfRn32joDZ1N2CpeT
	 jhJNkkL4VCkMUUgYqkpuLnsU7ru3cU6Go887wJd09ri9XQyJD1QQZAG708uNyBR0kIrh4D5J2EGg
	 vu1bOEh88zwYaQ9Vb9q8GYJpvS+Nk6PQ9RMZf2t1w+qaZkrbu0OEwaqQ6fhRr4pTV2Q0vo+c90CJ
	 cohxr2xmdbBZK+ymZ0bKVp5bozy/tqvJ9iCSNbbbOMNA+hzobsiCChWxjRhUYPWjWyFQgcSFugiP
	 zGXak2ssj1h6N0JFHs3Giu+II7T+eWkpTaVx+6rXVjjbqmpLHtrF1PD2Nv21legm0BlxTgyqMV8V
	 EYgj+kBjVMN9VKVZExlf5Sk8VcVYdIpoUIs/Z1xK4TRKp8680/ZVZf3px3JYQmrl19xtbvugMMEx
	 YUx7LpTuHCA5C5LTAOGfSXdn3NcYcQbAUcmTBv0YHr6W6En+XFgHkZMkbqVps+P0CtcUKxCGizo0
	 58MMu4g0mGSUkwezMc8CcMiJ2lrmkui0OlJ/kMOtEt1HEm75hNkKwWRUNaZtPzgfnJFAwg4RZzYo
	 S7PVrMBnYPN+jj2cV4AC6tmARxa0/Ft1qdP3rKGDyO+dkJyIQS8N2CYYNzm9VCxW+re4HIVEdTf4
	 1jC3HXLu75GO8Z8H+cJACJLDXlPXzVOqCFJs5Ol/CWyfPIue4OovUdnxhTz/Qfb37Xog8yLUTPya
	 IcRfhBCobFUZD4p4wCEjp20b+ws9OpAfxQVZ8FUTbpKNBw6d58TzydDA2B1zp7KGokVrCwiJBT4+
	 b3NVHAYqgmQ01jjLmJwg/J6iKdJCN4U893Qbr/WwWzAMHh3jo+Y8ym8sjeGvHH+2jR+B89e/vKht
	 aofPLQbwymIYgyLfeufqB6C4UglGjaOwjlNgsdw8zzL6zsWoGCSWFQzvX4FipIOl/S3KVHhIwQe4
	 bipDdVA/gtnICNu+aV1v/8+QDNKZtwij3nSuqlWoLD5nNUup0FoXB7jLXfU9A=
X-QQ-XMRINFO: OWPUhxQsoeAVwkVaQIEGSKwwgKCxK/fD5g==
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
Subject: [PATCH 6.1.y 1/2] drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array
Date: Mon, 27 Apr 2026 14:54:25 +0800
X-OQ-MSGID: <20260427065425.4120132-1-32840572@qq.com>
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
index fdc302aa59e7..79e43896eddd 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -226,43 +226,36 @@ void amdgpu_bo_list_put(struct amdgpu_bo_list *list)
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

