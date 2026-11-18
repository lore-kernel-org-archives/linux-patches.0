Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017160;
	b=qUEYKVlyMTDOQHEL41BOef5yWIWvJw/HpyNfhWaot8DmOGd2nYHK2hz66wuf+47GjY1X
	 K8mVhgtbF+lwj8Nh1ZQJepxx90P/VJd+bpD1O3n8qa00v55Dm79pyDUEHgjd81yipOYGC
	 8dbKepLEXPsj/6xyPi5WlqLOPTuLlPgUF1FXhftJWdO6xBJ5ox7TegY4TJ4kE+FmsPas4
	 DHkNnMEHEo92bjHanbj7fiDOi/bmcFaXfGfp/brYfzIcmIOBaayQGrw6/rOn5eRLAAhJK
	 RNPUDEhoDj5Dx6s9usFm3YwN3OdtxWrC95PCA5DXuE+uxoh+Ch6qf9tDcb7WD9o4jMQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/poLV3tX3zno12QBa03GqMVim/4pxwv78oty3kBkhbc=;
	b=uaMq3owXKUUQD1balZ1M4jw8J0t9fEYCYJ5TpoaeyLONowHDlLeG9FTBF8m8cLBf4U4O
	 vrnCAAIN7QvSiLaXPiVTRqdDOyw3B2kLdaMZuH6IfMoeJtevTBINU3KXkar7eaYj+ybtt
	 6Vt9lEDTwpGVKDeZhkkFekKnGnLKGODvDHNqhZGFPK3TUOazth6Kz+OUoWvtdbRqIZFKG
	 7aVWRSwksxVmLPVWkex8mEaZGOwKpJUyUUXSGQew9drUtUiqfWceDELz+2d2ct6PL+X4T
	 1IaQaIkh9wvxNEDGMsys09SRdZpXIOl4JRPeNgCX21IS9v5xS1UTu5fTkgN5vTRRg+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vo5Spp+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC0A5606A31C;
	Wed, 18 Nov 2026 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vo5Spp+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A7B31F000C4;
	Wed, 18 Nov 2026 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017159;
	bh=/poLV3tX3zno12QBa03GqMVim/4pxwv78oty3kBkhbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vo5Spp+SAxS8NSaJhHBJk7sTqeaM9AStjScFzkY2KRdVaK/r33DpJjEhqKa9JegxW
	 lgi++qkWTLNxxWGbqniac0Y7x16+B6TwezB8Dh2bZ9NyKbyumYTntW1NiypoxZIIxK
	 xtUZubmK/8Y2PyovY/qhzanibaJ0JBHqCE/CgViQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0743/2651] drm/amdgpu: Add workaround to enable GCv12.1 MGCG
Date: Wed, 18 Nov 2026 15:33:03 +0100
Message-ID: <20261118150314.632492812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit 67f7737a13de7fecab9726cff58229af25ffed71 ]

A workaround sequence which toggles MGCG override is required to enable
hardware MGCG. As this is not the final solution, don't change the CGCG
flags.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 52a484f3ef5b ("drm/amdgpu: Move GC v12.1 spm vmid init to hw init")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c | 53 ++++++++++++++++----------
 1 file changed, 32 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
index 78d64f2ed31fd..61f89fcc3407b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
@@ -214,6 +214,8 @@ static void gfx_v12_1_update_perf_clk(struct amdgpu_device *adev,
 static void gfx_v12_1_xcc_update_perf_clk(struct amdgpu_device *adev,
 					 bool enable, int xcc_id);
 static int gfx_v12_1_init_cp_compute_microcode_bo(struct amdgpu_device *adev);
+static void gfx_v12_1_xcc_update_medium_grain_clock_gating(
+	struct amdgpu_device *adev, bool enable, int xcc_id, bool force);
 
 static void gfx_v12_1_kiq_set_resources(struct amdgpu_ring *kiq_ring,
 					uint64_t queue_mask)
@@ -2817,6 +2819,8 @@ static int gfx_v12_1_xcc_cp_resume(struct amdgpu_device *adev, uint16_t xcc_mask
 				return r;
 		}
 
+		gfx_v12_1_xcc_update_medium_grain_clock_gating(adev, false,
+							       xcc_id, true);
 		/* GFX CGCG and LS is disabled by rlc fw */
 		gfx_v12_1_xcc_enable_gui_idle_interrupt(adev, false, xcc_id);
 
@@ -2850,6 +2854,8 @@ static int gfx_v12_1_xcc_cp_resume(struct amdgpu_device *adev, uint16_t xcc_mask
 			if (r)
 				return r;
 		}
+		gfx_v12_1_xcc_update_medium_grain_clock_gating(adev, true,
+							       xcc_id, true);
 	}
 
 	return 0;
