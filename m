Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029500;
	b=xDyh8B1gjqFEEcmVb69awh7Zmv9U7pOb3t9QmwtamRZJVfpMNIe1YAzYCcD2oLDLvvTF
	 GY2hwJDi5YQ6252Y3kj51Csta/uyJzveizcS3mMUajGJJnRO2kyJynfQ3/dfii/8yh01b
	 F5Mt8yO+p+QR9kqtzjFnmbnlhG9FitBfMLfyk5J8QRTYgGyVbW2TXJSUzDlpzfSb4HR7x
	 cR3Vo+HbEyw6WZDCTMGrq6KUcbk7J/T0eE38L/YGBN89KKmzIRVItBHnmG3DHlrwWgSlK
	 hjqoPwkZt7sDxTbdBMfcLR1y7+PfnA6Z1nSQjXMPnUwKzfFTLlcR3zRgLOI/LmwczgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029500;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApbdGtUX+s3xaV2JxuDDOt32wASv79qwDz+L1cKHyhA=;
	b=clSgfeA68zbZOqbRUVRbsTP5hraknpjFV5ZWn8Jh0MOyxierctkj/sY7AtHG9D0z6GQd
	 Rh1dnB3hzz2IDEkcPu4X2OlqXwwa7G0WEd0R0gnHTLSAk4PdYzlI3HXAA2WWHjwKpj6k9
	 5DmwdQBMvHnM7YZueYZF6fY3S1degp3TNpto8hiLVtdvQHptZpsyQiqpJSK2aPTIXK/fv
	 nSrp009n1ocKKJTspONXlIMk7GFkA/q545DcZvdcKNNFDM69F5E9gmXOnzLtwVi57w6F4
	 NIOYPoo5bgKFltbFJI4TWQ9OUSzFByzijqX6vOSeaHiUBJRr0b9T3RsCM1Yc2YzMNqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nxTX75u/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A035D606A32A;
	Wed, 18 Nov 2026 19:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nxTX75u/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30121F000C5;
	Wed, 18 Nov 2026 19:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029500;
	bh=ApbdGtUX+s3xaV2JxuDDOt32wASv79qwDz+L1cKHyhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxTX75u/xbpK1aIWuTs9Ar8WkNql1jCzAbYR+A3MMCizGouX9iDDIQyioI0OqWnjM
	 hsyEJNvciVDBnu718qGuTM6vkHlL3cIXCh9S6SqX3vG4WDz+idiiuB7SZeLtsc3sJH
	 woXvJ/t++wGQEN6rqXP5o9hxP1UtDTIebm1LZl/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0369/1756] ARM: dts: stm32: add LTDC / DCMIPP access controller for STM32MP135
Date: Wed, 18 Nov 2026 15:41:36 +0100
Message-ID: <20261118150023.120451577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alain Volmat <alain.volmat@foss.st.com>

[ Upstream commit 0c354b85cc95b5d563a581c8dbca57b4942bfae7 ]

Add ETZPC as an access controller for the LTDC and DCMIPP found
on the stm32mp135.

Fixes: a06b9560eb6c ("ARM: dts: stm32: add ETZPC as a system bus for STM32MP13x boards")

Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://lore.kernel.org/r/20260721-etzpc-mp13-ltdc-dcmipp-fix-v1-1-a969f2ab8da1@foss.st.com
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/st/stm32mp135.dtsi | 42 ++++++++++++++--------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/arch/arm/boot/dts/st/stm32mp135.dtsi b/arch/arm/boot/dts/st/stm32mp135.dtsi
index 834a4d545fe44..f573335edf6b4 100644
--- a/arch/arm/boot/dts/st/stm32mp135.dtsi
+++ b/arch/arm/boot/dts/st/stm32mp135.dtsi
@@ -6,29 +6,29 @@
 
 #include "stm32mp133.dtsi"
 
-/ {
-	soc {
-		dcmipp: dcmipp@5a000000 {
-			compatible = "st,stm32mp13-dcmipp";
-			reg = <0x5a000000 0x400>;
-			interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
-			resets = <&rcc DCMIPP_R>;
-			clocks = <&rcc DCMIPP_K>;
-			status = "disabled";
+&etzpc {
+	dcmipp: dcmipp@5a000000 {
+		compatible = "st,stm32mp13-dcmipp";
+		reg = <0x5a000000 0x400>;
+		interrupts = <GIC_SPI 79 IRQ_TYPE_LEVEL_HIGH>;
+		resets = <&rcc DCMIPP_R>;
+		clocks = <&rcc DCMIPP_K>;
+		access-controllers = <&etzpc 4>;
+		status = "disabled";
 
-			port {
-			};
+		port {
 		};
+	};
 
-		ltdc: display-controller@5a001000 {
-			compatible = "st,stm32-ltdc";
-			reg = <0x5a001000 0x400>;
-			interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&rcc LTDC_PX>;
-			clock-names = "lcd";
-			resets = <&scmi_reset RST_SCMI_LTDC>;
-			status = "disabled";
-		};
+	ltdc: display-controller@5a001000 {
+		compatible = "st,stm32-ltdc";
+		reg = <0x5a001000 0x400>;
+		interrupts = <GIC_SPI 88 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 89 IRQ_TYPE_LEVEL_HIGH>;
+		clocks = <&rcc LTDC_PX>;
+		clock-names = "lcd";
+		resets = <&scmi_reset RST_SCMI_LTDC>;
+		access-controllers = <&etzpc 3>;
+		status = "disabled";
 	};
 };
-- 
2.53.0



