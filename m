Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D561A168B4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 09:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034D1C4339B;
	Mon,  8 May 2023 09:57:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683539847;
	bh=6wYXNBTZ4x0jV1UClvCRWnfr1suepy1nKzQn5N5Aa8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnjgpuFm4JJakR5X2aCKErDyLA5dHVIzpXwjyzhpvA5TGQxfUVFIe71VFytVmCl6k
	 jlTOIQ0Qe5V6XUbLNHK/zRtpu92usQ5CCbiukyIuCNXbkDNtKCb6EpVKf67UUIbgvT
	 fFwRrsiuEzq7AOuwEAJZH6YvekSLeg7JWKBdwLkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Souradeep Chowdhury <quic_schowdhu@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/611] arm64: dts: qcom: sc7280: fix EUD port properties
Date: Mon,  8 May 2023 11:39:58 +0200
Message-Id: <20230508094427.371450553@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a369c74243ca4ad60b9de0ac5c2207fb4c4117b8 ]

Nodes with unit addresses must have also 'reg' property:

  sc7280-herobrine-crd.dtb: eud@88e0000: ports:port@0: 'reg' is a required property

Fixes: 0b059979090d ("arm64: dts: qcom: sc7280: Add EUD dt node and dwc3 connector")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Souradeep Chowdhury <quic_schowdhu@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230308125906.236885-10-krzysztof.kozlowski@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 346da6af51ac9..023ce83f88dce 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -3590,12 +3590,17 @@
 			      <0 0x88e2000 0 0x1000>;
 			interrupts-extended = <&pdc 11 IRQ_TYPE_LEVEL_HIGH>;
 			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
 				port@0 {
+					reg = <0>;
 					eud_ep: endpoint {
 						remote-endpoint = <&usb2_role_switch>;
 					};
 				};
 				port@1 {
+					reg = <1>;
 					eud_con: endpoint {
 						remote-endpoint = <&con_eud>;
 					};
@@ -3606,7 +3611,11 @@
 		eud_typec: connector {
 			compatible = "usb-c-connector";
 			ports {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
 				port@0 {
+					reg = <0>;
 					con_eud: endpoint {
 						remote-endpoint = <&eud_con>;
 					};
-- 
2.39.2



