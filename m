Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACB94CB47;
	Sat,  3 Feb 2024 04:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933791; cv=none; b=lzEXpSDdqA/JUMQIFXK95tpG/3G8pyaoYbzjHQVBjcnP8/H69cU1zfUwfc8MuLJ7IHaxuEZZ6Gjyo3FajsJ5woVby2bzYo7CgU3miJbQTpzKb7D3kG+tkRwj4crYX/DX+V0Pq4t1xD/jweC7//D2V4bnlt2/A1gqo0vbjitSNfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933791; c=relaxed/simple;
	bh=d4ESUat7mnNfkt10T7CzxBaddYWIv8su2cW/8ab3k7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j2COSduxmZtCFuaDi5VKF8WEBQSGKkBSjJngi+JxXRO6Tws4RL/tcsIGtHyIbA163eXUeOOVM4H52fckcNORUaxHbcnsL8tHMSDjvkW5CvZNd0rvRtuaNhAj1BqfcvFWAdFWrmN9ZuakpO45OEmrcs9Qj7lIzY5vVDSAv8igx4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1Y2c14c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1Y2c14c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82AA8C433A6;
	Sat,  3 Feb 2024 04:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933791;
	bh=d4ESUat7mnNfkt10T7CzxBaddYWIv8su2cW/8ab3k7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1Y2c14cBrtvMl5KIqvohGn4G0MxZOQ6MfVc9yzYAr+6c/XgwEJLR4cxDqpGyo/8s
	 ugP/nWrZp11KugTGf0kiFbyuHlWq9vQvgA8BqljVuoOtv7DFQEkqUQDZz22PnPlAE2
	 hvrj7Z43gzYXLeYK6/orV6YP24lJ+w6CDWMDGefA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 101/353] arm64: dts: qcom: sm8550: fix soundwire controllers node name
Date: Fri,  2 Feb 2024 20:03:39 -0800
Message-ID: <20240203035406.980654171@linuxfoundation.org>
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

[ Upstream commit 07c88da81caf0e72c3690b689d30f0d325cfeff4 ]

Fix the following dt bindings check:
arch/arm64/boot/dts/qcom/sm8550-mtp.dtb: soundwire-controller@6ab0000: $nodename:0: 'soundwire-controller@6ab0000' does not match '^soundwire(@.*)?$'
from schema $id: http://devicetree.org/schemas/soundwire/qcom,soundwire.yaml#

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20231106-topic-sm8550-upstream-soundwire-bindings-fix-v1-1-4ded91c805a1@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 5cf813a579d5..e15564ed54ce 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -2060,7 +2060,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr3: soundwire-controller@6ab0000 {
+		swr3: soundwire@6ab0000 {
 			compatible = "qcom,soundwire-v2.0.0";
 			reg = <0 0x06ab0000 0 0x10000>;
 			interrupts = <GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
@@ -2106,7 +2106,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr1: soundwire-controller@6ad0000 {
+		swr1: soundwire@6ad0000 {
 			compatible = "qcom,soundwire-v2.0.0";
 			reg = <0 0x06ad0000 0 0x10000>;
 			interrupts = <GIC_SPI 155 IRQ_TYPE_LEVEL_HIGH>;
@@ -2171,7 +2171,7 @@
 			#sound-dai-cells = <1>;
 		};
 
-		swr0: soundwire-controller@6b10000 {
+		swr0: soundwire@6b10000 {
 			compatible = "qcom,soundwire-v2.0.0";
 			reg = <0 0x06b10000 0 0x10000>;
 			interrupts = <GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>;
@@ -2198,7 +2198,7 @@
 			status = "disabled";
 		};
 
-		swr2: soundwire-controller@6d30000 {
+		swr2: soundwire@6d30000 {
 			compatible = "qcom,soundwire-v2.0.0";
 			reg = <0 0x06d30000 0 0x10000>;
 			interrupts = <GIC_SPI 496 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.43.0



