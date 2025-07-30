Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EEE275AE9;
	Wed, 30 Jul 2025 09:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869096; cv=none; b=gixfYLAmwU3r/HCTeoK1/D/kCqZ4b9mIXlI73v06QxNSpkHb+RjOBT4RKCVXpz3LKIrvol489s0U8fnxYkSOf3cUTlNRfyiOgyfeISHBq+9liX0bwBUjQVyKloV5Y8gDswDY5oRXrkR1cuNBOYdPW+ZH1/NIG23alIkcNhruJcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869096; c=relaxed/simple;
	bh=Z5ulYsprUqu+aKRngLNirmiAiJwG00nbh2mzalTefMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FlqJRjYQ47aHONCYH9V5oztJcvqCzJ85369hX8wo2aD8BaFeME4BlgWHey0bTvRhCnIBmh/fFNgOFKcMAojKcSbCPtpfor4X1G/AURHIdQrOhoNFRS+9f8uBKBEZP2LKhY+tIZfGoe07RtG8I3jdZu+ycmwa7hksF5iWGqKEkA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Aqf6qMQR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Aqf6qMQR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F0DC4CEF8;
	Wed, 30 Jul 2025 09:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869096;
	bh=Z5ulYsprUqu+aKRngLNirmiAiJwG00nbh2mzalTefMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Aqf6qMQRL4i9prTJgCUZMVOQwx1JBD9WGZX9ESgmVxFNLI0O4FUiMwWhLx5I29k8h
	 fN5a6DqXkqGhdoop3NSdpFX3P+6B860xEvNYMpiC5mjxcTO/QzhxUWwxof24IWk1UF
	 GxSbv+jDFIUu0uCGRdTYPDFp7Rh1wMO9cfVI4yig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xilin Wu <sophon@radxa.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Georgi Djakov <djakov@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 09/92] interconnect: qcom: sc7280: Add missing num_links to xm_pcie3_1 node
Date: Wed, 30 Jul 2025 11:35:17 +0200
Message-ID: <20250730093230.989157378@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xilin Wu <sophon@radxa.com>

[ Upstream commit 886a94f008dd1a1702ee66dd035c266f70fd9e90 ]

This allows adding interconnect paths for PCIe 1 in device tree later.

Fixes: 46bdcac533cc ("interconnect: qcom: Add SC7280 interconnect provider driver")
Signed-off-by: Xilin Wu <sophon@radxa.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250613-sc7280-icc-pcie1-fix-v1-1-0b09813e3b09@radxa.com
Signed-off-by: Georgi Djakov <djakov@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/interconnect/qcom/sc7280.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/interconnect/qcom/sc7280.c b/drivers/interconnect/qcom/sc7280.c
index 346f18d70e9e5..905403a3a930a 100644
--- a/drivers/interconnect/qcom/sc7280.c
+++ b/drivers/interconnect/qcom/sc7280.c
@@ -238,6 +238,7 @@ static struct qcom_icc_node xm_pcie3_1 = {
 	.id = SC7280_MASTER_PCIE_1,
 	.channels = 1,
 	.buswidth = 8,
+	.num_links = 1,
 	.links = { SC7280_SLAVE_ANOC_PCIE_GEM_NOC },
 };
 
-- 
2.39.5



