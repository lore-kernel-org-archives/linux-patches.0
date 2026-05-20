Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82655233933;
	Wed, 20 May 2026 17:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299530; cv=none; b=Z2aAYgLAZQJZm0uu8ZoU23f0X5ZiwzPpj3DaNO27PjvySnqTv+URNu55Ix09iC6WJat25KmLOSaSIrQj4ahkMiQ3qZ2MKMLknsaKBSp6RyBXctRM+8XO8DeJKUo24C9FGnCJEIaMdT/L/+DkIUHLNFIDkv28BJobtqelYdAPJ9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299530; c=relaxed/simple;
	bh=2z7fnD2E7g+CUER9HsCClIdGLi8IpV+H4l8hwgGKuTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=etB1lmuzpztx2CBaL2Z9boa/cojAfHpZ3nrxBroLefPf8zsnym5l6TMOavAktjN60eIfwgvCTV47F/FwxW+hinAXNzUq25TpS/C9w9p2/dFgTFC+4vNg7CYp0q7UzyVcyQ+AVIviaKIb2SMawngnpsuqKEPN/nFtQeG8qaNBWFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QK028uRd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QK028uRd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76191F000E9;
	Wed, 20 May 2026 17:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299529;
	bh=CrySXuX0xqxIhPF/2+f9ByEXUjM2/4EhlgB966X9rM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QK028uRdSh8aAhBTONsIVHE9JF/YbWoWSpFlhFidAxAQYGBkBlN6VOXIaSTNFgbqI
	 kCudVtj34thcSdg3Aq1AlVC5GIdb4v7uHrFiwBrEKaHlDIzdzF9OLuq5JqjE34jywG
	 +oS9riwqUZPrP+iNRVpcBgbVNKkUe0JjdOwIty+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Yinjie Yao <yinjie.yao@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 808/957] drm/amdgpu/jpeg: set no_user_fence for JPEG v3.0 ring
Date: Wed, 20 May 2026 18:21:31 +0200
Message-ID: <20260520162152.090429260@linuxfoundation.org>
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

[ Upstream commit a2baf12eec41f246689e6a3f8619af1200031576 ]

JPEG rings do not support 64-bit user fence writes, reject CS
submissions with user fences.

Fixes: dfd57dbf44dd ("drm/amdgpu: add JPEG3.0 support for Sienna_Cichlid")
Reviewed-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Yinjie Yao <yinjie.yao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 4d7d774f100efb5089c86a1fb8c5bf47c63fc9ef)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
index d1a011c40ba23..af231d093a3ce 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c
@@ -594,6 +594,7 @@ static const struct amd_ip_funcs jpeg_v3_0_ip_funcs = {
 static const struct amdgpu_ring_funcs jpeg_v3_0_dec_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCN_JPEG,
 	.align_mask = 0xf,
+	.no_user_fence = true,
 	.get_rptr = jpeg_v3_0_dec_ring_get_rptr,
 	.get_wptr = jpeg_v3_0_dec_ring_get_wptr,
 	.set_wptr = jpeg_v3_0_dec_ring_set_wptr,
-- 
2.53.0



