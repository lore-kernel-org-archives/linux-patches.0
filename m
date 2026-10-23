Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774279;
	b=oM3i3kn4u5u4wg2p7wqvL+0p2hNXx8xL5aIsSXhscS9ECK2kGnUQnBcMZY82p3nxmJhL
	 kaEmcYVaqoFKl02mnWE+5g5sRO5PyPmZKYJ3pxrEhjAfEm4CS6d4AI+Oi3EZjkZqXKw6d
	 ObnITxd96PW7ltKk/E0jFFo9gB4tnTDx+rReWshSWVEUvh85Cb/553QDXuI80fdHdF42Z
	 HQwLdOa4IjM+XaYGshPBVcEK034PExsfheMyAMEhb+h8kQGGwzx1YiwY4mTEiaW5YuOqW
	 k3i1M3+q5ZwD3N+SgZy24fvdiLnMpnBVLV0raC1TRLdpRoYlxSAsfNbSrxylAel0L5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jVaepgA+xVXIRZyTOEqhhZAOmNXIyMis/7RxPdpCQSM=;
	b=qtN8APgrT0WBnJ2SQRMVharHNbidDb2mPnPN8mTIk8n8SqKe5HNClbSeAN2y+slcC6PA
	 ULXhqbUkhdFwDxu8gzdHupXN0lwbxTU+B4OJFsYNv6B/qI+nH/J2bjO1HTIYhjDH9eopJ
	 XN0MhOG91SYje9AGN6pT5QE5VhvrkDjy0cfKc5tp3GI6gfNasFNUJqlErDdOej8xR+1q/
	 1ZXwXhog1UHPG90behIIBXdAB9m9+mjqPFZDlKGnsEnRKy2nLvR2NSpV1uWW6eq+PxrB5
	 Hzngo2Jy0MZkQXZjqM8e5ssw+SpBtEKuxIdYlhA9gZXxl+XSf8sgZBHbouF9WQMU4IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zxxf3NNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83548606A31B;
	Fri, 23 Oct 2026 16:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zxxf3NNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9E61F01825;
	Fri, 23 Oct 2026 16:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774279;
	bh=jVaepgA+xVXIRZyTOEqhhZAOmNXIyMis/7RxPdpCQSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zxxf3NNggVBbrOBWpXdNBm+j0jkWr9SnirFW/9cIXrBcpdz6WWrlg0Fi77wWhzzpY
	 oy5iAL1thDNu6A/57PxidhW0VClmDDiYdEajifPefdzuRsscrKP5Q0dvR9tlaoCKcB
	 0KNVgwvhzgSXtF8dwy7CqVJQtz7Mhq7noyS2nP2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	David Rosca <david.rosca@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 143/193] drm/amdgpu: Fix VCE 3 ring align_mask
Date: Fri, 23 Oct 2026 18:37:00 +0200
Message-ID: <20261023163717.592520113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b54359efac06f..9c4c782c99aa1 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v3_0.c
@@ -955,7 +955,7 @@ static const struct amdgpu_ring_funcs vce_v3_0_ring_phys_funcs = {
 
 static const struct amdgpu_ring_funcs vce_v3_0_ring_vm_funcs = {
 	.type = AMDGPU_RING_TYPE_VCE,
-	.align_mask = 0xf,
+	.align_mask = 0x1f,
 	.nop = VCE_CMD_NO_OP,
 	.support_64bit_ptrs = false,
 	.no_user_fence = true,
-- 
2.53.0



