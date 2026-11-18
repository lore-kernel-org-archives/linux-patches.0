Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048888;
	b=aMCE1uqibIX/vCLM90uMZfMpTldGSG6nCXmRO6HudOt3kLT5DZN5FA+JzTbk9mHLika/
	 zEWVbIqBJ7pCCdqjSpIXY2mTJlbFwXWWGp+3XuQLkzxE9IR1nnSCWPIuvQ8CDtlA6oSzf
	 46SEBr/PSEKcisp29MqKID68rSIC8g+Sc9nF75jxTJkjUzxcz4TxkZEQwlkhjUNcOg0RZ
	 cRmLBga/gSzaE/SWfBP6Nhd5Zz40FBlGHY1pY/+DoZC6IYvT2/7/LvPkg89kEsJXW+SlV
	 4R/jKQey4pSwwhdxAVpPgHKx6gPL1HcW0skiILjqLLGGq3RSR8pKMzrw66e+VqIUTkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TOgpV1/SN9mOz4XYKzNUVojcQKpeGkDgr69WwVVun+c=;
	b=fzaZDJzx+JiO3aa7y6ATn0xUDaYRLI1hnnp5Gr9JfW7I48gDvgXeRBke5QI+KOghUD7B
	 yRedejVLcoLaxu/YzQ5e88eLGbzWoxHe1QNx5PU3fKvtXD4xtCnm8CjXNoz1TPTYnvhFA
	 0cLG8Khq+Lx717PbPOYokfPyYw9M19/dJbGmiG1M+UCNaF4ylzKwem2dE2CQViph9Yg8Z
	 /aQNTIK783GDVweH47IMQWPlkRlJEVrXlecdg7/qIXIZB1c+8u3XAELHcPNwkSJYU2NEe
	 4xTwDLq8CjERZGjmFVx74gKXqR4BioCtF5n9NuVNQ/s7GsfxQqcUPbfuKNNdMkjoVRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKMriLBD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485E7606A31C;
	Thu, 19 Nov 2026 00:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XKMriLBD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B581F000C8;
	Thu, 19 Nov 2026 00:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048888;
	bh=TOgpV1/SN9mOz4XYKzNUVojcQKpeGkDgr69WwVVun+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKMriLBDUbS238hP8acD3Z3YPBnPCPppZVXlexdSCR1esAodR9fkSmoj3TRDNwygs
	 8zIbx7yS11UZz7DvwQXXUHnnKae585ZkforHMJ9xbDgA/xrCNuONp9eSE3y4GE3KpK
	 4OQDtwoUkzCWDmqrLul5Wyi6I7TTR6vzbA2+oKlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2154/2857] drm/msm: Properly handle msm_ioremap() without name
Date: Wed, 18 Nov 2026 15:53:08 +0100
Message-ID: <20261118150318.952074370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d02cd29ce8299..bebc9001db163 100644
--- a/drivers/gpu/drm/msm/msm_io_utils.c
+++ b/drivers/gpu/drm/msm/msm_io_utils.c
@@ -63,7 +63,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
 
 	if (!res) {
 		if (!quiet)
-			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n", name);
+			DRM_DEV_ERROR(&pdev->dev, "failed to get memory resource: %s\n",
+				      (name ?: "#0"));
 		return ERR_PTR(-EINVAL);
 	}
 
@@ -72,7 +73,8 @@ static void __iomem *_msm_ioremap(struct platform_device *pdev, const char *name
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



