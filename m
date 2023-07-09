Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829BB522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:33:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064B4C433C7;
	Sun,  9 Jul 2023 11:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902397;
	bh=wwn6gTY0zKcfNNTELl8wpp1wC8Oz5cI+oRoIEGrsXzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ty5Tapdrv5EO0Fb/83MFy0ZhII0SS02Gh8UeLGhK912vcfJVPft7ljy8rGUztDQb9
	 zLFTHAtjbnGf+zYvDV0VAuVhHtJlj3kDRQg/8gPHtWwLXL+KZUx/NH06bPXJsx0tQY
	 HIrRIM2VM2M7twaUSg7lHfH39AdDeVlQwCeo3Pwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 335/431] MIPS: DTS: CI20: Add parent supplies to ACT8600 regulators
Date: Sun,  9 Jul 2023 13:14:43 +0200
Message-ID: <20230709111459.026697461@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit fbf1e42093f8d6346baf17079585fbcebb2ff284 ]

Provide parent regulators to the ACT8600 regulators that need one.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Stable-dep-of: 944520f85d5b ("MIPS: DTS: CI20: Raise VDDCORE voltage to 1.125 volts")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index 2b1284c6c64a6..eac6b3411b5f7 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -242,16 +242,19 @@ regulators {
 			vddcore: DCDC1 {
 				regulator-min-microvolt = <1100000>;
 				regulator-max-microvolt = <1100000>;
+				vp1-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			vddmem: DCDC2 {
 				regulator-min-microvolt = <1500000>;
 				regulator-max-microvolt = <1500000>;
+				vp2-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			vcc_33: DCDC3 {
 				regulator-min-microvolt = <3300000>;
 				regulator-max-microvolt = <3300000>;
+				vp3-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			vcc_50: SUDCDC_REG4 {
@@ -262,21 +265,25 @@ vcc_50: SUDCDC_REG4 {
 			vcc_25: LDO5 {
 				regulator-min-microvolt = <2500000>;
 				regulator-max-microvolt = <2500000>;
+				inl-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			wifi_io: LDO6 {
 				regulator-min-microvolt = <2500000>;
 				regulator-max-microvolt = <2500000>;
+				inl-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			cim_io_28: LDO7 {
 				regulator-min-microvolt = <2800000>;
 				regulator-max-microvolt = <2800000>;
+				inl-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			cim_io_15: LDO8 {
 				regulator-min-microvolt = <1500000>;
 				regulator-max-microvolt = <1500000>;
+				inl-supply = <&vcc_33v>;
 				regulator-always-on;
 			};
 			vrtc_18: LDO_REG9 {
-- 
2.39.2



