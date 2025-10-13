Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F30A3081AE;
	Mon, 13 Oct 2025 15:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369173; cv=none; b=ttcytQ6xZt9o2Vo4cRRi5lgBS04RMdrhcXk1bx45tf0Sw2LjSzl4BUnfJf0yPfUfwz5OZktSN6vm0MPNTJnYvuy3407+lUi1tjl3cl1/noUh+LNWesF9cTqOyFunnG5iDM2CHF7BML0OI2Kc7SDS9o0NsLTpQv7K6EW8UGBgG7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369173; c=relaxed/simple;
	bh=NY8ImeykUexv8hE+10CJW6RTlCJoMSau7LpXm/FOBbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBaOYhgb8eb2dszueQSg7jNoMF1vddsFE7ROmlem1XSEjSw5iNGcv7EpmH8kWgBRlEZVYxxlF0B+ZzsLoishBTfg9Ao6qOPLKtyTzgOuxgllp3S6efkhiEBH6zGITpPIohWCxKoKVMv/wrvjNmu/vxePUD2w3u+KUECnM7ky7W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MV0EZxGZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MV0EZxGZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEC80C4CEE7;
	Mon, 13 Oct 2025 15:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369173;
	bh=NY8ImeykUexv8hE+10CJW6RTlCJoMSau7LpXm/FOBbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MV0EZxGZRK98ykTgAB0hWs2zkvrR2AfM2xjxlYniRH4UUB6Y1fFNNw+HfQvO54Xh4
	 Xax3ljc440Y26/TTIQQ5/UpBK959soL5Iq2sCTUE54ncDbamZFwJM+kVw2Ev/YXxW4
	 DRMs6nbDQdE+KIuDYBR6lAZ6nStuhGkwWzRwOEpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 153/563] arm64: dts: allwinner: t527: avaota-a1: hook up external 32k crystal
Date: Mon, 13 Oct 2025 16:40:14 +0200
Message-ID: <20251013144416.832161060@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wens@csie.org>

[ Upstream commit 3d5e1ba00af8dd34ae1e573c2c07e00b5ec65267 ]

When the board was added, its external 32.768 KHz crystal was described
but not hooked up correctly. This meant the device had to fall back to
the SoC's internal oscillator or divide a 32 KHz clock from the main
oscillator, neither of which are accurate for the RTC. As a result the
RTC clock will drift badly.

Hook the crystal up to the RTC block and request the correct clock rate.

Fixes: dbe54efa32af ("arm64: dts: allwinner: a523: add Avaota-A1 router support")
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20250913102450.3935943-2-wens@kernel.org
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts b/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts
index e7713678208d4..4e71055fbd159 100644
--- a/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts
+++ b/arch/arm64/boot/dts/allwinner/sun55i-t527-avaota-a1.dts
@@ -309,6 +309,14 @@ &r_pio {
 	vcc-pm-supply = <&reg_aldo3>;
 };
 
+&rtc {
+	clocks = <&r_ccu CLK_BUS_R_RTC>, <&osc24M>,
+		 <&r_ccu CLK_R_AHB>, <&ext_osc32k>;
+	clock-names = "bus", "hosc", "ahb", "ext-osc32k";
+	assigned-clocks = <&rtc CLK_OSC32K>;
+	assigned-clock-rates = <32768>;
+};
+
 &uart0 {
 	pinctrl-names = "default";
 	pinctrl-0 = <&uart0_pb_pins>;
-- 
2.51.0



