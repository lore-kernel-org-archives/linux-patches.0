Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CA7AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E237BC433EF;
	Wed,  4 Jan 2023 16:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848723;
	bh=QU6E9a04N1en8MkogseUdwddJuUBtrw3ip3ycxGEiPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvAn57Dpj/gV4vrErp75JJUuUlqy7nv4vc9XlTxZJyjw9VlPwlF25SkC9Ch5Otj9d
	 BO8qlZoxmZr/AzZkh4uBl7R1TA+1X5e13EZuNkvr2N3v67SXUuxkpcnNKXqAkGnbBk
	 K8+76p+kUfb8GL9ASEKb0Ckf/Xve8uS2Xxt/YFfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.0 004/177] arm64: dts: qcom: sc8280xp: fix UFS DMA coherency
Date: Wed,  4 Jan 2023 17:04:55 +0100
Message-Id: <20230104160507.788839543@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 0953777640354dc459a22369eea488603d225dd9 upstream.

The SC8280XP UFS controllers are cache coherent and must be marked as
such in the devicetree to avoid potential data corruption.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Cc: stable@vger.kernel.org      # 6.0
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221205100837.29212-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -855,6 +855,7 @@
 			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0xe0 0x0>;
+			dma-coherent;
 
 			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
@@ -923,6 +924,7 @@
 			power-domains = <&gcc UFS_CARD_GDSC>;
 
 			iommus = <&apps_smmu 0x4a0 0x0>;
+			dma-coherent;
 
 			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,


