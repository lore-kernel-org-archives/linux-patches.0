Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215181;
	b=LxD9CatC62z5oNpOGIortG2M+fTbfSDIbauFQEll84zqGofEeLBsxEthNVwtjc6IvXbc
	 8NbkomoS2VgA6mksouiszQpJWmxLsu4OfB02l3sm/YBv3HlDad2wa8PRlgtNwkOW+lit2
	 iGg85ZWC82i4ztj2kTCPIh3dPjrcUDe0kd+DszdFgsUzUwfBQ3Cwn4BSU0vpRXmfylul/
	 2LsBGA+8ESxGKBZI1khZdxsIMnidHRY73pDUz3saeD71uRpJNnkA+i9sL1qLYtgJVqfYy
	 jfw7J1edU8QV5hLwDNZ/nG0gIGJTzp8QBBxvaiKsOSihNSvxWBlotdSZlZMOT8BOa+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215181;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=rcAwac14WWe1+UrFZ0hJHPil1boKQcrn/4uvF3zpbmU=;
	b=mHrbb6pn07MHdSz0VqroF5X50hXWZ947xMO3GBqse1bFP4WL8XAsMw0qk++WE+hE3tOa
	 6tIo75hPK/XqZGE0mPXZLIUKEdISRxzzoXtpiaad/sTv0rrYMbh35jSWp5yIePBngt5lM
	 Wn9FL+FaNkY47jMujO3B/4pPLPGgSfWlNfu6zTDISv+iNBd/9o+ZqgX6+yNxJtvZ1VLU/
	 NLWqwJcHjFm27tM/KuiLzuAwYEbMjBWMveMo2ON5YEfTBnTgqQjVwFVc5nKdjrJ0q+9nq
	 he4p4CMFd5go0QBPavtd+17+WU1eOUazsGrwgDyroEGeZfaKtNSvdEPBAH93wCZUUVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuyEllUn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95933606A31E;
	Wed, 28 Oct 2026 19:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wuyEllUn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66131F01825;
	Wed, 28 Oct 2026 19:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215181;
	bh=rcAwac14WWe1+UrFZ0hJHPil1boKQcrn/4uvF3zpbmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wuyEllUnAHy2+SsIYt81AgUAbdF10K2VRNajEGU12IQ5bomfUIzxugTjL7/Ao8o0E
	 5J0v9W29EmWtFscieVX6mgxCUtssFrILJn7GFOtw8E6vhKlcusykFh/nc1hGVy6R5b
	 E8SGmwknTsMHTCVLkp+w9dZaU7+VcoU+zw5YOKgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1120/1887] drm/amdgpu/jpeg: set no_user_fence for JPEG v2.0 ring
Date: Wed, 28 Oct 2026 17:53:36 +0100
Message-ID: <20261028170524.889871078@linuxfoundation.org>
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

[ Upstream commit e5f612dc91650561fe2b5b76dd6d2898ec9ad480 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: 6ac27241106b ("drm/amdgpu: add JPEG v2.0 function supports")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 96179da0c6b059eb31706a0abe8dd6381c533143)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index 3301ad980f28a..af8f244e9c940 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -762,6 +762,7 @@ static const struct amd_ip_funcs jpeg_v2_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = jpeg_v2_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v2_0_dec_ring_get_wptr,
-- 
2.53.0



