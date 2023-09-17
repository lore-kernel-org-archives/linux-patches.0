Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B756AAC
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA40C433C7;
	Sun, 17 Sep 2023 20:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982061;
	bh=v+87mFBZhhIIN0WJkgXM9L5ZsAWqPMuRWGiqg2iA6nU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNmEZoe5xZ9ztsQZ976h5M4+T/07STYVrWib1MJA5DnLvKmUTqNQafkdONZX2P789
	 P4WwgQA5PHKTcYJY1YZroR2As0+xO7unNfrAiuhc+QPmc+JNAnGj8L2JvB/9v+OmH4
	 AVYsAsoojoWY9/NOfwVewwPr2p0m6yE6Jx88xo/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/511] arm64: dts: qcom: correct SPMI WLED register range encoding
Date: Sun, 17 Sep 2023 21:09:32 +0200
Message-ID: <20230917191117.358471812@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit d66b1d2e4afc0c8a9eb267740825240b67f6b1d1 ]

On PM660L, PMI8994 and PMI8998, the WLED has two address spaces and with
size-cells=0, they should be encoded as two separate items.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220505154702.422108-2-krzysztof.kozlowski@linaro.org
Stable-dep-of: 9a4ac09db3c7 ("arm64: dts: qcom: pm660l: Add missing short interrupt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm660l.dtsi  | 2 +-
 arch/arm64/boot/dts/qcom/pmi8994.dtsi | 2 +-
 arch/arm64/boot/dts/qcom/pmi8998.dtsi | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/pm660l.dtsi b/arch/arm64/boot/dts/qcom/pm660l.dtsi
index 05086cbe573be..536bf9920fa92 100644
--- a/arch/arm64/boot/dts/qcom/pm660l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm660l.dtsi
@@ -67,7 +67,7 @@ pmic@3 {
 
 		pm660l_wled: leds@d800 {
 			compatible = "qcom,pm660l-wled";
-			reg = <0xd800 0xd900>;
+			reg = <0xd800>, <0xd900>;
 			interrupts = <0x3 0xd8 0x1 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "ovp";
 			label = "backlight";
diff --git a/arch/arm64/boot/dts/qcom/pmi8994.dtsi b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
index a06ea9adae810..7b41c1ed464ac 100644
--- a/arch/arm64/boot/dts/qcom/pmi8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8994.dtsi
@@ -35,7 +35,7 @@ pmi8994_spmi_regulators: regulators {
 
 		pmi8994_wled: wled@d800 {
 			compatible = "qcom,pmi8994-wled";
-			reg = <0xd800 0xd900>;
+			reg = <0xd800>, <0xd900>;
 			interrupts = <3 0xd8 0x02 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "short";
 			qcom,num-strings = <3>;
diff --git a/arch/arm64/boot/dts/qcom/pmi8998.dtsi b/arch/arm64/boot/dts/qcom/pmi8998.dtsi
index 0fef5f113f05e..ef29e80c442c7 100644
--- a/arch/arm64/boot/dts/qcom/pmi8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmi8998.dtsi
@@ -44,7 +44,7 @@ lab: lab {
 
 		pmi8998_wled: leds@d800 {
 			compatible = "qcom,pmi8998-wled";
-			reg = <0xd800 0xd900>;
+			reg = <0xd800>, <0xd900>;
 			interrupts = <0x3 0xd8 0x1 IRQ_TYPE_EDGE_RISING>,
 				     <0x3 0xd8 0x2 IRQ_TYPE_EDGE_RISING>;
 			interrupt-names = "ovp", "short";
-- 
2.40.1



