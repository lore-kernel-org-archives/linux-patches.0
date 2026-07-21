Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F5D425863;
	Tue, 21 Jul 2026 19:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663441; cv=none; b=KV2Z8v7ysbkHJSsioJk86EKK4OqMFx3DzNf7TzhZFMb8oMb94FAhseZx24aA1X9p35lYyqxY8VUairYtBKbIHTXiOBj7E5wrZ6Ef5GzGnj44LzW007zI9GYxzz8dPxlCT1zvOzcsbyL55Gk3YTi62DqufpTM25okgWZCUQnfims=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663441; c=relaxed/simple;
	bh=u7kkaBKvlhtbxUpg1zo+rwj5Ri93fQr8+9hv9iu9ddw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nkIli1bW+BqD0/rfrdcxCieloKYgAdn4bm4+Q0m32mz1U8QHC0pasG3Oa/98Wpi+hPZP6vhRy+9dvkGDeSom8BCQflVxTgcB1aYu7SOLUlMJ+x4OObWr/8Njiy+D8HZ0JrA1NaifvMyzEW2ATMaXOu1pLnbEoshW++u2gqNlwR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9/IU00D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9/IU00D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0D21F000E9;
	Tue, 21 Jul 2026 19:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663440;
	bh=IeEPo5WoeM0d8Co1DZFLDhGy5gkqqu5V02p6NjSSFrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9/IU00DGylDuEMYF9bLQ39qxTkQaSW/A77NJxpL2D/P++XAlVrObdj6M6RzDefaT
	 q1azFinZ2LOZweioQhKPBz9LaGSDUmZ4NIkBUz/Fzxuhm9sl+LaWsmxcBteb3vk7Rr
	 UpQ/EX6R+SwedtcWexA37y2hEpS/3NCwZzywp4sE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.12 0822/1276] arm64: dts: imx8ulp-evk: Correct Type-C int GPIO flags
Date: Tue, 21 Jul 2026 17:21:05 +0200
Message-ID: <20260721152504.458506786@linuxfoundation.org>
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

commit b4f5c46163b3fe3ec7ed8a76dff8b7e80a776a1f upstream.

IRQ_TYPE_xxx flags are not correct in the context of GPIO flags.
These are simple defines so they could be used in DTS but they will not
have the same meaning: IRQ_TYPE_EDGE_FALLING = 2 = GPIO_SINGLE_ENDED.

Correct the Type-C int-gpios to use proper flags, assuming the author of
the code wanted similar logical behavior:

  IRQ_TYPE_EDGE_FALLING => GPIO_ACTIVE_LOW

Fixes: c4b4593ecb0b ("arm64: dts: imx8ulp-evk: enable usb nodes and add ptn5150 nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8ulp-evk.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
+++ b/arch/arm64/boot/dts/freescale/imx8ulp-evk.dts
@@ -130,7 +130,7 @@
 	ptn5150_1: typec@1d {
 		compatible = "nxp,ptn5150";
 		reg = <0x1d>;
-		int-gpios = <&gpiof 3 IRQ_TYPE_EDGE_FALLING>;
+		int-gpios = <&gpiof 3 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_typec1>;
 		status = "disabled";
@@ -146,7 +146,7 @@
 	ptn5150_2: typec@3d {
 		compatible = "nxp,ptn5150";
 		reg = <0x3d>;
-		int-gpios = <&gpiof 5 IRQ_TYPE_EDGE_FALLING>;
+		int-gpios = <&gpiof 5 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_typec2>;
 		status = "disabled";


