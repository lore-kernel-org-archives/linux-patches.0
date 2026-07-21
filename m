Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E699846D2A4;
	Tue, 21 Jul 2026 17:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654006; cv=none; b=nGxKO03czzUnfWb/9L/6mPzib9I8peUI/Pwo5fpDasJab4of+aXFIFDoM1oTlXWW6VigVvaZleRvx088ikehBYq4eVgbn7AO8cYJMfAiq5th5eEzb0/4nQfQjKXKYRcCPIDgiGttwwbpIYTHbARsT3Upu9XAnezQIJc1OFlVFTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654006; c=relaxed/simple;
	bh=hshwBIbFqnlPqZGEH/3ot8WeTbO4YRWIGc5p8yuB3WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RR58bEDKCv1Ze0lZRGq95wmbvnIfDsx2nm8YQMvWDf9Lf9CpkHdCkfMA2FeaXoGDmZapVEXeL2iw+fLSibXgH/XXO4fzHPt0qlWUnCDcKceSK7ojgNnIL1av0/f3GDd7HRu7E7CL+memJZuyHrY15k9WJj5zJUWFeBRGaMqzA5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tNAbSKDw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tNAbSKDw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53BD01F000E9;
	Tue, 21 Jul 2026 17:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654004;
	bh=cwcRvoJIc4AabvxOlbnv/9F5iQhS1/7YLmbE9kBfmc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNAbSKDwdNWUsSXGznOCMxL14r6wlLsOwqeBkN1++IHCBU3HbKEgzvX6TPIozUDIE
	 6ALTKGtya2AfA0YRnOpGf3EQ3Ew7nUqqwijqaAwP8r6zGKiGj3C2m2TSuva7Bwh8nX
	 h1GQ2JmbJ0CQ/0DaTOqqz7YORqwdc2R9if4XUTHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Frank Li <Frank.Li@nxp.com>
Subject: [PATCH 7.1 1541/2077] arm64: dts: imx8ulp-evk: Correct Type-C int GPIO flags
Date: Tue, 21 Jul 2026 17:20:14 +0200
Message-ID: <20260721152629.122821467@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


