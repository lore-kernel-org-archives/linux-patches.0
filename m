Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B361922D9F7;
	Thu, 15 Jan 2026 17:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498374; cv=none; b=rx+Yb/Q7tWlxhWydtAUbv5D3zhTeZhDDuHlpIWK7H4GtRaiH7ApKFQihrenJYqe1il8m1QsJjNgOB7Nfsr1b7Liz/eojOK+G2Yrj/xO1Wk0HObL0lQLOR3FkN/strN62X2Ok9c5zgmheMXrLq4g4DHHhPYvZqvzlpqcPXl8HNJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498374; c=relaxed/simple;
	bh=Zvo3UaY0UqNTizXHlSH7MyjnNGP4dY4NGU2+A1Opi9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFCCDO9cN2CesAXKxOqgMM3NMqBaunhPDc/fI3FvRSqRjmtKiy9qpHbOaSBTnEGMiSXjN4W6khLEnlCC7+bB7I+wHazzGCGwqjZM/CU2StEyA+1id6/R269y0C6J+KrNR1ShnGr7Mws6o/mv0UIUkja9st11zP60F/+mCLeXa9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNiz3kwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNiz3kwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A798C116D0;
	Thu, 15 Jan 2026 17:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498374;
	bh=Zvo3UaY0UqNTizXHlSH7MyjnNGP4dY4NGU2+A1Opi9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNiz3kwMqYzo8fuHWQLzT4sxsizMvot0n/omScZG4UZ0L59DvDl86h+h4UxURwu+q
	 P4dbX8Wui07/r46VhGmePIfNyIEsGU+ZuzxyyKlfUvD4tzXP+8P+I2MhPe0DmBWT8e
	 YUFPHq98Lt7pccExHZ5UwFI6x9SY1WcabbqwsFBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 5.15 409/554] drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers
Date: Thu, 15 Jan 2026 17:47:55 +0100
Message-ID: <20260115164301.036617967@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

commit 779b68a5bf2764c8ed3aa800e41ba0d5d007e1e7 upstream.

REG_A6XX_GMU_AO_AHB_FENCE_CTRL register falls under GMU's register
range. So, use gmu_write() routines to write to this register.

Fixes: 1707add81551 ("drm/msm/a6xx: Add a6xx gpu state")
Cc: stable@vger.kernel.org
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/688993/
Message-ID: <20251118-kaana-gpu-support-v4-1-86eeb8e93fb6@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu_state.c
@@ -794,7 +794,7 @@ static void a6xx_get_gmu_registers(struc
 		return;
 
 	/* Set the fence to ALLOW mode so we can access the registers */
-	gpu_write(gpu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
+	gmu_write(&a6xx_gpu->gmu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
 
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[2],
 		&a6xx_state->gmu_registers[2], false);


