Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835E91C4A24;
	Mon, 10 Mar 2025 17:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629459; cv=none; b=XMzIiL6Dzso1zk4NtZfR14IWHk5C72hCYM7GaE4eANdRSBNkof8BzzIS7JiMsO5YMp2/xVGwglZSPmGbfwSqh7tb3lJGYgRGD/PiUMn8EbGcgmW9L+1Mbz03yNjSJVG15oQcaL/+KbZUnWs65jMQNQI3iqVyiH7uk9U0081PJKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629459; c=relaxed/simple;
	bh=xSSvJLVZdBs4lC8SLNt53HsgTRXw4ttr/4hXYJkFPoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKySIRxuH0NZwtIlge9GeXpK2FwM0mTmoXfjtX3jVvMVG8f7Vwh11FwEMUn//dBKSmc0f44+Cg95w25uRGQGEA4O1cnTngEmvR+x5IZF0nJFQ0f1/Ygim6ochaygaleh9v18dcOL5FMG0fH6ZoAR1eKSjC/mYmjy2dqGTedFpNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRdFnkVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRdFnkVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFF4C4CEE5;
	Mon, 10 Mar 2025 17:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629458;
	bh=xSSvJLVZdBs4lC8SLNt53HsgTRXw4ttr/4hXYJkFPoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HRdFnkVfy0TK66aBPrMF7mbRNChI+6MJ2dW1KOYRCorAtp+ZlRGjSCs1CiieBqIFv
	 ZVEfCWpw+wei0kpmRGDV36qfrKxQXkfn3HTCYUiIbBm4dRBtQivlZ1sxGrJA2qcBDA
	 +2uoGV+iSzlfYYMGRmT4uWrfnVMhDQc40O1VDP3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 5.15 301/620] arm64: dts: qcom: sm8350: Fix MPSS memory length
Date: Mon, 10 Mar 2025 18:02:27 +0100
Message-ID: <20250310170557.504745853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit da1937dec9cd986e685b6a429b528a4cbc7b1603 upstream.

The address space in MPSS/Modem PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB) which has a length of 0x10000.  Value of 0x4040 was
copied from older DTS, but it grew since then.

This should have no functional impact on Linux users, because PAS loader
does not use this address space at all.

Fixes: 177fcf0aeda2 ("arm64: dts: qcom: sm8350: Add remoteprocs")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-3-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -754,7 +754,7 @@
 
 		mpss: remoteproc@4080000 {
 			compatible = "qcom,sm8350-mpss-pas";
-			reg = <0x0 0x04080000 0x0 0x4040>;
+			reg = <0x0 0x04080000 0x0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,


