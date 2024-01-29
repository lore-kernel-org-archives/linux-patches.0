Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B246815958C;
	Mon, 29 Jan 2024 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548100; cv=none; b=h52Z43waelPYxrOD7Ng0SlCuo6aVKCmp4nwuS6foYnvPCoXnzocwEQM04rUyJqs3wycJM/i0jf+xGEN6+wGNEHt/mu2FpdtsrKvAI8qW4YjNv9xTXKsOBY8U83xSrcaz5L30kxzCcj8Og48Pzj+K/TDwE47YfDq4Omdecc+74pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548100; c=relaxed/simple;
	bh=t2M72Uco+pqkTrATZADnM94gP9fkpEzmuS3iUiaT7xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6FaYiPCTrmD1YoRm1Tp1L/FNqFgnn4eyIKjqU2/Dv4F2D/+v6YCSUt1fOkM0HyOcrD8sWs31zuIrTBURsqpX3MX7p1va+KqdJvIFaKGwICzHGusKleW4TUNXVBOdaSQP42XGmiCj0BiIcfa0GNwcyvIH9FeLvXSxGcL5w08sQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fqQlts2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fqQlts2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B327C433C7;
	Mon, 29 Jan 2024 17:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548100;
	bh=t2M72Uco+pqkTrATZADnM94gP9fkpEzmuS3iUiaT7xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fqQlts2WMcEbgivc/5mmuX19qZAfx0tsM2topFv8rO5IHsNfow9qzEaRKDjqUdKcN
	 rU92UaPmErDIyRJ5hdQujE3Mh4szLpz6/BGPK9KLsySjl1BJcNwkqJkmUEEYRSoS8i
	 axHApAVmtwqZXCGzBhdV5te6cOlZ7reCa2GS4kbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 084/346] arm64: dts: qcom: sdm845: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:01:55 -0800
Message-ID: <20240129170018.864776400@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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
@@ -4054,7 +4054,7 @@
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc_intc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc_intc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
@@ -4105,7 +4105,7 @@
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc_intc 7 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc_intc 10 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc_intc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


