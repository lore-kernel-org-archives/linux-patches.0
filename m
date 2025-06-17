Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DAF20B807;
	Tue, 17 Jun 2025 16:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178938; cv=none; b=O6wVVwm4IZvqjGH9j35neu5TRVGh8UO/1XutgI9RdU+tujGYNGZ8688FPg5HIwfl8pAzntxr7omvBJoLgoqBPCiJrLjqqdc8v8UCTeyFvXCnRGkspSO5XeTgJjRiS2GsB/ySAf5UOxj3vLnJfrDSXGYkQYCunU6uDsvDLAaW1wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178938; c=relaxed/simple;
	bh=y1W0ikrlABQQE9GrUAZoY5CFFon2lNfBRBwYiEcNezk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gzr8wOv67F6KEpwdZA7g4W+1BlnlTBOfOt1vyA63vAfi9TU7F9WZT63uJkwYzjCb1HK0y6ng9l2J0PNvSqdiVRnepcJbfwbFZxBL8cQH8uWkVA2wmY+xBhGi/ZwE2EpzoabRmrjiZqt0lsbHBcNgHxaITJdWjX7k/rxxrE2dspk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lqe4xPhs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lqe4xPhs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E773C4CEE3;
	Tue, 17 Jun 2025 16:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178938;
	bh=y1W0ikrlABQQE9GrUAZoY5CFFon2lNfBRBwYiEcNezk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lqe4xPhsqFBmdrPJXDKq6JP5WXgBm9OJqravrALWw8NVmXzmbDbkB4rj2VzuM/RUb
	 zIY6936t22P8zc94CtzvHzGBOrWTiHIGSmWNLdt+mmXvVw7+V8ojBaoIulVSb7+eb5
	 P7fpF2ZcmEiK+yNyrDlC/Qe0todhtqlOgjEhSmMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Manu Rastogi <manu.rastogi@amd.com>,
	Vitaly Prosyak <vitaly.prosyak@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 598/780] drm/amdgpu/gfx10: Refine Cleaner Shader for GFX10.1.10
Date: Tue, 17 Jun 2025 17:25:06 +0200
Message-ID: <20250617152515.837687414@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Vitaly Prosyak <vitaly.prosyak@amd.com>

[ Upstream commit d26625d034fb8d596f0488472969493fa02d03f3 ]

This patch updates the cleaner shader, which is responsible for
initializing GPU resources such as Local Data Share (LDS), Vector
General Purpose Registers (VGPRs), and Scalar General Purpose Registers
(SGPRs). Changes include adjustments to register clearing and shader
configuration.

- Updated GPU resource initialization addresses in the cleaner shader
  from `be803080` to `be803000`.
- Simplified the logic in the SGPR clearing section, ensuring all SGPRs
  are set to zero.

Fixes: 25961bad9212 ("drm/amdgpu/gfx10: Add cleaner shader for GFX10.1.10")
Cc: Christian König <christian.koenig@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Manu Rastogi <manu.rastogi@amd.com>
Signed-off-by: Vitaly Prosyak <vitaly.prosyak@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h   |  6 +++---
 .../drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm  | 13 ++++++-------
 2 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h
index 5255378af53c0..f67569ccf9f60 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0_cleaner_shader.h
@@ -43,9 +43,9 @@ static const u32 gfx_10_1_10_cleaner_shader_hex[] = {
 	0xd70f6a01, 0x000202ff,
 	0x00000400, 0x80828102,
 	0xbf84fff7, 0xbefc03ff,
-	0x00000068, 0xbe803080,
-	0xbe813080, 0xbe823080,
-	0xbe833080, 0x80fc847c,
+	0x00000068, 0xbe803000,
+	0xbe813000, 0xbe823000,
+	0xbe833000, 0x80fc847c,
 	0xbf84fffa, 0xbeea0480,
 	0xbeec0480, 0xbeee0480,
 	0xbef00480, 0xbef20480,
diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm b/drivers/gpu/drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm
index 9ba3359253c95..54f7ed9e2801c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_1_10_cleaner_shader.asm
@@ -40,7 +40,6 @@ shader main
   type(CS)
   wave_size(32)
 // Note: original source code from SQ team
-
 //
 // Create 32 waves in a threadgroup (CS waves)
 // Each allocates 64 VGPRs
@@ -71,8 +70,8 @@ label_0005:
   s_sub_u32     s2, s2, 8
   s_cbranch_scc0  label_0005
   //
-  s_mov_b32     s2, 0x80000000                     // Bit31 is first_wave
-  s_and_b32     s2, s2, s0                                  // sgpr0 has tg_size (first_wave) term as in ucode only COMPUTE_PGM_RSRC2.tg_size_en is set
+  s_mov_b32     s2, 0x80000000                       // Bit31 is first_wave
+  s_and_b32     s2, s2, s1                           // sgpr0 has tg_size (first_wave) term as in ucode only COMPUTE_PGM_RSRC2.tg_size_en is set
   s_cbranch_scc0  label_0023                         // Clean LDS if its first wave of ThreadGroup/WorkGroup
   // CLEAR LDS
   //
@@ -99,10 +98,10 @@ label_001F:
 label_0023:
   s_mov_b32     m0, 0x00000068  // Loop 108/4=27 times  (loop unrolled for performance)
 label_sgpr_loop:
-  s_movreld_b32     s0, 0
-  s_movreld_b32     s1, 0
-  s_movreld_b32     s2, 0
-  s_movreld_b32     s3, 0
+  s_movreld_b32     s0, s0
+  s_movreld_b32     s1, s0
+  s_movreld_b32     s2, s0
+  s_movreld_b32     s3, s0
   s_sub_u32         m0, m0, 4
   s_cbranch_scc0  label_sgpr_loop
 
-- 
2.39.5



