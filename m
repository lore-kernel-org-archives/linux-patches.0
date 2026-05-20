Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E248331220;
	Wed, 20 May 2026 17:27:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298079; cv=none; b=S7ROHGJCnWolioQr7VMI0Ek9pGH2gG4FLPB8DWFpW3SWzePPYyfFeu1X9tFabbFhvx+wgeiB60bUhWYof4t6GYHNEMt/xAZKV0Fnjm+EA1ejL2VFBikP+15U/UCeZood5Iuytipw6F2BnI3W70Eq+Cqjz1W4+j90HylCXmamyoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298079; c=relaxed/simple;
	bh=VITqL5UQLaMUfHsrE5A9NtawQTdkXipG5bhbgoHfR8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uVUvXNT5fjwEP5AaERD1Ei7XWnw1U6jBrNU+IBn+doKy5IHCs80CSr1kDhKwFMSv+VP3thuMY0REBGfU9dSb4eTrgxjeoPkNG4DhC5bQgAofUoCiBS9LVbo04ahOwmcjha2dmZvQZcHaA5ohExrTjRjv12gm3PgZtskEN3637hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ptMiTnQp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ptMiTnQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FFF1F00893;
	Wed, 20 May 2026 17:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298078;
	bh=gxzsy01aQ0V67MHIk1Dwi+BhqI3z7xGNVFUh1Av3JXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ptMiTnQpPenBOPYzFQjOZ23xsf4f/Qwh0/1J+Vs2/uVi1oz4FcT5qh9zjWg+uUdSl
	 JPuRsNidSZPnVImeSj1dRb4v6AtUEPQeXA8d4PufCsjBTo+DXERSolSXkJ8iWqtMii
	 7W6ovWjEj17dWfMEDJ5wMVetvagLVmtbSIINIoyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 275/957] drm/msm/a6xx: Fix HLSQ register dumping
Date: Wed, 20 May 2026 18:12:38 +0200
Message-ID: <20260520162140.506556320@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 9cec333e23e15..def021ba19299 100644
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



