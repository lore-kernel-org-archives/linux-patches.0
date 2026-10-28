Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215179;
	b=ijDO8OrFBDqolKKS6cpxtINfzdsfXQXqjjuGC4/UN+Un4jyO0OMXQ5efnXoNVC+Dtlbc
	 41CFk8QDHtn9OkYIhHnyeNqiX4Ll/LA13y+k/c2ce7h+pmb+NUDPi44fNz5XtY5KZCKLv
	 H9rW6FFOc6GwYIj2FSPgAfXZ9ornkXkrh9HXICsmAv6wr+h2k0p/r+NtgJK+sTa2XvL4+
	 ToqnuXGz30oNsmEcLzHyxbuHiaJY74oPheGLuB+bbGUkOnHNEIOiDzH1Vka0IRQx2WKtm
	 6Ea+AdPFbVh0RkeXVSF7Mc3nACqdBJKepawne6mUUuuVB9F/GXP5aRJdE+eN9WXTMtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=p9Xn16h7IDNXOpcXrc4iTebHsk5hKin9d5h0kALRefA=;
	b=SoN5eM2usCb6KyofqO1U9LdW2qHpRWlvm5AVI185DtJwF/tSt6TUK+tMCv7w/rgZrfQ/
	 eXWrFobXuzB2z0HNXAU4Ps5lRqRCRNiU2kouGTDwFQGvfed3pUIDqmxZ9m+wXLsD9rG4Y
	 uxSThTkAvbAVZDq4bV+jmfxTlUJFNL+qHGfjeKbeIgR7IuJAX/pmsDAdb3gxeI9iQRSz9
	 HSWayRzJBgARq+Lq6DOEgeLpCGdqquZG+08Gph/MhIGl8nKTzUSNcWb0TcqTnBQ5p/x+H
	 /NFcvP3TPKH11/r1Hz4ohGCC5NqMJdul3dRyOlfOibvga3sMxyZzkDYuyJLpnDSroGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bh4j3gSz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDB6606A31A;
	Wed, 28 Oct 2026 19:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bh4j3gSz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A92B1F01825;
	Wed, 28 Oct 2026 19:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215178;
	bh=p9Xn16h7IDNXOpcXrc4iTebHsk5hKin9d5h0kALRefA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bh4j3gSzbNNaUNBUIF8WP5vQSqXvGC7yg4ImWRu+xf/MI6weyJdl0UAyUswD58znB
	 /TMiRB688CCwvCloimIx0MZXE6SBkdlBDScsEId0BmYk0qlzR0t0nUASdVDnobap5C
	 QjVAWcOmsjs/BhOi2T4dkSiyeh91U9ZEajxJ/HhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1119/1887] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.5 ring
Date: Wed, 28 Oct 2026 17:53:35 +0100
Message-ID: <20261028170524.866679711@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f87d0f6ffc93f..a094dd138c0d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c
@@ -641,6 +641,7 @@ static const struct amd_ip_funcs jpeg_v2_6_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_1,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
@@ -671,6 +672,7 @@ static const struct amdgpu_ring_funcs jpeg_v2_5_dec_ring_vm_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_6_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v2_5_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_5_dec_ring_get_wptr,
-- 
2.53.0



