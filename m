Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB674605D7;
	Tue, 23 Jan 2024 01:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974706; cv=none; b=ePh/bNjOapQlmhjN4SlatypTCow8RxgRk3qJX4BzZW0wUj9j5tFqCP5hP+0mrv1XyX/1l+Qmcor2O99MZ0WMjMlQ2hlca3x+ddubBwpeW8QVkETEopYDh8H7NBFFNl3Nyg+fJDrs8KpaTUJzqnf0zpm7sDKKoQB4ORWn4qSi9/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974706; c=relaxed/simple;
	bh=kgsHKoKU9MufJBEAfYpeiHTtNi9VJ++a5Xr/LvDbmj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=diERIQOXD0r2A2P+217gQAwtfP0SJNIetFQh8k09/LgkoKQa5/VyE0B3w28g1ea2xLV1jja8KeYLt4kG05K/iHKl1oXj5V8gU/fFLLOpugtefj8vHqQrAwKQ5KN/HTWbsNLfxFLGtbDSTpXhWfiLeXFG9mT21Eyi5qiCAI4JSpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJ+lzsv+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJ+lzsv+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D20C43390;
	Tue, 23 Jan 2024 01:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974706;
	bh=kgsHKoKU9MufJBEAfYpeiHTtNi9VJ++a5Xr/LvDbmj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJ+lzsv+RYNXGAB/vbswXVVVZUdZva2QJOfESYky02cwmOPYO79pbSIYuBte/Gntp
	 voSPKbH+9p/OHKKkONQ2RHkJaK5Rpymi3hDSTyADbwMm1vc4iNzYPm+k64nd1w7bS7
	 OIs2V+gBXuaDy9LvveqWPj79oawFLOCO4oqiaIas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/583] arm64: dts: qcom: sc7280: Mark Adreno SMMU as DMA coherent
Date: Mon, 22 Jan 2024 15:53:02 -0800
Message-ID: <20240122235816.139628922@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4903d17c4207..1fa1a615109a 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2733,6 +2733,7 @@ adreno_smmu: iommu@3da0000 {
 					"gpu_cc_hub_aon_clk";
 
 			power-domains = <&gpucc GPU_CC_CX_GDSC>;
+			dma-coherent;
 		};
 
 		remoteproc_mpss: remoteproc@4080000 {
-- 
2.43.0



