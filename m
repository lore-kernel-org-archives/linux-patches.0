Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04530111AE;
	Sat,  3 Feb 2024 04:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933569; cv=none; b=RELpiAyQJK5Tzqand0yhCFh8mLKE0eBFJlE0j/pMRfoHX5rrDH5XyDJ1SABQVjV4/TuLuqzUh2TTZaGCOQTsVgetpak8P1LTcPSRt5d7NfvM5uP9wZYw4s+Kn3KJWACNlbBPvR1pSTeU3aDA1uv4+Wl7H3LPPYUejPkNYHSIkXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933569; c=relaxed/simple;
	bh=72CMKQZgZEldiyivTqukoqJqu8ZbrBCXRaAo6PNr71I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NwocOCwCyDx0k0tg2/lIBpKPJ5TGTpTagw1yeRoO4b5H9AMXrsOezGcRpI6VIhzIGGnhRQzFmzfhC7pRrf7nv8D1Gby8HdxvKvIoKL49Ss+R4NUv+eSpFZHEp7M/jAu7Qp0ODfoDNGnK5u+pRO9BXqYIiJbSCNV6tFHR5EQdffY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CxwnhHWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CxwnhHWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68D09C43399;
	Sat,  3 Feb 2024 04:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933568;
	bh=72CMKQZgZEldiyivTqukoqJqu8ZbrBCXRaAo6PNr71I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CxwnhHWA6DDLlzJ4YGjBhgv1Z3JN/8zJbZQgYRTW1VRrI5agVWkMDCS6jGsYxQ4ho
	 UB/1ZcFkyRByuyNQLkpyXBjz24e9KBC/+4+Y/sqYXU/WKtCoPpVm8CLmLK2nvjfUZV
	 J073E6T4AOR8VJdUrZBcJUKmHz4r3oHrUvxoWDII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabio Estevam <festevam@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 124/322] ARM: dts: imx27-apf27dev: Fix LED name
Date: Fri,  2 Feb 2024 20:03:41 -0800
Message-ID: <20240203035403.150645007@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@denx.de>

[ Upstream commit dc35e253d032b959d92e12f081db5b00db26ae64 ]

Per leds-gpio.yaml, the led names should start with 'led'.

Change it to fix the following dt-schema warning:

imx27-apf27dev.dtb: leds: 'user' does not match any of the regexes: '(^led-[0-9a-f]$|led)', 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/leds/leds-gpio.yaml#

Signed-off-by: Fabio Estevam <festevam@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts b/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
index f047a8487073..849306cb4532 100644
--- a/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
+++ b/arch/arm/boot/dts/nxp/imx/imx27-apf27dev.dts
@@ -47,7 +47,7 @@
 		pinctrl-names = "default";
 		pinctrl-0 = <&pinctrl_gpio_leds>;
 
-		user {
+		led-user {
 			label = "Heartbeat";
 			gpios = <&gpio6 14 GPIO_ACTIVE_HIGH>;
 			linux,default-trigger = "heartbeat";
-- 
2.43.0



