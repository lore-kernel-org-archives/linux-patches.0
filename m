Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C79EA3FE37B;
	Wed, 20 May 2026 18:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302802; cv=none; b=NM8v/NjKEKtykKygktf7Szx2FwMla7Cgoew/IV5yU+1+oa8lFSS9xjUZsF0jnaZ5VGcsk1rWTYvxFWPO4GflN3ZxoBRHJwOWvQ7fmi/KujIcud4kBZu9KXS0GE3DA0Lzbb1WkRYEd8uJN7G0fVMs9V2dqqSPJINERxv/Z7VQwbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302802; c=relaxed/simple;
	bh=m+lQyApD4dB9woCVyAkI+oarMO1gOqHxqDEx+fysfJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EnxUGLEcgZHKKkQ0sOHQlcxsVNnV1w3D5uHPo5BCp2Y7y6fxXzZDsVy6t6vHLMMjd0ho2GcpWmeSpj7v2VFkMvb746yKj99/wYZqfO6QAFTq01wAPDolcQrnYw+HBNSrblxT1SyWQdXk7y2+MVClUyXRhLnCVehBTyxEG77/VqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J+irw4dI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J+irw4dI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7771F000E9;
	Wed, 20 May 2026 18:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302801;
	bh=i7x5bl+qVyyqiDfsvfVC1YbRk3nEvhWhvtGP/at+rq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+irw4dIwu33hsclrmRpLvVsUuJ3uCCxahlbyjLtC/YeN9JqAbCA3y+xSZbBg3pPk
	 mvimHTOxVbU5NyPNWlFYxq2221VdUzknQ3iMAWumWzVOJ4Zg1k4WtM8XgAT2CPmX+V
	 jYx24wszgWtHDJE7/cF/cYS2iu1/Lm/ujKmyx1Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 406/508] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring
Date: Wed, 20 May 2026 18:23:49 +0200
Message-ID: <20260520162107.407519215@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit e7e90b5839aeb8805ec83bb4da610b8dab8e184d ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: b13111de32a9 ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_0")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8d0cac9478a3f046279c657d6a2545de49ae675a)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
index 3eb3dcd56b579..9d4eb9c8885f1 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -722,6 +722,7 @@ static const struct amd_ip_funcs jpeg_v4_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_dec_ring_set_wptr,
-- 
2.53.0



