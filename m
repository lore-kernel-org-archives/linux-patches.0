Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040513;
	b=CPZvCWm+LItMBG0GF5YO2viJfH/lEtAEjuSDOtCcKoT10zscx5h0WvVFwnrSLgL7vSNp
	 rLxFKydsCLh0t8x1crbgToRGrJTPb/T8hcGSaj8XfT+b/AlZXs3sG9mECYtQ5Z+IJPnvn
	 OcBg3JLKgkelckoBaZ3+1tpjtAPDGTiR/+NNLuCHf4xYcmjZkkt90/+ljANI1UCOMDDiQ
	 +znoiaX/fbEI6ThKkyUIk3I+Sc/fwrsjWPXuWNrW7XFmY3IPRl+j0Ym+hSU5N9fHEGFsT
	 nCK3H2RyNvuF4lZNlHebqlNvFB7OFBPsa1gqZtzqdv1OKiL9HHkVNEv6Avukaur7ifg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dsU7ZN7QAV2eJlfZTVItBYcf4lahM3DnYtQej+npT8I=;
	b=1Czgnw8R26EKrlttGnURhtlxyPOMPwdACyYjNlYOiqYoDPqhE0eTTiuOxshfHIhdFxcF
	 oepLYkyWVwhT7SGKOSNlbT0iEV0B3UOgQqDIeHvJM9+2b3GAaARQdo5ezTActpH9+rAmN
	 Q168H7016A65T/G9HrK1yfYemFOJqPsGsMGeelIOTH+dILYbC6wgjAn5T4eRpav2dyx38
	 IGTFjdwr2UYZPExlNyHtMF9KSSp7kq052xvXst6KCr3Is9So1GtKaPHZU+juq2pyDf5gD
	 Zv0klMivsD6wfG8ESxg8nsC13Tgo3SKBf/q2nTckOsGqp3cj/UWYs+JoR2aGEYrxhNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kx7bimlm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F047606A320;
	Wed, 18 Nov 2026 22:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kx7bimlm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECFE1F000C4;
	Wed, 18 Nov 2026 22:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040513;
	bh=dsU7ZN7QAV2eJlfZTVItBYcf4lahM3DnYtQej+npT8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kx7bimlme9+poGO2B+I4Lubv6yqsU7VKwWv/uigrptHWjaToYSx6M1DF28VnUOqn/
	 E1KqURcyQsE7/vUchfdu/PFTXOHYDC6qQ1IDZWLxbRllVkW0scP1du1bJFF2jJw7Qe
	 nDj8oRfmrWadONMDkrgbfm0qtn++tBDkcL8cQPhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2483/3318] drm/msm: Properly handle msm_ioremap() without name
Date: Wed, 18 Nov 2026 15:51:45 +0100
Message-ID: <20261118150435.897061213@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 14fe0ea79e0e25efc603f6f4bc81cb5b813f0e69 ]

msm_ioremap() accepts being called without name of the region to map and
in such case maps by index 0.  However error paths still use the name in
error message.

Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: c8afe684c95c ("drm/msm: basic KMS driver for snapdragon")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752660/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-5-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_io_utils.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/msm_io_utils.c b/drivers/gpu/drm/msm/msm_io_utils.c
index 59d2788c45104..aa8b6971cb801 100644
--- a/drivers/gpu/drm/msm/msm_io_utils.c
+++ b/drivers/gpu/drm/msm/msm_io_utils.c
@@ -64,7 +64,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
 
 	if (!res) {
 		if (!quiet)
-			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n", name);
+			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n",
+				      (name ?: "#0"));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -73,7 +74,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
 	ptr = devm_ioremap(&pdev->dev, res->start, size);
 	if (!ptr) {
 		if (!quiet)
-			DRM_DEV_ERROR(&pdev->dev, "failed to ioremap: %s\n", name);
+			DRM_DEV_ERROR(&pdev->dev, "failed to ioremap: %s\n",
+				      (name ?: "#0"));
 		return ERR_PTR(-ENOMEM);
 	}
 
-- 
2.53.0



