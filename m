Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7132B28387;
	Sun,  1 Sep 2024 16:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208111; cv=none; b=Kzvk1dVSPcYyjYSbLldEc6Putm/CD0W9bIf8kD35YtE03hPexjIC1PcxsMBn3AtAe8FUB8u8nIITU2ziRdjeInJmvHROp3p82R52ew7npq5cgE7apej2W6wOh/GzHLcF0AWeW1Alk9HHL+xerGvf7lZF9JywZ3GNFy8ywLeiY3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208111; c=relaxed/simple;
	bh=yDPNE+F140U4txi0M9xtXrs4qjjuOHtKgo0piNtvTME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qb2q3l/ZknOp+v5Ws+oXJ92628Xn1AxtfCCwD1zaRHfYyWJ8wKhwmo5fsYS4blbvZ+8PyI2CA9lT7zO97CePIVozR7QOzUgYa42LbG4ty9p4TlPxZSYkZzr8N8Elewuazu+4GgePlaYiUj8aRO4zuUTnl35rnOkh3iN9+aA7dF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1RnwMvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1RnwMvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D48AFC4CEC3;
	Sun,  1 Sep 2024 16:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208111;
	bh=yDPNE+F140U4txi0M9xtXrs4qjjuOHtKgo0piNtvTME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1RnwMvrpUSIvZGQH3lbDkLCnu3r+0Pzr71HQa4l6xyDaHt+DkmD/jf6JywFsJ1WC
	 Xyu30Yb5G9oBZcfjcvBoJYlg9xMhP52NxgCzFxv5P+oJ7R9Y7ZlrKShV0zDVQQopAQ
	 CJgbY+eGixKt5mXT3ICIwKLy487ZjbmtvI5+0Fko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 77/93] ARM: dts: imx6dl-yapp43: Increase LED current to match the yapp4 HW design
Date: Sun,  1 Sep 2024 18:17:04 +0200
Message-ID: <20240901160810.635612275@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Vokáč <michal.vokac@ysoft.com>

commit 8512fbb64b0e599412da661412d10d4ba1cb003c upstream.

On the imx6dl-yapp4 revision based boards, the RGB LED is not driven
directly by the LP5562 driver but through FET transistors. Hence the LED
current is not determined by the driver but by the LED series resistors.

On the imx6dl-yapp43 revision based boards, we removed the FET transistors
to drive the LED directly from the LP5562 but forgot to tune the output
current to match the previous HW design.

Set the LED current on imx6dl-yapp43 based boards to the same values
measured on the imx6dl-yapp4 boards and limit the maximum current to 20mA.

Fixes: 7da4734751e0 ("ARM: dts: imx6dl-yapp43: Add support for new HW revision of the IOTA board")
Cc: <stable@vger.kernel.org>
Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi b/arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi
index 52a0f6ee426f..bcf4d9c870ec 100644
--- a/arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi
@@ -274,24 +274,24 @@ leds: led-controller@30 {
 
 		led@0 {
 			chan-name = "R";
-			led-cur = /bits/ 8 <0x20>;
-			max-cur = /bits/ 8 <0x60>;
+			led-cur = /bits/ 8 <0x6e>;
+			max-cur = /bits/ 8 <0xc8>;
 			reg = <0>;
 			color = <LED_COLOR_ID_RED>;
 		};
 
 		led@1 {
 			chan-name = "G";
-			led-cur = /bits/ 8 <0x20>;
-			max-cur = /bits/ 8 <0x60>;
+			led-cur = /bits/ 8 <0xbe>;
+			max-cur = /bits/ 8 <0xc8>;
 			reg = <1>;
 			color = <LED_COLOR_ID_GREEN>;
 		};
 
 		led@2 {
 			chan-name = "B";
-			led-cur = /bits/ 8 <0x20>;
-			max-cur = /bits/ 8 <0x60>;
+			led-cur = /bits/ 8 <0xbe>;
+			max-cur = /bits/ 8 <0xc8>;
 			reg = <2>;
 			color = <LED_COLOR_ID_BLUE>;
 		};
-- 
2.46.0



