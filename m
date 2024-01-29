Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666A8157E75;
	Mon, 29 Jan 2024 17:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548383; cv=none; b=e16ZpCsY2Ha6QXB+FwnSrupzCuJbMEyx0Sbn42YuxbrFeOC+2FbV7EIzn/VK0PHFaXZ6wX5Ot6c0JXGq7t6l4BNp7bLvhb7x5EqPipUdLZNkM1nDCbSAoF4GBDZr85Jz7XycExz01sfr2j33B1+oSyjWHhcAY6DZ5PXvQzt+FkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548383; c=relaxed/simple;
	bh=zYBSK6JSFoWgH58Qo/D9U7o9jt+mmckZh0XuRg2icAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQmAze6P9Q2iXfR96TMdBrmRy9GOPt78onKz/nWugkVlzg7SoDkyBrF/qaqzx1BPIlNgdYNaBI1Bx9ziQ87UeSjnbGzOrQ4P8XiPnx0jfKm1T/By8VOpSR2bIt/W2DnQdGLKA3O5dc6f5255aRBZhf3f6IGl6BBEwU3Rio+UvrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n49aWVCd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n49aWVCd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E038C43390;
	Mon, 29 Jan 2024 17:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548383;
	bh=zYBSK6JSFoWgH58Qo/D9U7o9jt+mmckZh0XuRg2icAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n49aWVCdR4csnHzTGUSFCprjM4BQLz2nz998yQ9v0+iuE+O2BI1GPTrl7e3o9IJ+F
	 dtZ6weNogvhAE6W9VogKYyLOsqqgCmbF55mwbfVcVHDCrQEDDKMwY7duuLf8RXuNH4
	 6/3dNpd8YVmM6O5yNMjc5QB3q12HNAhOKaQZ4Zmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/185] ARM: dts: qcom: sdx55: fix pdc #interrupt-cells
Date: Mon, 29 Jan 2024 09:05:55 -0800
Message-ID: <20240129170003.576747095@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit cc25bd06c16aa582596a058d375b2e3133f79b93 ]

The Qualcomm PDC interrupt controller binding expects two cells in
interrupt specifiers.

Fixes: 9d038b2e62de ("ARM: dts: qcom: Add SDX55 platform and MTP board support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231213173131.29436-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-sdx55.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index eb1db01031b2..7bb2f41049d9 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -522,7 +522,7 @@ pdc: interrupt-controller@b210000 {
 			compatible = "qcom,sdx55-pdc", "qcom,pdc";
 			reg = <0x0b210000 0x30000>;
 			qcom,pdc-ranges = <0 179 52>;
-			#interrupt-cells = <3>;
+			#interrupt-cells = <2>;
 			interrupt-parent = <&intc>;
 			interrupt-controller;
 		};
-- 
2.43.0



