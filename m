Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4960244679;
	Tue, 29 Apr 2025 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945692; cv=none; b=MXgZsjm3UMHSAr0tRdutABqXG224s7lJpd47tXuVpQ3SHmIOfAATY6cVT11y8ZU135xKA8P+wENCj2OqA0woa5LphFU8tfYbv9jCTmQEeN3+5e2boxzU5dsbs1d3d3Mh6XSc4AP1V1/XYk+pU2j0OncllraSWvwr6dqLknbakpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945692; c=relaxed/simple;
	bh=pUxc/tHwf4fOOICtEyuwj9B1fduA5e1onnVpPutyYYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNudsp2EqzsiLdOB+3bSCRgQ8ks9pEHuzNextTbp/l6LdcGW1GateotGGgSD+tGn9tQ6tcmj/nmKCU92mZNOHvvlnU1rWrjwmxJjlzIQTcZsiUW/uf99HIJHjvRh1Ex5AYan91y09VtW618N3JXO25bOdYu3GQfyAJYVNWoCiJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R066cJ0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R066cJ0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 345B2C4CEE3;
	Tue, 29 Apr 2025 16:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945692;
	bh=pUxc/tHwf4fOOICtEyuwj9B1fduA5e1onnVpPutyYYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R066cJ0Kboi3D1gtSTT+WIAHIy/VdHchgvDVKH3ayHsRDI25sw8aQ8R7sHku9lQiZ
	 U2U/u528qwKTNP+CnI+dXwyPQssWhL5H26wTgcHdP/oDop2r+14SauZmbE1B6x94to
	 EaXlOUeFvobEtK0HhmLLHZW+NK8ARZZXETeejZfY=
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
Subject: [PATCH 6.14 003/311] mmc: sdhci-msm: fix dev reference leaked through of_qcom_ice_get
Date: Tue, 29 Apr 2025 18:37:20 +0200
Message-ID: <20250429161121.163355490@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index e3d39311fdc75..3fd898647237f 100644
--- a/drivers/mmc/host/sdhci-msm.c
+++ b/drivers/mmc/host/sdhci-msm.c
@@ -1873,7 +1873,7 @@ static int sdhci_msm_ice_init(struct sdhci_msm_host *msm_host,
 	if (!(cqhci_readl(cq_host, CQHCI_CAP) & CQHCI_CAP_CS))
 		return 0;
 
-	ice = of_qcom_ice_get(dev);
+	ice = devm_of_qcom_ice_get(dev);
 	if (ice == ERR_PTR(-EOPNOTSUPP)) {
 		dev_warn(dev, "Disabling inline encryption support\n");
 		ice = NULL;
-- 
2.39.5



