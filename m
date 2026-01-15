Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF433C1FE7;
	Thu, 15 Jan 2026 17:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499752; cv=none; b=ZlUSNTO6RhKykHhtpR3iUplnkY1XVdn/lMf9xLgXyKmCHmiM1FHJIucTugP4UpnAMBXim9H44x07zaAsFVILFLgwAmgwcjHUpeVgK6vvJh9sRqcwEpG66mXAdHGNjZ0SuSp5ftZatiK7DYHcG5PMDXlgjLoFrJ9j4AN/9COLR9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499752; c=relaxed/simple;
	bh=eUSknsXitKnfacu+trzE5DYjr3yT5MQFwnWNeMBXcI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK9yEKUvZfGxnRfagDUyAZdNX3NkGlLqI/AbhkD+KLPngjQx/K5Ef7WHAaN5PW5q2RRzME7HU3//VQpu8J6h2JwPvsdhA0Qgk5LD/IuzHq1Gm6pYVYrZePk0vLdnxl72E5lR44CGEWZstbo9I+8msZ9IxEgOgzmY1pXWmfhRnvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U8OU8u4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U8OU8u4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0361C116D0;
	Thu, 15 Jan 2026 17:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499752;
	bh=eUSknsXitKnfacu+trzE5DYjr3yT5MQFwnWNeMBXcI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=U8OU8u4QFtHyMwlHlXiZ//0ovM7iV0ifKWxUP8zAaZKlORHHVdXm+k19utowwt97K
	 6fGVLcMQlEt19UBw+8FTV8ln5XAdnze7T5/XAFAW8W0/ewILLQbS9JEC/j+SzeSaDn
	 GTuZRuQtITnHiBQzg6rp6L2h2n/4sGRxFByvUKQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 5.10 336/451] drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers
Date: Thu, 15 Jan 2026 17:48:57 +0100
Message-ID: <20260115164243.049951392@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


