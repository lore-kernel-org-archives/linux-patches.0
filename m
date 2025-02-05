Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B82E13C3F6;
	Wed,  5 Feb 2025 14:15:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764949; cv=none; b=U3m77hOZ0xp7Sx9zlbmUEqzHf8DFfZOZZ1fsUALuT4L86DwPbv7dVI9H0sPtYLrv+NY6NuP10E+FKdrfMkx95T1ej5e2QtZ/iFWFfaKouxHXwdC05eWLyd/PPQmyNHT2Juu8aBOaHN+jJFTq1za0Jn77MtjAjwBDSWDxiTAhQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764949; c=relaxed/simple;
	bh=0LI4yy37iskR/n8a1DnLQWGsuN9TS5oEOHb32/8ABOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/SoWIYJdfeP1nfFiKsEqvAh7B71VinVUlWi8Z1w5p7TVZ+RSKfn0KpOM6QCTMdtq10HIKdrlkb3r9ZY2OmUGwJ7RgV71oFAKhODEYozgAppq7AVR8irOhd6ekC+yaUj92PAm76dp3lqwg8LndSET/+SKm/5WrgbGGd41THzL9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZCFrRUxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZCFrRUxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A856EC4CED6;
	Wed,  5 Feb 2025 14:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764949;
	bh=0LI4yy37iskR/n8a1DnLQWGsuN9TS5oEOHb32/8ABOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZCFrRUxXbbP4iPFZZY7uhejuYiqo9veFKMEIJmwX4+7ffMljUUIbKM52XIrzDcHoF
	 LqN+gMPjSqy4wVbIRc6Vz0RhB1njtPQVJmDYkkpeKR37P9QEceS942NdHZTiiNdkY8
	 Y8eWVoGv1a9e5B7B8BxCthpVwzK3XzGd3cDnxx6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 218/393] arm64: dts: mediatek: mt8183: kenzo: Support second source touchscreen
Date: Wed,  5 Feb 2025 14:42:17 +0100
Message-ID: <20250205134428.644420542@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hsin-Te Yuan <yuanhsinte@chromium.org>

[ Upstream commit 5ec5dc73c5ac0c6e06803dc3b5aea4493e856568 ]

Some kenzo devices use second source touchscreen.

Fixes: 0a9cefe21aec ("arm64: dts: mt8183: Add kukui-jacuzzi-kenzo board")
Signed-off-by: Hsin-Te Yuan <yuanhsinte@chromium.org>
Link: https://lore.kernel.org/r/20241213-touchscreen-v3-1-7c1f670913f9@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts   | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts
index 8fa89db03e639..328294245a79d 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts
@@ -11,3 +11,18 @@
 	model = "Google kenzo sku17 board";
 	compatible = "google,juniper-sku17", "google,juniper", "mediatek,mt8183";
 };
+
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
-- 
2.39.5



