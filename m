Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5D11C6B5;
	Sat,  3 Feb 2024 04:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933841; cv=none; b=cSTNNtoyCoh77hjOyZaoshYfIaEFzfS8TaWZZWJjURtQ/YzHN2ySENiMwChS/zAuBTfm9IjHNUNFoZH6wd2m1sIFuS5bSu99SNAppTZ+8oCet1kv5ryGbHcKG5Gpl2XgO0sX2ByvaYUU6I/ytE7HePqx1LzcwUxzUiko6mkBW5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933841; c=relaxed/simple;
	bh=0x3l9+0clveFzlScwniqH6aduuaU2TJDlvWjj5YdZyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQwE3kE5B2VKMk15JdshY3vL8R5UPDoW4fcU2nZ7cIANoeHQMHipXa2lHGutvj+npe5JTP+vbir1bYkmJiw39lDssetRAe5iqy4+vjwGZQbrbGtUCqz2JNtqGitHXlNEw67c+WZx/hVxYA7vKsm94xERKVPcBNsWU85cewJIVTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7vod5Cz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7vod5Cz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37551C433C7;
	Sat,  3 Feb 2024 04:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933841;
	bh=0x3l9+0clveFzlScwniqH6aduuaU2TJDlvWjj5YdZyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7vod5Czu6/UUy+q0i4DarCh9b+o47dJVeyyL70kMN75iZlQSnMwGacIiQltnJl+8
	 tyLvMpx10elGUZiin16cqXwKviupLY5/B+qegYuPGMe+xKy0/DEy5pEptYryoXFpLA
	 Zux0l3g9agTkM+wEaJ9oHKR/nvtczOpa/4S3z9iU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 142/353] arm64: dts: amlogic: fix format for s4 uart node
Date: Fri,  2 Feb 2024 20:04:20 -0800
Message-ID: <20240203035408.190798805@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index c1f322c73982..b1b81ac03200 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-s4-s805x2-aq222.dts
@@ -15,7 +15,7 @@
 	#size-cells = <2>;
 
 	aliases {
-		serial0 = &uart_B;
+		serial0 = &uart_b;
 	};
 
 	memory@0 {
@@ -25,7 +25,7 @@
 
 };
 
-&uart_B {
+&uart_b {
 	status = "okay";
 };
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
index e0cfc54ebccb..dac18eb634d7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-s4.dtsi
@@ -126,14 +126,14 @@
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



