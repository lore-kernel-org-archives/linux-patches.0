Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792775001;
	b=EMvMOReAXyTv899HGnMyhJj7ZRrgQl83Es+wPXNyKyShv3K7rnHeDgmESVNwaAkEetfM
	 c5KmmCD8fNCPVnALteToA9G7Rn2rrV98SNiYbNMOIlt7IRt+Y6nUUfoqbi2d2JZtnhOI7
	 sM/GRiB+NEBVhv9yJFvBsDpxCYJKiA8z+0mL+C/FRqwzOG2aiQlt2tLIFy2qgWW23xoPt
	 bsLvtCwa/rUE+iLt5sgUYrTveHqDe79hk0h4s5l+SDBJo8Hoprt/daSQEOxcYV94R4RH8
	 kirKWUhznHrn+mOOwHYTj+i/UIkJedPXPVTfTWRC0jv1AbX+F0AaYw1KODC1fSLDLCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792775001;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=7m53AaP+qoLRhnf8433h+DOC/yexpebvKI9neReJCTI=;
	b=gg2fN1iI7W/31DX7S0kJwQ3NRpBMzxmOlqkSIHAo+TvsWle9oBERhyAxNI/ucUkJRAYH
	 VV8wfc+EHF3Xmlz3YbWLKzJUFTmId78Pc4Ef6dP3AhhN3NQme+qrJShipdGYi+1QEIhdU
	 lgVZQyamUFH3a6svraJ2ZCXQNFhAWCID11Pq3sDlmqUfkLfwq9HS8chpgr6tKxAjXTFZt
	 z0B7/jgSZnf4/MyYFd+7IEPSvKKq34Vtaa8/swztfzM1S9kAb8tXtvOZZOjc7QSc+QXus
	 wvdwtDo1IjCd1hq2mYrczvQrbfNdKsilXLdIB+UMELomT/hri1kPPr4MAY8x0sLVV/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEg9iFUv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D3606A31A;
	Fri, 23 Oct 2026 17:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEg9iFUv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735F71F01825;
	Fri, 23 Oct 2026 17:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792775001;
	bh=7m53AaP+qoLRhnf8433h+DOC/yexpebvKI9neReJCTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEg9iFUvPU+3KjdtR4TK2Ri8NnvnBXm9CjCNFsPlSHGNhBGS2sOikPVWBM63los3M
	 rhUNMDLY/4GkJJX0Ok98wE0l6db/nHeqEUtW2oHEP+71fALEHeee4DRapXmorLxPYx
	 hczUt/7ofVdFJg8AVTIdaVAtpY56MU+jBeq2to2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Cheng <benjamin.cheng@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 211/242] drm/amdgpu/userq: actually validate userq BOs
Date: Fri, 23 Oct 2026 18:40:53 +0200
Message-ID: <20261023163718.787775200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Cheng <benjamin.cheng@amd.com>

[ Upstream commit 32d0771ef4ca69c30a1db3aefa34dd177cd2a047 ]

This was supposed to loop over the individual evicted list, as the
kernel and always_valid evicted lists were already handled in
amdgpu_vm_validate.

Without this, BOs that were created and evicted before a userq was made
would never end up in an eviction fence rearm.

Also add the missing ref to the BO before drm_exec locks and refs it.

Fixes: 4cdbba5a16aa ("drm/amdgpu: restructure VM state machine v4")
Signed-off-by: Benjamin Cheng <benjamin.cheng@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 18decfc9e8cc0fa70b6de9944cc27a37729edfbd)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq.c
@@ -937,19 +937,21 @@ amdgpu_userq_bo_validate(struct amdgpu_d
 {
 	struct ttm_operation_ctx ctx = { false, false };
 	struct amdgpu_bo_va *bo_va;
-	struct amdgpu_bo *bo;
+	struct amdgpu_bo *bo, *tmp;
 	int ret;
 
 	spin_lock(&vm->individual_lock);
-	while (!list_empty(&vm->always_valid.evicted)) {
-		bo_va = list_first_entry(&vm->always_valid.evicted,
+	while (!list_empty(&vm->individual.evicted)) {
+		bo_va = list_first_entry(&vm->individual.evicted,
 					 struct amdgpu_bo_va,
 					 base.vm_status);
+		bo = bo_va->base.bo;
+		tmp = amdgpu_bo_ref(bo);
 		spin_unlock(&vm->individual_lock);
 
-		bo = bo_va->base.bo;
 		ret = drm_exec_prepare_obj(exec, &bo->tbo.base,
 					   TTM_NUM_MOVE_FENCES + 1);
+		amdgpu_bo_unref(&tmp);
 		if (unlikely(ret))
 			return ret;
 


