Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A8C6FDEB;
	Mon, 29 Jan 2024 17:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548479; cv=none; b=ha7AOHTVHeFbqn35F62Byttb02vurVs8wyuoyOtXAeop6QuXd3TkvDWt0ATxcg1oJye5c4MnJ044ZgHVAa9MSdQRxX3caOECYrRxjC1dr+NR7BBA1760P0+cZ+mer9adMqsfJmDMLvxn35hL408pxuxg1bBQ7LjUOeFJUG2653w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548479; c=relaxed/simple;
	bh=wH2+wUpRRfiZV/k76HUZv1npj+5Yu2YSccGEoXpvNrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZeND6roWyX/Y2HCMcnajoAKWGWMtmNuOlwZpueZ5ZJ9bjKTbj89iCWoepcqhnU6g/djR2A0j4t09YAFZ9HnIzhbWh1W1YvC6GJOxaMtut+6Knd64U2CdknUd1u+kvmL07ONOBsKQY2xYE5GU3BE5wq3tz1PINpkC+ubzXPFUpUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rKtqd7XQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rKtqd7XQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2DDC43390;
	Mon, 29 Jan 2024 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548478;
	bh=wH2+wUpRRfiZV/k76HUZv1npj+5Yu2YSccGEoXpvNrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rKtqd7XQhalZFw4mCbfyS4/8WxzJxMxbaWlysybW72+kENR5XdTTUyC4iwT5/loM8
	 hyS2umelkTe8SqmYT5osPVPJHJKDqKUoBYKcH7TGtrdCva78d2VlkK8KNQZ47Ehy+9
	 CmfOlxV/074o+nV8hg+msZXZ2xd6n3Bao+DLAB5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 098/331] ARM: dts: qcom: sdx55: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:02:42 -0800
Message-ID: <20240129170017.795068798@linuxfoundation.org>
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

commit 710dd03464e4ab5b3d329768388b165d61958577 upstream.

The USB SS PHY interrupt needs to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: fea4b41022f3 ("ARM: dts: qcom: sdx55: Add USB3 and PHY support")
Cc: stable@vger.kernel.org	# 5.12
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231213173131.29436-4-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx55.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
@@ -593,7 +593,7 @@
 			assigned-clock-rates = <19200000>, <200000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 198 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 51 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 11 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 10 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


