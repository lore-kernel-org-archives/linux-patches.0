Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F852FB08C;
	Wed, 25 Feb 2026 06:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002754; cv=none; b=joCjhG6FajsQyvmIn7Dc7E7XizrOPNNXGpC0KLDn1EbOO/nMQWyLMMFonmbq5CupIaL6Q5NTlRbBR/c6WQIzkC1jrewNQFB+7656HlvbZXBfM4JxPSVbSZqfudKfZWr2d7TmXVOPDv3NrJQn6ARWV4r0BOZYf+5vgk45ym7vMcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002754; c=relaxed/simple;
	bh=gEKXF2kur5urtu6k8z309Adcp3KCWpw6yVSa0t519E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+/EDx0FjlQEWBSdeZqI8kAO3PKnHsk8WXCcZMO00ExhEye5Thh1fHtyVWMRRJwTA7BNdbH1El2r2Cd0NNTCkBUximZ2eE+rjCEfXncRxxBzTV8g2p/aDRH1zidmEJRKu7Fm9UG+kvBPlkaHJv/SZ9RruCW3t7NWZq2Ht+KUzmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tD+ig0qn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tD+ig0qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBCBC116D0;
	Wed, 25 Feb 2026 06:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002754;
	bh=gEKXF2kur5urtu6k8z309Adcp3KCWpw6yVSa0t519E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tD+ig0qnqd9D83h6Oblic7gM+5sV957vICVOGl5R+MkKXBa7HZYtOcm/LyCuf7LRB
	 t+PrMxKDEhfIIFGv2Dy2MeG/7EMI/uXOOoNvZe8fjXNXgNehFh78ok8UahXHUSZM1u
	 l5uz/0cmNOtZ2Qi8GVSfZLuuqV/cdSn2yXsEtowI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 581/641] drm/amdgpu: move reset debug disable handling
Date: Tue, 24 Feb 2026 17:25:07 -0800
Message-ID: <20260225012402.590230127@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit ad0a48e531a3137cec16bb5f8f60c8cc8de06b01 ]

Move everything to the supported resets masks rather than
having an explicit misc checks for this.

Reviewed-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 46a2cb7d24f2 ("drm/amdgpu/sdma5: enable queue resets unconditionally")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_job.c  | 8 +++-----
 drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c | 3 ---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c   | 3 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c   | 6 ++++--
 drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c   | 3 ++-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c    | 2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c  | 6 ++++--
 drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c | 8 ++++++--
 drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c   | 3 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c   | 6 ++++--
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c   | 3 ++-
 drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c   | 3 ++-
 12 files changed, 32 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
index d020a890a0ea4..630af847f29ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_job.c
@@ -130,11 +130,9 @@ static enum drm_gpu_sched_stat amdgpu_job_timedout(struct drm_sched_job *s_job)
 	}
 
 	/* attempt a per ring reset */
