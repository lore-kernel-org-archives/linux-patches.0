Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052764;
	b=zu3mYDpCb4LcS2T72ISyZkbp/rB3WijDU5nZtqAHZ/C4K7lOuh2LC8MWof8/vPO4G2Tj
	 HRu2Y9B3rvDvuBbArEL2qPPLcLWGiuplSlmUcAHGa+FHOGEpZquu7TWBV5svEvSHx+Fh+
	 w9jVwKKF4LS3Jpgj64aEH4ilewpPlhRPMf4fcJOqcGdLtJYgkzAm0sNVTK5Vgz9L2ZBJN
	 4vPMwZkYb3SOJEzwXJVHVdl7mwppaVG3KpC29T36LDHM/kZo8IOR3Dl6CAdSSka781hpg
	 ucBrTtCiA5N9yWW92zFSTZMYMqf5yvZQzXenXuOpMjhSv2hjWvTY7Td0KZftrvxdDVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052764;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=16hmnJYJMbj4MRTahf0ElMHQ1/MubIYu62qTxba4m90=;
	b=Wq5/6eMk0SOQSKRKAu52Qp/ml3cewFZHCdYguY7IbVNVopedvMh8C3uuEJlHrbRRa8su
	 n5g9qDpxIfpRNlZUedqfhtE8lsD5Kdug7KqTzm4JibwbmlDTlBMvfWAdBojeIWkvGF6YR
	 El3P1jXiYEolrEOyEkwCUcvrOLOXjoX7utQHdFeCUA8wUqnUI7nMbYhRBwMjZaz9bpLQ3
	 2PvnQXjIEJzK0n2Hpzd7JblEurlBYsyMEifvHSNbuFgZiIIEk7FdpcsSfe4HcNrg+SzSB
	 PRwL2jRycd4sCYzKUpGuzvCMLckk1TYy6beZ+prP5/MD7u/WQwUWvUvORRcYEm8VkCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXt9fkj3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80084606A325;
	Thu, 19 Nov 2026 01:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TXt9fkj3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908951F000C4;
	Thu, 19 Nov 2026 01:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052764;
	bh=16hmnJYJMbj4MRTahf0ElMHQ1/MubIYu62qTxba4m90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TXt9fkj3HuSQtLYLq8XgNRz0B9m0yeduTn9WJ/vml28SGAESjAR+tPAe4ZL0A5zso
	 1nwG1LB9w1OYrzy7moZPaDsEeX6aW+7Fh0FMdu24/TdCDd21SdLjDUL2cDneYybjWR
	 TZzdrqgm4pxtcmY1u3aCvG/kFXC4gr6xYmLxpztA=
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
Subject: [PATCH 5.15 0677/2214] drm/amdgpu: reject ANONONLY userptrs that span multiple VMAs
Date: Wed, 18 Nov 2026 15:39:13 +0100
Message-ID: <20261118150038.874938690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6c541fb35a4e7..076b3698bbdcb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -706,7 +706,8 @@ int amdgpu_ttm_tt_get_user_pages(struct amdgpu_bo *bo, struct page **pages)
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



