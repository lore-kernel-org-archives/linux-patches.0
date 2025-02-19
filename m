Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 889C71C7019;
	Wed, 19 Feb 2025 09:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956457; cv=none; b=B6/NU0L+EacAB/B9+grIvn03RImNxzgt94+QUDTU5g+QIqWAy68Mh/xj/MQbOGe1Z1U29sS4PZ9vkW93A+QFJgoRtlOk4ndcV32h74c03G1GgkW3Y+fHpf7C2sa2IrLUsdeOO+XIZSm/41fyoIYCZ5PGFICWl1hSqg0/fr8madw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956457; c=relaxed/simple;
	bh=qkcrz2yFAdITE+MLMCPdgtfAwPG68vCedTiD8Xyz7TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lHTtb5upqFbm1qsjE0BZO/phH5NJlTLmvpZ85Bsnuu4D3sUE6NCGTDcOtMf8/Yb+VZy4MRMbwpVItD+h3rgZQt6VA9O1RnJxyr5RXFBQm59UcVhCMdabgZ6buaUG1x0YI8afmgvZ/u2nl1jqDtU1wphpKU+wR3hBqj8vKIAy2Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fcm0von9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fcm0von9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C92C4CED1;
	Wed, 19 Feb 2025 09:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956457;
	bh=qkcrz2yFAdITE+MLMCPdgtfAwPG68vCedTiD8Xyz7TU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fcm0von99xiyvKdNnaJwDP+OlGBL6IjP2TTcLBccffze8t1U8dYZyiW+hpinBYh5A
	 cIzMpKtQBTL3Zu7tFo1nNe3597NQoeekV/7oYeZ+uFpbxvNZpqS6honYEfeME/WfQM
	 5AN7bJlXqzTTNk0Z6WAymDG1BInYxt4uewMoCW0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/578] arm64: dts: qcom: sc8280xp: Fix up remoteproc register space sizes
Date: Wed, 19 Feb 2025 09:23:01 +0100
Message-ID: <20250219082659.930084739@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 7ec7e327286182c65d0b5b81dff498d620fe9e8c ]

Make sure the remoteproc reg ranges reflect the entire register space
they refer to.

Since they're unused by the driver, there's no functional change.

Fixes: 152d1faf1e2f ("arm64: dts: qcom: add SC8280XP platform")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Link: https://lore.kernel.org/r/20241212-topic-8280_rproc_reg-v1-1-bd1c696e91b0@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 7e3aaf5de3f5c..6b0d4bc6c5419 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -1119,7 +1119,7 @@
 
 		remoteproc_adsp: remoteproc@3000000 {
 			compatible = "qcom,sc8280xp-adsp-pas";
-			reg = <0 0x03000000 0 0x100>;
+			reg = <0 0x03000000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 162 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -1806,7 +1806,7 @@
 
 		remoteproc_nsp0: remoteproc@1b300000 {
 			compatible = "qcom,sc8280xp-nsp0-pas";
-			reg = <0 0x1b300000 0 0x100>;
+			reg = <0 0x1b300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_nsp0_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -1937,7 +1937,7 @@
 
 		remoteproc_nsp1: remoteproc@21300000 {
 			compatible = "qcom,sc8280xp-nsp1-pas";
-			reg = <0 0x21300000 0 0x100>;
+			reg = <0 0x21300000 0 0x10000>;
 
 			interrupts-extended = <&intc GIC_SPI 887 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_nsp1_in 0 IRQ_TYPE_EDGE_RISING>,
-- 
2.39.5