@@ -3489,37 +3495,41 @@ static void gfx_v12_1_xcc_update_coarse_grain_clock_gating(struct amdgpu_device
 	}
 }
 
-static void gfx_v12_1_xcc_update_medium_grain_clock_gating(struct amdgpu_device *adev,
-							   bool enable, int xcc_id)
+static void gfx_v12_1_xcc_update_medium_grain_clock_gating(
+	struct amdgpu_device *adev, bool enable, int xcc_id, bool force)
 {
 	uint32_t data, def;
-	if (!(adev->cg_flags & (AMD_CG_SUPPORT_GFX_MGCG | AMD_CG_SUPPORT_GFX_MGLS)))
+	bool support_mgcg;
+
+	support_mgcg = force || (adev->cg_flags & AMD_CG_SUPPORT_GFX_MGCG);
+
+	if (!support_mgcg)
 		return;
 
 	/* It is disabled by HW by default */
 	if (enable) {
-		if (adev->cg_flags & AMD_CG_SUPPORT_GFX_MGCG) {
-			/* 1 - RLC_CGTT_MGCG_OVERRIDE */
-			def = data = RREG32_SOC15(GC, GET_INST(GC, xcc_id), regRLC_CGTT_MGCG_OVERRIDE);
+		/* 1 - RLC_CGTT_MGCG_OVERRIDE */
+		def = data = RREG32_SOC15(GC, GET_INST(GC, xcc_id),
+					  regRLC_CGTT_MGCG_OVERRIDE);
 
-			data &= ~(RLC_CGTT_MGCG_OVERRIDE__GRBM_CGTT_SCLK_OVERRIDE_MASK |
-				  RLC_CGTT_MGCG_OVERRIDE__RLC_CGTT_SCLK_OVERRIDE_MASK |
-				  RLC_CGTT_MGCG_OVERRIDE__GFXIP_MGCG_OVERRIDE_MASK);
+		data &= ~(RLC_CGTT_MGCG_OVERRIDE__GRBM_CGTT_SCLK_OVERRIDE_MASK |
+			  RLC_CGTT_MGCG_OVERRIDE__RLC_CGTT_SCLK_OVERRIDE_MASK |
+			  RLC_CGTT_MGCG_OVERRIDE__GFXIP_MGCG_OVERRIDE_MASK);
 
-			if (def != data)
-				WREG32_SOC15(GC, GET_INST(GC, xcc_id), regRLC_CGTT_MGCG_OVERRIDE, data);
-		}
+		if (def != data)
+			WREG32_SOC15(GC, GET_INST(GC, xcc_id),
+				     regRLC_CGTT_MGCG_OVERRIDE, data);
 	} else {
-		if (adev->cg_flags & AMD_CG_SUPPORT_GFX_MGCG) {
-			def = data = RREG32_SOC15(GC, GET_INST(GC, xcc_id), regRLC_CGTT_MGCG_OVERRIDE);
+		def = data = RREG32_SOC15(GC, GET_INST(GC, xcc_id),
+					  regRLC_CGTT_MGCG_OVERRIDE);
 
-			data |= (RLC_CGTT_MGCG_OVERRIDE__RLC_CGTT_SCLK_OVERRIDE_MASK |
-				 RLC_CGTT_MGCG_OVERRIDE__GRBM_CGTT_SCLK_OVERRIDE_MASK |
-				 RLC_CGTT_MGCG_OVERRIDE__GFXIP_MGCG_OVERRIDE_MASK);
+		data |= (RLC_CGTT_MGCG_OVERRIDE__RLC_CGTT_SCLK_OVERRIDE_MASK |
+			 RLC_CGTT_MGCG_OVERRIDE__GRBM_CGTT_SCLK_OVERRIDE_MASK |
+			 RLC_CGTT_MGCG_OVERRIDE__GFXIP_MGCG_OVERRIDE_MASK);
 
-			if (def != data)
-				WREG32_SOC15(GC, GET_INST(GC, xcc_id), regRLC_CGTT_MGCG_OVERRIDE, data);
-		}
+		if (def != data)
+			WREG32_SOC15(GC, GET_INST(GC, xcc_id),
+				     regRLC_CGTT_MGCG_OVERRIDE, data);
 	}
 }
 
@@ -3589,7 +3599,8 @@ static int gfx_v12_1_xcc_update_gfx_clock_gating(struct amdgpu_device *adev,
 
 	gfx_v12_1_xcc_update_coarse_grain_clock_gating(adev, enable, xcc_id);
 
-	gfx_v12_1_xcc_update_medium_grain_clock_gating(adev, enable, xcc_id);
+	gfx_v12_1_xcc_update_medium_grain_clock_gating(adev, enable, xcc_id,
+						       false);
 
 	gfx_v12_1_xcc_update_repeater_fgcg(adev, enable, xcc_id);
 
-- 
2.53.0



