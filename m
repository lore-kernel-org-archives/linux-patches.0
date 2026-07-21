Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B183C434E2C;
	Tue, 21 Jul 2026 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648903; cv=none; b=dEQZ7ei66fYVOMkVWt70IFViOE3sFsloC0dfo3a+ttWm2tyPxe6+f/QbxXjF81V9SmHeFuN11CJ4xRkuH5jR72FO1mIN2fD9caUO0VTVx/5tYvpjAWwdDLlaBg3YbyEzfc5Bdo4NgciGGJNr1nHJGvArbBq/NtpyMISw3LIMROw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648903; c=relaxed/simple;
	bh=WqCMqQ+yrdmoDmPv5PaWzAZavDxm7p6GWI3FzkpC8iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlPaQ3yi0hp3Vz3IUhs9AODpoW9W5Anvm+AjtAkKftVla4QPSUsk4hZOHTB/Wv3Uf3GrCNFlFFUyDa5YYaXzH04gWw4h3qr1fIoeD8UiJKB6X9Xybg6lH8QzYCz1TtbsEkCRXMNJqCjABee5g/l15vrmExG6j97H9k398R0NQ6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCFk3heL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCFk3heL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E3D1F000E9;
	Tue, 21 Jul 2026 15:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648902;
	bh=U4lWV2DhhgmwazWnJMAMs5pXzPYVD2yZ+NwjZ6wIVT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tCFk3heLmNL3oeSNzj5TZldQm+Xui1DSxx5/ail18NPJH5aoLOzl7Pda0Cskg+RH5
	 d/WDifoL+XzmPIffJ/Ngt+x0ncfSWWc49Ir/ewuYiclgmT2NL38QS436LlW8ruC/xS
	 OTKuBFEsV6CwvZsSwZKb8uDYUmdw9XClzTOepRUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0376/2077] drm/msm/a8xx: Fix RSCC offset
Date: Tue, 21 Jul 2026 17:00:49 +0200
Message-ID: <20260721152601.559537224@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit 586a34dafc08c4fa68d1b4673de24cd84d09df05 ]

In A8xx, the RSCC block is part of GPU's register space. Update the
virtual base address of rscc to point to the correct address.

Fixes: 50e8a557d8d3 ("drm/msm/a8xx: Add support for A8x GMU")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/727117/
Message-ID: <20260522-glymur-gpu-dt-v5-1-562c406b210c@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 1b44b9e21ad868..cab4c46c6cf2ea 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -2357,7 +2357,12 @@ int a6xx_gmu_init(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 			goto err_mmio;
 		}
 	} else if (adreno_is_a8xx(adreno_gpu)) {
-		gmu->rscc = gmu->mmio + 0x19000;
+		/*
+		 * On a8xx , RSCC lives at GPU base + 0x50000, which falls
+		 * inside the GPU's kgsl_3d0_reg_memory range rather than the
+		 * GMU's.
+		 */
+		gmu->rscc = gpu->mmio + 0x50000;
 	} else {
 		gmu->rscc = gmu->mmio + 0x23000;
 	}
-- 
2.53.0



