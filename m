Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016115;
	b=qaSXnR0jHZAIavy5uJmHJqTD2B9tgtr0n/VLvPCGv+pUi6hVATrakwo5XfIICkJ/9VtR
	 j80J4rpF8iXrp1gZWFtNnFMtyNoPs189dpmMhExs8bK7SDHWErwgOllole7Cd83o8mpPI
	 9G1eCRJ9gcAr74Jfy/z7CZXNuzfjb4oDytUB5YgMGndOkCgLzBq93OK5UUroeMrwIAjeq
	 /E7eeTf+RU3GXZusLkDKPBN8AaH5HvvmqtcDl9JXgU8e51K4hGBD8TzlXCBSQLBwlHq5Z
	 zwYAfxFSFKpfNLvI49DWyNoILPYfIymIlPQvsaiCBFP1TF4vSlqL14Av3RI8Ig0ozrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hBD8vGBsa1OCgtpELIIP36vr1KGEw3YHf7npRm8RhLI=;
	b=3MYlQNwHXHmXRYIbCnlOMKcsEgxIbo/zJHNkaVP32+40Sf4jrxoA7HlD3E8mseg1kAhX
	 tCdneFvwzIqT8/peUybxamodqdJp1I8YQZQS00DPz+O4982QBjd7iy7M5N73wLs7vl8kr
	 V5vXqpDXMJVQ4AiGtsVGrQkEi2Dsp/5Q13DFwA8JwfV9TQ41r7lrNg8yVO9iSIPIqFdDS
	 ySTm1+9wPc6bGu5FMGSWN+zIhXxYvZ4K3xFZ5c9NhlDbbeV+8JJ78Ya5pteu6WF+zFgth
	 DREwCDSNac3m+uHVt0FbQJxOnBwvlJeJ38AXgth6hB5CrrehFcWI6vuvnE2gdFy4vlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6x2mz9j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E933B60A2629;
	Wed, 18 Nov 2026 15:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O6x2mz9j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D731F000CC;
	Wed, 18 Nov 2026 15:35:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016114;
	bh=hBD8vGBsa1OCgtpELIIP36vr1KGEw3YHf7npRm8RhLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6x2mz9j8NKJxmDycqk+Tkeuxl7fd/V1+8nrsLLm/GkB5WFLONjKU0OnfjmXUuW/I
	 alFjaRGWjkQTYYzkoFa4azG2+Nupbj9eRljaW/CawNeBW01+w+WMDMHuPtRDD6FkGz
	 UrY6AKa8+QNkxp/STOMIEvPAJMnGw805AjfD+ixw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0413/2651] ARM: dts: stm32: add LTDC / DCMIPP access controller for STM32MP135
Date: Wed, 18 Nov 2026 15:27:33 +0100
Message-ID: <20261118150302.704882989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



