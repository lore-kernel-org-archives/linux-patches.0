Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016474;
	b=GC4TSHMtyV8XUPP1M97JMrqg16uBcu0o8jwhKxMheR4gkbv2iS6eF0qsJaEU9Na5Sw/2
	 oIbhxtUmNhj9y9Co9+cNF8hWo/cp+xn9uK8Fdo1LpQrzGH19nUhONYpmljN3Ge/ucrbcU
	 M2DHVcafWFYQPsM/7CV4BHw5mfcHDewkGKGExme8tOGU5taifeDpVVFe77FXwz6igPpsg
	 qjXgvt+CH5y1EdZVDXE7yC1hlte0RoOQEIYAFGW8jVSkCnl1Q27oh1kBPSoZeTcG9vfYs
	 H0CJbEC6saH2hwo4RSvyIVx9Gq+bfC71FLe61w/Eeq08kHuvPS629iW+WJoOwxSe7qQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016474;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UXJ5Wty+z9ivq6FkLShq27KjBS4RpULYFqaghbobcsA=;
	b=0XXKx4drcwAzedjeKT20X7UtKgEPupgCwBnggeOy8LubhhZrCky0iXnW65ddlDbfdqQ7
	 ywE5jdvsEMEikW83MtN5sqfkc6YBunKBFq6Z0w1PPI4Beemneah/QH6zwSZDCiyKoxj3f
	 OnwIdpA6nYgIUTR+yjohpEax8shoDh3SozZ9Cp1ApFgln0q1GIWTtgwNCZwDnGux2J24N
	 VG6Om9AF/OrFXEGC+kG6fQncB9xwLbxRkZBrGCkSiqm2SBY7HO3Gw37hBYETeX9dSdg8H
	 XvGtW+c3NFH0Mvvl4KvrXq4FuOonpx4TWv9emxQlypTmnasR0ZKGIhOlqK5G62DbLfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdB2TSN5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B611D606A325;
	Wed, 18 Nov 2026 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qdB2TSN5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A4A1F000C4;
	Wed, 18 Nov 2026 15:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016474;
	bh=UXJ5Wty+z9ivq6FkLShq27KjBS4RpULYFqaghbobcsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qdB2TSN5bJB2wwgJ2lsTlb2pFWzdo60U80DEFLy4HN77g0M/Enrs6K+Qas9DPrdUZ
	 vlEhU5mJDfq1YXj7gfLykPAuEJJBiibUcZJhQs/6rIFenlkb6p4AA4Wh76leziIu1X
	 Z01NE/Y02VD1P0dU/Yp31kmt3zJNWhwM+12hcj+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Khatri <sunil.khatri@amd.com>,
	Prike Liang <prike.liang@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0542/2651] drm/amdgpu: reserve eviction-fence slot at WPTR caller
Date: Wed, 18 Nov 2026 15:29:42 +0100
Message-ID: <20261118150307.266146150@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit 5e6b21bce9d939b564e1f1c88a429cfa1fe66d3a ]

Root cause analysis showed that the previous workaround was fixing the
symptom in the wrong layer.

Problem:
  kernel BUG at drivers/dma-buf/dma-resv.c:319!
  BUG_ON(fobj->num_fences >= fobj->max_fences)
  Workqueue: events amdgpu_userq_restore_worker

- amdgpu_evf_mgr_attach_fence() had been temporarily taught to reserve/add
  fence bookkeeping internally as a workaround.
- This hid the real contract violation and made reservation policy implicit
  inside a helper.

Review clarification:
- The helper-side dma_resv_add_fence-related workaround was only an intended
  proposal sent for review discussion, not the final direction.
- Final fix keeps fence-slot reservation explicit in callers and leaves the
  helper free of policy decisions.

Findings from investigation:
- drm_exec_prepare_obj() both locks and reserves fence slots.
- drm_exec_lock_obj() only locks and does not reserve slots.
- Existing attach_fence callers in the GEM/userq restore flows already reserve
  TTM_NUM_MOVE_FENCES + 1 before adding the bookkeeping eviction fence.
- The WPTR mapping path in mes_userq_create_wptr_mapping() used
  drm_exec_lock_obj() and then called amdgpu_evf_mgr_attach_fence(), so this
  specific path could add a fence without pre-reserved space.

Fix:
- Switch the WPTR mapping path to drm_exec_prepare_obj(...,
  TTM_NUM_MOVE_FENCES + 1), restoring the caller-side reservation contract.
- Remove the helper-side reservation workaround from
  amdgpu_evf_mgr_attach_fence().

Why this is the right layer:
- Reservation policy stays explicit at call sites that define how many fences
  may be added in that execution context.
- The helper only performs validate + add_fence when called with a properly
  prepared reservation object, matching the existing drm_exec model.

Fixes: 7264bc10c7c6 (drm/amdgpu: dont pin wptr bo instead use eviction fence)
Cc: Sunil Khatri <sunil.khatri@amd.com>
Cc: Prike Liang <prike.liang@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Reviewed-by: Prike Liang <prike.liang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_userqueue.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
index 8d5dcaf4fea6b..d19ece2eb7d40 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_userqueue.c
@@ -60,7 +60,8 @@ mes_userq_create_wptr_mapping(struct amdgpu_device *adev,
 		}
 
 		obj = wptr_mapping->bo_va->base.bo;
-		ret = drm_exec_lock_obj(&exec, &obj->tbo.base);
+		ret = drm_exec_prepare_obj(&exec, &obj->tbo.base,
+					   TTM_NUM_MOVE_FENCES + 1);
 		drm_exec_retry_on_contention(&exec);
 		if (unlikely(ret))
 			goto fail_lock;
-- 
2.53.0



