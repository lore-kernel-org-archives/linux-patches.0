Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E3714D424;
	Tue, 23 Jan 2024 00:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969281; cv=none; b=lXwSDIR+9B6vie7VNZX/6ktgJy7WplDTf5TsY9kDbrNDYo5ADSv+vafm+/Efrnuy6NcNDnCjr/92QqsSa/6+hh31ue5Nl8SMpG71IMtwPoshhFCpJEE0j91HAVjWugPOQ1cEdjFgVEOjfGz2MROmtlrln9g1i7QkVflpfXEsIyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969281; c=relaxed/simple;
	bh=9gC9pV7H2MFvq0eZDcRcVIsmN/MZerjPvHP+CcVIqqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DlNl88GgIMs1+SOuMEdNPvMaqsX+DzOPmUuayKgua3WzKCZvPJEDOM8nxBRmnThYj6gMv729eDiQupkTwVshbVUHQt28BGMB1yXPoT+Otu9qmqSOouxpb6CxXFUbcm40/zOLUrGXcfkjR4Xu4EdEExTBjt6omA/yF0HrKWgCj2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kdDzHoIg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kdDzHoIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F092FC43394;
	Tue, 23 Jan 2024 00:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969281;
	bh=9gC9pV7H2MFvq0eZDcRcVIsmN/MZerjPvHP+CcVIqqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdDzHoIgIVWitq1CIqL405bab4GsCgo/G+VVjb6U0ofEMjxzn8FiGHP0V9T2pPX0e
	 nRw6oYiaXNnD6dNhB3wQ+YaWPkJ8oFiEW4BYn/thDkFcZAhyyqFl7qzIWUceMyyZiY
	 h9dnP0fKQCS/rjo07fuh0xfLfC4S+PiHTJ6ZYXk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 142/641] arm64: dts: qcom: sc7280: Mark Adreno SMMU as DMA coherent
Date: Mon, 22 Jan 2024 15:50:46 -0800
Message-ID: <20240122235822.489497210@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index ea183eadf700..1a3db2579806 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2773,6 +2773,7 @@ adreno_smmu: iommu@3da0000 {
 					"gpu_cc_hub_aon_clk";
 
 			power-domains = <&gpucc GPU_CC_CX_GDSC>;
+			dma-coherent;
 		};
 
 		remoteproc_mpss: remoteproc@4080000 {
-- 
2.43.0



