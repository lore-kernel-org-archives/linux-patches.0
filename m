Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359E7233933;
	Wed, 20 May 2026 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299533; cv=none; b=HcVeBqX7fv9du8Dw6qI0VKsy/fxNiNMu0YR4Yg/qhr0MHORwJ1TgnS9ukseRLkeYVY1PGhAgZ5BwbFh9JHMOtdmslRny4KQdZ05vMtYYATllWgbTArjVcSmAbNwNwEiG1thDjGm9TXhA5tF3YTo6GUqPh+6hL8Bix3SiZSAUiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299533; c=relaxed/simple;
	bh=yz8QbgoAm7boeJ5Dl0NBJ1b/eOhvKMZfNGYlzePGFf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qJxen6I2luieToplz9I8NXKlFX2Px3baE4zqT4xbB2sgQmkCIhDjWL6qhKMItVYvJI7BU/51t9sCXgn0n69n3Go15VDkE5eDoJkOtcqBlXnekGC3EDidBvDRzv91GYkFrqgmE5ZizGgF053mQ8d3ScZFsp2RSG35z1S0UlQE69g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJDk7D1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJDk7D1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D201F000E9;
	Wed, 20 May 2026 17:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299532;
	bh=40xS9Ei5RZsZlhZzAfrOqwNnGx0drnHf7guVK82cgF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJDk7D1tNgilKK46+e2hducbfdll3Xe6xagc7fseUcS+fmwrzsGlaksFjF+3IWqAK
	 qQSM+1rgm+Rfqn/jvLAditX2wu7CgSTdIHWbjENE6j/BqeJ1m/aN2PlGK87/eHmY+7
	 chspTZrtoROhQPBBp2XjVYduS/Nx7lJbs4He0o7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 809/957] drm/amdgpu/jpeg: set no_user_fence for JPEG v4.0 ring
Date: Wed, 20 May 2026 18:21:32 +0200
Message-ID: <20260520162152.111313777@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 33db2c1ae6cca..90582066e6a1a 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v4_0.c
@@ -759,6 +759,7 @@ static const struct amd_ip_funcs jpeg_v4_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v4_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v4_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v4_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v4_0_dec_ring_set_wptr,
-- 
2.53.0



