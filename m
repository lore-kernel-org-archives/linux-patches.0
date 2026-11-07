Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065143;
	b=r2LUwZ3suUdnj8Ctukw14+oOH9+DUUSK8rDBU4WK0JFJXI1mbB6dA9yLJnbsAZcRZT8S
	 pPqNlbdnF66SzPBbTiLi3HeWyfPgF1W502NMx9EwN+sQCLJAtp67xuoiEqMQWPwSdTFIA
	 rtNYV+SEqj+V9Lo9bLxZ5erJk/9gWqR49xZELJl3Ahk8+LwFptJxBeYSwgkr70qWUq91y
	 Y+VJ5lBT+KPLb/5+f05P7BGSZW8S8/IsuwIz7oKeJMTBn6uoX63p1fqo+MJpJUJWzNGtx
	 6VSv9/NdKsYBFxSsbMrCzq1icrLY2i1MyK5/RLsoFGJ3PGIqt6jiRfVUv5Kf0leykvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065143;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qrJ/dTmjFKmdFgSlIEB/WVBC8lhwYvls2SJADAxpaI4=;
	b=06OlzhKHtNYKB0GN5jJG4ARmP4ZCXmEg16VGmf9/CNXvUDF4aourFEoWFKAQacR6vq4A
	 iKQJfigApWq/g6EzQCdetHUvvMpAhs4CjDxMghNccpsG0ipwKanTCYBmv08Hawjxy4/Um
	 p1ylCpxKoLC2xxJzdaac5w3rY7Ulyzvh3GsVrLupQKdWASuFgtAXTDvaQoRhCKbbhjgX6
	 3ueROYnehtRSHXozEFCAtqCiydBboDDslNlsjh6qhjnc8l+vq34mkNK7HHG9wNMZSvtNH
	 ACN+lHdkU8Z6LN/qXKztpSnhLGL1Mzb0jKDsAw1+67V8IzO/vmkop2OpbT9T6FrJBxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMvEIjUY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67178606A338;
	Sat,  7 Nov 2026 15:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xMvEIjUY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C7641F0089F;
	Sat,  7 Nov 2026 15:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065143;
	bh=qrJ/dTmjFKmdFgSlIEB/WVBC8lhwYvls2SJADAxpaI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xMvEIjUYuiqFSmfG0xth93BeT4spxRviKpnLxm5OAEUr3UIb/yDZgjj77Oztzi2R3
	 kCpvdC3dC+t2OUkpEtjHT0RABPhiV2QsICkvvLhUhoQ7mJHp8gaUByfSJGcJXwjyJ9
	 JzDdsuGyoBvKlHaJ1Bx59zrGyKttX2Yp/6ROZtkU=
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
Subject: [PATCH 7.3 0959/1257] drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs
Date: Sat,  7 Nov 2026 08:54:15 -0500
Message-ID: <20261107135005.827227024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 83968886c29a6..364be96c08dfe 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -777,7 +777,8 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo,
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



