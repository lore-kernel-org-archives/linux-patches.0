Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CCB22EE46;
	Tue, 12 Nov 2024 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407973; cv=none; b=fNGz/4RL7t9dehCkoDw5WYEmOWZjZnP+J5/lIoo0xQPfoJ7YLPGNHYupIrpKVd+08Xu1XsVG5LbbkHj5pMu4Dy/maBf/kwW1P6ccHQ4IGfUz+yEk/H4WjWwJFqaVbA4IomfE8TrlRjsmfynHmecoULj75VZpBRmRqNSBOGcdrXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407973; c=relaxed/simple;
	bh=5iW3R0Nl0Zjfv9TS9sPeuf2WhNqFB5iOM2CSvDDnrk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4kL9SABftkkXzHgf8i4eLASL3Bii6F9h8FZfhBsFs7QDNcIwlgo10Ys1k+2MhnRecExjMx+bI7ondwMWx9MzA1T6RjiWthbBaxa5pRr2fF0Obh9yrHhhA8PyRlCnguCrO8sBXzURis4GrW8iXS3K7MbzjGI9ge82oK5S6PgBvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ywgQbjEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ywgQbjEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09641C4CECD;
	Tue, 12 Nov 2024 10:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407973;
	bh=5iW3R0Nl0Zjfv9TS9sPeuf2WhNqFB5iOM2CSvDDnrk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ywgQbjEiykYcWGg8z+uju03kiLzMhWDKRD6jLb9Yq0TTY1mnjEEszcL4LacLy7ybR
	 UiPSKC/oU6a7YIgDVEusSY9FSBf5b8xVaxwDW5PeF0/SVRIwa+uoRsi9C38m7a6CH9
	 KmY/vtycH6sSydZrQpUjYkGZExsC2PZkBbr3BOIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 020/184] arm64: dts: qcom: sm8450 fix PIPE clock specification for pcie1
Date: Tue, 12 Nov 2024 11:19:38 +0100
Message-ID: <20241112101901.645156274@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 5d3d966400d0a094359009147d742b3926a2ea53 ]

For historical reasons on SM8450 the second PCIe host (pcie1) also keeps
a reference to the PIPE clock coming from the PHY. Commit e76862840660
("arm64: dts: qcom: sm8450: correct pcie1 phy clocks inputs to gcc") has
updated the PHY to use #clock-cells = <1>, making just <&pcie1_phy>
clock specification invalid. Update corresponding clock entry in the
PCIe1 host node.

 /soc@0/pcie@1c08000: Failed to get clk index: 2 ret: -22
 qcom-pcie 1c08000.pcie: Failed to get clocks
 qcom-pcie 1c08000.pcie: probe with driver qcom-pcie failed with error -22

Fixes: e76862840660 ("arm64: dts: qcom: sm8450: correct pcie1 phy clocks inputs to gcc")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20241006-fix-sm8450-pcie1-v1-1-4f227c9082ed@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 9bafb3b350ff6..38cb524cc5689 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -1973,7 +1973,7 @@
 
 			clocks = <&gcc GCC_PCIE_1_PIPE_CLK>,
 				 <&gcc GCC_PCIE_1_PIPE_CLK_SRC>,
-				 <&pcie1_phy>,
+				 <&pcie1_phy QMP_PCIE_PIPE_CLK>,
 				 <&rpmhcc RPMH_CXO_CLK>,
 				 <&gcc GCC_PCIE_1_AUX_CLK>,
 				 <&gcc GCC_PCIE_1_CFG_AHB_CLK>,
-- 
2.43.0



