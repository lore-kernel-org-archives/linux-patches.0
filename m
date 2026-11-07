Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065151;
	b=4bQJvG4tROZ7cMnept0DK/jQ4AV2ucFW6snwKGM0Zh597X+qRVN9ZJLANBGsCPb1iFsP
	 QDoxtDT0VbyBH1z7QedOyGgy4H/DOx0z9Wi+JMYn8qWj9E4kAqSkS6Y0N9LdH1uKYjYx1
	 vfSkZS6uuRJ4WP9X9Uzystzvf8gZNLtWZI98IxfIHUuyI2GGRPLrQQWQxTMhqbX1jC0ay
	 GrEiZfRSinSOLL8MWuyd8q3VJZbZXt87vDurYuBH4/gfrUtp2ihxEVh4pBJpKV3CLxz+O
	 J1TCOlelCX1SVPQ96+mRMl8l68QDVqaORB8cHzOSXFg8tapeeMsmGuZYz7393ZScVHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065151;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V9Ft01f7TVKlbqsKyiffGsdVNYKD7DBiWpjc/4srzzo=;
	b=4Omc2SqJKNLEx3FJL59aZAmAZJxm/Y/KXZvfuiKsE1BDaLwyJjxXaWEEroIWNCydSkCy
	 /Oxq811Yhpe2CUcyfluZOtsNKggfFkf2eT0BfKtYXnFCR4ME2ObedFzucjVbhHvooh96X
	 oxOyZ1SUhOehHig+ILTaqUXdBa8uLKnC5eXkaFWAfyS6SgjFxdLd8DpMSmQFAEPDG3sQx
	 7xyzbv/sm/IVqmbwdjlfZkwD/VfNnEjDVGl9JHbxURFsYwm735/k/FtJXNYvOupmaeACj
	 W15rWAUHgXvgRKuSt23QCozoj4ROLpX83eCZyUXfzeC8Qmq1cScBiX8qz67s6RZ0HCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2ornGpI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04EA606A335;
	Sat,  7 Nov 2026 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T2ornGpI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649D11F0089F;
	Sat,  7 Nov 2026 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065150;
	bh=V9Ft01f7TVKlbqsKyiffGsdVNYKD7DBiWpjc/4srzzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T2ornGpIpkM5lajhnO1BSLECpyb5aOnT8/92dR9tWnhv1C6FoAXNZz2tTFrOYY3sj
	 ZP9iKkWS5XkY86P+2K4Qu2aWYbEcoToIuRuTLsN0EYnwT+RB+ZCyJVdxu2f3e74M77
	 TGQzl5kZC3DMr4tJP+/7e651BxYXQu6u5ndCYXaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
	Mukul Joshi <mukul.joshi@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0962/1257] drm/amdkfd: fix NULL deref in SDMA HQD debugfs dump on GC 12.1
Date: Sat,  7 Nov 2026 08:54:18 -0500
Message-ID: <20261107135005.910017674@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>

[ Upstream commit 0fe236afa2b9b28540fa1f8c789ef5d499c5d0ee ]

Reading the KFD HQD debugfs node (dqm_debugfs_hqds) on a gc_12_1_0 part
oopses with a NULL pointer dereference:

  BUG: kernel NULL pointer dereference, address: 0000000000000000
  RIP: hqd_sdma_dump_v12_1+0x6a [amdgpu]
  Call Trace:
   dqm_debugfs_hqds+0x2da/0x360 [amdgpu]
   kfd_debugfs_hqds_by_device+0x74/0xa0 [amdgpu]
   seq_read ... __x64_sys_read

get_sdma_rlc_reg_offset() assumes an interleaved layout where the second
SDMA per XCC lives in a separate SDMA1_HWIP register aperture. On
gc_12_1_0 that aperture does not exist.

Rewrite get_sdma_rlc_reg_offset() to mirror sdma_v7_1_get_reg_offset():
base the offset on adev->reg_offset[GC_HWIP][xcc_id][0] and add the
per-instance SDMA1 offset for the odd instance.

Fixes: 7bd5d763b8e1 ("drm/amdkfd: Add gfx_v12_1_kfd2kgd interface for GFX12_1")
Signed-off-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Mukul Joshi <mukul.joshi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 94b2c5b06d37adc0e9a23138252758657b64b58a)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/amd/amdgpu/amdgpu_amdkfd_gfx_v12_1.c  | 44 +++++++++++--------
 .../drm/amd/amdkfd/kfd_device_queue_manager.c |  9 ++++
 2 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v12_1.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v12_1.c
