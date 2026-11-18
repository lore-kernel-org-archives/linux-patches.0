Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017041;
	b=xqwMyD1NAnRyY9bgCtmblIYZPw6nDA3zYqnHyCbUBr/AeDR07SjcKnOKZh86gdmsCQbL
	 RPserOtPCV+RLhHM0niCyDTclRXYkFJHCpjsGfhjjLApy9i3Ol664mrI0LvGpIj4xXb0c
	 LtEEWv+SM7tRNyYowPOO9zDNKp+VXLAXtVn4uFfB2v8zz1lQ/WG6aEhnlu06VX5iGzSm7
	 NOxjrhTQUuV1Mvr6LWcxOzzEJyQb724sEYd5l8Czd+mQWiJAojC9D3qkBXwV2tas77aSK
	 uJLO/MXXHYSTUhKp3u101MdiNPfEfnZNA9xnnsGsyYKVrLRTu7eDu3fSyQbIasACOpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kmJJo+3oaxNIqJN5WRo6kgOIVmzMMgvZu/xldZmoVyI=;
	b=KQoffhRj0bqTYt0e0UXhr00bKK49PUydoGg6qEbqRBcqINhuxyHwc/6ScD1CJoVZ9JNI
	 zHTfRNEB4kzIQXU/QDzd0KkUXhOp62auKnGW3MD+x7gqodvPFErLYaGcSuc/VdW7XFAqa
	 jAZylqYbhmB154aa8T4+s7XyqdD5opA2wrOImUcyecwThQ7xycwOpkuHVqSTt+vg1L4WO
	 oqzOZQas0EDTzmrCsFpyLF+cI5+dn9I+7oJXRSFwVtyf+y4iDxf53TLgqZ3wkRs5TUzSJ
	 BsCEGCB0IVOXP0CnnxtVh6NDX02nySg7iXyrwXruLxbWpmGz5od9anwu9nJxIFz+CDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZWukfTS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C69606A325;
	Wed, 18 Nov 2026 15:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LZWukfTS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D9D1F000C4;
	Wed, 18 Nov 2026 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017041;
	bh=kmJJo+3oaxNIqJN5WRo6kgOIVmzMMgvZu/xldZmoVyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LZWukfTSOUO+ktLKZfd6Rn51mE8Qo5+qPs6BJJy3ezeptQd702WEvOgeeLTPjuht/
	 E30aSczS/1+HxgtuABuDkjVyg1utpdo/zQ1YWGtqM7oOFhdiEt8VCVV0hdRlf8Vzpj
	 mgwoyCYe6ojOt0dGGENGIh3ITqRYja+guDVI9rZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijo Lazar <lijo.lazar@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0744/2651] drm/amdgpu: Move GC v12.1 spm vmid init to hw init
Date: Wed, 18 Nov 2026 15:33:04 +0100
Message-ID: <20261118150314.665317293@linuxfoundation.org>
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

[ Upstream commit 52a484f3ef5b36c063d8fca7b8763c1a9676c625 ]

GC reset is not released during sw init and hence it shouldn't be
accessed. Move spm vmid programming to hw init phase. This programming
may later be overridden with the job's vmid.

Fixes: ad5f1ee0a9b0 ("drm/amdgpu: Add initial support for gfx v12_1")
Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
index 61f89fcc3407b..0213df54b33a9 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v12_1.c
@@ -216,6 +216,8 @@ static void gfx_v12_1_xcc_update_perf_clk(struct amdgpu_device *adev,
 static int gfx_v12_1_init_cp_compute_microcode_bo(struct amdgpu_device *adev);
 static void gfx_v12_1_xcc_update_medium_grain_clock_gating(
 	struct amdgpu_device *adev, bool enable, int xcc_id, bool force);
+static void gfx_v12_1_update_spm_vmid(struct amdgpu_device *adev, int xcc_id,
+				      struct amdgpu_ring *ring, unsigned vmid);
 
 static void gfx_v12_1_kiq_set_resources(struct amdgpu_ring *kiq_ring,
 					uint64_t queue_mask)
@@ -682,7 +684,7 @@ static void gfx_v12_1_init_rlcg_reg_access_ctrl(struct amdgpu_device *adev)
 static int gfx_v12_1_rlc_init(struct amdgpu_device *adev)
 {
 	const struct cs_section_def *cs_data;
-	int r, i, num_xcc;
+	int r;
 
 	adev->gfx.rlc.cs_data = gfx12_cs_data;
 
@@ -695,13 +697,6 @@ static int gfx_v12_1_rlc_init(struct amdgpu_device *adev)
 			return r;
 	}
 
-	/* init spm vmid with 0xf */
-	num_xcc = NUM_XCC(adev->gfx.xcc_mask);
-	for (i = 0; i < num_xcc; i++) {
-		if (adev->gfx.rlc.funcs->update_spm_vmid)
-			adev->gfx.rlc.funcs->update_spm_vmid(adev, i, NULL, 0xf);
-	}
-
 	return 0;
 }
 
@@ -2054,6 +2049,9 @@ static int gfx_v12_1_xcc_rlc_resume(struct amdgpu_device *adev,
 {
 	int r;
 
+	/* init spm vmid with 0xf */
+	gfx_v12_1_update_spm_vmid(adev, xcc_id, NULL, 0xf);
+
 	if (adev->firmware.load_type == AMDGPU_FW_LOAD_PSP) {
 		gfx_v12_1_xcc_init_csb(adev, xcc_id);
 
-- 
2.53.0



