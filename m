Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209449;
	b=4Fk1kEC/H6EqhEaVLBk8Cm5DgyP2g4NxM/vlx9q40SL/lglIwttXDbRnfCLhPWAIapOa
	 l3YsRJMIVIDca5NQImri726Y+iqaZnc9+u1qQEtsFTuhnhEErZUBfR3rc7oAI0FiOeCrp
	 rM++lwYaiuMDY+WmZqWa7NrnMgOgD/c1Bvdpqfs/QZrlUX0HE1SowesvpJCVUbRTZcHvl
	 NQlU0HxR3OZVBaathVpBDD0UmHHOb1t4nuzDhA+Wf3OF1UzQ/1WA1zt3SLc0RZ5V8GjkD
	 u+x08cWn8fqWe7awFQEN2brL5vGrhbDqLMGQsnPah6yQRGDZOO1b2endmh+flU6b9dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6yfsuFE00Xa0/8YwBhOF3e28TIZ4zQuNbE9T8RIh2MY=;
	b=nuL3NNiFvH0wBy4P5fQgd3/GNkELKk+xi0Gc2nmPv+o42Y3bAYL+VKfhxnfNkc1rV20D
	 AQrtMAo0audMzOHss86Gi1WLx9uts8iMLPfIM0KCVgrMx3JxdcbzgyzmDBq80yZL2bRM2
	 lWSilEm0u9KB2GYLU1WExbz+BDdIbvNOWMuQGvxVUwX/RgnPibNoXv/D8uE7KnweOZTcl
	 MWwPGCXwN0YsLz/w+IpQcLWc8gfDAndwQzB4/KhFJx+odwQ3ok9neEjTQAbfhi9u5LAXA
	 mlMTp+pfjjFw1a6E53/Rf1atrlBFHOhHF2f4PbMjHak2Dzjh1V35tu9hvGyUWUGYyUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHGOtXAh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7096F606A31C;
	Wed, 28 Oct 2026 17:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GHGOtXAh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12A11F01825;
	Wed, 28 Oct 2026 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209449;
	bh=6yfsuFE00Xa0/8YwBhOF3e28TIZ4zQuNbE9T8RIh2MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHGOtXAh/mD+fTPzmvoe1o+uABTCuCZKLo9JDgEcG21YUHPUxrqj6k0d5wgINQvxk
	 kgCJPP2/ZrlATtWresZR7xdEuo5CKw8HgI4NJ7S3vHguJZiySJN9LXT19E0OpWgz0R
	 UqHXWfPNqQbQ9CHK91YD9YkE5zE1f38dtage5kHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 476/516] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Wed, 28 Oct 2026 18:00:28 +0100
Message-ID: <20261028170014.756793979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Rosca <david.rosca@amd.com>

[ Upstream commit 2ee9836545e690c9e66ec203445d7705959fd7a8 ]

The largest frame is 20 dwords, so 0xf mask is too small.
This was always wrong, but we were lucky with the VCE_CMD_END
commands inserted after fence and vm_flush.

Fixes: 8897ea8c761b ("drm/amdgpu: Implement insert_end for VCE 3")
Cc: stable@vger.kernel.org
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: David Rosca <david.rosca@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v3_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
index 89f5bdf7f2c3c..8429cf773dc2b 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -932,7 +932,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



