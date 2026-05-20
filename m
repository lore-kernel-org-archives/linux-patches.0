Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C236A357;
	Wed, 20 May 2026 16:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295268; cv=none; b=hLLEGI+/rGgzbuzxAM2IOzNVMBFNPWZFwwbIGBV4c5yGqSWu6n1SQxg+nW+s2pFXdjM+fr2rcWAwFdeD8m1nDQTgd5TaNd8kWAXEr9VWzOCLS9hKN8lptRT+myMRShEc8hI5wiGqbFP5KWcHAilC4aO/BA/8GvSMZ3aATIVE7ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295268; c=relaxed/simple;
	bh=sdNLlUG0H/IDuuVpJPXTlbC9xApIY/pYdKsUkUm/Gng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtczfxn5WBDrfq85ilcZ0hs7JmNddeXCo+4gyvFyzsyQoJ9H+aduhwSG/+iaE4HeveKcJQIN+XApYqVvidpMntUdIjfE5A+40NnF8ZPeFEUqFsmTfy+L8kVHOi0DgiXUBD7/RgHQ/aTOMJkOni8XXGoxS8LfQ0EUcOxoptHfUl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtUSpDM4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtUSpDM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBD91F000E9;
	Wed, 20 May 2026 16:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295266;
	bh=2mMrGT2DStifiJSwPTQ8buFLAf3ILCLtZUUIC/8Ezew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtUSpDM4m837ItKO1HMIrExhQrmELbha8jPlNBHd3SBVtQb1NXWTGRh51YHgLSbQj
	 QAMUwqlnoi+CdNCX7dga/tRQw70sg5yc4+IHJ9bBBOipKMTJlDgt7WyhDv/8MBcIT+
	 1G8YDjhWXEyt50gWu/VhX+Hxl9FKtAM7iFPCJAHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0355/1146] drm/msm/a6xx: Fix HLSQ register dumping
Date: Wed, 20 May 2026 18:10:05 +0200
Message-ID: <20260520162156.235287483@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robin.clark@oss.qualcomm.com>

[ Upstream commit c289a6db9ba6cb974f0317da142e4f665d589566 ]

Fix the bitfield offset of HLSQ_READ_SEL state-type bitfield.  Otherwise
we are always reading TP state when we wanted SP or HLSQ state.

Reported-by: Connor Abbott <cwabbott0@gmail.com>
Suggested-by: Connor Abbott <cwabbott0@gmail.com>
Fixes: 1707add81551 ("drm/msm/a6xx: Add a6xx gpu state")
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/714236/
Message-ID: <20260325184043.1259312-1-robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
index 2d56fe0a65b7e..72c4bb360acd5 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -1013,7 +1013,7 @@ static void a6xx_get_crashdumper_hlsq_registers(struct msm_gpu *gpu,
 	u64 out = dumper->iova + A6XX_CD_DATA_OFFSET;
 	int i, regcount = 0;
 
-	in += CRASHDUMP_WRITE(in, REG_A6XX_HLSQ_DBG_READ_SEL, regs->val1);
+	in += CRASHDUMP_WRITE(in, REG_A6XX_HLSQ_DBG_READ_SEL, (regs->val1 & 0xff) << 8);
 
 	for (i = 0; i < regs->count; i += 2) {
 		u32 count = RANGE(regs->registers, i);
-- 
2.53.0



