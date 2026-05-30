Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C07F33E36A;
	Sat, 30 May 2026 17:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161917; cv=none; b=WKmBYlhtdRaP8aLmL0OhALc3crP2fX49qatQyC0B61RSflSyve3bfA+brTFtcahclC3Gn1RXzas+FJmPUU4ijoRzHswR4Xf6AL0iojR1ChP3OuVx+rckMLi8oAtkDEZY55E1S44Awnt/JH2Qgg7FBb+aMhF03+A/wgqKEFdMRkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161917; c=relaxed/simple;
	bh=Osw84QPA8UKVUnGQdKEOQQ4wdDaacb6+4iZJCS11Kxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W4f8dx5tgpyNDaUo6M9a+CoDb0Tah5QRRjaEIM1ZUMEr8pO4jiVfSsVF+lkTz9iACB/QnMA/ixJzFQlGVRfCczV4kLGKgd7CzgCegRUNH11oUUxkRLoa37ghfbfJS8lXSbjjxDY5EpJgK2tMwlUxnhAlEn6obMlW3qD5J2aiHf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=czuPOONe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="czuPOONe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC071F00893;
	Sat, 30 May 2026 17:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161915;
	bh=9agWzAnIEwXWCP/b3TH07oOAW6NIBszqFpx6gNvwv4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czuPOONe1YxGNq9oiMc/2IttiV1PRV46JNqEQR4IrYl0+yqf6ZuFiCQGfnLhEE/eV
	 Ryp8b90pV3tjR6y0AtxXs0WLiYP8njoiZOsqVkE/1XRkIF8Q/F0udw2gbzuISAlRVS
	 zQ03iHgRVPsirProT5B049uXhVBoYP+GbB3NxGP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Demers <alexandre.f.demers@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 736/969] drm/amdgpu: fix spelling typos
Date: Sat, 30 May 2026 18:04:20 +0200
Message-ID: <20260530160320.874852581@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Demers <alexandre.f.demers@gmail.com>

[ Upstream commit ce43abd7ec9464cf954f90e1c69e11768b02fa0a ]

Found some typos while exploring amdgpu code.

Signed-off-by: Alexandre Demers <alexandre.f.demers@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 13e4cf116dbf ("drm/amdgpu/uvd3.1: Don't validate the firmware when already validated")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c | 2 +-
 drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c   | 6 +++---
 drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c   | 3 ++-
 drivers/gpu/drm/amd/amdgpu/vce_v2_0.c   | 2 +-
 4 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
index 3a1576e2f8e3b..c76f1e1ee395c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gmc.c
@@ -256,7 +256,7 @@ void amdgpu_gmc_sysvm_location(struct amdgpu_device *adev, struct amdgpu_gmc *mc
  * @adev: amdgpu device structure holding all necessary information
  * @mc: memory controller structure holding memory information
  *
- * Function will place try to place GART before or after VRAM.
+ * Function will try to place GART before or after VRAM.
  * If GART size is bigger than space left then we ajust GART size.
  * Thus function will never fails.
  */
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
index e458e0d5801b0..fbfed90503868 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v3_1.c
@@ -98,7 +98,7 @@ static void uvd_v3_1_ring_emit_ib(struct amdgpu_ring *ring,
 }
 
 /**
- * uvd_v3_1_ring_emit_fence - emit an fence & trap command
+ * uvd_v3_1_ring_emit_fence - emit a fence & trap command
  *
  * @ring: amdgpu_ring pointer
  * @addr: address
@@ -242,7 +242,7 @@ static void uvd_v3_1_mc_resume(struct amdgpu_device *adev)
 	uint64_t addr;
 	uint32_t size;
 
-	/* programm the VCPU memory controller bits 0-27 */
+	/* program the VCPU memory controller bits 0-27 */
 	addr = (adev->uvd.inst->gpu_addr + AMDGPU_UVD_FIRMWARE_OFFSET) >> 3;
 	size = AMDGPU_UVD_FIRMWARE_SIZE(adev) >> 3;
 	WREG32(mmUVD_VCPU_CACHE_OFFSET0, addr);
@@ -416,7 +416,7 @@ static int uvd_v3_1_start(struct amdgpu_device *adev)
 	/* Set the write pointer delay */
 	WREG32(mmUVD_RBC_RB_WPTR_CNTL, 0);
 
-	/* programm the 4GB memory segment for rptr and ring buffer */
+	/* Program the 4GB memory segment for rptr and ring buffer */
 	WREG32(mmUVD_LMI_EXT40_ADDR, upper_32_bits(ring->gpu_addr) |
 		   (0x7 << 16) | (0x1 << 31));
 
diff --git a/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c b/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
index c108b83817951..01d8e7d2caf97 100644
--- a/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/uvd_v4_2.c
@@ -298,7 +298,7 @@ static int uvd_v4_2_start(struct amdgpu_device *adev)
 	/* enable VCPU clock */
 	WREG32(mmUVD_VCPU_CNTL,  1 << 9);
 
-	/* disable interupt */
+	/* disable interrupt */
 	WREG32_P(mmUVD_MASTINT_EN, 0, ~(1 << 1));
 
 #ifdef __BIG_ENDIAN
@@ -308,6 +308,7 @@ static int uvd_v4_2_start(struct amdgpu_device *adev)
 #endif
 	WREG32(mmUVD_LMI_SWAP_CNTL, lmi_swap_cntl);
 	WREG32(mmUVD_MP_SWAP_CNTL, mp_swap_cntl);
+
 	/* initialize UVD memory controller */
 	WREG32(mmUVD_LMI_CTRL, 0x203108);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
index 67eb01fef789b..479eb9382c77e 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v2_0.c
@@ -278,7 +278,7 @@ static int vce_v2_0_stop(struct amdgpu_device *adev)
 	int status;
 
 	if (vce_v2_0_lmi_clean(adev)) {
-		DRM_INFO("vce is not idle \n");
+		DRM_INFO("VCE is not idle \n");
 		return 0;
 	}
 
-- 
2.53.0



