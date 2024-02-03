Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6C910A09;
	Sat,  3 Feb 2024 04:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933577; cv=none; b=WNZClKDrwgwemqBqMdGjWBd/Gz7FFmmk2QNjAk1tAk+LtjxSxSNlaVVB7jfrmvbBWcxeW6xrkhgzG3V5tSrxwvsGjqTTOr+pWjTNe7IFijSbjJG3riZPbMNID9hl5ldT3VlE8OiotZc9/UUb2h1eQO2m/AKxxK8dMlka+zfRe5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933577; c=relaxed/simple;
	bh=NOdxeJu9orPyAO2KV9daU7o96hPIqkIUXLZGsAftCsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3FgVkH84hbcwoZ3JNabZtmv8jvUUTSP/aJAsUsR2NPNDFLpyX85iTl2ekKxRFku3aCxaqM7/TKI3wVNixol6nTgBUKSzbd4FmZLLQjpl6ckEzocHKmPNI7xvV004aTYWSDQ3rbK6xGEDF1PMULcFMckybkExnDhLAtqoncLGQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5PLmvHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5PLmvHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29657C433C7;
	Sat,  3 Feb 2024 04:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933577;
	bh=NOdxeJu9orPyAO2KV9daU7o96hPIqkIUXLZGsAftCsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q5PLmvHuwGQ7nNX8H3OQ/yrxgS3RKmAFZQIquYMZZR3uF4UmIwTzLhBSgywWo5eOL
	 uep1RqTxWxO/AykMYIbSfY0f25239mtmOgoTBsN/p0aGcYC6O4kX4Jga5csfinUnX8
	 KFWREnOXdPwHFGhx4r2KIlGdtDG+j9qKLwKcy1Cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Mao Jinlong <quic_jinlmao@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/322] arm64: dts: qcom: Fix coresight warnings in in-ports and out-ports
Date: Fri,  2 Feb 2024 20:03:54 -0800
Message-ID: <20240203035403.577094943@linuxfoundation.org>
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

From: Mao Jinlong <quic_jinlmao@quicinc.com>

[ Upstream commit bdb6339fd46b8702ea7411b0b414587b86a40562 ]

When a node is only one in port or one out port, address-cells and
size-cells are not required in in-ports and out-ports. And the number
and reg of the port need to be removed.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Mao Jinlong <quic_jinlmao@quicinc.com>
Link: https://lore.kernel.org/r/20231210072633.4243-5-quic_jinlmao@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi |  5 +----
 arch/arm64/boot/dts/qcom/sm8150.dtsi |  5 +----
 arch/arm64/boot/dts/qcom/sm8250.dtsi | 24 ++++--------------------
 3 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 63f6515692e8..234d7875cd8e 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -3555,11 +3555,8 @@
 			};
 
 			in-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
 
-				port@1 {
-					reg = <1>;
+				port {
 					etf_in: endpoint {
 						remote-endpoint =
 						  <&merge_funnel_out>;
diff --git a/arch/arm64/boot/dts/qcom/sm8150.dtsi b/arch/arm64/boot/dts/qcom/sm8150.dtsi
index f7e35e220018..26b6d84548a5 100644
--- a/arch/arm64/boot/dts/qcom/sm8150.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150.dtsi
@@ -2973,11 +2973,8 @@
 			};
 
 			in-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
 
-				port@1 {
-					reg = <1>;
+				port {
 					replicator1_in: endpoint {
 						remote-endpoint = <&replicator_out1>;
 					};
diff --git a/arch/arm64/boot/dts/qcom/sm8250.dtsi b/arch/arm64/boot/dts/qcom/sm8250.dtsi
index 1a98481d0c7f..64a656dcfa1f 100644
--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2830,11 +2830,8 @@
 			clock-names = "apb_pclk";
 
 			out-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
 
-				port@0 {
-					reg = <0>;
+				port {
 					tpda_out_funnel_qatb: endpoint {
 						remote-endpoint = <&funnel_qatb_in_tpda>;
 					};
@@ -2877,11 +2874,7 @@
 			};
 
 			in-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port@0 {
-					reg = <0>;
+				port {
 					funnel_qatb_in_tpda: endpoint {
 						remote-endpoint = <&tpda_out_funnel_qatb>;
 					};
@@ -3090,11 +3083,8 @@
 			};
 
 			in-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
 
-				port@0 {
-					reg = <0>;
+				port {
 					etf_in_funnel_swao_out: endpoint {
 						remote-endpoint = <&funnel_swao_out_etf>;
 					};
@@ -3178,8 +3168,6 @@
 			clock-names = "apb_pclk";
 
 			out-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
 				port {
 					tpdm_mm_out_tpda9: endpoint {
 						remote-endpoint = <&tpda_9_in_tpdm_mm>;
@@ -3445,11 +3433,7 @@
 			};
 
 			in-ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				port@0 {
-					reg = <0>;
+				port {
 					funnel_apss_merg_in_funnel_apss: endpoint {
 					remote-endpoint = <&funnel_apss_out_funnel_apss_merg>;
 					};
-- 
2.43.0



