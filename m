Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025010;
	b=fle33+mUEX6fXNvsV3K2G3nWWnuhaglpxHb4XIfBAovyo50rxDDweXcWgowYNO4AhuaR
	 QvQFpW348xPt/2B1iLZu3SS1l68FQdJpaIedZ6zb088egMhWxF3RkySDABYdCJWVvJMr9
	 I6b/byMO66KCkjThOgcmZNNhLb/xkwVmjyMBS4VFfGGWKnOGPpxJNclq56Fou1PfTwHJ0
	 2nNpb2yR6VAhTgFPOdt8VSnm9ZVUoGfurLsfhpIuaM0oUK9KhKe7+aApfwmrtqjhXN1Pd
	 PsbDqqaFRk2o0QxybEMNKV8COIl1PWfLoACovMSQMtBcRFK0azTOwd29cdh7/vx1S7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025010;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=otmkUwM+bD939Odxn/9YXnQapyk079c+VbqmbyuejVo=;
	b=V/2jBYroQOeU3PFOzafyllT61facL4W9lp1k9gA4fKKs3zbTAoFZUX3DBKEI/Rt0wgfC
	 xkATNMUh3BchRWhP19FCPR+EVr0A2BHk4luQo8f2QCNLdUeLolPZSTgpXR67gC4vUdqGP
	 eWGtXlU8etfr/FkrgTpPnx0rqp5vF8m2js8EIoaCai2IYGF68ZlLbgTqjy4CCM9SImqt5
	 USUFnrDwTNe4CDOv6q08KcHKKk1pSQSq66BjSlW2bmw0TGCGHOVZFMTYuS/xfHqgzBx9a
	 uL9IahMXHQ0UHtxYXn3gL0tFxAgvq6hLKzOckcZMTDevcuZSPJdPVj+D2ZBhYJ5w0mw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qmh1Z9Vb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8AE9606A325;
	Wed, 18 Nov 2026 18:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qmh1Z9Vb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359921F000C4;
	Wed, 18 Nov 2026 18:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025010;
	bh=otmkUwM+bD939Odxn/9YXnQapyk079c+VbqmbyuejVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qmh1Z9VbkPq0WNHpqlTMJRRyeZZsVTQY6Iv06zZqkbyRECwb0uwqQbVI3pMuLf6w6
	 mSIoG3K0Wl/5XOZ8C1CD8L4OjPvkhN8B2CE7vMEjgVaOnK7pSMXJqSFRUxQs5EErpN
	 /Ftii9M6ClmyNYa6Z2nIwUjR8P/wkpPnskGgHfwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0913/2151] drm/msm: Properly handle msm_ioremap() without name
Date: Wed, 18 Nov 2026 15:44:08 +0100
Message-ID: <20261118150155.649014040@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a6efe1eac2712..99221b0d7e3f0 100644
--- a/drivers/gpu/drm/msm/msm_io_utils.c
+++ b/drivers/gpu/drm/msm/msm_io_utils.c
@@ -77,7 +77,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
 
 	if (!res) {
 		if (!quiet)
-			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n", name);
+			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n",
+				      (name ?: "#0"));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -86,7 +87,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
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



