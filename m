Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A30942B9C7;
	Sun,  1 Sep 2024 16:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208672; cv=none; b=qRB0LFhwTNywooOfM2/IeOlQIXtv26ibfbyKLVxRRhqr9Mx1IrrIrPo7bQwzCxDEneMbNKymrIrGIXoqdtqvpDcEmSaBBOQ6WR3wstmWwOlxrSl0fYv2QRMFxRAvzxZzGVrA3ez+T3FkY5mNF/S0aMWylSueXj5KeVsGlMdto1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208672; c=relaxed/simple;
	bh=5sG9k3B/958kKnsc26xxirZrdB6nq646QKxZ7i5HB/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a148huPsKAx8LIP4oUeePYnDvprcUKoVMofJ1oTjkae25c1fUQPGr+/ZOOfUFMiqZFUiJBR8DRlp4UBRjFHiAMaEkY2ZsRC/vOBbjn9GjGl3ELgXbx//re+rClHr8/56+NlHpimj767EzgkTCar431OCN37znWN/shp9GS4ZKPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHzH4iC6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHzH4iC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DE2C4CEC3;
	Sun,  1 Sep 2024 16:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208672;
	bh=5sG9k3B/958kKnsc26xxirZrdB6nq646QKxZ7i5HB/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gHzH4iC6Ur00ZvE+7pqPPp6ERDMN49gXcGwN0u1owKrRQR2fZfpe7FruMYXO02MNl
	 y/sPELE/4mV4RfExGGNpFkM6I9mroyWMotx8loBJQilsC/J0WdnmRmzDOqEoX3l1QO
	 4FJQoPJx2D7Gm1u7cQmV+iHagcnVzQ6fBTxoGK7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michal=20Vok=C3=A1=C4=8D?= <michal.vokac@ysoft.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.10 129/149] ARM: dts: imx6dl-yapp43: Increase LED current to match the yapp4 HW design
Date: Sun,  1 Sep 2024 18:17:20 +0200
Message-ID: <20240901160822.306068592@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx6dl-yapp43-common.dtsi
@@ -274,24 +274,24 @@
 
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


