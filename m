Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7F6368968;
	Wed, 20 May 2026 18:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301456; cv=none; b=NG47bu7BvVehQYw4MSvjIYTXrFVtlsU6brTAbMEDd5666pxRxa4/JRvu71B2A5TqyQ1xIa47hmqmTh/UhaQAdHD4p1SNCZf+Eo/z7YDn0t5jksepBxxQoz6zVYsrNELnBk+vo0tw1trABfqVj/wzZnGD9Rfp/2l2soBsfVk/H6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301456; c=relaxed/simple;
	bh=vlwBw0wCua/lGPABLB9aAr6wNoQUOmoupTQzYNGjcNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEeFsIO6Sr9HcFj+WAqdLxP70DLVxhtIcT9XYnE3mGEERpllDddN+yl7QwDOIX5cTaccF8knRIlSw1Es33nQltA4GsHOE3uzAGOYorlSsYdhZeSlZARgfc3tF3CQCY8lo/uOKkkTA7nfHWURv20vIiYQ69pCHCj1sToQ32zPOIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZEGrjtBI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZEGrjtBI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4F81F000E9;
	Wed, 20 May 2026 18:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301454;
	bh=U4zmN4l6xtEIj7p2FwW/3shQDqVVYCvcqrDeNnX9MEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZEGrjtBI7D7akzsJ/FL3104Jay16otlHSGtj6jzdL3ul+oizn4FvWnVw66NjcQluh
	 NP9HYnXXKSWlzoJXeoAICDCcNgUgpJqYT1CWJ23sntQf4XW/g5FYkl1/zXUXdlufu9
	 tKTL/EzFchPsrzTssrVzT9har/h3M+iGdSKiXx0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 559/666] drm/amdgpu/vcn: set no_user_fence for VCN v4.0.5 enc ring
Date: Wed, 20 May 2026 18:22:50 +0200
Message-ID: <20260520162123.383473841@linuxfoundation.org>
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

[ Upstream commit 589a254bf3e88204c8402b9cbccd5e23a0af990f ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: 547aad32edac ("drm/amdgpu: add VCN4 ip block support")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 084d94ac93707bdda07efb5cee786f632de4219b)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
index e2533776173ca..f0354a7dfb461 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
@@ -1414,6 +1414,7 @@ static const struct amdgpu_ring_funcs vcn_v4_0_5_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_5_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_5_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_5_unified_ring_set_wptr,
-- 
2.53.0



