Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB2D33A9D6;
	Sat, 30 May 2026 16:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159028; cv=none; b=RUbQfrDGWywXZiDx8n2MVR5f6TZE2DpmRTp1GVWP9HS77yoPh8CCoVizbIoxc0uCnoXh9LOdqhTmxdaZVNAAmxAsTFiC7zfDYhMBKsRs6C0XGXYqZjspHc6LXr0nwdif+QoIlc9iWmcYq7QogtC2My7oHlfS3ttG7WXD2s/kRTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159028; c=relaxed/simple;
	bh=R54vMwjrbkOHnYeE4BHANs/ppIZ2pQqceVWi62ybHBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6/sFNz0WD9p5jl9khjs8wfCW4K3QeKEaDdV5HuSgwYPs74e1YYK2CikdbJLj/F/PoolXGGGWwVRgTlCL2Sf4YD86VLbLAZzk6L13zP4qMsvlEHWorDs4VAkRbO9E7ZZJqSWesT/+WMFVnJp/grdYTI2xQEfREp70muuQDglLK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNixGlKe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNixGlKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FBA1F00893;
	Sat, 30 May 2026 16:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159026;
	bh=HVVKnfG9TWrqfI4SiLn5EwYTNWcMFrVh4erdvcuYrbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HNixGlKeU9HLpEvI1dqLk6gLBvNAFAp6QLAQMP+1sXKGfYEEC3oyAxUPDtxsPw0Tj
	 YdHArxI6vP3YBBdn7SBdS6h1GYDUwU2s1UmB+sEF5eYPI96bnBEdzif+VKMPo06A6o
	 qDoe8VijA0UwlPGnLrFVIDzuAKPg0H3Q6Lqg5Qt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 094/969] drm/amdgpu: remove two invalid BUG_ON()s
Date: Sat, 30 May 2026 17:53:38 +0200
Message-ID: <20260530160302.927286643@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 5d55ed19d4190d2c210ac05ac7a53f800a8c6fe5 ]

Those can be triggered trivially by userspace.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
[ Modified to gfx_v11_0.c only. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 37f793f7d4d24..6e3a32779168b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -5380,8 +5380,6 @@ static void gfx_v11_0_ring_emit_ib_gfx(struct amdgpu_ring *ring,
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 	u32 header, control = 0;
 
-	BUG_ON(ib->flags & AMDGPU_IB_FLAG_CE);
-
 	header = PACKET3(PACKET3_INDIRECT_BUFFER, 2);
 
 	control |= ib->length_dw | (vmid << 24);
-- 
2.53.0



