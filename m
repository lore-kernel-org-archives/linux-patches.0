Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C027C16419;
	Sat,  3 Feb 2024 04:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933380; cv=none; b=gNizo6nEmtZfvfDvGLesHbNq1g9lX8jA3IwHUMbIQMMEvmAiCqQmuWxRrdp9LvYbnOMjdlo+8UiMDGe+DW+ULndAl8aKe8cJYGqSuFe/07yKSfaC6WZ75igYE2WjfrzvZvhjR+oRZCu78aTmxX1eVd4wmxEX6FNAV/wGkYU7D7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933380; c=relaxed/simple;
	bh=AXA2YAtHZsYhKItWyLpq1I1ezerIgpOlMl1wmpc0z70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n49jFca0H0YEreWTB3reIGIYLR7UnuHV//ajDVTsaE7BIVcOh9poDKfu6X49NbXGxEGUh4/1/znysVh71poPPA9X01jMiSh3KkTYORQZ7fm+fqX+pLPIXofCuQDY1CeLXAboMQyzFnivFH3VBXefCLvgkQunHvNTNeFDYSwKF9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P4aI4VWn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P4aI4VWn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88CB7C43390;
	Sat,  3 Feb 2024 04:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933380;
	bh=AXA2YAtHZsYhKItWyLpq1I1ezerIgpOlMl1wmpc0z70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P4aI4VWnw3+EqbNtH9RUGulph6Ev8P1XeBAfw3jvoV0a7rD84mxDZHrh5DrMyYp49
	 TPL73jSagmCFaBlMKfEQVksPO6KcrrPo/sHUrHsipab2pSErA3ukZkNU1gGmjOV0Gq
	 LhA60Muj7s0y5tbIK68sCqkJ+nrkhLoDh3M3HDcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/219] arm64: dts: amlogic: fix format for s4 uart node
Date: Fri,  2 Feb 2024 20:04:24 -0800
Message-ID: <20240203035330.163616319@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit eb54ef36282f670c704ed5af8593da62bebba80d ]

Aliases use lowercase letters and place status in end.

Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20231215-s4-dts-v1-1-7831ab6972be@amlogic.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts | 4 ++--
 arch/arm64/boot/dts/amlogic/meson-s4.dtsi             | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts b/arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts
index 8ffbcb2b1ac5..bbd3c05cbd90 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts
@@ -15,7 +15,7 @@
 	#size-cells = <2>;
 
 	aliases {
-		serial0 = &uart_B;
+		serial0 = &uart_b;
 	};
 
 	memory@0 {
@@ -25,6 +25,6 @@
 
 };
 
-&uart_B {
+&uart_b {
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index ad50cba42d19..372a03762d69 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -118,14 +118,14 @@
 					<10 11 12 13 14 15 16 17 18 19 20 21>;
 			};
 
-			uart_B: serial@7a000 {
+			uart_b: serial@7a000 {
 				compatible = "amlogic,meson-s4-uart",
 					     "amlogic,meson-ao-uart";
 				reg = <0x0 0x7a000 0x0 0x18>;
 				interrupts = <GIC_SPI 169 IRQ_TYPE_EDGE_RISING>;
-				status = "disabled";
 				clocks = <&xtal>, <&xtal>, <&xtal>;
 				clock-names = "xtal", "pclk", "baud";
+				status = "disabled";
 			};
 
 			reset: reset-controller@2000 {
-- 
2.43.0



