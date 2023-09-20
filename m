Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D41A347CB
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4201DC433C9;
	Wed, 20 Sep 2023 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213005;
	bh=xCoZ510v+maRK4Bh4zpsqyDAymm7FfEwN47ZFz5H1sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pUzoNVKR3kWvEWs4P9ZUxF51KCSEuwyD82QgipyojmPaWBX+wOqRfdRxfOduEBVVJ
	 6YAJf3sQVTbxGxFa9AT42N9eQv0InnRvxS4OHFazUFQ/CfJpPiTEI3oKvEYrgtcIY2
	 XV6kUFXvce8l10n5ZLf3tNMB6E/ARG+j+Aai49qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/367] ARM: dts: s3c6410: move fixed clocks under root node in Mini6410
Date: Wed, 20 Sep 2023 13:27:55 +0200
Message-ID: <20230920112901.094318078@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 8b81a8decea77bf2ca3c718732184d4aaf949096 ]

The fixed clocks are kept under dedicated 'clocks' node but this causes
multiple dtschema warnings:

  clocks: $nodename:0: 'clocks' does not match '^([a-z][a-z0-9\\-]+-bus|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
  clocks: #size-cells:0:0: 0 is not one of [1, 2]
  clocks: oscillator@0:reg:0: [0] is too short
  clocks: oscillator@1:reg:0: [1] is too short
  clocks: 'ranges' is a required property
  oscillator@0: 'reg' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200907183313.29234-3-krzk@kernel.org
Stable-dep-of: cf0cb2af6a18 ("ARM: dts: samsung: s3c6410-mini6410: correct ethernet reg addresses (split)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s3c6410-mini6410.dts | 30 ++++++++++----------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/arm/boot/dts/s3c6410-mini6410.dts b/arch/arm/boot/dts/s3c6410-mini6410.dts
index 1aeac33b0d341..75067dbcf7e83 100644
--- a/arch/arm/boot/dts/s3c6410-mini6410.dts
+++ b/arch/arm/boot/dts/s3c6410-mini6410.dts
@@ -28,26 +28,18 @@ chosen {
 		bootargs = "console=ttySAC0,115200n8 earlyprintk rootwait root=/dev/mmcblk0p1";
 	};
 
-	clocks {
-		compatible = "simple-bus";
-		#address-cells = <1>;
-		#size-cells = <0>;
-
-		fin_pll: oscillator@0 {
-			compatible = "fixed-clock";
-			reg = <0>;
-			clock-frequency = <12000000>;
-			clock-output-names = "fin_pll";
-			#clock-cells = <0>;
-		};
+	fin_pll: oscillator-0 {
+		compatible = "fixed-clock";
+		clock-frequency = <12000000>;
+		clock-output-names = "fin_pll";
+		#clock-cells = <0>;
+	};
 
-		xusbxti: oscillator@1 {
-			compatible = "fixed-clock";
-			reg = <1>;
-			clock-output-names = "xusbxti";
-			clock-frequency = <48000000>;
-			#clock-cells = <0>;
-		};
+	xusbxti: oscillator-1 {
+		compatible = "fixed-clock";
+		clock-output-names = "xusbxti";
+		clock-frequency = <48000000>;
+		#clock-cells = <0>;
 	};
 
 	srom-cs1@18000000 {
-- 
2.40.1



