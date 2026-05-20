Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 865B43F23C2;
	Wed, 20 May 2026 17:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296873; cv=none; b=fHigcKmmlNgMpeCjrAbKQ5AHdNNWlzV0aJrzsSlU++fwxfgpRYp5gbQy40s8r+nwupOnx18So5D8XOFH+iUYAMR9rbgPX3la1SZncSiTe3p1ZQrw8a9m+bue2FIHlsj1IZvChkvtUoOGMrXa6B4D6k5kujxiPB9qKl8eYJTEgNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296873; c=relaxed/simple;
	bh=wF4Cj93NffJG+aJNrrWGKJLT8jFX50LJKNB2JrbvN24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pmjk+v9/yd7l5jeMq7ZRWPx3wghr2oSMn7Ty2ZFcQgl3Ya83Jv92r37D+/Smwbu7ApUTQIUlVvyFvbZBOzBWFKwPRQ51903uSow9nDLkRzPlolDtlReuU/WGY2srYMgcIJfVo+WOgdl+3eqrHbaY1TvfcBis4CjFXGNf1WURF28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E/rLsGj2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E/rLsGj2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E561D1F000E9;
	Wed, 20 May 2026 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296872;
	bh=8ime/L1RPMghicCRFvB6GufR+RvNEchthWaUkYuRuv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E/rLsGj2MJ34voJmS7zBJGbOeetuOnJs8PLTDVvLrigS0MhgmESQioYLfzQacRsRE
	 3yR2LbvP+aEA2xTk2XmLoZzwMnGqJytl9ca0i0atHI0ZF5X5ZfTyBW+iljaStoPQaS
	 OaSSzWryUsVplJg+wGrqsEMqSX6t409TUcIi+wMY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0965/1146] drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings
Date: Wed, 20 May 2026 18:20:15 +0200
Message-ID: <20260520162210.072020710@linuxfoundation.org>
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
index 2fe5b3fe287f9..81bba3ec2a937 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1856,6 +1856,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_dec_sw_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0x3f,
 	.nop = VCN_DEC_SW_CMD_NO_OP,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v3_0_dec_ring_get_wptr,
@@ -2038,6 +2039,7 @@ static int vcn_v3_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 static const struct amdgpu_ring_funcs vcn_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v3_0_dec_ring_get_wptr,
@@ -2140,6 +2142,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v3_0_enc_ring_get_rptr,
 	.get_wptr = vcn_v3_0_enc_ring_get_wptr,
 	.set_wptr = vcn_v3_0_enc_ring_set_wptr,
-- 
2.53.0



