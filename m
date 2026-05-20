Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC553FB7FC;
	Wed, 20 May 2026 18:46:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302790; cv=none; b=R7oX4E/6R90ya36Am7BVOdvKhfMkNT657ikTszjpFDkd3sHDuJnW6tAvi+77evaj97ovUnENvHoRrJYF8bzRat6gdXiEpeiifNiEg5hF2sGD4fJUQlkGaCdDlhm66WTnd6f5QFWWWKzLJpqoZgkcmZCgGGHBcsUIizgXWMzY3cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302790; c=relaxed/simple;
	bh=ettvZWoeP9NRChqVTuxw8CXKtj8pYeNGV45DUuGTHes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hX58OdES+X/qy/t9Yz4OiMmazvDSJWmTMn7NsfmyxhyDshW09qwVnGeU4AufA6qIIB4Y4QOIPFg9P6Jav/FCweZOZSMf//5slKZCqSJmN8UtS5ou1p0hc4PtWM+UTWo5giProQ8SFeafPqOQZ/ozlBhkC2TPqe6ujNlpbieZ6pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSenH6xL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSenH6xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C92371F000E9;
	Wed, 20 May 2026 18:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302788;
	bh=grEW3ADLvWPC9Ja6EtC7WLsU4afMsjH/dn5RXhWtf8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bSenH6xL2INFODSFkMYxGO+OIjwgbgjpoprUPcHpGVgjuKWp3dzSKvkTdRvHS3/j7
	 2ITbK8d+cepiImRHfjnIEll9aihF5kvcwMsuq1ULO8+bLKWxIdGSm/JmJjicZ9t7ak
	 XgWqhsuvl65WG+fie1C6JAA/H7xFVPEdKdgn/ntg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 401/508] drm/amdgpu/vcn: set no_user_fence for VCN v3.0 enc/dec rings
Date: Wed, 20 May 2026 18:23:44 +0200
Message-ID: <20260520162107.301931926@linuxfoundation.org>
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
index c9345da548a61..37b93af917fe2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1737,6 +1737,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_dec_sw_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0x3f,
 	.nop = VCN_DEC_SW_CMD_NO_OP,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v3_0_dec_ring_get_wptr,
@@ -1918,6 +1919,7 @@ static int vcn_v3_0_ring_patch_cs_in_place(struct amdgpu_cs_parser *p,
 static const struct amdgpu_ring_funcs vcn_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_DEC,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.secure_submission_supported = true,
 	.get_rptr = vcn_v3_0_dec_ring_get_rptr,
 	.get_wptr = vcn_v3_0_dec_ring_get_wptr,
@@ -2019,6 +2021,7 @@ static const struct amdgpu_ring_funcs vcn_v3_0_enc_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v3_0_enc_ring_get_rptr,
 	.get_wptr = vcn_v3_0_enc_ring_get_wptr,
 	.set_wptr = vcn_v3_0_enc_ring_set_wptr,
-- 
2.53.0



