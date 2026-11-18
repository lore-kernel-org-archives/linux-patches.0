Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058618;
	b=AdydhZOyhQ4z50R+nYOWfMjxQ0yZCXVX15xQW35dLGlUoyCN1l/PWB4dq4ve4dVqL2gW
	 Bzmb4KwTNMG6tUrCpt4C2MNSlv3Eu8wdDh1On2WfO5wPMXcXKUnCkVCEDw9dqtsDyGnPp
	 AaQ9cdprFOJBsIZAx2v1dJA+fazJwWwY31Z+SbxjCXRunkFw+wwEGLpmXx7f5kvS2QRBv
	 6mRYwL7IP0IdTupW8kO8FI61FFLKdjd/E5ISkUckIiIf0WUKfKNRq5TJkXMdbkVCRHdnZ
	 M5RI2DCJb0JQBkuyqOJzFLGEDEnwDZMj61KBACSTTzQHXv+p5GgJWlP3MJn4VWwIvCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NEMknso6McH2sZKJOk6PbYPd0lmKRAO+1ad70Pj/zRE=;
	b=YElgeKWuZs/UhBhytl1Vb88ZyWVQFvWKSMA9inGM6X55undCqoxsSTzsFNFSFfztMas4
	 TXnR9CYcJgS/AKmUnLJJPftw80H/l/vPZ0k8z9td0eCAe9BSTMnNqEnKEJ+5o56PZ5xOd
	 oIpCshVbgrFdllvUTrBmRCjvlHh4uGY3CsJsKEepALImJ5wzsowUmaY33Ht4evWSh4KM3
	 5h00QPX6HbSuWK8Z6wHv0IOxHqU4Qx0LMwDv3HKfsbKMlOjo0vGKQF81JbROLAZrgyuJU
	 loSxRxuOXfxFr476szXifLYSA7zK698fUNUN9Wjt/Sa3UrXOmMiq8WwyE1l7V6zpCJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAYz7CBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CDFE606A31C;
	Thu, 19 Nov 2026 03:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lAYz7CBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36701F000C4;
	Thu, 19 Nov 2026 03:23:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058618;
	bh=NEMknso6McH2sZKJOk6PbYPd0lmKRAO+1ad70Pj/zRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lAYz7CBCSac8b+hgG5367PF0Th2p05clujKp95stt5UOg37T33OlRiSG+RAtkN11+
	 nHvrIzFQM6ZWtZbQAnA/titLMmIdWxpWguavl+fssnCm8VO6vnykWE16SkWIQqN6LG
	 jNxO/KrraXYz4W7fE7Ik7M/62PawYBIYZHlVc1+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Philip Yang <Philip.Yang@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0550/1848] drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs
Date: Wed, 18 Nov 2026 15:43:08 +0100
Message-ID: <20261118145937.975479033@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jesse Zhang <Jesse.Zhang@amd.com>

[ Upstream commit d577b68a854d0f590f480777249b041507d0708c ]

For AMDGPU_GEM_USERPTR_ANONONLY, amdgpu_ttm_tt_get_user_pages() only
checks the VMA at the start of the range for a backing file, and
amdgpu_hmm_range_get_pages() then faults in the whole range, across any
other VMAs. The check used to reject ranges ending beyond the first VMA
(vma->vm_end < end), which got lost when the code moved to HMM.

An ANONONLY userptr over one page of file-backed memory is rejected
with -EPERM, but one over an anonymous page followed by the same
file-backed page is accepted.

Restore the check and reject ANONONLY userptrs that cross more than one
VMA. The second userptr is now rejected too.

v2: reject ranges spanning multiple VMAs instead of walking every VMA
    (Christian)
v3: cast num_pages to u64 to avoid an overflow (Christian)

Fixes: 6826cb3b92a3 ("drm/amdgpu: support userptr cross VMAs case with HMM")
Cc: Christian König <christian.koenig@amd.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Acked-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 75d753ed4704d5efc72164d9e546b2a282e42ae2)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 228da106477d8..9a185949eed2a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -885,7 +885,8 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
 		goto out_unlock;
 	}
 	if (unlikely((gtt->userflags & AMDGPU_GEM_USERPTR_ANONONLY) &&
-		vma->vm_file)) {
+		     (vma->vm_file ||
+		      vma->vm_end < start + (u64)ttm->num_pages * PAGE_SIZE))) {
 		r = -EPERM;
 		goto out_unlock;
 	}
-- 
2.53.0



