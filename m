Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92D421ABDB;
	Tue, 29 Apr 2025 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947594; cv=none; b=sWWqDGuHKj3t4coCSgH9/3pH04l2jhB4xhg+OOYDI432Z+++QQ9l3qUzhTafNy6jEom+MVomDk/WXnwgxrqikjQbBGBPncstyFW17yx4yuQ9ok18k2wkYV6nwJuX2rTg/mySc00idbDWUNJGNlW5sQLScZD94lRIZkd2fuccWyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947594; c=relaxed/simple;
	bh=6dw+ADfUYdche8BEgm/fSptyp44UDnsvFpjyuMaVIlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr+fblsbCWzoITP+f8KEaDmOM6JAI3qxrrr7tn8l822xDHgaVFPwYTKfLZQJV5EHEt8CkuC8kceFjk6sVEdYO0XXKWKPTKbSUkgveTUOM4qyZYFT7Ku7auh6qUoDoMtM5gIO7bdldAJ6jbcjST/Qc6xlalB6pOw3EpOnAClgBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MqIUVgU6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MqIUVgU6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C850FC4CEEA;
	Tue, 29 Apr 2025 17:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947594;
	bh=6dw+ADfUYdche8BEgm/fSptyp44UDnsvFpjyuMaVIlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MqIUVgU6Q4hGDS2YGepG7WHOhKKHZHJHK88Bd6UdbbTk1V06nKBBeD1oGHQ2hnSJL
	 vi/Gq5+btN15+yjKnD+RMOnbJuyThLDbiUi3r7x/Vy9DhHuFcbG8IctMtsnz4r+JuC
	 ZHIczFdaKBXIaEZHRb0tBY2TGmWqBxHFNVkZ3dX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 006/280] mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get
Date: Tue, 29 Apr 2025 18:39:07 +0200
Message-ID: <20250429161115.274250672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tudor Ambarus <tudor.ambarus@linaro.org>

[ Upstream commit cbef7442fba510b7eb229dcc9f39d3dde4a159a4 ]

The driver leaks the device reference taken with
of_find_device_by_node(). Fix the leak by using devm_of_qcom_ice_get().

Fixes: c7eed31e235c ("mmc: sdhci-msm: Switch to the new ICE API")
Cc: stable@vger.kernel.org
Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Ulf Hansson <ulf.hansson@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250117-qcom-ice-fix-dev-leak-v2-2-1ffa5b6884cb@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci-msm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/host/sdhci-msm.c b/drivers/mmc/host/sdhci-msm.c
index 945d08531de37..82808cc373f68 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1866,7 +1866,7 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	if (!(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
 		return 0;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;
-- 
2.39.5



