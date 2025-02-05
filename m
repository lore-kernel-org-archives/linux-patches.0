Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57ACC1FE474;
	Wed,  5 Feb 2025 14:41:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766507; cv=none; b=dQxoM3pi9AnybtzWMZv7mZpEelUZqTWFTi4sHIgzapEtvnXjTaw4lN5GU4t1KY/LLArkdy+W4/piy2svFmKiCEwifoN/xjh4RcAgP0TQocJriD6AWGUJ29Lp/itB4zdUeXS7pXQhPdNmwgKabBOzHHr0jEP4la5vMqIW343wMnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766507; c=relaxed/simple;
	bh=wSl/hMyr4Ac03tQIsuq0AUjpYWe3xg6I8MJKQuI84V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJLeC2EPBkgFL0lXgsAjMwmK5vHzg7MJYB6eAu7dzotORfHd791YMOJ8Yd0d97cBURCUUAE/BB8xOviR0i8zF7XMSz+Pq+DSt/B85WpgUBnZS7lBexOFqtG67zqeFmRmmCGraFrJeXLMCLDXvhYTsfZ68a1vqY6Yw35Pel9VOjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Cny9qC3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Cny9qC3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACFDCC4CED1;
	Wed,  5 Feb 2025 14:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766507;
	bh=wSl/hMyr4Ac03tQIsuq0AUjpYWe3xg6I8MJKQuI84V0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Cny9qC3gXrEbuUEgj6EDzkkl6PKruITMFL+dy1Rae9uqQu76Pekoum7TApixhoo7
	 f/Sh3FmsydnOapVbjfP6iwM7WVo2SLCM3J3mgyK9Bs1+M+n8xsjCGSyO4nFLtrdDT8
	 aAGCLvxnY/nMuqS95/D2FQPxTKZsNGwf/FKA3r98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 330/590] arm64: dts: mediatek: mt8183: willow: Support second source touchscreen
Date: Wed,  5 Feb 2025 14:41:25 +0100
Message-ID: <20250205134507.902759852@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 9594935260d76bffe200bea6cfab6ba0752e70d9 ]

Some willow devices use second source touchscreen.

Fixes: f006bcf1c972 ("arm64: dts: mt8183: Add kukui-jacuzzi-willow board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241213-touchscreen-v3-2-7c1f670913f9@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi
index 76d33540166f9..c942e461a177e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-willow.dtsi
@@ -6,6 +6,21 @@
 /dts-v1/;
 #include "mt8183-kukui-jacuzzi.dtsi"
 
+&i2c0 {
+	touchscreen@40 {
+		compatible = "hid-over-i2c";
+		reg = <0x40>;
+
+		pinctrl-names = "default";
+		pinctrl-0 = <&touchscreen_pins>;
+
+		interrupts-extended = <&pio 155 IRQ_TYPE_LEVEL_LOW>;
+
+		post-power-on-delay-ms = <70>;
+		hid-descr-addr = <0x0001>;
+	};
+};
+
 &i2c2 {
 	trackpad@2c {
 		compatible = "hid-over-i2c";
-- 
2.39.5



