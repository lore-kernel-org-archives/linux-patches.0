Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D723F0A83;
	Wed, 20 May 2026 17:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299625; cv=none; b=UunfhhrPhfk6XpFb7MfI1E6L7j6fwKuhp0sFFrP1q2SeJkz2fIiwD3b3MWobmyIC/ApH4NqqPbdc8BnnD18LTDgWZkQQLcd1GC7ZIh5ps/7TwCHRpXn9En8+l8mjJI3exBIi+QdabK2l7P9bbqrYffw8aI0FtkfumrxeoRhD2gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299625; c=relaxed/simple;
	bh=CfBCVaU1rZ1tECugYvxF8R3YtsD0PWf4ibLwTLltZeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b6pJ2/ABSJMOGwh/mYn5/adhhoSpi0NkhK+gmcnkLp5pIVDD7lkWz/3SqWuNHhPasFdtTJ/g+nzyIqHfJfeyDUop4CcltkCaDJGRy8S3b3EJHrP2ysfVPNP79GDFyZ7tN5C7n64Qh6bdPPv1jDnaV/f2j3McSIZmLOrXe+AtYz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUZaDIm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUZaDIm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7B5E1F000E9;
	Wed, 20 May 2026 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299624;
	bh=LZ46RxQe8N4EO2YCw8VWlMrXSV17+BhAvZSRNzxnEn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aUZaDIm37GkE/CakcpmTYOYWXdmvTeoGJuUgWsAs2s82T1s5iMeTPMMxSi/3ZOQ8H
	 S+Jz2hTuIjHFcIXYitj/w2S2nsIFhSJEjFAaZLXgFFi5r/dToXUyKBSoYdjiO6YiTt
	 vckuSnsb/bqHzccHZ/xoRoo3XM4IAwfmxQBJpkig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 802/957] drm/amdgpu/vcn: set no_user_fence for VCN v4.0.3 enc ring
Date: Wed, 20 May 2026 18:21:25 +0200
Message-ID: <20260520162151.960753735@linuxfoundation.org>
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

[ Upstream commit 4532b52b34e4e4310386e6fdf6a643368599f522 ]

VCN encoder and decoder rings do not support 64-bit user fence writes,
reject CS submissions with user fences.

Fixes: b889ef4ac988 ("drm/amdgpu/vcn: add vcn support for VCN4_0_3")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ff1a5a125c5a70c328806b9bc01d7d942cf3f9aa)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
index cb7123ec1a5d1..88d1139e931e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1628,6 +1628,7 @@ static const struct amdgpu_ring_funcs vcn_v4_0_3_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_3_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_3_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_3_unified_ring_set_wptr,
-- 
2.53.0



