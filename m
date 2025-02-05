Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8B8197A8B;
	Wed,  5 Feb 2025 14:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767120; cv=none; b=mOkpokSs9qZsPLlYGfHWIaaiVLm5nFp3DvmQ509hO6kCBciJyjRaVPIqS451DZQIHgPaXwPt1QvhuOBN11e+O7/gboOk8gILfcmhD8GaZutJIpACLKbAnP3T2fp7Y3c586eaMeWOSXtDh1NrQsObKY1uFcB74fafvMS/0OJy8n8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767120; c=relaxed/simple;
	bh=yYcRNfZyxJ/bVN0SOMGF/2jifwlBpaIjuiiLKsiqYqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sv8f5CodullRoAPnxM7iJoxw3drRyademrvaZuFNV/EqIk9Gmz4nznIlhFJwnm31J7q3RRIqEd+sZdl39L3yfSUxs4ATlibID/Mjfovjj1ZDRG7l9Rc7XIaYiuKaVTksM0gLT79mg4N4qFSrEnhEVjTZSF6fWulK2Mq5LnYoAaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4x59fE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4x59fE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76275C4CED1;
	Wed,  5 Feb 2025 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767120;
	bh=yYcRNfZyxJ/bVN0SOMGF/2jifwlBpaIjuiiLKsiqYqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4x59fE/on2Q+4ilakuYuGZFAKZxBc/Lu7lmrdv/4wAP1oHr3yjit8WYqh0hiiuz4
	 UsvEAW5nyvt3sT1Jq8PKgdr+yMv9637K/hjofaiWoxBUpxjEjhDHilovfFOiLP/7Ef
	 0mwW2O3uAEhvKftfeUC/kbLYdQXXq9z7Zr9cigjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 359/623] arm64: dts: mediatek: mt8183: kenzo: Support second source touchscreen
Date: Wed,  5 Feb 2025 14:41:41 +0100
Message-ID: <20250205134509.957938717@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index e8241587949b2..561770fcf69e6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8183-kukui-jacuzzi-kenzo.dts
@@ -12,3 +12,18 @@
 	chassis-type = "laptop";
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



