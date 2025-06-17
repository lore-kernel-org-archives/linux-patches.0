Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC9FF2EE5EE;
	Tue, 17 Jun 2025 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177935; cv=none; b=k4iU3NkPJmuy78xhI2bLg+o0PF8hw6bwd8LZ5ooP+rQTb0aoxHNMwsE0S+7hwLQJH2O9eytydmoDmJWZG/y7Fvp85+6HpJxD15dSB6TIkMZZNhBiRMK4xyFu5kT6tDptjqgAmbEx/ud/2omElqI2IdeX1N5CEbtKq0v9NuKchFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177935; c=relaxed/simple;
	bh=be7H0RCuekhgXndJzyeQWSm5E5MwYy8DLrLSZKNcvOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzNcSDVbuESbWMCSXa+LQxmysrVxKRXBRxyKfceXfm+fsl2TQJD6zcewp0vyZnNEOqn2fzpaUK9dMmLxZ1YGJoL8RsE7FVUmeMkfT5zbmNLMawlm0C1Qcq5oBT4oQeo4trTEhCPYC9vUUdctobuR08GF3Boc/nasLyzu1ttSByE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s6bcce5g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s6bcce5g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F9FC4CEE3;
	Tue, 17 Jun 2025 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177934;
	bh=be7H0RCuekhgXndJzyeQWSm5E5MwYy8DLrLSZKNcvOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s6bcce5gCqFXeQhGhC0Dw4WSq2gg2LBHTBBXnUi0CvOOmVRDNzaYTaP4wcR9ksJ9d
	 QpQbGs3JcT19W8JXBQrKbNyan5iK+calAKnFRuCVN6O9xqvHsETCFRDIEoGyruy/H1
	 pQCwylIjOFDaj2FUiuE5aYsxkBLPbTAxHxVze0L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 385/780] arm64: dts: allwinner: a100: set maximum MMC frequency
Date: Tue, 17 Jun 2025 17:21:33 +0200
Message-ID: <20250617152507.138908685@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit d8f10550448b03d3c5c6d9392119205c65ebfc89 ]

The manual for the Allwinner A133 SoC mentions that the maximum
supported MMC frequency is 150 MHz, for all of the MMC devices.

Describe that in the DT entry, to help drivers setting the right
interface frequency.

Fixes: fcfbb8d9ec58 ("arm64: allwinner: a100: Add MMC related nodes")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20250505202416.23753-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi b/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi
index f9f6fea03b744..bd366389b2389 100644
--- a/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi
+++ b/arch/arm64/boot/dts/allwinner/sun50i-a100.dtsi
@@ -252,6 +252,7 @@
 			interrupts = <GIC_SPI 39 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc0_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -267,6 +268,7 @@
 			interrupts = <GIC_SPI 40 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc1_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -282,6 +284,7 @@
 			interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 			pinctrl-names = "default";
 			pinctrl-0 = <&mmc2_pins>;
+			max-frequency = <150000000>;
 			status = "disabled";
 			#address-cells = <1>;
 			#size-cells = <0>;
-- 
2.39.5



