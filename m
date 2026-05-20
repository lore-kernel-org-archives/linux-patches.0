Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A2CB3FE662;
	Wed, 20 May 2026 18:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302792; cv=none; b=DqpGT8wElH7NUBw/0XtqkSn0tEn4TSYyiEb3l+orybTfRPoPRot1yIumyfVVzY/Jgk2ISHITZ/82ORbgjH/MYujBjdOJtgILLat816gZvTrOAgSMJENOBzvNDVWnU7ivuhFCWiKmerw2n9+Y3nzNWP1kjBVzXoJANWHQS70aqQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302792; c=relaxed/simple;
	bh=5+2Ay3rOPcur9/5PpXev6VuFD7g3C2zRUbXqeEFU5EU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=huJNArk9lCSaG7fAoSi+Wxwreig1T2Sp+N2t1CkFZ7TLDpNNxN5YCaE4dZJrlEuluwCcxjCWsaoXbCBcE1A5YUZLxQwynxEqXjLi+933WO9W/OlTDh/txgZEqrbMS/GPpwpdO9CKRst9yc3hRZs6nW1WG3cm2ig6iHaZCl6hkig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvk6/VdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvk6/VdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E19E1F000E9;
	Wed, 20 May 2026 18:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302790;
	bh=Nq4b6f1BKZ0v/ZbXW1YOpHHDQt4pattRI393NWYuWSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvk6/VdTchAZ2xwKT68UMg95N5zHROXQNsMJ+PvDtw3M7PRT8//22GJJ3eW8gDLwa
	 DgBquYlUWRhbnz/FLjFTp/8MVNWVfz/0LZJ7lyovZS3vWWIuQ5pd0og+6AkyPHWyv4
	 HmSeozvBq300Qf9SfOfp4e8suwkY/iFD7OnhlpWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 402/508] drm/amdgpu/vcn: set no_user_fence for VCN v4.0.3 enc ring
Date: Wed, 20 May 2026 18:23:45 +0200
Message-ID: <20260520162107.323170393@linuxfoundation.org>
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
index d1141a9baa916..3379469ab04c1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_3.c
@@ -1423,6 +1423,7 @@ static const struct amdgpu_ring_funcs vcn_v4_0_3_unified_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_ENC,
 	.align_mask = 0x3f,
 	.nop = VCN_ENC_CMD_NO_OP,
+	.no_user_fence = true,
 	.get_rptr = vcn_v4_0_3_unified_ring_get_rptr,
 	.get_wptr = vcn_v4_0_3_unified_ring_get_wptr,
 	.set_wptr = vcn_v4_0_3_unified_ring_set_wptr,
-- 
2.53.0



