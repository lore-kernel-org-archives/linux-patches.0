Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2021E15DBCB;
	Mon, 29 Jan 2024 17:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548474; cv=none; b=OmPwVdH37eZR9/2Z+2dcpoyEAjO+lihRgYFEV+JzKQA8MQ8ZL1nATr0FW7g5i6G4BheCVUmtqNOAejJW15sdVFQk4AJwqwJ/w3vLZFfNrEgF0T+peqrEBz5tOPFP/9Y5qzBSXprUmVKm+YF/fgTiNNYPoOkFvbF4eH+SmLbjxbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548474; c=relaxed/simple;
	bh=HEo+kqmrVUacfRk6oljEZYKV0b2N2aL1k5bpnSjTolA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s8zrALd+ZpLisHBqAdn+1o0ZKDAzbVsmTK/2S0M3gu6gb8HWmPLkchVoCjEboEBb6ai39gEMn1ri51oMOejXDiGUhsN3gzfLoUJgeK9KaUQPbOuNST6JAJCJq1x12MusrZS9pzO/U5SJcHcdU/K2k3K4ww3Q2g1mxSY5mHRZiW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1ljOhQr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1ljOhQr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81214C433C7;
	Mon, 29 Jan 2024 17:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548473;
	bh=HEo+kqmrVUacfRk6oljEZYKV0b2N2aL1k5bpnSjTolA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1ljOhQr/HOyLb8ZXmWe0A3tM//qaGqFbBvmZKnZQrI5HJB0PDPm/KmSDSInCtofW
	 0fRLsDnSPV7oevlczIX8iWa14AO3LsN8sa6C0hWbW/AI6nwud8aPNcb0eDFAztKXWH
	 D/eQKtkBqXkm6cURwf6NZqXqCb99Cw48+sYTBtUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 091/331] arm64: dts: qcom: sdm845: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:02:35 -0800
Message-ID: <20240129170017.592246715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit 971f5d8b0618d09db75184ddd8cca0767514db5d upstream.

The USB SS PHY interrupts need to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: ca4db2b538a1 ("arm64: dts: qcom: sdm845: Add USB-related nodes")
Cc: stable@vger.kernel.org	# 4.20
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231213173403.29544-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -4085,7 +4085,7 @@
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc_intc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc_intc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
@@ -4136,7 +4136,7 @@
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 7 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc_intc 10 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc_intc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


