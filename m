Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060774;
	b=05YOHBUtONHCSi7BOU4F+Ud9xHDtk4Q3m6XLaPnCAYu3HbGk60BO2UrHFyMUsU+j87Kd
	 CDEcjsTm8A+q1RdX8T50k8tOu3Ji2VfXGasRDTcDJtm41xOnKHNfXyPGJXi01DDsrkDDF
	 FU0b5+hi09IklYRkdVuS1s/UNwPEoaZRbes2MRANgFYWRCkvDrfG7tg1u7QLezzXbs+f3
	 vO5v+yCr6LKgrGhqd7AnRMVO77OuMRwPP6n0+zwhizfzI+A7FGWYlMyf063jHq59B4Dtt
	 nbmw7GNU3gdEHYmMHdpcZDHAIlaTlrpvvaoMcjJU1N22ZS+P2Iu72Bn70i7PQ4MIVsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mcBGxJdzelyhYfw1PBKSKVGgIy4fMVjJZfnDye5grjE=;
	b=ljieeHMp3ZECzw+3d54TK+2GEtMOuSEk8dZ0Xy44ppFK2BnCx7ERM0YZ+Fz+Qlek5KYf
	 Fz7+VRoZKsDQ+2U0vK80z1dnBP7B5GG8Gi0FuAHvWLshdnDl5R5xGlLigdtzOFImDjs7U
	 UBV/Fv0bFROPkOOA8BR+ZfxK7MePvDDbyutZWxtyljM9agwEkvA1CSBmcDxFODt138dDm
	 PYWdySVkCV4Wd67PJhXxvHzURBsZeGctyNSxMOEH/RGfwGAqjl0R5aD/R5gDzJBeTIrmw
	 YyoKYJ+sCS+ZLgmUG9ASY0C+hTxdreau8aRRau0lxoL5p91bEaH0+oN8o/EkHAAxj3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAMI4I+d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A639606A326;
	Sat,  7 Nov 2026 14:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kAMI4I+d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344E11F0089F;
	Sat,  7 Nov 2026 14:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060774;
	bh=mcBGxJdzelyhYfw1PBKSKVGgIy4fMVjJZfnDye5grjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAMI4I+dUYra69W2NQbhGy/f3AExpddyw2PboWJFls9r13tXuW9c7rjWmTr6iRyzc
	 JX7Mr5bg9b6ymAG9FQVR1gwTZkUKQWyiRyNVznja/v4IJbJBAgJGKOCRE+PifqMjx0
	 MjdekRlC+xsXWYJwQu/HcKoMdhMUaJkmmfXpOlrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aditya Sherawat <asherawa@qti.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0165/1536] drm/msm/adreno: Add support for A704 GPU
Date: Sat,  7 Nov 2026 08:36:21 -0500
Message-ID: <20261107135002.302785134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aditya Sherawat <asherawa@qti.qualcomm.com>

[ Upstream commit 1f69339da06255a7f8560b4768fff83992c03deb ]

Adreno A704 GPU found in Shikra is an IP reuse of A702 GPU with very
minimal changes. The only KMD facing difference is the chipid and the
zap firmware which is specified via devicetree.

Just add the new chipid to enable support for A704 GPU in Shikra.

Signed-off-by: Aditya Sherawat <asherawa@qti.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/738931/
Message-ID: <20260710-shikra-gpu-v6-1-b388ec5dce77@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_catalog.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
index 8bb23012994c6..829fb746645a8 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_catalog.c
@@ -1281,7 +1281,7 @@ DECLARE_ADRENO_PROTECT(a730_protect, 48);
 
 static const struct adreno_info a7xx_gpus[] = {
 	{
-		.chip_ids = ADRENO_CHIP_IDS(0x07000200),
+		.chip_ids = ADRENO_CHIP_IDS(0x07000200, 0x07000400),
 		.family = ADRENO_6XX_GEN1, /* NOT a mistake! */
 		.fw = {
 			[ADRENO_FW_SQE] = "a702_sqe.fw",
-- 
2.53.0



