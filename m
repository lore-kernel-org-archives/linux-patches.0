Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B50252912;
	Mon, 23 Jun 2025 13:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685813; cv=none; b=eNMiWOuPEkT4s9/KpbpmCXb+Fj4moC64v5ycgQkXqnBt7Q+xoG2NQQngLjIXu8KVIeEXR4xt/mkYdlfsXfh0TD3OGw6wl2a59zw5qAwamtvXL2LMBPe0fcSCk6nm48hxqeUKA40tdjwR2U40Rrsisiks37kfBRzuOdehgSpls8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685813; c=relaxed/simple;
	bh=WF+wQxVwYxf0ZvZBFIP1BC9oVu1cUr9fU/xu2924X2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uqv5hpjMpKae2BHW5N/XPE4BJWDHEK6Cx9DMdzVVMUg0ZWunYlu50GzoO5P+BeC6wrau1Yeiv+XDZmhtm6hegyojljfEFOtAhdKIaquWlt9bEze1qOOlx/4xGzz1lq9t/E3kd2iM2jm5l3+bwIK+9lpcekxM7LBnxe7p9mlL7n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l56Cbjw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l56Cbjw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826F9C4CEEA;
	Mon, 23 Jun 2025 13:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685812;
	bh=WF+wQxVwYxf0ZvZBFIP1BC9oVu1cUr9fU/xu2924X2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l56Cbjw1KGGcr6mBdAB5AnMOabed/ClxZXQt5q/oOcCbv8eWhPcDGeJ3IRfx2Doij
	 FpdKNXG3iOhWmHfN8Z3pLrVUefRGgAdhinI17OfddiKxHl5O9wBCzYgnAbubAfk5ue
	 mPmYFgExclWsBvNM8Z4yu3emXk+xpqct3g1vThbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <Christian.Koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Shashank Sharma <shashank.sharma@amd.com>,
	Arvind Yadav <arvind.yadav@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 286/592] drm/amdgpu: fix MES GFX mask
Date: Mon, 23 Jun 2025 15:04:04 +0200
Message-ID: <20250623130707.160010828@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arvind Yadav <Arvind.Yadav@amd.com>

[ Upstream commit 9d3afcb7b9f950b9b7c58ceeeb9e71f3476e69ed ]

Current MES GFX mask prevents FW to enable oversubscription. This patch
does the following:
- Fixes the mask values and adds a description for the same
- Removes the central mask setup and makes it IP specific, as it would
  be different when the number of pipes and queues are different.

v2: squash in fix from Shashank

Cc: Christian König <Christian.Koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Shashank Sharma <shashank.sharma@amd.com>
Signed-off-by: Arvind Yadav <arvind.yadav@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c |  3 ---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h |  2 +-
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c  | 15 +++++++++++++--
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c  | 15 ++++++++++++---
 4 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index fb212f0a1136a..5590ad5e8cd76 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -150,9 +150,6 @@ int amdgpu_mes_init(struct amdgpu_device *adev)
 		adev->mes.compute_hqd_mask[i] = 0xc;
 	}
 
-	for (i = 0; i < AMDGPU_MES_MAX_GFX_PIPES; i++)
-		adev->mes.gfx_hqd_mask[i] = i ? 0 : 0xfffffffe;
-
 	for (i = 0; i < AMDGPU_MES_MAX_SDMA_PIPES; i++) {
 		if (i >= adev->sdma.num_instances)
 			break;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
index da2c9a8cb3e01..52dd54a32fb47 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.h
@@ -111,8 +111,8 @@ struct amdgpu_mes {
 
 	uint32_t                        vmid_mask_gfxhub;
 	uint32_t                        vmid_mask_mmhub;
-	uint32_t                        compute_hqd_mask[AMDGPU_MES_MAX_COMPUTE_PIPES];
 	uint32_t                        gfx_hqd_mask[AMDGPU_MES_MAX_GFX_PIPES];
+	uint32_t                        compute_hqd_mask[AMDGPU_MES_MAX_COMPUTE_PIPES];
 	uint32_t                        sdma_hqd_mask[AMDGPU_MES_MAX_SDMA_PIPES];
 	uint32_t                        aggregated_doorbells[AMDGPU_MES_PRIORITY_NUM_LEVELS];
 	uint32_t                        sch_ctx_offs[AMDGPU_MAX_MES_PIPES];
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 480283da18454..821c9baf5baa6 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -669,6 +669,18 @@ static int mes_v11_0_misc_op(struct amdgpu_mes *mes,
 			offsetof(union MESAPI__MISC, api_status));
 }
 
+static void mes_v11_0_set_gfx_hqd_mask(union MESAPI_SET_HW_RESOURCES *pkt)
+{
+	/*
+	 * GFX pipe 0 queue 0 is being used by Kernel queue.
+	 * Set GFX pipe 0 queue 1 for MES scheduling
+	 * mask = 10b
+	 * GFX pipe 1 can't be used for MES due to HW limitation.
+	 */
+	pkt->gfx_hqd_mask[0] = 0x2;
+	pkt->gfx_hqd_mask[1] = 0;
+}
+
 static int mes_v11_0_set_hw_resources(struct amdgpu_mes *mes)
 {
 	int i;
@@ -693,8 +705,7 @@ static int mes_v11_0_set_hw_resources(struct amdgpu_mes *mes)
 		mes_set_hw_res_pkt.compute_hqd_mask[i] =
 			mes->compute_hqd_mask[i];
 
-	for (i = 0; i < MAX_GFX_PIPES; i++)
-		mes_set_hw_res_pkt.gfx_hqd_mask[i] = mes->gfx_hqd_mask[i];
+	mes_v11_0_set_gfx_hqd_mask(&mes_set_hw_res_pkt);
 
 	for (i = 0; i < MAX_SDMA_PIPES; i++)
 		mes_set_hw_res_pkt.sdma_hqd_mask[i] = mes->sdma_hqd_mask[i];
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
index 624c6b4e452c8..7984ebda5b8bf 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -694,6 +694,17 @@ static int mes_v12_0_set_hw_resources_1(struct amdgpu_mes *mes, int pipe)
 			offsetof(union MESAPI_SET_HW_RESOURCES_1, api_status));
 }
 
+static void mes_v12_0_set_gfx_hqd_mask(union MESAPI_SET_HW_RESOURCES *pkt)
+{
+	/*
+	 * GFX V12 has only one GFX pipe, but 8 queues in it.
+	 * GFX pipe 0 queue 0 is being used by Kernel queue.
+	 * Set GFX pipe 0 queue 1-7 for MES scheduling
+	 * mask = 1111 1110b
+	 */
+	pkt->gfx_hqd_mask[0] = 0xFE;
+}
+
 static int mes_v12_0_set_hw_resources(struct amdgpu_mes *mes, int pipe)
 {
 	int i;
@@ -716,9 +727,7 @@ static int mes_v12_0_set_hw_resources(struct amdgpu_mes *mes, int pipe)
 			mes_set_hw_res_pkt.compute_hqd_mask[i] =
 				mes->compute_hqd_mask[i];
 
-		for (i = 0; i < MAX_GFX_PIPES; i++)
-			mes_set_hw_res_pkt.gfx_hqd_mask[i] =
-				mes->gfx_hqd_mask[i];
+		mes_v12_0_set_gfx_hqd_mask(&mes_set_hw_res_pkt);
 
 		for (i = 0; i < MAX_SDMA_PIPES; i++)
 			mes_set_hw_res_pkt.sdma_hqd_mask[i] =
-- 
2.39.5



