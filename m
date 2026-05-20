Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC1B35F619;
	Wed, 20 May 2026 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296905; cv=none; b=AwoxOlsua6+4L/YO4RNj6bD40CPPCG8Oc8dzq6a3KTjxEGvtNTv8IdZZExQy/GTQDutnmFeqnuWzj1C36GP2srw2XH3/kesVTosQBsNKV3fyQgwY9/mURXXeoqcikuTnfhuFIyULQhrO4j62M/SJfh9LIh6hhbZrZjlIfMQ8csg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296905; c=relaxed/simple;
	bh=Y/blYIi7A9C9CVnii25p9oMrVv7mKpsEXyBsvyKwDsM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WGDLXL+2wPvF6YqjLCGq4GV6ALd3yD9+xUC41TatroWQ52jOJfdeInSnB8fFnYH1L65+J4CQa7RGefjPlIcUdPxsmXvWNXbqzuv1mvw3eG90R5vivy61MT30lVfXgSMHR77cKVHcsqliOiXkua3suG+S1EcH09YZTQDwcYrHZzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjoR+gcU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjoR+gcU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 954431F000E9;
	Wed, 20 May 2026 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296904;
	bh=KUG5OTmNbs7/N48LExVWp0dDKDJRkdsOehIAEWIbg0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jjoR+gcUCpaK03mwUkPYDmtxgXd8blNWvOOYeHN8la1hdTQOORl5Lh5nPIAc3ckZa
	 XhMauCvkktCJUko6kEbzhbcn3mbOUWEIeUNfZeViXVGK4BAiuc+QpGJ825bsaRy32S
	 kXE438rJoo/HyGpyPKY+MvpoougQkF0titQVKWgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0976/1146] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0.5 ring
Date: Wed, 20 May 2026 18:20:26 +0200
Message-ID: <20260520162210.320738707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yinjie Yao <yinjie.yao@amd.com>

[ Upstream commit b65b7f3f3c18f797f81a2af7c97e2079900ad6db ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 8f98a715da8e ("drm/amdgpu/jpeg: add jpeg support for VCN4_0_5")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit f05d0a4f21fc720116d6e238f23308b199891058)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
index 54fd9c800c40a..a43582b9c876c 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0_5.c
@@ -804,6 +804,7 @@ static const struct amd_ip_funcs jpeg_v4_0_5_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_5_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_5_dec_ring_set_wptr,
-- 
2.53.0



