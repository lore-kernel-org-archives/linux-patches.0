Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591548;
	b=EJNjUbzGfQG+3nya+O4Bn2PdJvJG1ptFaXKnv/nafNB9AvaUzNGl4Oi8EYf+qa5F2n8c
	 at/lTWf5vv4bOJsK9dV3ZecGSRL0WT6xS8uVv6Hux1xggxQhU+bT5nT0ABNKXE5CFOR+e
	 ndegQ1A+zGXCTcCr6BGzAv/Mj+RTQ1LvEkj6c2pDkkTrWJ7vkcXF2YwFb3j9F0QhtCLgm
	 gTDLS/hyCBBM9irrq5xw/YmgxFZLwlydsQf8bbH8p2sWRwLj2oda+gByX0JrUzrdk+neG
	 pWLJbe74sL66R3av7la5/kr7ibYw0kXq31FoC+Ym1l/QN2wmg0qoQUrOKXtg2cA1BuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591548;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m6Ne42nz2LyRkWPDw5G6I4AvQ8mAnSNeKMqktFdxqpo=;
	b=QmKqp1g+ZL9yMKLugtEtxsrWRaMPZOAC4lzdrbVZwOHCQtOltnuCRg6iKS5IYuHadNmf
	 2fgOld5z7ypLjFTw4r9HRtwwLBpka/Ol1Yucyv1SzVmfdF6G2OtDURq1i/s8gamweF2Nw
	 us+nBA7kAhGzCwbqF1pKCYHwsP2+5CASh62+4wkMC21wbPRqpnpH0ILuI8H+lTR0xCUZk
	 VkbBEP51tPkU3opt3C8CACnH133IwHjyJI4p4Y4+JEpgtB85S0I1zJP2ziSXjuHtgNNaH
	 6kzt2afPjB7WHCUt+N2qYJ2TCNvEldrgqJjkRyxVUkTsZDdianOPU7OMe0bjeSgsbqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2t5PezU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254E4606D4B3;
	Fri, 13 Nov 2026 17:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R2t5PezU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C59201F000C4;
	Fri, 13 Nov 2026 17:39:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591548;
	bh=m6Ne42nz2LyRkWPDw5G6I4AvQ8mAnSNeKMqktFdxqpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2t5PezUcM8cOp2a4d6rhhpAianCDv2FsXU1VkRvlIQPU6lmMVJXRjk9Vw6fzJaoH
	 dPRd5p2Hs99XUWzifmeK2YUEc6kITvpaoImPGD319tXf0lfJK3OR/8lFjalL9r3i+i
	 wcMmYn8wUNwTYRBQ9x23J05hJK86sQGQFVJbYDLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Sierra <alex.sierra@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 564/670] drm/amd: define gc ip version local variable
Date: Fri, 13 Nov 2026 10:52:08 -0500
Message-ID: <20261113153830.990088770@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Sierra <alex.sierra@amd.com>

[ Upstream commit 9bfe4caa4e57ba343d81e837911242f058688200 ]

For better readability. Also leftover orphaned code.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 232213c9bd7f ("drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c | 8 +++-----
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c  | 5 +++--
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index d82f90f480240..fba9d8c6fd2b1 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1139,12 +1139,13 @@ static void gmc_v9_0_get_coherence_flags(struct amdgpu_device *adev,
 	bool uncached = bo->flags & AMDGPU_GEM_CREATE_UNCACHED;
 	struct amdgpu_vm *vm = mapping->bo_va->base.vm;
 	unsigned int mtype_local, mtype;
+	uint32_t gc_ip_version = amdgpu_ip_version(adev, GC_HWIP, 0);
 	bool snoop = false;
 	bool is_local;
 
 	dma_resv_assert_held(bo->tbo.base.resv);
 
-	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
+	switch (gc_ip_version) {
 	case IP_VERSION(9, 4, 1):
 	case IP_VERSION(9, 4, 2):
 		if (is_vram) {
@@ -1158,10 +1159,7 @@ static void gmc_v9_0_get_coherence_flags(struct amdgpu_device *adev,
 				/* FIXME: is this still needed? Or does
 				 * amdgpu_ttm_tt_pde_flags already handle this?
 				 */
-				if ((amdgpu_ip_version(adev, GC_HWIP, 0) ==
-					     IP_VERSION(9, 4, 2) ||
-				     amdgpu_ip_version(adev, GC_HWIP, 0) ==
-					     IP_VERSION(9, 4, 3)) &&
+				if (gc_ip_version == IP_VERSION(9, 4, 2) &&
 				    adev->gmc.xgmi.connected_to_cpu)
 					snoop = true;
 			} else {
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index 7bbeb9768a56f..a62c94894a274 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1224,6 +1224,7 @@ svm_range_get_pte_flags(struct kfd_node *node,
 	struct kfd_node *bo_node;
 	uint32_t flags = prange->flags;
 	uint32_t mapping_flags = 0;
+	uint32_t gc_ip_version = KFD_GC_VERSION(node);
 	uint64_t pte_flags;
 	bool snoop = (domain != SVM_RANGE_VRAM_DOMAIN);
 	bool coherent = flags & (KFD_IOCTL_SVM_FLAG_COHERENT | KFD_IOCTL_SVM_FLAG_EXT_COHERENT);
@@ -1233,7 +1234,7 @@ svm_range_get_pte_flags(struct kfd_node *node,
 	if (domain == SVM_RANGE_VRAM_DOMAIN)
 		bo_node = prange->svm_bo->node;
 
-	switch (amdgpu_ip_version(node->adev, GC_HWIP, 0)) {
+	switch (gc_ip_version) {
 	case IP_VERSION(9, 4, 1):
 		if (domain == SVM_RANGE_VRAM_DOMAIN) {
 			if (bo_node == node) {
@@ -1322,7 +1323,7 @@ svm_range_get_pte_flags(struct kfd_node *node,
 	pte_flags = AMDGPU_PTE_VALID;
 	pte_flags |= (domain == SVM_RANGE_VRAM_DOMAIN) ? 0 : AMDGPU_PTE_SYSTEM;
 	pte_flags |= snoop ? AMDGPU_PTE_SNOOPED : 0;
-	if (KFD_GC_VERSION(node) >= IP_VERSION(12, 0, 0))
+	if (gc_ip_version >= IP_VERSION(12, 0, 0))
 		pte_flags |= AMDGPU_PTE_IS_PTE;
 
 	pte_flags |= amdgpu_gem_va_map_flags(node->adev, mapping_flags);
-- 
2.53.0



