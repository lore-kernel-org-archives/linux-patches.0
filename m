Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252933890F9
	for <patches@lists.linux.dev>; Mon, 27 Apr 2026 06:51:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272716; cv=none; b=VcDa+GN2LTQ9uwk4XgX6PrRL8QJ84NCd7FPX01HGq4npwqfBI6PGpx7AoAsb+JPBKelAHX0NQ35qG9oneWUo58k2O25dlMNNhTsl7gS+fmVzPilp0VHhI+2AASpLjWR/k6P4QdcDNjx3SgmKmxOZFKnd1nAF/n1f+JRwXDTMXMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272716; c=relaxed/simple;
	bh=SIkLTwXx+19eW46RjvDYfRGi/+vFUwsdkLTWEyKkJqs=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=AMKasnPMcGLpq/yUyw9OkPOG7ZKESCnWrXHSPUcQESWfoiYTV8urYaGQlA+TZfaoKg1w2dJFK1eNOPto97vCrIHIZ+OI3RAxzyU/GpUeX0RuXzX3A6qK47mg5u7RGgweW3bbwZhd1PvzHBMPAfXCujH986NY+PHxhmHqgzskdng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=EfaVkvpT; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="EfaVkvpT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1777272704; bh=ks8ggYiCLDadKMxcZ8CW+2cQqlh6RyPsgTtN23PYkL0=;
	h=From:To:Cc:Subject:Date;
	b=EfaVkvpTYvW47+GK0uzcMjTdJrExZAQPwbgVy9MEZz/ZWFMd/TZdbJmiprDOTDRzk
	 NkOYEh5KHNUboLXyp1cyd10nK/Pd7sv2PZxFz9cwYGeHbdOh1RtxchGvDPsejlPzGP
	 Hrq5/X88dVvveYmKvhZf7+ToGYJ8xwM+b+bS/BZY=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id CE98AADB; Mon, 27 Apr 2026 14:51:41 +0800
X-QQ-mid: xmsmtpt1777272701t78vn4y9q
Message-ID: <tencent_8DBF29E0271CF7880497A344239DA11C2B0A@qq.com>
X-QQ-XMAILINFO: MRMtjO3A6C9XhMGAw4Y2fX3RcOFCSr9oRvruFjIRTe12uuhbLspCq/SNuxvm7A
	 /fk2dEjaYSKw0EedVgPO6nIz6hLkHgVIovQaqi2r98YMvjd3U2/vqzWwcywvrK2hcL8XMVFi5mTr
	 aFZyz7oKC2HY+LAukPfbcNgTYO3cPCFsLHpUb88LlzUhakacuGNho12hcp7o1tkkH7SpO82enzTC
	 l0rglZjLbzM3vjgjglGL7IwDQNU7U/+KInd23qTD/reO+HdVks9XQNft/Sxih3dBovBCYiwqlwh7
	 VWHVMwhILJHDTs/9QmilCLXVHswg0JKsnu7b55aeN4XFb1ZJM9U7iEu15UXsoZNy7ai1EuUIV2s5
	 SRlfPND3AQ1Zy3BEShDgJY/qNHnUWu9uFxFGG7SBsGsEstl+uN+bph6AGZ8kajr/6RlJzxs1x30Y
	 wsVgutCd1YZb8grk02KL8527aQ7SDXjTjHgtVfYdiYMYj0LBroUGAiz8pDGlfQmYJ5mcAacQeNvv
	 q/G1237Jw+nE27gSCTdRFRtpBDQKalmmkFXAxf1SVX2ciLNkbmXVFkeRhCVZxzjM/sZU39Ox4EEN
	 dEzbzP581qm8P/KRqZY119BhwP0NTihokx3mIKXDMTrncrEl9DMUSPrWSYQqTk0hRyHmSPt2UwF1
	 w0yRTeSJ+Ybj2Nye9IYpODU6cq3/aiCVv3pO6fBZNpGqz2mJbmh6qvE1tKeaMQOl7B8pemJHyYzZ
	 9PM6fFZ0h0WYQIdj5xtVe9ZUi5QLRNVEJ4oRtWtfbPcBGQcxDrsxPKihk/yCDEK5jaey9QixmhQh
	 ID90LasAN1l0o+VryfPK7FkJ92QdCtRIffUqMET+vdgBLloEQTd5qyZkz6SQHmrtPt9nd84s072j
	 ExqWgGdRNSz9B9yTzEmmsvTiBkpo+/PmN4K1lTmGuogumRLBnJ3vhP3n2e+bnIgNrH9pJbn9f7op
	 Mi2kXYMCcsMJ5DBts/0KhejMXs313OQ2R0ENTa6EurJ77/3OqDZAUDM4tdvpx3MR+acCRRR24=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
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
Subject: [PATCH 6.12.y 1/2] drm/amdgpu: Use vmemdup_array_user in amdgpu_bo_create_list_entry_array
Date: Mon, 27 Apr 2026 14:51:41 +0800
X-OQ-MSGID: <20260427065141.4118590-1-32840572@qq.com>
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
index 702f6610d024..66fb37b64388 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_bo_list.c
@@ -184,43 +184,36 @@ void amdgpu_bo_list_put(struct amdgpu_bo_list *list)
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

