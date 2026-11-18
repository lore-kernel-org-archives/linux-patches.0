Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023524;
	b=YlzN7stukqe6fmmeiOG8XV3jxGVbulz8voJwcrS+1cX3PTTnDTKXTFyPtFjxZxEHmwqL
	 3uCKhs+lMi6+bgRujzKyXZdQjmAoXytK6Z7KH093jeliCfgNmcXcdPEYhOPs2nUz6PnSv
	 zrpvC+XWectQNjQNeNaxeiFlHFNNiTyHtt7IFxAm1mX4kP92O7S/ZzyWhmDQwjRNIn07q
	 8VwkSWDyaKbtgSqx0zpj/7Y1UnlRQ5AwSklKEcvwVIVx7FeEGFwUrJkgNEk0i2CViQuQO
	 AIF8/DU6p0huau3vDQd69pmXtsbDHwnyYCtPw6joC1/EQ5imAW/uQk5DbDkY27h3fcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PF/+HaDaPAFpbK6eMB8LfDy2mqo8e02MjEua6Fup2BA=;
	b=yxsx+I+1bUtoUlcaNMwoU/APr1RKGGg5swtJ/XffDyMxS27QOMTKhqE7KbwojZSj+8J6
	 GMBBmowTSFHKIXl1bWYJSPXvv6q1uw7/KmSIa+yfxPRIpWBp2HaiZTps7xDq59SbWpRDo
	 e8VM6TeKLHMyXqs/1UV6Sh2estKrTE2BVZf9agQHvzXJ9Sbfd9d9KD/mpz4AjGxa0mULL
	 poL8RnsI0O58GrUOQCLtoTvl2ymuw5hlbadeqXHtGy81NvKzZGEnhXa28FqpAKJLOHv5Z
	 JLeRDmrZ056hC9+/QKyunUjc/hVQzIQnviq3bFXwRiEFGLIbFa1fGKRf8Zn4GmIpfsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+oqDNvO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2080B606A320;
	Wed, 18 Nov 2026 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a+oqDNvO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 661231F000C4;
	Wed, 18 Nov 2026 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023523;
	bh=PF/+HaDaPAFpbK6eMB8LfDy2mqo8e02MjEua6Fup2BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a+oqDNvOKYztA71QxA7RR6ALIUMPoyLpH2yVkk6kAN0B/cbM54lTRP6YtU81/dNzz
	 Vs+bVjzLtTgaBNPU3WyeZA1kjdy21Jo3IdXhjFGQRZ2nkvXAsZYXcOZ3KDgWfXcPQq
	 xtmDOjP6SqrwlZgAutE8frv36Upn7VYh9YXTC8v4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alain Volmat <alain.volmat@foss.st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0401/2151] ARM: dts: stm32: add LTDC / DCMIPP access controller for STM32MP135
Date: Wed, 18 Nov 2026 15:35:36 +0100
Message-ID: <20261118150136.669025348@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