-	if (unlikely(adev->debug_disable_gpu_ring_reset)) {
-		dev_err(adev->dev, "Ring reset disabled by debug mask\n");
-	} else if (amdgpu_gpu_recovery &&
-		   amdgpu_ring_is_reset_type_supported(ring, AMDGPU_RESET_TYPE_PER_QUEUE) &&
-		   ring->funcs->reset) {
+	if (amdgpu_gpu_recovery &&
+	    amdgpu_ring_is_reset_type_supported(ring, AMDGPU_RESET_TYPE_PER_QUEUE) &&
+	    ring->funcs->reset) {
 		dev_err(adev->dev, "Starting %s ring reset\n",
 			s_job->sched->name);
 		r = amdgpu_ring_reset(ring, job->vmid, &job->hw_fence);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
index 5ec5c3ff22bb0..304564ec2f59a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ring.c
@@ -460,9 +460,6 @@ bool amdgpu_ring_soft_recovery(struct amdgpu_ring *ring, unsigned int vmid,
 	ktime_t deadline;
 	bool ret;
 
-	if (unlikely(ring->adev->debug_disable_soft_recovery))
-		return false;
-
 	deadline = ktime_add_us(ktime_get(), 10000);
 
 	if (amdgpu_sriov_vf(ring->adev) || !ring->funcs->soft_recovery || !fence)
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
index 726b2bdfbba33..003bcece715eb 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -4956,7 +4956,8 @@ static int gfx_v10_0_sw_init(struct amdgpu_ip_block *ip_block)
 		amdgpu_get_soft_full_reset_mask(&adev->gfx.gfx_ring[0]);
 	adev->gfx.compute_supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->gfx.compute_ring[0]);
-	if (!amdgpu_sriov_vf(adev)) {
+	if (!amdgpu_sriov_vf(adev) &&
+	    !adev->debug_disable_gpu_ring_reset) {
 		adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		adev->gfx.gfx_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 	}
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index c936772c03725..1dd9fd486eecf 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1821,13 +1821,15 @@ static int gfx_v11_0_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(11, 0, 3):
 		if ((adev->gfx.me_fw_version >= 2280) &&
 		    (adev->gfx.mec_fw_version >= 2410) &&
-		    !amdgpu_sriov_vf(adev)) {
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset) {
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 			adev->gfx.gfx_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		}
 		break;
 	default:
-		if (!amdgpu_sriov_vf(adev)) {
+		if (!amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset) {
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 			adev->gfx.gfx_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		}
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
index f80e9e356e252..50e39b9d9df6f 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_0.c
@@ -1547,7 +1547,8 @@ static int gfx_v12_0_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(12, 0, 1):
 		if ((adev->gfx.me_fw_version >= 2660) &&
 		    (adev->gfx.mec_fw_version >= 2920) &&
-		    !amdgpu_sriov_vf(adev)) {
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset) {
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 			adev->gfx.gfx_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		}
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index dd19a97436db9..7d0a2d239b78d 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -2409,7 +2409,7 @@ static int gfx_v9_0_sw_init(struct amdgpu_ip_block *ip_block)
 		amdgpu_get_soft_full_reset_mask(&adev->gfx.gfx_ring[0]);
 	adev->gfx.compute_supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->gfx.compute_ring[0]);
-	if (!amdgpu_sriov_vf(adev))
+	if (!amdgpu_sriov_vf(adev) && !adev->debug_disable_gpu_ring_reset)
 		adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 
 	r = amdgpu_gfx_kiq_init(adev, GFX9_MEC_HPD_SIZE, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
index c90cbe053ef37..a4ebb6c5af557 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_4_3.c
@@ -1149,14 +1149,16 @@ static int gfx_v9_4_3_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(9, 4, 3):
 	case IP_VERSION(9, 4, 4):
 		if ((adev->gfx.mec_fw_version >= 155) &&
-		    !amdgpu_sriov_vf(adev)) {
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset) {
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_PIPE;
 		}
 		break;
 	case IP_VERSION(9, 5, 0):
 		if ((adev->gfx.mec_fw_version >= 21) &&
-		    !amdgpu_sriov_vf(adev)) {
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset) {
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 			adev->gfx.compute_supported_reset |= AMDGPU_RESET_TYPE_PER_PIPE;
 		}
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
index 36b1ca73c2ed3..a1443990d5c60 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_4_2.c
@@ -2361,11 +2361,15 @@ static void sdma_v4_4_2_update_reset_mask(struct amdgpu_device *adev)
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(9, 4, 3):
 	case IP_VERSION(9, 4, 4):
-		if ((adev->gfx.mec_fw_version >= 0xb0) && amdgpu_dpm_reset_sdma_is_supported(adev))
+		if ((adev->gfx.mec_fw_version >= 0xb0) &&
+		    amdgpu_dpm_reset_sdma_is_supported(adev) &&
+		    !adev->debug_disable_gpu_ring_reset)
 			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		break;
 	case IP_VERSION(9, 5, 0):
-		if ((adev->gfx.mec_fw_version >= 0xf) && amdgpu_dpm_reset_sdma_is_supported(adev))
+		if ((adev->gfx.mec_fw_version >= 0xf) &&
+		    amdgpu_dpm_reset_sdma_is_supported(adev) &&
+		    !adev->debug_disable_gpu_ring_reset)
 			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		break;
 	default:
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
index 7dc67a22a7a01..8ddc4df06a1fd 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_0.c
@@ -1429,7 +1429,8 @@ static int sdma_v5_0_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(5, 0, 2):
 	case IP_VERSION(5, 0, 5):
 		if ((adev->sdma.instance[0].fw_version >= 35) &&
-		    !amdgpu_sriov_vf(adev))
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset)
 			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		break;
 	default:
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
index 3bd44c24f692d..c6a619514a8ad 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c
@@ -1348,12 +1348,14 @@ static int sdma_v5_2_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(5, 2, 3):
 	case IP_VERSION(5, 2, 4):
 		if ((adev->sdma.instance[0].fw_version >= 76) &&
-		    !amdgpu_sriov_vf(adev))
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset)
 			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		break;
 	case IP_VERSION(5, 2, 5):
 		if ((adev->sdma.instance[0].fw_version >= 34) &&
-		    !amdgpu_sriov_vf(adev))
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset)
 			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		break;
 	default:
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
index 3c6568d501994..2170400449872 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -1356,7 +1356,8 @@ static int sdma_v6_0_sw_init(struct amdgpu_ip_block *ip_block)
 	case IP_VERSION(6, 0, 2):
 	case IP_VERSION(6, 0, 3):
 		if ((adev->sdma.instance[0].fw_version >= 21) &&
-		    !amdgpu_sriov_vf(adev))
+		    !amdgpu_sriov_vf(adev) &&
+		    !adev->debug_disable_gpu_ring_reset)
 			adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 		break;
 	default:
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
index 326ecc8d37d21..2b81344dcd668 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v7_0.c
@@ -1337,7 +1337,8 @@ static int sdma_v7_0_sw_init(struct amdgpu_ip_block *ip_block)
 
 	adev->sdma.supported_reset =
 		amdgpu_get_soft_full_reset_mask(&adev->sdma.instance[0].ring);
-	if (!amdgpu_sriov_vf(adev))
+	if (!amdgpu_sriov_vf(adev) &&
+	    !adev->debug_disable_gpu_ring_reset)
 		adev->sdma.supported_reset |= AMDGPU_RESET_TYPE_PER_QUEUE;
 
 	r = amdgpu_sdma_sysfs_reset_mask_init(adev);
-- 
2.51.0



