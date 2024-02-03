Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753571BDE6;
	Sat,  3 Feb 2024 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933792; cv=none; b=LPgFi2BrtB3gakkC73eYs/FQ6ZnCykUcDxEDpxkh9TDEjjGpuPvmJPEonLb0/K9ndVicdtLF/7ooMNtyG8mUnbMs99aSeZ0lh2RTnzKHI7ikEYQrF3T9KzW2QHIPXZTZdo7BQZtXL1AfrcR9GQdI+VTdMsMKn0XfuN0FKjLsY0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933792; c=relaxed/simple;
	bh=qHPtUKLWPAtmvtFT34mZVsuG4+286JfaA4f/+PsmdWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpZb2ZAlsIEfDESIorM9iuuVXVFekkK6B6KWvFUyVCiQceqsPS808lFIjZ4xLm34q4hrAGOZWpuGSjWiwBPXtbpblfjwbIKlO+icsHFo+q5XuoVkltFJhPD44p118UdlbmzhOGHXxQ+XDBbvdJqSffcy/82WzsfpnwvKWitss2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oIPElXsb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oIPElXsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C708C433F1;
	Sat,  3 Feb 2024 04:16:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933792;
	bh=qHPtUKLWPAtmvtFT34mZVsuG4+286JfaA4f/+PsmdWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIPElXsbXLsigU0o4zKfxg+hnzV+RgcotpmHjI8UyKkd9TqwNdMFfUNT0J2QHgv3X
	 CRM3mnp1cPevgJUI2ckUy+4xCXhnpgzTWaWS2YesrikIft7h0hx6FD7e7pqSqI6SIF
	 weuYzsd6HE4vB/Pv/jVnNgGHxnBWhYaNEIV3GLN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 102/353] arm64: dts: qcom: sm8450: fix soundwire controllers node name
Date: Fri,  2 Feb 2024 20:03:40 -0800
Message-ID: <20240203035407.008833615@linuxfoundation.org>
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
index dc904ccb3d6c..f82480570d4b 100644
--- a/arch/arm64/boot/dts/qcom/sm8450.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8450.dtsi
@@ -2160,7 +2160,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr4: soundwire-controller@31f0000 {
+		swr4: soundwire@31f0000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x031f0000 0 0x2000>;
 			interrupts = <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
@@ -2208,7 +2208,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr1: soundwire-controller@3210000 {
+		swr1: soundwire@3210000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x03210000 0 0x2000>;
 			interrupts = <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
@@ -2275,7 +2275,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr0: soundwire-controller@3250000 {
+		swr0: soundwire@3250000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x03250000 0 0x2000>;
 			interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>;
@@ -2302,7 +2302,7 @@
 			status = "disabled";
 		};
 
-		swr2: soundwire-controller@33b0000 {
+		swr2: soundwire@33b0000 {
 			compatible = "qcom,soundwire-v1.7.0";
 			reg = <0 0x033b0000 0 0x2000>;
 			interrupts = <GIC_SPI 496 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



