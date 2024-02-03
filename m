Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA0F9E9;
	Sat,  3 Feb 2024 04:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933579; cv=none; b=r/xJRlrST+YgNLEvJtAtRlhIiUyEP/AdlJ2EV1XMKkbiD9kfXNws9Jt5HcoPAzHsRXsmQ8ZAcPoPvUtu+dx3OJ8KMnn/Rn+7rV6cEdjS/+UftJOH+RjLow9riBwWcG35zAH9SX7/y0D29IT24mDjeqpjcORmVG+jSY5pwMej114=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933579; c=relaxed/simple;
	bh=WNyNu0WXNpO7P3fXc1YXYRAoXjJ5cxkaOdH0Ii4LbmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYoQiYyBtfVE0WycitKgCZrjjL9NJBMhxoSmLvfHrKvX27xIvh8GUaBhAg9az0Sao90+awnxDSRxSiJtVrTUNOYcfryYX/J6k/sRkc8HgB3KyIvA3uL59eP1vqoxbSVLEite/OTydw5gja2Ozoh0DkmUyJ+Viz3ofJtV+hxa3Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaqj49GD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaqj49GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38B4C433F1;
	Sat,  3 Feb 2024 04:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933578;
	bh=WNyNu0WXNpO7P3fXc1YXYRAoXjJ5cxkaOdH0Ii4LbmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaqj49GDwIfVyCMH19Zv893V/GA8yiHj5cLeDfFohK+EK/1GmoJef8X1Tt+c0rjeL
	 kouZXy4HKhOi89NaPuBYnEAIVPerbQ0GiodEITvojngg6jSJu3SLX0dv+B88u4hMg9
	 Odv/M2tCBmqoAzb9oFr1Stp856lk1ZkDYtACEgs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 139/322] arm64: dts: amlogic: fix format for s4 uart node
Date: Fri,  2 Feb 2024 20:03:56 -0800
Message-ID: <20240203035403.645449524@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f24460186d3d..55ddea6dc9f8 100644
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



