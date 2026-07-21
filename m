Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B91429CDF;
	Tue, 21 Jul 2026 19:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661464; cv=none; b=aFdjNIcFO9rrOP5u7xuezCAsLd/WWOqn0U8dr+6Ut3wmkiFSV++NsBum/wjY4QTtA9i80WGKaWki/bk2Clz5zX5WVJ+ZYYfBwVbIKVF+oE8vHWtBiRHY+qN4x/xRzwnh5zVI4C9ElIIbC7qhDWRiBrK59m6oHc/NzUb8PAnTycg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661464; c=relaxed/simple;
	bh=Zt812k1JgMhe/aFM1Z4ov2JBIF8i17FdajN4OeP2JZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+xOc0aiWc/l+3XJQErDVd3KzJRzzBfBTfaNJldn9sokA5OcIoenvCuDBwh/AlbaZUoLxDL2GttTSFT+IX9lUWXTwpME5La9f9wMmCqabHV2solzY2agiWXhu8i48+VWTaq4F/buEB0+1W8I7CblX9U2YusrntEvg38uilsbgAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jCGi9RGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jCGi9RGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703661F000E9;
	Tue, 21 Jul 2026 19:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661463;
	bh=A6OZqDxDkDXjG4lVfNyA/F4r6ykpRcBmWEkD1apigms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jCGi9RGBwPUXMLDJVpiPx3Y5RYOcbh3iTIV3CH7WgRV4V1A8//l9rJYynGkpMoBIF
	 J8bVZjoHdFw/dWoXVRUpJukJySdk6Ir2CchGtRmhtZSM/Gj8DYr+1v8Apk9nn+9t+K
	 Hh0Jvf/dl3q3Uvnc5z1qWLBbhbEBlsbFl0bqEKsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0075/1276] dt-bindings: pinctrl: nvidia,tegra234: Add missing required block
Date: Tue, 21 Jul 2026 17:08:38 +0200
Message-ID: <20260721152447.773844859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 61b5deb5a968f7a82124f9b2591a6a151ed7273a ]

Binding should require 'reg' property, because address space cannot be
missing in the hardware and is already needed by the Linux drivers.
Require also 'compatible' by convention, although it is not strictly
necessary.

Fixes: 857982138b79 ("dt-bindings: pinctrl: Document Tegra234 pin controllers")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml          | 4 ++++
 .../devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml
index db8224dfba2c1b..56fb9cf763ef7f 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml
@@ -58,6 +58,10 @@ patternProperties:
                     drive_soc_gpio27_pee6, drive_ao_retention_n_pee2,
                     drive_vcomp_alert_pee1, drive_hdmi_cec_pgg0 ]
 
+required:
+  - compatible
+  - reg
+
 unevaluatedProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml
index f5a3a881dec4f0..bd305a34eee2b2 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml
@@ -115,6 +115,10 @@ patternProperties:
                     drive_sdmmc1_dat2_pj4, drive_sdmmc1_dat1_pj3,
                     drive_sdmmc1_dat0_pj2 ]
 
+required:
+  - compatible
+  - reg
+
 unevaluatedProperties: false
 
 examples:
-- 
2.53.0



