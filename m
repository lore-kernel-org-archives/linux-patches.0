Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41FF42F704;
	Tue, 21 Jul 2026 20:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665730; cv=none; b=VrnCJYH0TUWZIJpgBz992/6qUu761dbueUFuCiGINc0DudSSeEFYig/5QdfWUn3pya7F/ZbvHJalBGcrcF6KyyRnXFU2KTmPaeTtQWh5P3DJ3T8B4s5v1BCL4PVx36qoB7EUBXWcAYVaiSj7Ucna1bEiv7nDv+hYxSi+4RXSKcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665730; c=relaxed/simple;
	bh=9AFuXGKWPw9/4Rn6ID7ekuijPUOxDsitwD+DKwtz+A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfHiFqAZNWjjNVktaBALCsxNAmc/OnSZL5mUBsOaumnZ6QGTJB4uHBHH5NnihcdrIz2HvaLCPHPkm/bfTzMaFFZjzkoOkeVTkPQPc7rt06VFWVJXB3GURsXkPLcX0nCDGtx5+/CW0SsI9R7DWgGwvADREUMcLniZ/hJHB/7ekLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ezH9ihV0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ezH9ihV0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92C11F000E9;
	Tue, 21 Jul 2026 20:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665729;
	bh=C7l6qHA2IVaR2kdICuogL0LKKX/CQQxMp5X8YO/oNG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ezH9ihV0kjqjhbJ1dFEZj6YOve6+8PYW1/98/XYP/f6IlvzI13V+DJGx8UTl77A4/
	 snoVKUyqVzt9SRhg5ceMB8WqPjWelYqN8iKg7fRI5ZAHf97tX92bFiELaLKNmcf+gw
	 a8IE8v0r1hWXVRMzGsWZg8OcJMstWccCeOBOScpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0370/1266] dt-bindings: pinctrl: nvidia,tegra234: Add missing required block
Date: Tue, 21 Jul 2026 17:13:27 +0200
Message-ID: <20260721152450.106363978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f3deda9f7127fd..3c19147af91e37 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux-aon.yaml
@@ -55,6 +55,10 @@ patternProperties:
                     drive_soc_gpio27_pee6, drive_ao_retention_n_pee2,
                     drive_vcomp_alert_pee1, drive_hdmi_cec_pgg0 ]
 
+required:
+  - compatible
+  - reg
+
 unevaluatedProperties: false
 
 examples:
diff --git a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml
index 17b865ecfcdaa0..4f79dbc1bde66e 100644
--- a/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/nvidia,tegra234-pinmux.yaml
@@ -112,6 +112,10 @@ patternProperties:
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



