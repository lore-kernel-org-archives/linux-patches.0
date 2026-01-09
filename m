Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EFC15ADB4;
	Fri,  9 Jan 2026 12:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962835; cv=none; b=oWPbRAmtXHZoLHRCaHa4qEBaH5qmUo9kQjwL5Qw7xTxyZhyYqBmzQCeL1/qVTs6qAVC3VrMVg7mJipYja5ZPuSMe731+7FJjnm4RTPbV1E0Rw+sJmkBAx6ZXSQLyMNgWMIQa1y1bNVebjM0SBfodDhe5pzuOHC1pGjJCH7jlYC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962835; c=relaxed/simple;
	bh=0vqjeH9O4QXUIj2WFVU4qItS0Ovtz8LAkvNr+60b2Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tGdBVzKSqhJCrmkucUIoKNzbO6FBLXnHjMbs5LyrwYPDiwqL9SW+kMLquUFyGPicF9RtrYaYJuUAZ5SCeMxcf9Db4p+LjREbS/E1/wiRURScC5/n5GDh/F6oFIz1JZtrEh6tqYh8yF1K1EpZSLzjQ0DNyJnvU94QQ0QGCU9rtHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UiAevl/E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UiAevl/E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07E0C4CEF1;
	Fri,  9 Jan 2026 12:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962835;
	bh=0vqjeH9O4QXUIj2WFVU4qItS0Ovtz8LAkvNr+60b2Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UiAevl/E2BpyF2+fBCddFFQJlPNrwoMFmhQqEQz8GQJO3MKocT9BO0ajoHU8ZjSp2
	 1OLffMo+L5Xagwb3v0RKOYIJkI38IyPBQ7nb4NUYR/Ru5KoueaErDKNhFKQ4IQHoZW
	 XfCYxYHfQoakO/IyL//EhbPj7svr0ImUBHr4EZ20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: [PATCH 6.1 505/634] drm/msm/a6xx: Fix out of bound IO access in a6xx_get_gmu_registers
Date: Fri,  9 Jan 2026 12:43:03 +0100
Message-ID: <20260109112136.555117347@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -801,7 +801,7 @@ static void a6xx_get_gmu_registers(struc
 		return;
 
 	/* Set the fence to ALLOW mode so we can access the registers */
-	gpu_write(gpu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
+	gmu_write(&a6xx_gpu->gmu, REG_A6XX_GMU_AO_AHB_FENCE_CTRL, 0);
 
 	_a6xx_get_gmu_registers(gpu, a6xx_state, &a6xx_gmu_reglist[2],
 		&a6xx_state->gmu_registers[2], false);


