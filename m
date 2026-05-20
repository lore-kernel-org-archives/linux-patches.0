Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848D93EFFB8;
	Wed, 20 May 2026 18:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301463; cv=none; b=BosKj7CzXD42l8+ba7Yu2G2igBSH+R2NjqxUf2XoRdlZIWCuXbDCte0xKEs/Co14cDGjjHdlh5hLSSawEYR6eKKGETvpJE+/sRUCMhtj2xUBLMCLM/fv3Xzc4S0l1rzkKNJxZrvg/LDUT6atpLGlMNzokikpWBDeikiqACkI5W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301463; c=relaxed/simple;
	bh=Qi9+z9W28Tda7TJVWfKURyUexjXxuETS1FN9IvJ0u5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nT6qcYQOAMpLkQN+Dc8t1o0a0UzVdqRNvmdILohNNgK5vS9l25iMcdtpTDmYzIhv7YDYpI2sW5O591OApn9wrZKqLJrnJswegvNs/CSGmd3OuxRBSVQePnzkJ2PiblGODKVEEOWNEPtbu+fXIPWckQvRdSbdhYRAVIc73d4NBy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1WxtWjaG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1WxtWjaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3351F000E9;
	Wed, 20 May 2026 18:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301462;
	bh=/S5cfaJCG+2y1fe3b2uHMYmiTUL4g0iTtFJPg59n0jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1WxtWjaGQaBjhPAJShAAgT28xCLbg3L2iNlIvRj2MlPE/+i8Y3eij9bTZrR4dFEpG
	 GGVJJ00C2Xo4fk6ABrSMAW8QHaOR6ta4iibMYmnFbv337OB0h5Jm+f/NKGXjWp/ioo
	 z3kwnjzq++4gMNk1nVUUcJnmZHtSXqVmvZXBKZWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 562/666] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring
Date: Wed, 20 May 2026 18:22:53 +0200
Message-ID: <20260520162123.448099500@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit 79405e774ede411c6b47ed41c651e40b92de64a2 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 14f43e8f88c5 ("drm/amdgpu: move JPEG2.5 out from VCN2.5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3216a7f4e2642bda5fd14f57586e835ae9202587)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
index ec0fa685e1275..e4cfa6b7141f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -659,6 +659,7 @@ static const struct amd_ip_funcs jpeg_v2_6_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_5_dec_ring_set_wptr,
@@ -689,6 +690,7 @@ static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_6_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v2_5_dec_ring_set_wptr,
-- 
2.53.0



