Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047716;
	b=lqMnWSdtDIbumuU6BHGTtk8Yv6ZoNor2REGQluAmI4omfAEAyOEZp5Ci7oYtv2Dvbr8z
	 oPI8QXgfT7eOUrSB8t4RZTUOpfpg84SaFv4FEqj7TJIKbmu1Ytp7KsDOhH7eUZ7w071r8
	 Gme+SmhvFujZmDKqdH+BDrBJ/uBaZs3Mfd2HXsOq8N/TrY/h2Sixv2pqDPqeByEeX4Ys4
	 Ol18jOP0qJ6qdXLxGDBDbKf4arDdRBUFr5K8v88gEi6gtzZ7eJjmaN6Ai9sF0Gqvsc5bT
	 fe0kC94al3LENT0bTR18AZ8Np6NXGpmGBkiF+BC1PO2ajBHUglQT8sB0u8EP9gUhwpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=scL3qgOr25vourICalyEMXPZlt7KoeHxcW/S4sHn/no=;
	b=ZEqHfz8HQCmeh5pD7e+cL0U3FYHewMHAV4kMCwcvti4TvTMG64+je7/XojtP8j5WLSO/
	 y/Be62BJY5eOXFqgiItALoCBlNPGNUdzZlzXoslEC5yD09WAGD9R5s30eXGIr5AgJfzrW
	 /fuMetfJRo3Rf7VkRh0cKWazFawJbNgBxYOD+/h2Hr9SI5fZIbGIdqAbs48U8w/5NQQxB
	 ZHslWXirDd89tEzPPVZrNYkMD/58xas+qA3QwsoUdftgbTlpPh6HKwDRHkwOYyObk0KbI
	 ivClk++ZwL0NBvn9IYY2ZQ27zkp2YthRLAYBsLDPE5PsMyYjX1VtEeAgOnwz7tXGAWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SOQhgB0c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBDDE606A320;
	Thu, 19 Nov 2026 00:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SOQhgB0c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 754F11F000CC;
	Thu, 19 Nov 2026 00:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047715;
	bh=scL3qgOr25vourICalyEMXPZlt7KoeHxcW/S4sHn/no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SOQhgB0cmW4yDQj1dN7RlXeRWIWT63tqTkAsDiV9icfQLgE67Qhs/DvfDDMA8w8BX
	 A/iaOppjZ3AkGFRpGX2ozG6SpEYmPiTHEhq1vddgxUofa/YkZyT3AS4QE3CLk8Ofts
	 V21ho1iufkzsisXSm1y49Tz5G0NkH3+DEDlTxQQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1739/2857] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:46:13 +0100
Message-ID: <20261118150303.919589906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 337d10963f601d5a3dfb4b7aa273ca8c0b4d5172 ]

The SDHCI node references the 3.3V regulator through a bare "vmmc"
property, which is not part of the mmc controller DT binding; the
correct property is "vmmc-supply".

Fixes: aecc313490ae ("ARM: dts: mvebu: add support for SolidRun Clearfog GTR")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
index d1452a04e9040..0435c9c20ea73 100644
--- a/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/armada-385-clearfog-gtr.dtsi
@@ -202,7 +202,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



