Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B521BDE6;
	Sat,  3 Feb 2024 04:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933793; cv=none; b=ZtNJ6YKpoeR8PqHkum5krTFvRrf7pZgTNQf9nlRyFTpdPyWO9lmoDFN6F9Mcm3rcGEIEoQV/lFNhyMcEUyJDdQfV6iyjH2hB/RJI/Bqv1i15nkmyF4UBCYoBMSolKQPByz3n0ulZ/brgSEMvcRjysa8iaLw0N/3AFckFj13ZqsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933793; c=relaxed/simple;
	bh=KJNtyDKsSui10Zs6JC16CT/4JTYflPrYA5aa/rZ2Y4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fhy8Ig0Z4kgN9ZG3doi3Sb2KjU1YbbY3EF8N6q20b1zvu+XjQgPslcSgDmIrG48jYZgKSlN7EiclvD1Zqe1HDkrIw8gFV0NnXkxb2vTXbEz6WjFtb8VE7eurLkQDnEDgv3bLgIiYWVxWTsS75NjyF7uK12xPbZRut/V6jtsM7VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wro47sam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wro47sam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FBFC433C7;
	Sat,  3 Feb 2024 04:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933793;
	bh=KJNtyDKsSui10Zs6JC16CT/4JTYflPrYA5aa/rZ2Y4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wro47samzFRTYdbcmMo0ZYM+fdB1i2q4w37WJxM87uRbsI/xRfpWt5VDFx2AjOPqC
	 aVEzeF7FeS+oQtTsGfIMfE6MWLOQCnH0P09d5v8TipAh3QWliylN3qfoJyf7WRzLg9
	 u8NRzOJc7bnUPo4FcIj8aZOhz2M+74DluxoF0Xo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nia Espera <nespera@igalia.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 103/353] arm64: dts: qcom: sm8350: Fix remoteproc interrupt type
Date: Fri,  2 Feb 2024 20:03:41 -0800
Message-ID: <20240203035407.033467950@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

From: Nia Espera <nespera@igalia.com>

[ Upstream commit 54ee322f845c7f25fbf6e43e11147b6cae8eff56 ]

In a similar vein to
https://lore.kernel.org/lkml/20220530080842.37024-3-manivannan.sadhasivam@linaro.org/,
the remote processors on sm8350 fail to initialize with the 'correct'
(i.e., specified in downstream) IRQ type. Change this to EDGE_RISING.

Signed-off-by: Nia Espera <nespera@igalia.com>
Acked-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20231111-nia-sm8350-for-upstream-v4-4-3a638b02eea5@igalia.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 1d597af15bb3..a72f3c470089 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2021,7 +2021,7 @@
 			compatible = "qcom,sm8350-mpss-pas";
 			reg = <0x0 0x04080000 0x0 0x4040>;
 
-			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 2 IRQ_TYPE_EDGE_RISING>,
@@ -2063,7 +2063,7 @@
 			compatible = "qcom,sm8350-slpi-pas";
 			reg = <0 0x05c00000 0 0x4000>;
 
-			interrupts-extended = <&pdc 9 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 9 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_slpi_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_slpi_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_slpi_in 2 IRQ_TYPE_EDGE_RISING>,
@@ -3207,7 +3207,7 @@
 			compatible = "qcom,sm8350-adsp-pas";
 			reg = <0 0x17300000 0 0x100>;
 
-			interrupts-extended = <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 6 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 2 IRQ_TYPE_EDGE_RISING>,
@@ -3512,7 +3512,7 @@
 			compatible = "qcom,sm8350-cdsp-pas";
 			reg = <0 0x98900000 0 0x1400000>;
 
-			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 2 IRQ_TYPE_EDGE_RISING>,
-- 
2.43.0



