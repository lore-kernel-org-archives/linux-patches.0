Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7FF61586DB;
	Mon, 29 Jan 2024 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548097; cv=none; b=t/5AVBKUDEaHA2/FEuhYTbXZugVs1s0h17+4DWSAYXZPq9ClW/hJNHJlQZWxK82V5KaC7xoAQcAkKr5BwyTSye10rS7FAxAFvLUbY2hHBSBcTCiMjptfzvEW78px/QHTBfuyaWc880ENRDwrS/6az3JkLg1bhJ3YeiXYEF2mMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548097; c=relaxed/simple;
	bh=HoUncHru8oszzcl6cm3wfpeeTtWWUnWdQR3ZxaxcZ5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CCxy0aES48wWaXcLZW5BpRo4Aots4VC+Tvdf7/Brix5IPawheCFQXmI4N9lvZZYmXjKk6/aqrK9hg4gmL6cEHfRkLP9Kd8gZ4yl7QDWhfaI3Yy3xiHn8P2IVtTFP7zS0SLAVXBE+FvnrdQbAxHdY2BpnKmNMAl4bISKeykR8fro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/H7H5Bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/H7H5Bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804EAC433C7;
	Mon, 29 Jan 2024 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548097;
	bh=HoUncHru8oszzcl6cm3wfpeeTtWWUnWdQR3ZxaxcZ5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/H7H5BwC2NqLdloOsJOV1ruZzOAiiwkoKUU0WDDZU2E6fFP7xFlc2IaZAQ7xHhnj
	 8GHMbB+RXdtLSx/eM5+fB8Xb0X8F6AklQu55FBc96ko1Ihkf14hM0zdu48K75Y7LL5
	 Q8VFP+aP0dWIQ++ZfMoxZlX63kRmxjvklNO9oF9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 090/346] arm64: dts: qcom: sdm670: fix USB SS wakeup
Date: Mon, 29 Jan 2024 09:02:01 -0800
Message-ID: <20240129170019.052843994@linuxfoundation.org>
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

commit 047b2edc35b8db22354b4fba37818b548fc18896 upstream.

The USB SS PHY interrupt needs to be provided by the PDC interrupt
controller in order to be able to wake the system up from low-power
states.

Fixes: 07c8ded6e373 ("arm64: dts: qcom: add sdm670 and pixel 3a device trees")
Cc: stable@vger.kernel.org      # 6.2
Cc: Richard Acayan <mailingradian@gmail.com>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Tested-by: Richard Acayan <mailingradian@gmail.com>
Link: https://lore.kernel.org/r/20231214074319.11023-3-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sdm670.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sdm670.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm670.dtsi
@@ -1296,7 +1296,7 @@
 			assigned-clock-rates = <19200000>, <150000000>;
 
 			interrupts-extended = <&intc GIC_SPI 131 IRQ_TYPE_LEVEL_HIGH>,
-					      <&intc GIC_SPI 486 IRQ_TYPE_LEVEL_HIGH>,
+					      <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
 					      <&pdc 8 IRQ_TYPE_EDGE_BOTH>,
 					      <&pdc 9 IRQ_TYPE_EDGE_BOTH>;
 			interrupt-names = "hs_phy_irq", "ss_phy_irq",


