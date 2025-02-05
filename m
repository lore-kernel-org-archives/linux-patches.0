Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05EC1FCFFC;
	Wed,  5 Feb 2025 14:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766496; cv=none; b=lKQNVsTTM4lrOp0LX58EJqI1aspWQXKWuVap8/Bhhb2i+yjAfZG7M4CLzViaYMfQ6pFa9Z9aXReElc66Oifzx+G9x4+MAV0am5egxIEokQ60afb533vXdAcMLFt09jNV6mkW/GkTCJ7rJFd3rw1Zpyfmh2pfqF1HygHmBORXxqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766496; c=relaxed/simple;
	bh=iuBhuyWTD3mnhBPA3ZQRYeFQZMhQIWSOJIFhsf2vEso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mttDTin4tzp+tdCCdNKM24FIX+BzZpCbcOvw1fq2Wv3Zb1fZITdUXRodJMWRzQqB3uoKTq2d6yCrYKRYJn2KWZcFQx6nKKcmYU6AO9Qmm7e8sxgFS8t9IS/+61YpoImUUyi2Bau/otWVJwXJRbp15nrlp0dAPv1kbQrTyJDz17Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUdSefOC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUdSefOC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A979C4CEDD;
	Wed,  5 Feb 2025 14:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766496;
	bh=iuBhuyWTD3mnhBPA3ZQRYeFQZMhQIWSOJIFhsf2vEso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUdSefOC9pBsWdcwRBbdC6Ds4SZCza3iShioZoiYl0OSIwDlfKISbs8Maazl3busQ
	 osyZ1CSlY8gxmNt7gzu0A9i4B9W0tC7fBfXki6POsoKqgFWFGGXjrzYt2QVVjQ0vKC
	 FK/1Xaa8JR361fLgylSg5HIWGcwrOiV+DeljymTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsin-Te Yuan <yuanhsinte@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 329/590] arm64: dts: mediatek: mt8183: kenzo: Support second source touchscreen
Date: Wed,  5 Feb 2025 14:41:24 +0100
Message-ID: <20250205134507.861247570@linuxfoundation.org>
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



