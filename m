Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028746;
	b=DxZNImmaWbsahkI4hE61d2i2X/SCj7zYLV1difuJRoSYywiXZ7FXPlr2QKayLaCHQHLl
	 OyQJ6YYDdukOxtbFKMSQ/jTxo2ZPPn4Vq14RD7A3m7Cw+/PZJkozbwHBLlCQJvXkhuuZR
	 +K7O/JhlG9lzyRCPvKmgKXHAI13aVTj/q6Ss1VQ8EvfMpbjr4oqQoD7fLw9JPq3iKHx7b
	 ZTPthazCahf3Pr69p97eDq1EmIVgRivCqc5FjTioqm/yHwLOR7mwVSPM4PncKRjtOkoMR
	 8Wsj27Wl0k2AXbHBZ5wn0AEVogQxkDS5SrkM60U5GIqx3z4/LCfZNS0aC1fKHZM99DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N4JPV9QvFgineKBfIZK2x6xkZfBhSUSbnmvwDO42FyM=;
	b=oh/9lOYHoMIJr2fN27DXD8liFUSYfEjlDub4yeEZLoVUvRiDuwPLSJw7lHX2+4wTIjPG
	 x/+MmdHxQ8kbsTrp3TmIiq2eqGpCfUX7G1vf40gSGX/rvlIarv4Cf+1rxIetDVy2Mm44R
	 kKIu2CcyRHUTS0xOVuvrVdzjkJnRpDRuCWj/G8GU7q+nFLPV2uiYQfzzHqjaM3Bq1cCU7
	 IB/5ja/9GXoZlu3pfMLZMEqE4528dnpOCay8+idK4dlRDAoAWZGK4acc29RE1AsRMeUYO
	 COmN7KFL3eLWiBnPF7Fs+r4mzr3ieB/AE2aEKzcXXgLoV3CDSGn4DSOoyYyteCeEtug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NUosymXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9558F606A32F;
	Wed, 18 Nov 2026 19:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NUosymXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E4C1F000C4;
	Wed, 18 Nov 2026 19:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028746;
	bh=N4JPV9QvFgineKBfIZK2x6xkZfBhSUSbnmvwDO42FyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NUosymXg3WXX9bcCWyuZo9TBqMfQnY/d2jU6xIEmLyw+VSOw4KWlH1lTlAUYrWiZ2
	 8Xy3CAoCTmrvKiAW/ZbPoxcNU+LgYLmQBMtfbOLn5YiAtyxuqAwQ5u32mpagHJT+L9
	 qzuFnoH2q1ZHUHjtkLdfrNl5SHBJOho46U5biebU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0104/1756] drm/amdkfd: Map wptr BO to GART unconditionally
Date: Wed, 18 Nov 2026 15:37:11 +0100
Message-ID: <20261118150012.362000089@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit 30837a49bd0aba0f311d4056cd48753955f60d40 ]

For simulation C models that don't run CP FW where adev->mes.sched_version
is not populated correctly. This causes NULL dereference in
amdgpu_amdkfd_free_gtt_mem(dev->adev, (void **)&pqn->q->wptr_bo_gart)
and warning on unpinned BO in amdgpu_bo_gpu_offset(q->properties.wptr_bo).

Compared with adding version check here and there,
always map wptr BO to GART simplifies things.

v2: Add NULL check in amdgpu_amdkfd_free_gtt_mem.(Philip)

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: da2897ee8b81 ("drm/amdkfd: use the queue's process info for the WPTR BO eviction fence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c    |  3 +++
 .../amd/amdkfd/kfd_process_queue_manager.c    | 23 ++++++++-----------
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
index 1a92f04c63ace..2de2895e3850b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.c
@@ -368,6 +368,9 @@ void amdgpu_amdkfd_free_gtt_mem(struct amdgpu_device *adev, void **mem_obj)
 {
 	struct amdgpu_bo **bo = (struct amdgpu_bo **) mem_obj;
 
+	if (!bo || !*bo)
+		return;
+
 	(void)amdgpu_bo_reserve(*bo, true);
 	amdgpu_bo_kunmap(*bo);
 	amdgpu_bo_unpin(*bo);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
index 445fba8e4bbdd..4a3ed391b3c7b 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_process_queue_manager.c
@@ -278,20 +278,17 @@ static int init_user_queue(struct process_queue_manager *pqm,
 		/* Starting with GFX11, wptr BOs must be mapped to GART for MES to determine work
 		 * on unmapped queues for usermode queue oversubscription (no aggregated doorbell)
 		 */
-		if (((dev->adev->mes.sched_version & AMDGPU_MES_API_VERSION_MASK)
-		    >> AMDGPU_MES_API_VERSION_SHIFT) >= 2) {
-			if (dev->adev != amdgpu_ttm_adev(q_properties->wptr_bo->tbo.bdev)) {
-				pr_err("Queue memory allocated to wrong device\n");
-				retval = -EINVAL;
-				goto free_gang_ctx_bo;
-			}
+		if (dev->adev != amdgpu_ttm_adev(q_properties->wptr_bo->tbo.bdev)) {
+			pr_err("Queue memory allocated to wrong device\n");
+			retval = -EINVAL;
+			goto free_gang_ctx_bo;
+		}
 
-			retval = amdgpu_amdkfd_map_gtt_bo_to_gart(q_properties->wptr_bo,
-								  &(*q)->wptr_bo_gart);
-			if (retval) {
-				pr_err("Failed to map wptr bo to GART\n");
-				goto free_gang_ctx_bo;
-			}
+		retval = amdgpu_amdkfd_map_gtt_bo_to_gart(q_properties->wptr_bo,
+							  &(*q)->wptr_bo_gart);
+		if (retval) {
+			pr_err("Failed to map wptr bo to GART\n");
+			goto free_gang_ctx_bo;
 		}
 	}
 
-- 
2.53.0



