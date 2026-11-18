Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017507;
	b=0K8ujtbeM9VLVFR4JQMAGcMEGqdCVA963yaW+gQlOgaijBsi52kY9wXFfSi94hEvjfoI
	 C4Z3zAX/mupS4+r2Murrdt2y8FyUe9n/SfT/06Ch2JyBIwapWOD0JBQHT5+PNbnINnczs
	 qoJe6kBHjZLrwsrAqSK+Oj27Vj59oPgapCSAlhIIUQL75pSaliaC6msB4IzJPnB1Gy7TW
	 JltGLX7HFUWa4NiGMertLeHKjVT/SOhcDtwD6L9l40Qa4pRX4Jcd34MWHlwU/8IUQgipI
	 KB8YxcFu7q4KHrLDToHJ7SBj2gZeFENmPrIAHaQAH2jWf6J7Z6ZqGS2++3roO8ppAyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017507;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pw9UZGi5w3SRYsERx2vPy+6y0ZNJzmh5S+7IUz3Op3A=;
	b=APC5xO2DI/yjR3Npr/lnyLdX/aMxsOQcCKDSxDB6zoNH4qlUhz9Oj3asixDYBATeYQl7
	 PWRTwMHwg8tgS22D4O6OAFA0B0AOC3W5BjeH3ORWHIG9BwvyF1MhnDGQ39G99WdLQAJ0T
	 UkcN0L7aAsMjb2qUjH4cnucMbPt102n2d54MkHqXMef1R9AdPHp38wTu2TuiBuNMO7Dtz
	 3hqVhbMZ4OznUxsdRYVC0vznMBkPANlLUmiGjG41xON+CeYcVHgbql84vj/RLJ5BXsmYT
	 MZ1nZt0G4oy6az+Kld2sBSbTAXDHkjBNr5ZsKdzkqbwGvgUMs6qiI0VoSH5fmFVP2pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=naRQzV80;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C559B60A2604;
	Wed, 18 Nov 2026 15:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=naRQzV80
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D52B1F000C7;
	Wed, 18 Nov 2026 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017507;
	bh=pw9UZGi5w3SRYsERx2vPy+6y0ZNJzmh5S+7IUz3Op3A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=naRQzV809dTCw1xsQKdei8Yhr5Al42EHAXeBSdnevYwdZxORcd61VdxJuoGJVB7LM
	 +dc0YAA8FUMSd7+4rekTjNVXfmADxf6uaU0llqk3asbCCVeRXh13TXhWd14q8wOdj8
	 fPsAWC+r3wjmmYFsLxTyA2pQZ7gC65B9Mmbfs/PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0907/2651] drm/msm/a6xx: Honor perfmode_bw threshold on A8x
Date: Wed, 18 Nov 2026 15:35:47 +0100
Message-ID: <20261118150320.530627155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit db6a2e4a7ebd4378d03a97f4bef22f8c157240ad ]

Instead of voting ACV for all bw corners for A8x GPU, restrict it to BW
votes above the perfmode_bw threshold, similar to the A7x GPUs.

Fixes: 288a93200892 ("drm/msm/adreno: Introduce A8x GPU Support")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/755589/
Message-ID: <20260923-hawi-gpu-v1-1-0c3c79a1a470@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c   | 8 ++++++--
 drivers/gpu/drm/msm/adreno/adreno_gpu.h | 5 +++++
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 6d49c51df1a27..baf77a6205724 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1656,8 +1656,12 @@ static int a6xx_gmu_rpmh_bw_votes_init(struct adreno_gpu *adreno_gpu,
 			if (bcm->fixed) {
 				u32 perfmode = 0;
 
-				/* GMU on A6xx votes perfmode on all valid bandwidth */
-				if (!adreno_is_a7xx(adreno_gpu) ||
+				/*
+				 * GMU on A6xx votes perfmode on all valid
+				 * bandwidth. A7xx and A8xx only vote perfmode
+				 * above the perfmode_bw threshold.
+				 */
+				if (adreno_is_a6xx(adreno_gpu) ||
 				    (bcm->perfmode_bw && bw >= bcm->perfmode_bw))
 					perfmode = bcm->perfmode;
 
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.h b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
index 114a40f79ef3a..bd5c440f1753f 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.h
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.h
@@ -580,6 +580,11 @@ static inline int adreno_is_a750_family(struct adreno_gpu *gpu)
 	return gpu->info->family == ADRENO_7XX_GEN3;
 }
 
+static inline int adreno_is_a6xx(struct adreno_gpu *gpu)
+{
+	return (gpu->info->family >= ADRENO_6XX_GEN1) && (gpu->info->family < ADRENO_7XX_GEN1);
+}
+
 static inline int adreno_is_a7xx(struct adreno_gpu *gpu)
 {
 	/* Update with non-fake (i.e. non-A702) Gen 7 GPUs */
-- 
2.53.0



