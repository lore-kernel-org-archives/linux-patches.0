Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E5230DEAC;
	Wed, 20 May 2026 18:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302078; cv=none; b=j6JvyybvFmlpoo8Nt3UuGW7SWsl8fgL2gb0Xx93VG2RAK79doO9y2Y6VwA7nRLHAT2ldI225QOfmGAuJ0iKFR8lGJ8vMMcP9dZFDX4OkYw/CBCizREZSyPK8ogP5F6uFAlA2VSQeDKMGrryJtOcCM48hVG3hEAhlBfdous8ETv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302078; c=relaxed/simple;
	bh=YAwN+bPLVaWYy1wHlLNFApIViM6R4JFz8zUWosfBEtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uU56o4OcpEkKz48CP/UXe1+Eh1D+OLdPe9EfeQTrFGUq5e48s8WLIoRM9a+CjdYKlaP0yib15J8rhXjij+DkKCTaN7S8UeGbEnmkv0qZEJe+Q5HQGZEu37P7qybt5VV06IiCLphA8mYylu+gu5RbsmxuwQCp0rK0jjSKSl2ufy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nKfpii2+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nKfpii2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13CFD1F000E9;
	Wed, 20 May 2026 18:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302077;
	bh=SiYm8I4gI6sok+Zmz5vOgR0EEmpCvZtng/2MGDSBY0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nKfpii2+rF+ILFHheNrFEYGLL6GZNDfEzUI5SyO/Q3WsOX0PqfBJSDy7QKXta4N//
	 bnc2mYSf5x0rusTKqmqKY4OQ/7ASx2hAl1jVDQA03zkn5fDChwbV94JSDvqNOA38JW
	 xmPc+MVKPDGssv5P2AkZmEVWVcNy6ixtnjGad99g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/508] drm/msm/a6xx: Fix HLSQ register dumping
Date: Wed, 20 May 2026 18:19:14 +0200
Message-ID: <20260520162101.466250883@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 258de1bfc5700..6ebb7e6254175 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -672,7 +672,7 @@ static void a6xx_get_crashdumper_hlsq_registers(struct msm_gpu *gpu,
 	u64 out = dumper->iova + A6XX_CD_DATA_OFFSET;
 	int i, regcount = 0;
 
-	in += CRASHDUMP_WRITE(in, REG_A6XX_HLSQ_DBG_READ_SEL, regs->val1);
+	in += CRASHDUMP_WRITE(in, REG_A6XX_HLSQ_DBG_READ_SEL, (regs->val1 & 0xff) << 8);
 
 	for (i = 0; i < regs->count; i += 2) {
 		u32 count = RANGE(regs->registers, i);
-- 
2.53.0



