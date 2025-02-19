Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E4A1B6D0F;
	Wed, 19 Feb 2025 09:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956423; cv=none; b=IWrxYj65JMiF27FvHrdggkVJujC/qWFOy4kcB/ih6re7TUQuqPTQkaHq4976h8qxY45Rn9Td6hn/cai5c5aEaHPpZRn+eHpXgE0RGQbcWCFcU6dviazRC0/TbHHzAnm+Kj2n9Iot4y0G3jvRbXoqDV+5HxqsKSv3LZqVVNxh7lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956423; c=relaxed/simple;
	bh=5QX3X+c+7Cgxeg3LBTV/0lXxiAZSZnjqMqHyAhshHuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xysu7llfVCEfe+43sknpuSZM+t5ZGby0Ts07tnLSSzGXcfvSBbqzVJqlbdzpsryYCAR1dihcWIINbnCNBhGSyHRjy7OFmLsAaJ+7YkpL4Kh/BzpVE+uUFA/b2B7CKZwWzXmEK1pEXDfJPWYAvUNlVu6d5TTIN/8GdLR3ZU3ON38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LxrGHuRR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LxrGHuRR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0102FC4CED1;
	Wed, 19 Feb 2025 09:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956423;
	bh=5QX3X+c+7Cgxeg3LBTV/0lXxiAZSZnjqMqHyAhshHuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LxrGHuRRgChlwSLF70KMnTxsTPg/ZYWTp24cIpZXJWwY4Si+CE93qay5zcfvbszGq
	 r/w4WOxvftKjCl1hUfcMwvsfcaJCvIjVdnUSeVYOsPpNWOBWxLjoVrWbAd/+WRl8lK
	 Ed3zXasoK3uE9/Rp01dUMbLLWuuqXhcn9drX5KBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Weiss <luca.weiss@fairphone.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 173/578] arm64: dts: qcom: pm6150l: add temp sensor and thermal zone config
Date: Wed, 19 Feb 2025 09:22:57 +0100
Message-ID: <20250219082659.775193528@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luca Weiss <luca.weiss@fairphone.com>

[ Upstream commit ce1b5eb74b3ef042b1c797f04e8683e7cad34ae6 ]

Add temp-alarm device tree node and a default configuration for the
corresponding thermal zone for this PMIC. Temperatures are based on
downstream values, except for trip2 where 125°C is used instead of 145°C
due to limitations without a configured ADC.

Signed-off-by: Luca Weiss <luca.weiss@fairphone.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221028075405.124809-2-luca.weiss@fairphone.com
Stable-dep-of: 9180b38d706c ("arm64: dts: qcom: sc7180-trogdor-pompom: rename 5v-choke thermal zone")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm6150l.dtsi | 38 +++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/pm6150l.dtsi b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
index 06d729ff65a9d..ac3c6456c47c7 100644
--- a/arch/arm64/boot/dts/qcom/pm6150l.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm6150l.dtsi
@@ -5,6 +5,37 @@
 #include <dt-bindings/interrupt-controller/irq.h>
 #include <dt-bindings/spmi/spmi.h>
 
+/ {
+	thermal-zones {
+		pm6150l-thermal {
+			polling-delay-passive = <0>;
+			polling-delay = <0>;
+
+			thermal-sensors = <&pm6150l_temp>;
+
+			trips {
+				trip0 {
+					temperature = <95000>;
+					hysteresis = <0>;
+					type = "passive";
+				};
+
+				trip1 {
+					temperature = <115000>;
+					hysteresis = <0>;
+					type = "hot";
+				};
+
+				trip2 {
+					temperature = <125000>;
+					hysteresis = <0>;
+					type = "critical";
+				};
+			};
+		};
+	};
+};
+
 &spmi_bus {
 	pm6150l_lsid4: pmic@4 {
 		compatible = "qcom,pm6150l", "qcom,spmi-pmic";
@@ -12,6 +43,13 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 
+		pm6150l_temp: temp-alarm@2400 {
+			compatible = "qcom,spmi-temp-alarm";
+			reg = <0x2400>;
+			interrupts = <0x4 0x24 0x0 IRQ_TYPE_EDGE_BOTH>;
+			#thermal-sensor-cells = <0>;
+		};
+
 		pm6150l_adc: adc@3100 {
 			compatible = "qcom,spmi-adc5";
 			reg = <0x3100>;
-- 
2.39.5



