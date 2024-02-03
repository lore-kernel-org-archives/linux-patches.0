Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72C492C695;
	Sat,  3 Feb 2024 04:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933574; cv=none; b=C2zkd+dd5ZewkrXEMIm+J8xlGk8TLJrAV3vbComy3cSPFHIoxZbqqwfLkvZjypfKtINaqQlKs8u45bV25Thy7JvNIhi4KiOiBJ02z7SGe/juN+g7cORORBHSvUrYqwoB+Z/lXpjTdvQGHvVbSfXHvN5i5URq3rr9zPz5UFk+o+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933574; c=relaxed/simple;
	bh=NyEUorLdke72bZkrsnTJ90H4gVgCfSbJYCzdf8OcPkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7aWGGDFwdojnooCaHedO/cZcB9P5VcLZROPXQ6NRZ3Zmp4eFp59ss1hi32HFsvEaG79FEu9MRLm91pf/ImxqAoB5r/LJZDvRlHFeM7h2IcdUNbDATzBnwF8QSeWUQ9/2U6v773Yax5B29q/HON7OQf6CrRiKMYsF1xZUeke/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dheVVL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dheVVL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB5EC433F1;
	Sat,  3 Feb 2024 04:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933574;
	bh=NyEUorLdke72bZkrsnTJ90H4gVgCfSbJYCzdf8OcPkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0dheVVL+PvRMXzFcv+cg01cvRk9gSCdMhweTBEgMcJb/5jfnaKwlhZbEmIes5lgyz
	 9D/WvAq38jksgQ0Xoo2T/+mWkFhC2KJ5OM5ZIx4hOLxruHKmTk8gmu3SCohUT/XjRS
	 A2r+O3YIPu0vr6y2Zq2bRiWiG67YOJ2/9mLoUL1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/322] arm64: dts: qcom: sm8450: fix soundwire controllers node name
Date: Fri,  2 Feb 2024 20:03:20 -0800
Message-ID: <20240203035402.474859583@linuxfoundation.org>
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

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 11fcb81373de52eeb1d3ff135a8d24a4b18978d3 ]

Fix the following dt bindings check:
arch/arm64/boot/dts/qcom/sm8450-hdk.dtb: soundwire-controller@31f0000: $nodename:0: 'soundwire-controller@31f0000' does not match '^soundwire(@.*)?$'
        from schema $id: http://devicetree.org/schemas/soundwire/qcom,soundwire.yaml#

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231106-topic-sm8450-upstream-soundwire-bindings-fix-v1-1-41d4844a5a7d@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8450.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8450.dtsi b/arch/arm64/boot/dts/qcom/sm8450.dtsi
index 79cc8fbcd846..91d856e5b06b 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2176,7 +2176,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr4: soundwire-controller@31f0000 {
+		swr4: soundwire@31f0000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x031f0000 0 0x2000>;
 			interrupts = <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
@@ -2224,7 +2224,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr1: soundwire-controller@3210000 {
+		swr1: soundwire@3210000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x03210000 0 0x2000>;
 			interrupts = <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
@@ -2291,7 +2291,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr0: soundwire-controller@3250000 {
+		swr0: soundwire@3250000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x03250000 0 0x2000>;
 			interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>;
@@ -2318,7 +2318,7 @@
 			status = "disabled";
 		};
 
-		swr2: soundwire-controller@33b0000 {
+		swr2: soundwire@33b0000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x033b0000 0 0x2000>;
 			interrupts = <GIC_SPI 496 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



