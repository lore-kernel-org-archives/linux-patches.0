Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C885F46D080;
	Tue, 21 Jul 2026 18:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658487; cv=none; b=RcIpLECEcK4qlVp3Zg0Rdrs21g4xteVk+qVYnflrgYS+4Bfg6UmsOXrJtiN0Xz2jrZlanSxRT0Qa8uoXWwDXOGTwsi7vGuPrzSwm8dlkIPmIr+lCUbJ+DO2EF++6eItcMScbB53EZoXaOZffTqBz2S6mCCivXHScPqWdKFfoVlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658487; c=relaxed/simple;
	bh=GcGgXjUg+XR1DAJGz6rJsEccLE8DN5TBXNEd0H1ZW3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sjVyZOaf1qmy30ZlfvPD/Fo8xrki50lBLZqCR6HK1LD1IdnXyDmlDW7bNwsB1InI7AbB5h7o5RH1cgas4MeQN4LQjjojWGy+ajHXBUpmIFrJOJYNVo0Vq9qxpGFEabktfpl6qHpqbpQJI+6JaffKXFO116USaBFZhPcNkdprCGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPvpDpaq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPvpDpaq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BA01F00A3E;
	Tue, 21 Jul 2026 18:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658484;
	bh=SwYOHpARaTqjYW52remdQGhzHlDYtze3uR4IBxVk5bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPvpDpaqrAhdayUm5fpUBQf7vwARK1qoEr+cLGOtrB+7LSMRdzFzb8EYpV4I9tKtn
	 yc8cLkRYJEr5z1PjHF99TUkZn+W2xcfEtvu36Wx75q4rhgIdHTESpgAW8IRfQDbqwI
	 9MOOb3FwOdboUrus7Jqpw5NdqhLJNUaP4HPf99PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 6.18 1118/1611] arm64: dts: imx8ulp-evk: Correct Type-C int GPIO flags
Date: Tue, 21 Jul 2026 17:20:34 +0200
Message-ID: <20260721152540.566191812@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -166,7 +166,7 @@
 	ptn5150_1: typec@1d {
 		compatible = "nxp,ptn5150";
 		reg = <0x1d>;
-		int-gpios = <&gpiof 3 IRQ_TYPE_EDGE_FALLING>;
+		int-gpios = <&gpiof 3 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_typec1>;
 		status = "disabled";
@@ -182,7 +182,7 @@
 	ptn5150_2: typec@3d {
 		compatible = "nxp,ptn5150";
 		reg = <0x3d>;
-		int-gpios = <&gpiof 5 IRQ_TYPE_EDGE_FALLING>;
+		int-gpios = <&gpiof 5 GPIO_ACTIVE_LOW>;
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_typec2>;
 		status = "disabled";


