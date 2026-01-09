Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33B52FD699;
	Fri,  9 Jan 2026 12:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961050; cv=none; b=TPDQ/iQmOQFb94e1cdRf1lj5B4L6i/c/3rjTvTJo/wDjizfHIaHZhvmp71KboLzKul5OOh7vDukSaloWJvZkHwxsrQxtNfYX1ik99hNj8RLTXl8CF2mnQ6Ka0iwXh5fI/gp77Ef2iIshEMCWrmsmWosulXpfb6iah87xL7SS+eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961050; c=relaxed/simple;
	bh=4oEAy41KD23830qeiI23R/B7JI8etF85ru0y58teaKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rr8ERw92ix6/eFLoOz7+c9vBabk47zKtV9stb6+N617TD/wqSsCSriwXToRplIz3/e6pWxcgynb+BspTz9b6Fmi2C8KGJdNsseDm5dd+Jh5y+cfUUy/Gf1crF/XW0CmHaKiF4ICPAAxSVOosW8iMYcyLPeC4/atUlazcO7RRazo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gn8EKkk5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gn8EKkk5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CA6C4CEF1;
	Fri,  9 Jan 2026 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961050;
	bh=4oEAy41KD23830qeiI23R/B7JI8etF85ru0y58teaKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gn8EKkk5i8jAc0i2noVO7WyPU32gJSM2a3vvCqm7G2kQlGcb18OXRc1VFbLrgd2Br
	 RtA9mJKlmRa6i5zE1u6Ep1pR2qnRffZOLpoU21BATbpQiEZQ9KFbk3jOlrVUV9R6j1
	 AlA1vQAQLeHYKA1i8NfXGkxf3qyjBCbcsbhqeN9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.6 618/737] drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers
Date: Fri,  9 Jan 2026 12:42:37 +0100
Message-ID: <20260109112157.250899735@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -834,7 +834,7 @@ static void a6xx_get_gmu_registers(struc
 		return;
 
 	/* Set the fence to ALLOW mode so we can access the registers */
-	gpu_write(gpu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
+	gmu_write(&a6xx_gpu->gmu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
 
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[2],
 		&a6xx_state->gmu_registers[2], false);


