Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015107;
	b=Uu7NebidsJDkjVcQBxo+Bam5xUwbdBA7NQgjbM4w1zK5rHlv3r+NSwb71ww+0ObhtYu9
	 FMGFJNkE0u4uiZW47jXbrB4qcMAt/5+ahXRqEU5TGoWb0F3/ZzEOv1vTgUkttQVf6VSNZ
	 Pnh8Tg8SPRkLfjqtcAPEc3yttZL1H/I7o8+jYVj2mAT/rGtFn4qlx/GvXcmvobSnH9B5N
	 sGuLD0i21k4UrH0xefrVxlfUqb645svSThO8em7Bqlf2wSPna182BpZJi5W1BlvDYd2av
	 NbLjke7PgD1ZW6ykQBstfukLblqRDfYvvy4znW4E75Q901EAeH0pV+0mqJf6OiftLqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BAD0cOWaisgsWrHfWx1derTSrSezsIUh/m2kilUKT/U=;
	b=QHxtSTdyA45NiknyJFKIlhNagSH3HQ3i8GG6cC1nHAY8uUfn1+CKoMIubr68juhBG4bV
	 L/EG0MkURg6J+XX+PdRQ0leSQxVQjHI95X63HCCM7/CSCxYmov/ornqKV0LY8AeReS9FK
	 TFpqqQpQOrXxhIoV3PQ29z08x/UTVei5ceUDunrjKZCf40TLxlBCifjup4pirCmrjQqoJ
	 p29l47wsEWGUGW0ah848deHovuo+Jyth5Z6sZYwSrvky33PNHhWGu2UWR61SVRyZV31/L
	 VUdibGEpDU8GhQjjwBtW1rxuPtTu54yAC1SyVhU23gMECfl6m3pw5/TNU9g5yxm+pqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1PpMVyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D54660A2631;
	Wed, 18 Nov 2026 15:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F1PpMVyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC5C91F000C7;
	Wed, 18 Nov 2026 15:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015107;
	bh=BAD0cOWaisgsWrHfWx1derTSrSezsIUh/m2kilUKT/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F1PpMVyisiTdyhtZkGpD7yL4C6LijE/V5Px07wSMUnglcGWDSbexfwNAqnOw9U8IL
	 AAXI5zcd/yEzjs5qRUGdyJnaEtXatA4nSgVOgnSu31g5HkAjC6IVwEUKuJCaRdIJBB
	 lsZC6F8wK1/pw9digoqOq3/NNF6al1MdYapi8Z8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sonny Jiang <sonny.jiang@amd.com>,
	Boyuan Zhang <Boyuan.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0028/2651] drm/amdgpu: Correct VCN V5_0_2 doorbell index setting
Date: Wed, 18 Nov 2026 15:21:08 +0100
Message-ID: <20261118150248.989778541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sonny Jiang <sonny.jiang@amd.com>

[ Upstream commit 66421e37897ddd29c03a3290cd559f7c72622f80 ]

Each VCN 5.0.2 instance has 11 doorbells. Use an 11-doorbell when
calculating the per-instance VCN ring doorbell index.

Signed-off-by: Sonny Jiang <sonny.jiang@amd.com>
Reviewed-by: Boyuan Zhang <Boyuan.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: a56c2536c399 ("drm/amdgpu: cancel idle work in hw_init failure paths for vcn/uvd/vce/jpeg")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c
index b9f6ae75ea727..5291ebbc5c3e2 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v5_0_2.c
@@ -129,7 +129,7 @@ static int vcn_v5_0_2_sw_init(struct amdgpu_ip_block *ip_block)
 		ring->use_doorbell = true;
 
 		ring->doorbell_index =
-			(adev->doorbell_index.vcn.vcn_ring0_1 << 1) + 32 * vcn_inst;
+			(adev->doorbell_index.vcn.vcn_ring0_1 << 1) + 11 * vcn_inst;
 
 		ring->vm_hub = AMDGPU_MMHUB0(adev->vcn.inst[i].aid_id);
 		sprintf(ring->name, "vcn_unified_%d", adev->vcn.inst[i].aid_id);
-- 
2.53.0



