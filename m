Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6F8C3FBB45;
	Wed, 20 May 2026 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301447; cv=none; b=mLlBr3e87ALNHYecQAn5gFmJRiNzeNdSBQQgH6IL0PMpIFsM8b+KXS5nYxfRppw76ikGbxAVDpnDhXXOYBpdfKq590qliDoYZHBG5L06CVTwl4uLBcWQxAbv4jDBUsBshBe8sgzreHLms3XXZxjpQFGAr/0Joztektqez5RAVv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301447; c=relaxed/simple;
	bh=ldgY1VSXA3CL9htaSzEqbQRdgfn0V2SNtLpxDZoCNHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fsxx5/IRzFfelRMkiASJ+D9ajLwLKlhDNoYNdzxrRfaQ0FAu6KTeUoA5NY60MXAYv7eAwFRZDRyNRZ4mozICbYAEX0GfxKGXPu+I6qunE2rP+NU+AwfSPr39oWuQn7TnIF0vCBi87zZCiHJcYaOCIxPppJcXyjtkR86g97IUQbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nE/VgXXm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nE/VgXXm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ECF1F00893;
	Wed, 20 May 2026 18:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301446;
	bh=lgaWIsU/bPINxjfx18puwB8QrPlO/QmMtdSRPWsrR7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nE/VgXXmh6PNAPchfKQg1d6ANf2sUEPZUBXNPI8cIJ0YriVejG7KcgQ0kVfbznTtW
	 DAlIjxcCOCNaLySzI3KDvM0lueGAEvbM8TrAwGiJJ6DD8AUjR/Sd7xQmrvSv1q7lUX
	 g/USTFS6WMfa1kFo3D5LUHovgKb8T5EfQHurJjgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 557/666] drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings
Date: Wed, 20 May 2026 18:22:48 +0200
Message-ID: <20260520162123.338310893@linuxfoundation.org>
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
index 53428a364c1ae..09f8324fdb990 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1791,6 +1791,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_dec_sw_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0x3f,
 	.nop = VCN_DEC_SW_CMD_NO_OP,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v3_0_dec_ring_get_wptr,
@@ -1972,6 +1973,7 @@ static int vcn_v3_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 static const struct amdgpu_ring_funcs vcn_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v3_0_dec_ring_get_wptr,
@@ -2073,6 +2075,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v3_0_enc_ring_get_rptr,
 	.get_wptr = vcn_v3_0_enc_ring_get_wptr,
 	.set_wptr = vcn_v3_0_enc_ring_set_wptr,
-- 
2.53.0



