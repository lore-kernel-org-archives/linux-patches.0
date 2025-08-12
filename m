Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04B0283FE4;
	Tue, 12 Aug 2025 19:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025463; cv=none; b=Wbm5pRWsp2O6HoNUQ0jDmAFhu4kOhd7j8FH3ketPArw7SNTOaUHYAccRmBaPrm3m8RtW6+XVpFn0xYE55ZjFSVdQPDj0BXbM/cIRQRxokvN/WfIHMlsznmBHYbmICWV52FCYy7k6RUclB1078kywC8CP58ooE4rHUnPhp5uKZxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025463; c=relaxed/simple;
	bh=UxdfNm/I+vmbir9ICHHVR7mlVYVxCCqOjHpsZFEEs04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMp9xp2oI2OMBztIfRm5Qry8/JqdpuVi6MNciZvoaa+sOC9hmv70tFu+3k6/bEtk1i+t/wKqU3En1xCr3AYWQQjT7dN/+EMmgyh6lECWEJmLxQUbt9REpUT9W214+OW/IzXXmpwd5dwgyxQC1s9pJIgVBx3h8g4U8FSLZKZTUpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+xLwf26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+xLwf26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD99C4CEF0;
	Tue, 12 Aug 2025 19:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025462;
	bh=UxdfNm/I+vmbir9ICHHVR7mlVYVxCCqOjHpsZFEEs04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+xLwf26qjs6pwp8lIO9sni7zznoBUbP3V3D2PB3TdH7Y7ziNkoF+/ikpxYe/A7fy
	 61G1Z/FJgyYrRl9B/MKhptT0XRc8AJxd1cB0Heb4D0/FTa8chvW0EBNC5pxR6rxzfg
	 5AwNtukANfb8n9QLUte62gD/BZODY0u1oBASbAvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lijuan Gao <lijuan.gao@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 041/480] arm64: dts: qcom: sa8775p: Correct the interrupt for remoteproc
Date: Tue, 12 Aug 2025 19:44:09 +0200
Message-ID: <20250812174359.098663289@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lijuan Gao <lijuan.gao@oss.qualcomm.com>

[ Upstream commit 7bd7209e9cb11c8864e601d915008da088476f0c ]

Fix the incorrect IRQ numbers for ready and handover on sa8775p.
The correct values are as follows:

Fatal interrupt - 0
Ready interrupt - 1
Handover interrupt - 2
Stop acknowledge interrupt - 3

Fixes: df54dcb34ff2e ("arm64: dts: qcom: sa8775p: add ADSP, CDSP and GPDSP nodes")
Signed-off-by: Lijuan Gao <lijuan.gao@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250612-correct_interrupt_for_remoteproc-v1-2-490ee6d92a1b@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p.dtsi b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
index 2010b7988b6c..958e4be164d8 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p.dtsi
@@ -4663,8 +4663,8 @@ remoteproc_gpdsp0: remoteproc@20c00000 {
 
 			interrupts-extended = <&intc GIC_SPI 768 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_gpdsp0_in 0 0>,
-					      <&smp2p_gpdsp0_in 2 0>,
 					      <&smp2p_gpdsp0_in 1 0>,
+					      <&smp2p_gpdsp0_in 2 0>,
 					      <&smp2p_gpdsp0_in 3 0>;
 			interrupt-names = "wdog", "fatal", "ready",
 					  "handover", "stop-ack";
@@ -4706,8 +4706,8 @@ remoteproc_gpdsp1: remoteproc@21c00000 {
 
 			interrupts-extended = <&intc GIC_SPI 624 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_gpdsp1_in 0 0>,
-					      <&smp2p_gpdsp1_in 2 0>,
 					      <&smp2p_gpdsp1_in 1 0>,
+					      <&smp2p_gpdsp1_in 2 0>,
 					      <&smp2p_gpdsp1_in 3 0>;
 			interrupt-names = "wdog", "fatal", "ready",
 					  "handover", "stop-ack";
@@ -4847,8 +4847,8 @@ remoteproc_cdsp0: remoteproc@26300000 {
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp0_in 0 IRQ_TYPE_EDGE_RISING>,
-					      <&smp2p_cdsp0_in 2 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp0_in 1 IRQ_TYPE_EDGE_RISING>,
+					      <&smp2p_cdsp0_in 2 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp0_in 3 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "wdog", "fatal", "ready",
 					  "handover", "stop-ack";
@@ -4979,8 +4979,8 @@ remoteproc_cdsp1: remoteproc@2a300000 {
 
 			interrupts-extended = <&intc GIC_SPI 798 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp1_in 0 IRQ_TYPE_EDGE_RISING>,
-					      <&smp2p_cdsp1_in 2 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp1_in 1 IRQ_TYPE_EDGE_RISING>,
+					      <&smp2p_cdsp1_in 2 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp1_in 3 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "wdog", "fatal", "ready",
 					  "handover", "stop-ack";
@@ -5135,8 +5135,8 @@ remoteproc_adsp: remoteproc@30000000 {
 
 			interrupts-extended = <&pdc 6 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
-					      <&smp2p_adsp_in 2 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 1 IRQ_TYPE_EDGE_RISING>,
+					      <&smp2p_adsp_in 2 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 3 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "wdog", "fatal", "ready", "handover",
 					  "stop-ack";
-- 
2.39.5



