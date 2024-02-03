Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D5D2C694;
	Sat,  3 Feb 2024 04:12:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933575; cv=none; b=IJUhWNayJTbApMJW+3BvR4bh9gYIM0F9A/gAMnQqhj0Leqgb98CzYIEP8AnX24/uDFVuNbe+Igdkxwg1jD4A97dKeIQmUKG9qXcsjpLwWNvUJETEUpcTNRqVhDBKLAWoRc6o3v/RDrpfSodn+MYkl2qbtNIKAr7LfirYvKSC2ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933575; c=relaxed/simple;
	bh=WBEBi24HQfr6O4mdtrEI/BQASxXqv9bpYcT8yo6SPlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYOEnQ/TIC6MqV0DaKrWO5pyc8rak/hkJnhaToNDwlpNooWlOVGFqhsnSUOLCz4Ai3IYcNnEc9tVCFCd2f8VxsVzPDTJzeAodw1AC5CLWbnCFZYn8UyYORkHDYTDNOgxhrsUwPmYebB1muaKlNP2rneZLM1ldmI8gQhVqdiAE8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=06xjuoYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="06xjuoYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AFFC43394;
	Sat,  3 Feb 2024 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933575;
	bh=WBEBi24HQfr6O4mdtrEI/BQASxXqv9bpYcT8yo6SPlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=06xjuoYFK76LXA9AOEKX9gjv+er7E2DjexPH9965Q1OD45tu2+pO0z3HjA9dO+UXe
	 /xdvMJpCDMyWmgiI57A9OhvFBJywZqX9Al6CyIDvqv+BiGl8qXSphI67nkDTBbCbJC
	 htFk4ey6PMxpbh1693jy+ZlLiM0xKfPvqhxJFCK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nia Espera <nespera@igalia.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 104/322] arm64: dts: qcom: sm8350: Fix remoteproc interrupt type
Date: Fri,  2 Feb 2024 20:03:21 -0800
Message-ID: <20240203035402.511264352@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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
index a7cf506f24b6..5ed464c37422 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2020,7 +2020,7 @@
 			compatible = "qcom,sm8350-mpss-pas";
 			reg = <0x0 0x04080000 0x0 0x4040>;
 
-			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&intc GIC_SPI 264 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_modem_in 2 IRQ_TYPE_EDGE_RISING>,
@@ -2062,7 +2062,7 @@
 			compatible = "qcom,sm8350-slpi-pas";
 			reg = <0 0x05c00000 0 0x4000>;
 
-			interrupts-extended = <&pdc 9 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 9 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_slpi_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_slpi_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_slpi_in 2 IRQ_TYPE_EDGE_RISING>,
@@ -3206,7 +3206,7 @@
 			compatible = "qcom,sm8350-adsp-pas";
 			reg = <0 0x17300000 0 0x100>;
 
-			interrupts-extended = <&pdc 6 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&pdc 6 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 2 IRQ_TYPE_EDGE_RISING>,
@@ -3511,7 +3511,7 @@
 			compatible = "qcom,sm8350-cdsp-pas";
 			reg = <0 0x98900000 0 0x1400000>;
 
-			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 1 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 2 IRQ_TYPE_EDGE_RISING>,
-- 
2.43.0



