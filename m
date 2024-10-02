Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050861D0BAD;
	Wed,  2 Oct 2024 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877858; cv=none; b=l4e74fXadIdzg/zFddkdrpty89QAFwY7X8uCWCFJwShUW3JHQG29Ia0o096tCIhDnMiBE9yu5emcsxXeQZ9Bk125UBNmRcVD8lNMgyuMzo2aTWRZh5cRfteOlOcqaQhQF1ZVnX+DdjhP7Mq9vwC3/tFLxxP/VbagF1Ns9aNutrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877858; c=relaxed/simple;
	bh=n4MlK78gSdXGXeiCDVj3RCwOx8orc2KsECfSCbBd0+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA5Rx0HEvCdWFPKeJGjJ0p+6ix+Xr3kuZZeXhBEI6jFcK4Tof2/3ARppnJXFfypluIKmSy4l+HNXdRXd28LRLfgFwaaI5RDlMn3wejc5qy+hzGjf4rh6SO9E52d0WNlaygAGVUj86vrh9AEtkQyABSecxLEDaCv8hL8qAXKFK+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o0IEAZcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o0IEAZcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CBAAC4CEC2;
	Wed,  2 Oct 2024 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877857;
	bh=n4MlK78gSdXGXeiCDVj3RCwOx8orc2KsECfSCbBd0+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o0IEAZcs2PbWJYIr+urb/pJ8ve848cQXzKRUSM0hbtOOTM3AEI5WfN+QZSbisjp5/
	 Dz9Xcbmtat+dbtEo0airRF+PHIzwXc+b3SttY+TU94jdgrVb3VLC8mlLrZxzGDS3ww
	 +CvahBhgzmFyi7fvzCFx1ZdpUkpoo7VZZ+krS2x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 201/634] drm/msm: Fix CP_BV_DRAW_STATE_ADDR name
Date: Wed,  2 Oct 2024 14:55:01 +0200
Message-ID: <20241002125819.040478085@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit a47cfb688d78217983c4a0051449aa88e2ff5ebb ]

This was missed because we weren't using the a750-specific indexed regs.

Fixes: f3f8207d8aed ("drm/msm: Add devcoredump support for a750")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/607394/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gen7_9_0_snapshot.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gen7_9_0_snapshot.h b/drivers/gpu/drm/msm/adreno/adreno_gen7_9_0_snapshot.h
index 260d66eccfecb..9a327d543f27d 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gen7_9_0_snapshot.h
+++ b/drivers/gpu/drm/msm/adreno/adreno_gen7_9_0_snapshot.h
@@ -1303,7 +1303,7 @@ static struct a6xx_indexed_registers gen7_9_0_cp_indexed_reg_list[] = {
 		REG_A6XX_CP_ROQ_DBG_DATA, 0x00800},
 	{ "CP_UCODE_DBG_DATA", REG_A6XX_CP_SQE_UCODE_DBG_ADDR,
 		REG_A6XX_CP_SQE_UCODE_DBG_DATA, 0x08000},
-	{ "CP_BV_SQE_STAT_ADDR", REG_A7XX_CP_BV_DRAW_STATE_ADDR,
+	{ "CP_BV_DRAW_STATE_ADDR", REG_A7XX_CP_BV_DRAW_STATE_ADDR,
 		REG_A7XX_CP_BV_DRAW_STATE_DATA, 0x00200},
 	{ "CP_BV_ROQ_DBG_ADDR", REG_A7XX_CP_BV_ROQ_DBG_ADDR,
 		REG_A7XX_CP_BV_ROQ_DBG_DATA, 0x00800},
-- 
2.43.0



