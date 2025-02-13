Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF16326B087;
	Thu, 13 Feb 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460765; cv=none; b=EUKbPQFkyWU8UYVtvvDJCSRBWJsGifzJjbiUdj0+3/pbNIxEo7mH0yHOhU7t8OX3AQ+zzpyFRJTEKAbWxzSq9bj9hS3Ig7EK1vc9HB+liYsN7CjsEwN+N1Z1SDkdYqKDi1VDLlrHCZ4z2IIDPsslthjHzlprl1xaZbsEEYXoouA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460765; c=relaxed/simple;
	bh=sqah4PnpFKIZDmb5KZYU17BDtMj1E5XcjZuSTobtLNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMQJMqi5RWLoiKAdGhr+z4L5cEAk3w53kUFTAzYUEqi3o1koMIyTJuvCbEtsBO8a3H0ezBCGGcayjRCUliU+mf7YBbY7vYcA1+qxKtdg/o268ME2Rp/VLUcZYU51KdZy5H2PeOimojZUWj1snzuFygjWfTEA2344yXYCHg9Rlys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=asEhC5R2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="asEhC5R2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CFE7C4CED1;
	Thu, 13 Feb 2025 15:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460765;
	bh=sqah4PnpFKIZDmb5KZYU17BDtMj1E5XcjZuSTobtLNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asEhC5R2Ii0R9/Y8Vv84kwvYBd0P5L3+lBj0KfVItdaRy3JknNMpO33n7wrhjXSSm
	 0TqVFG/eX52LLHajSTPQ1QI0eaVOm5FAv1+xQiuSxhWdJVzlMhq33jiRUFVzCrOxqv
	 z/Ggrwbsh/HV0SBhaOxSuiNsdFvJyGy8vtRwqzmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 174/273] arm64: dts: qcom: sm6115: Fix ADSP memory base and length
Date: Thu, 13 Feb 2025 15:29:06 +0100
Message-ID: <20250213142414.210599120@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit 47d178caac3ec13f5f472afda25fcfdfaa00d0da upstream.

The address space in ADSP PAS (Peripheral Authentication Service)
remoteproc node should point to the QDSP PUB address space
(QDSP6...SS_PUB): 0x0a40_0000 with length of 0x4040.

0x0ab0_0000, value used so far, is the SSC_QUPV3 block, so entierly
unrelated.

Correct the base address and length, which should have no functional
impact on Linux users, because PAS loader does not use this address
space at all.

Cc: stable@vger.kernel.org
Fixes: 96ce9227fdbc ("arm64: dts: qcom: sm6115: Add remoteproc nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241213-dts-qcom-cdsp-mpss-base-address-v3-23-2e0036fccd8d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -2310,9 +2310,9 @@
 			};
 		};
 
-		remoteproc_adsp: remoteproc@ab00000 {
+		remoteproc_adsp: remoteproc@a400000 {
 			compatible = "qcom,sm6115-adsp-pas";
-			reg = <0x0 0x0ab00000 0x0 0x100>;
+			reg = <0x0 0x0a400000 0x0 0x4040>;
 
 			interrupts-extended = <&intc GIC_SPI 282 IRQ_TYPE_EDGE_RISING>,
 					      <&adsp_smp2p_in 0 IRQ_TYPE_EDGE_RISING>,


