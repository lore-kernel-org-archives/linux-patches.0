Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FBC78B5A;
	Wed, 21 Feb 2024 13:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521351; cv=none; b=Pe3WQyQJAFYNdbaWORtGbG09qobzQGLpTnA3uTa5FLlm/MwqTQYGooLX+Ui1hMv+KWHPifPGkX8fdFlvoBcKQrdXYgh5gvemoJxb1PZGbSSHA+qF1MgYCtpo5Iti5FahIzndYDT3yX8JymbRqsxPFF6A6fdnAehZNoZ5PF3UU6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521351; c=relaxed/simple;
	bh=MH1EpGrJwngmk2hBKaXxZ5VSkDYITR5qtST8TTf8u10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGT2iVONGhqTl3uN0iX1kTVgrQTnroopeKLyxS8qNxiETAClxXyA93yCBaRjxsVBrNaLFyMr61zvwJfMjA5t7D7FCIj5eoF117VTb46l8brxN4+jfWUqZvuxp5nneH8jTXAdLVB9I7dK7EEPC60960dphmMrjBBhzYNZ6ES9mYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lESj3pmx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lESj3pmx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BC6C43399;
	Wed, 21 Feb 2024 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521351;
	bh=MH1EpGrJwngmk2hBKaXxZ5VSkDYITR5qtST8TTf8u10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lESj3pmxDP1tUYVNNcQswyaKRQzGGgPC09bnCwT1RRgG7SMW3UbR9T7I8DWkEPFAb
	 5iVbj0ujB9hNccOEtrt/9UGYbhZTvR1R+HxwA5A2yV2Bt6MyNrh2QkqfxqiJi18X29
	 la4z3i/5HMSKN9NJprNTTKqwlz05sWi3hjcv+WIc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 090/202] ARM: dts: imx23-sansa: Use preferred i2c-gpios properties
Date: Wed, 21 Feb 2024 14:06:31 +0100
Message-ID: <20240221125934.695632982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit e3aa1a82fb20ee97597022f6528823a8ab82bde6 ]

The 'gpios' property to describe the SDA and SCL GPIOs is considered
deprecated according to i2c-gpio.yaml.

Switch to the preferred 'sda-gpios' and 'scl-gpios' properties.

This fixes the following schema warnings:

imx23-sansa.dtb: i2c-0: 'sda-gpios' is a required property
	from schema $id: http://devicetree.org/schemas/i2c/i2c-gpio.yaml#
imx23-sansa.dtb: i2c-0: 'scl-gpios' is a required property
	from schema $id: http://devicetree.org/schemas/i2c/i2c-gpio.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx23-sansa.dts | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/arm/boot/dts/imx23-sansa.dts b/arch/arm/boot/dts/imx23-sansa.dts
index fa22fd9b2412..a0bbc39e644a 100644
--- a/arch/arm/boot/dts/imx23-sansa.dts
+++ b/arch/arm/boot/dts/imx23-sansa.dts
@@ -175,10 +175,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "i2c-gpio";
-		gpios = <
-			&gpio1 24 0		/* SDA */
-			&gpio1 22 0		/* SCL */
-		>;
+		sda-gpios = <&gpio1 24 0>;
+		scl-gpios = <&gpio1 22 0>;
 		i2c-gpio,delay-us = <2>;	/* ~100 kHz */
 	};
 
@@ -186,10 +184,8 @@
 		#address-cells = <1>;
 		#size-cells = <0>;
 		compatible = "i2c-gpio";
-		gpios = <
-			&gpio0 31 0		/* SDA */
-			&gpio0 30 0		/* SCL */
-		>;
+		sda-gpios = <&gpio0 31 0>;
+		scl-gpios = <&gpio0 30 0>;
 		i2c-gpio,delay-us = <2>;	/* ~100 kHz */
 
 		touch: touch@20 {
-- 
2.43.0



