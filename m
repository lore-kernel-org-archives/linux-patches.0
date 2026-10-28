Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215187;
	b=5qFwVYIMSbib8ITnolt/23KmrcScOw+SjShLhCXbNT2UYSbmBUFw7hXr1M8IsZ3AvqLh
	 qJkuP6x9r12Kd4DfiWExDNm1UwP0u1cP1JfgWo7pBr76iXinhpX7IRsXs+5iIEWJXtuXT
	 0c09QhdZuaSWsaIzoWJrprpztJPNGeoEZr1nWBQb6tC0UlBsKBHajaou12JVRUQrOG7qf
	 jt54Wlo33FgfgMZQrdOXxcWUAVREWD5/M5HD9xK1R0nJTask3oy6p3q5fegFioGHpGhH6
	 zeFUNG9QPz+9O3n5/E5cDzTe2lx8pt38HKF1n+H/2H4l11yncCt8sPYdKJuvyazUYVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=khKD7d19aJSFWbvnUujJpiRLgxf2zrnXzrMk6L2KC/0=;
	b=mCr2ydyIdN9DDPFLfCQNNH7x8Mmyw7iPfACmVcISoiMneS1XKi0MAqvTeemG0pwHSHsv
	 WBjxx6pQy3bdI5xvs2ZW1tOr6u87pFpRfKC3ZC36gRSkyuOac5LdV5kKhnforShtlC2LA
	 5tV6yXjjegtRwGiT8KQGeYURfOr4ec5UDOC4kc1igjlc3fFdhalZfDk1SCwoKAxdXBllP
	 nutEDMiWHSYL2Xv2RtLodlfJguPfnyp3vjRGDL1uqAjqFdqvFET5mOqA0UVLXp+pd60Bj
	 9bvBOCDgfH1Aotdt5M66W0VlOVULrkjmkw2IcMlHrFW5i5/wHXMt1afOxUOJ2pjTl8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OSYPwEvj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D706606A31A;
	Wed, 28 Oct 2026 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OSYPwEvj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803721F01825;
	Wed, 28 Oct 2026 19:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215187;
	bh=khKD7d19aJSFWbvnUujJpiRLgxf2zrnXzrMk6L2KC/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OSYPwEvjF1K1lgEMReMuRSAa7YWtouu80doMzjcUjMol5ft6mmbP+qT8VlziI8Sgv
	 LCT5wYd20hMi/U8zOcJrBG+0f23WIO3HEgQ3rR/ybJaxIfCkkgOrOf64zzpB+zmHjL
	 8gedMZTrh3Nad+PrNMzyRLzy9+dSIhgWk5ek61fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1122/1887] drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings
Date: Wed, 28 Oct 2026 17:53:38 +0100
Message-ID: <20261028170524.933810940@linuxfoundation.org>
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

[ Upstream commit f1e5a6660d7cbf006079126d9babbf0ccf538c6b ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: cf14826cdfb5 ("drm/amdgpu: add VCN3.0 support for Sienna_Cichlid")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 663bed3c7b8b9a7624b0d95d300ddae034ad0614)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 478d75b268b1e..b73c642b7dc61 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1736,6 +1736,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_dec_sw_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0x3f,
 	.nop = VCN_DEC_SW_CMD_NO_OP,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
@@ -1914,6 +1915,7 @@ static int vcn_v3_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 static const struct amdgpu_ring_funcs vcn_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
@@ -2016,6 +2018,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.vmhub = AMDGPU_MMHUB_0,
 	.get_rptr = vcn_v3_0_enc_ring_get_rptr,
 	.get_wptr = vcn_v3_0_enc_ring_get_wptr,
-- 
2.53.0



