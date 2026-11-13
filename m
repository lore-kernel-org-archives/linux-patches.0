Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591555;
	b=X7sQhMt4YsnwnvH8/Auy72oF33EYNVOe/byV57nxLMi+oT+7I1QnANtZyoJNhu8hrHFJ
	 nOZNmSUGEKeaMjdPDqMkJkTLR3pvigtJL7k9IgrKM/NGEGpGLGnvyE32K93uRrln2fJD2
	 EYMxuH9JYND/R0rVADRFOvuwGeeb3I9kl3y6YIY//0iGm/UC5miAu7bC6WV+IDFnJ1BAy
	 CTr59jwb81aItC4LxkoR+5a0QUudJ0oHDtlcTji8cdDtWgxyneYzbMhpLnUlJ98m9Oyzz
	 m/XRXUZQYD/0vpmAbk4sdTjiXHQL1YIfpwWy9QApPWLvf6hf8DMRwO1m0azn/LiX/iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=leR3B6R1wUj6PXHsowLYRwixnzzgm1e5nX1UOqY0iYI=;
	b=NS3ApGgat9c4HdibWBs4qYHNlw5zYKMQEXTgMcB1So3J5lv3/wNQxnhOEDpBUP7PxwAo
	 Uzy7mj28AIPRxIK8hAP27wzZm+2szaGtlttMGxR77kO217EKeWgmQxu9NjoqXZPUEj6Yi
	 FIgWGhxW03TLkGEQh/j+AFZdnKLzMWaNXXVpij8df67GU+aUnUWpZAhXCk3SmYpMakAYv
	 QFCbxbc+HAC3CZ3JtTVhMMO8BQqo7XHeV+/dac/8a7gYLv1sN9MsoGDlILokyuir6jnbB
	 pug/LJmOJEgbGW1BnjrZmLXy052grzMDZoVtM0SlG3CEsp54l8x/ufjCK07/b2HYNEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nY+Vdfmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B499606E224;
	Fri, 13 Nov 2026 17:39:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nY+Vdfmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2802A1F000C4;
	Fri, 13 Nov 2026 17:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591555;
	bh=leR3B6R1wUj6PXHsowLYRwixnzzgm1e5nX1UOqY0iYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nY+Vdfmmy5uE4h+j7oGiIYoDRr5Hv100VkHozpGD50IYzYl/4h8/ZovwaJoacLq5d
	 lhFiDbCRIgG+A0pZT6cpat78I6XwNOWEWtf28FJk+HHSI+UoW5I9XjTmS1GfCpo531
	 G1OMFRNRTjIoa2sYNT50vNgfAB7MLUf6i6fAKvQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Sierra <alex.sierra@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 565/670] drm/amd: update mtype flags for gfx 9.5.0
Date: Fri, 13 Nov 2026 10:52:09 -0500
Message-ID: <20261113153831.020761976@linuxfoundation.org>
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

[ Upstream commit dad0c70507a834ac12e9286401d90536a3c4cea2 ]

Update mtype flags to meet gfx 9.5.0 requirements for remote GPU
memory and system memory.

Signed-off-by: Alex Sierra <alex.sierra@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Reviewed-by: Harish Kasiviswanathan <harish.kasiviswanathan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 232213c9bd7f ("drm/amdgpu/gmc9: add extra type-2 TLB flush for gfx942/gfx950")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |  8 ++++----
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c  | 16 ++++++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
index fba9d8c6fd2b1..68390bdbc51c8 100644
--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1207,7 +1207,7 @@ static void gmc_v9_0_get_coherence_flags(struct amdgpu_device *adev,
 		if (uncached) {
 			mtype = MTYPE_UC;
 		} else if (ext_coherent) {
-			if (adev->rev_id)
+			if (gc_ip_version == IP_VERSION(9, 5, 0) || adev->rev_id)
 				mtype = is_local ? MTYPE_CC : MTYPE_UC;
 			else
 				mtype = MTYPE_UC;
@@ -1217,10 +1217,10 @@ static void gmc_v9_0_get_coherence_flags(struct amdgpu_device *adev,
 			/* dGPU */
 			if (is_local)
 				mtype = mtype_local;
-			else if (is_vram)
-				mtype = MTYPE_NC;
-			else
+			else if (gc_ip_version < IP_VERSION(9, 5, 0) && !is_vram)
 				mtype = MTYPE_UC;
+			else
+				mtype = MTYPE_NC;
 		}
 
 		break;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
index a62c94894a274..f3a454d4698ae 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1272,7 +1272,8 @@ svm_range_get_pte_flags(struct kfd_node *node,
 	case IP_VERSION(9, 4, 3):
 	case IP_VERSION(9, 4, 4):
 		if (ext_coherent)
-			mtype_local = node->adev->rev_id ? AMDGPU_VM_MTYPE_CC : AMDGPU_VM_MTYPE_UC;
+			mtype_local = (gc_ip_version < IP_VERSION(9, 5, 0) && !node->adev->rev_id) ?
+					AMDGPU_VM_MTYPE_UC : AMDGPU_VM_MTYPE_CC;
 		else
 			mtype_local = amdgpu_mtype_local == 1 ? AMDGPU_VM_MTYPE_NC :
 				amdgpu_mtype_local == 2 ? AMDGPU_VM_MTYPE_CC : AMDGPU_VM_MTYPE_RW;
@@ -1287,9 +1288,13 @@ svm_range_get_pte_flags(struct kfd_node *node,
 			 */
 			else if (svm_nodes_in_same_hive(bo_node, node) && !ext_coherent)
 				mapping_flags |= AMDGPU_VM_MTYPE_NC;
-			/* PCIe P2P or extended system scope coherence */
-			else
+			/* PCIe P2P on GPUs pre-9.5.0 */
+			else if (gc_ip_version < IP_VERSION(9, 5, 0) &&
+				 !svm_nodes_in_same_hive(bo_node, node))
 				mapping_flags |= AMDGPU_VM_MTYPE_UC;
+			/* Other remote memory */
+			else
+				mapping_flags |= ext_coherent ? AMDGPU_VM_MTYPE_UC : AMDGPU_VM_MTYPE_NC;
 		/* system memory accessed by the APU */
 		} else if (node->adev->flags & AMD_IS_APU) {
 			/* On NUMA systems, locality is determined per-page
@@ -1301,7 +1306,10 @@ svm_range_get_pte_flags(struct kfd_node *node,
 				mapping_flags |= ext_coherent ? AMDGPU_VM_MTYPE_UC : AMDGPU_VM_MTYPE_NC;
 		/* system memory accessed by the dGPU */
 		} else {
-			mapping_flags |= AMDGPU_VM_MTYPE_UC;
+			if (gc_ip_version < IP_VERSION(9, 5, 0))
+				mapping_flags |= AMDGPU_VM_MTYPE_UC;
+			else
+				mapping_flags |= AMDGPU_VM_MTYPE_NC;
 		}
 		break;
 	case IP_VERSION(12, 0, 0):
-- 
2.53.0