index 070001fd34b0f..7b04258c38931 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v12_1.c
@@ -77,25 +77,21 @@ static uint32_t get_sdma_rlc_reg_offset(struct amdgpu_device *adev,
 				unsigned int engine_id,
 				unsigned int queue_id)
 {
-	uint32_t sdma_engine_reg_base = 0;
-	uint32_t sdma_rlc_reg_offset;
 	uint32_t dev_inst = GET_INST(SDMA0, engine_id);
+	int xcc_id = adev->sdma.instance[engine_id].xcc_id;
+	int xcc_inst = dev_inst % adev->sdma.num_inst_per_xcc;
+	uint32_t sdma_engine_reg_base;
+	uint32_t sdma_rlc_reg_offset;
 
-	switch (dev_inst % adev->sdma.num_inst_per_xcc) {
-	case 0:
-		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA0,
-				dev_inst / adev->sdma.num_inst_per_xcc,
-				regSDMA0_SDMA_QUEUE0_RB_CNTL) - regSDMA0_SDMA_QUEUE0_RB_CNTL;
-		break;
-	case 1:
-		sdma_engine_reg_base = SOC15_REG_OFFSET(SDMA1,
-				dev_inst / adev->sdma.num_inst_per_xcc,
-				regSDMA1_SDMA_QUEUE0_RB_CNTL) - regSDMA0_SDMA_QUEUE0_RB_CNTL;
-		break;
-	default:
-		WARN(1, "Invalid SDMA engine id %d\n", engine_id);
-		break;
-	}
+	/*
+	 * On SDMA v7 (gc_12_x) all SDMA queue registers live in the GC_HWIP
+	 * aperture. The second SDMA per XCC is reached by adding a fixed
+	 * offset (regSDMA1_* - regSDMA0_* == SDMA1_REG_OFFSET
+	 */
+	sdma_engine_reg_base = adev->reg_offset[GC_HWIP][xcc_id][0];
+	if (xcc_inst != 0)
+		sdma_engine_reg_base +=
+			regSDMA1_SDMA_QUEUE0_RB_CNTL - regSDMA0_SDMA_QUEUE0_RB_CNTL;
 
 	sdma_rlc_reg_offset = sdma_engine_reg_base
 		+ queue_id * (regSDMA0_SDMA_QUEUE1_RB_CNTL - regSDMA0_SDMA_QUEUE0_RB_CNTL);
@@ -141,8 +137,7 @@ static int hqd_sdma_dump_v12_1(struct amdgpu_device *adev,
 			     uint32_t engine_id, uint32_t queue_id,
 			     uint32_t (**dump)[2], uint32_t *n_regs)
 {
-	uint32_t sdma_rlc_reg_offset = get_sdma_rlc_reg_offset(adev,
-			engine_id, queue_id);
+	uint32_t sdma_rlc_reg_offset;
 	uint32_t i = 0, reg;
 
 	const uint32_t first_reg = regSDMA0_SDMA_QUEUE0_RB_CNTL;
@@ -150,6 +145,17 @@ static int hqd_sdma_dump_v12_1(struct amdgpu_device *adev,
 #undef HQD_N_REGS
 #define HQD_N_REGS (last_reg - first_reg + 1)
 
+	/*
+	 * dqm_debugfs_hqds() iterates engine_id over
+	 * node_id * get_num_all_sdma_engines()..+get_num_all_sdma_engines().
+	 * On partitioned devices that range can address a logical SDMA engine
+	 * beyond the instances that actually exist on this node; reject it
+	 */
+	if (engine_id >= adev->sdma.num_instances)
+		return -EINVAL;
+
+	sdma_rlc_reg_offset = get_sdma_rlc_reg_offset(adev, engine_id, queue_id);
+
 	*dump = kmalloc(HQD_N_REGS*2*sizeof(uint32_t), GFP_KERNEL);
 	if (*dump == NULL)
 		return -ENOMEM;
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
index 4594824985e1e..dd2c8ac7cb9c4 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager.c
@@ -4046,6 +4046,15 @@ int dqm_debugfs_hqds(struct seq_file *m, void *data)
 		     queue++) {
 			r = dqm->dev->kfd2kgd->hqd_sdma_dump(
 				dqm->dev->adev, pipe, queue, &dump, &n_regs);
+			if (r == -EINVAL) {
+				/*
+				 * SDMA engine not present/mapped on this
+				 * device; skip it instead of aborting the
+				 * whole dump.
+				 */
+				r = 0;
+				break;
+			}
 			if (r)
 				break;
 
-- 
2.53.0



