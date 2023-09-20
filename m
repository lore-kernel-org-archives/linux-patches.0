Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F0E347A0
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6799EC433CB;
	Wed, 20 Sep 2023 12:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213016;
	bh=Wj2g9D0NUrgw7IJr5A9DZRiDxocmus20mLdrLkqFFG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0S+eILX/AeBTViQVHMJTE099yCeS1/GaevBww6ZDQvyWae0lsIJBYTIRQyexwps1
	 sedlZEcPN1TKNepJExLZ4vOWLg2drGjOnZtZj4PDtWboG2rqh8y2yhELkNM8c6cruS
	 3MxaNnnbkCdAsmyRIGMiETbpkxZTxj7bBs7Q+ZSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 102/367] ARM: dts: s5pv210: add RTC 32 KHz clock in SMDKV210
Date: Wed, 20 Sep 2023 13:27:59 +0200
Message-ID: <20230920112901.212713760@linuxfoundation.org>
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

[ Upstream commit 7260b363457a22b8723d5cbc43fee67397896d07 ]

The S3C RTC requires 32768 Hz clock as input which is provided by PMIC.
However the PMIC is not described in DTS at all so at least add
a workaround to model its clock with a fixed-clock.

This fixes dtbs_check warnings:

  rtc@e2800000: clocks: [[2, 145]] is too short
  rtc@e2800000: clock-names: ['rtc'] is too short

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20200907161141.31034-15-krzk@kernel.org
Stable-dep-of: 982655cb0e7f ("ARM: dts: samsung: s5pv210-smdkv210: correct ethernet reg addresses (split)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/s5pv210-smdkv210.dts | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/boot/dts/s5pv210-smdkv210.dts b/arch/arm/boot/dts/s5pv210-smdkv210.dts
index 84b38f1851991..1f20622da7194 100644
--- a/arch/arm/boot/dts/s5pv210-smdkv210.dts
+++ b/arch/arm/boot/dts/s5pv210-smdkv210.dts
@@ -31,6 +31,13 @@ memory@20000000 {
 		reg = <0x20000000 0x40000000>;
 	};
 
+	pmic_ap_clk: clock-0 {
+		/* Workaround for missing PMIC and its clock */
+		compatible = "fixed-clock";
+		#clock-cells = <0>;
+		clock-frequency = <32768>;
+	};
+
 	ethernet@18000000 {
 		compatible = "davicom,dm9000";
 		reg = <0xA8000000 0x2 0xA8000002 0x2>;
@@ -147,6 +154,8 @@ &uart3 {
 
 &rtc {
 	status = "okay";
+	clocks = <&clocks CLK_RTC>, <&pmic_ap_clk>;
+	clock-names = "rtc", "rtc_src";
 };
 
 &sdhci0 {
-- 
2.40.1



