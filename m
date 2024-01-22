Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D566612C7;
	Tue, 23 Jan 2024 00:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970754; cv=none; b=ivo2Tr8G1MLsvKv6Y363NS/t9CoSS3V4ITCWTtZbqhb/tm4omky8+UpZ12L79VL6FZm7nAz418JboCyjPsmumQzY3X2OO4RUAAb7vsoa6270pUebY2KlOJpPb1QeR5O/aXCaDdI6lk/7Ccyj/byBitdNqMEXkQTblvMxfCob/bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970754; c=relaxed/simple;
	bh=V+KHbsUYJITvgVBPhRb7wBue6MMnz2IJNT0dCjAF/es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8m7g7hU8oipZfdm53Na94P07hZaNdl8VXKpA4dVn/6Ah28z7Wafg3GPdVuGdEHavRS8PrsXkleT56m+BcSzXRgcxkVNKpwXBIjBt27M5Nu7/w1UbwIgRsJDjPIO68MXo9WVLLdZoyK6kAl9cQ5XaKRhVtZaIYQVpM03AJzqw1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eyw8op2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eyw8op2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6983C433F1;
	Tue, 23 Jan 2024 00:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970754;
	bh=V+KHbsUYJITvgVBPhRb7wBue6MMnz2IJNT0dCjAF/es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eyw8op25PPzYH+BUsVTHnlpOguUWNQcrlxTQPHQ+OJJG2IuZ6Iffaxu4ty2fc+mI
	 OAuD+Le7Yv1PK+UpEnLXCLYGePCPCws/5t75vh77eKQYqSrbxNn/DBhMuTiZaNvuq6
	 iXerEGRb06LH4egCobCnpVfaR8qzUzMNuCLMtpAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 104/417] arm64: dts: qcom: sc7280: Mark Adreno SMMU as DMA coherent
Date: Mon, 22 Jan 2024 15:54:32 -0800
Message-ID: <20240122235755.300062984@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 31edad478534186a2718be9206ce7b19f2735f6e ]

The SMMUs on sc7280 are cache-coherent. APPS_SMMU is marked as such,
mark the GPU one as well.

Fixes: 96c471970b7b ("arm64: dts: qcom: sc7280: Add gpu support")
Reviewed-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230926-topic-a643-v2-3-06fa3d899c0a@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 30e18ce54921..fd1a451e1ba2 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2701,6 +2701,7 @@ adreno_smmu: iommu@3da0000 {
 					"gpu_cc_hub_aon_clk";
 
 			power-domains = <&gpucc GPU_CC_CX_GDSC>;
+			dma-coherent;
 		};
 
 		remoteproc_mpss: remoteproc@4080000 {
-- 
2.43.0



