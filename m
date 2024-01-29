Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB396FDEB;
	Mon, 29 Jan 2024 17:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548475; cv=none; b=D0OcSdx3eQDfVhMnxRugMx7W+726DYh8aOBHn34244Fo1WFo+vItcDjq0cX8z1XM++ngLuGnfr0UQ3dhQN4ftVxKd+ojpMPreokvSiP7azEOpQycVCt+CGfiYDxTMiyCD4JEtlhdoAVcAHzCHO9Won2rUTDmjmh4HwSkwZi1TYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548475; c=relaxed/simple;
	bh=MlbLeLBZiB1nKjVow2EYs7u5CB9R1ehK7ow5ww1PpgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq6B0iaIyb+mvPHGHTUVf6+U0eehlsRYeSDh8J5VdFjJ72fcYZKcdqdntIXK+JJqELGsN4NB9hqM0vKMlS3bp+zSJV5hTLtmxgXmvYbXYYv3nvQR/mZMV5ing1cHoTBsDWDvXWS+BIPfETVIdM1EKR9gnsqH+toV6FlXOXo1FG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YKkSZHXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YKkSZHXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E04D1C43390;
	Mon, 29 Jan 2024 17:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548475;
	bh=MlbLeLBZiB1nKjVow2EYs7u5CB9R1ehK7ow5ww1PpgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YKkSZHXcie7oARdkMibMNM7KsDO+LaVbg1gleYpdLu0UeNh8HH2LgU1KRy+1drpdW
	 IuIKl+IcN8n2YW1FwpnP4LbH2r6ynqZ0nszGT9v4IzV2LXN1eWPEDuwLIApm0aocHt
	 DUpiMc4pET5W1B0L8/s2m1nZ19xLwuDsumLKBGCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Pham <quic_jackp@quicinc.com>,
	Jonathan Marek <jonathan@marek.ca>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 093/331] arm64: dts: qcom: sm8150: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:02:37 -0800
Message-ID: <20240129170017.650098703@linuxfoundation.org>
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

commit cc4e1da491b84ca05339a19893884cda78f74aef upstream.

The USB SS PHY interrupts need to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: 0c9dde0d2015 ("arm64: dts: qcom: sm8150: Add secondary USB and PHY nodes")
Fixes: b33d2868e8d3 ("arm64: dts: qcom: sm8150: Add USB and PHY device nodes")
Cc: stable@vger.kernel.org      # 5.10
Cc: Jack Pham <quic_jackp@quicinc.com>
Cc: Jonathan Marek <jonathan@marek.ca>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231213173403.29544-6-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8150.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -3593,7 +3593,7 @@
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",
@@ -3646,7 +3646,7 @@
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 487 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 7 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 11 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


