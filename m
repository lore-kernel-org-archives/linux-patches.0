Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3889F1946C7;
	Wed,  5 Mar 2025 17:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197063; cv=none; b=bOuk/0kwO8kxBPOSjBi+cJcLFSGbHjda24tPfPG870z8LMS/gHXeOZBtEH8xW3iZ4HIv/yp+ycO4+YuGUC/KppkXwRD6gqd7Xo3bveOqo768VB/RDgS/8CbhTCVyfOwc4O7MPDjW8bL06ztSPN3O1D03W3LFYbGHUMzMFKx/NkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197063; c=relaxed/simple;
	bh=fe1nlH16gaU7hvAsmhp1s0UlvfmuhmsnoCa8wLOcD7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq2gBg8mnoXDIHWC2/4woIAOSFyZUwCZ7KcoKo+k7hHdCPl+TW9DA/nV0jwC31mCNnWzlyMbR3V+QXrg6ouvrADHqc5UYhkI/vEsRvAqDu5uM2PwdrBTn4aXyJSk4IeJvLDQ7Zy8ZkEEI8/CsGMvAAdJr8fHSVHGJRpC5aF6hsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7Y5x9+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7Y5x9+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D7AC4CED1;
	Wed,  5 Mar 2025 17:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197063;
	bh=fe1nlH16gaU7hvAsmhp1s0UlvfmuhmsnoCa8wLOcD7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7Y5x9+zu1jvcKJfZvAp9g8VjSU5BJQjbgSHWeEipcErJFtUdzBTGpf+INNafPhUH
	 wH1V4as1y+dGIBe+4p7Qn5/BYrukuEFvfatWN4gxfSZ/HN3DUMrxNKFk0M717sEJvd
	 g6cxlwpZBaxzqg5GVRykbIsddP3MnE6/6ZJ8ykHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 026/176] arm64: dts: qcom: trim addresses to 8 digits
Date: Wed,  5 Mar 2025 18:46:35 +0100
Message-ID: <20250305174506.513115197@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 22dbcfd6f4a9f7d4391f0aa66d3f46addea4bee9 ]

Hex numbers in addresses and sizes should be rather eight digits, not
nine.  Drop leading zeros.  No functional change (same DTB).

Suggested-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221115105046.95254-1-krzysztof.kozlowski@linaro.org
Stable-dep-of: 3751fe2cba2a ("arm64: dts: qcom: sm8450: Fix CDSP memory length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8350.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8350.dtsi b/arch/arm64/boot/dts/qcom/sm8350.dtsi
index 956237489bc46..5a4972afc9776 100644
--- a/arch/arm64/boot/dts/qcom/sm8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8350.dtsi
@@ -2226,7 +2226,7 @@
 
 		cdsp: remoteproc@98900000 {
 			compatible = "qcom,sm8350-cdsp-pas";
-			reg = <0 0x098900000 0 0x1400000>;
+			reg = <0 0x98900000 0 0x1400000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_LEVEL_HIGH>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,
diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 3f79aea644460..9151ed3b0a62f 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2093,7 +2093,7 @@
 
 		remoteproc_adsp: remoteproc@30000000 {
 			compatible = "qcom,sm8450-adsp-pas";
-			reg = <0 0x030000000 0 0x100>;
+			reg = <0 0x30000000 0 0x100>;
 
 			interrupts-extended = <&pdc 6 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_adsp_in 0 IRQ_TYPE_EDGE_RISING>,
@@ -2159,7 +2159,7 @@
 
 		remoteproc_cdsp: remoteproc@32300000 {
 			compatible = "qcom,sm8450-cdsp-pas";
-			reg = <0 0x032300000 0 0x1400000>;
+			reg = <0 0x32300000 0 0x1400000>;
 
 			interrupts-extended = <&intc GIC_SPI 578 IRQ_TYPE_EDGE_RISING>,
 					      <&smp2p_cdsp_in 0 IRQ_TYPE_EDGE_RISING>,
-- 
2.39.5



