Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027072;
	b=OPCo6z2IhNAai5hEapcA6625GEykq6EJb/eYp8iwNM3f/yEQ/LcGKXO/YdShRSxgn+Su
	 iESfqF3A2512+T2y5PN5HBAVo9bjN/YkYSVnOQF5EQu3yG0mt/axNQed+/D0+HGjRgGaZ
	 96dr5i9Ep9yrsawFHh/8jZkewwq4pcZowEH/DV110K4wgNfH5XNdRLmqAmj4lYDoR7Jmx
	 hA/ptnmKbrWN0UUmQm2vuZfcogPvNVUbZfo7Zm4jHyYSbOl4tjUQBYLceenpznshaLj1/
	 tcLiDVk68RgKjqUm3zmvxzmCH2J2d8HyTNI4SVWpQT4C1W2IxPX9U5tDyruD3XRx3UA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NvzlI2hDWInl1AYM2d8VTEa5G2P82A9iyyrRnoBTMHA=;
	b=UzpFZdfezhjjubUWwAoobGRu9Z3pBZGCrZgGBt9bt/wHVg6lpL17CNrbqzyfdC2Txcz5
	 kgzmIKiY/s6v2hc2HbkF6wQ7eKavBzPrs5qXARKlj5ToOilwOHlYOXjHKkr0i7NqyfhXJ
	 BPmYBXS6fUF8AYE6vtsj6bcOOjZzy+eVQ8LYUXfjAX1kB+O5EnTk9u/09Vs5fiX16SNT7
	 V+SL7+Sk06JDMg9RAx8R/6D+5Txwxi0iORxLVYyXyh6xyUDBRq98c6gYcJWTQVHU8Eom+
	 nKa8bo+KMhC6t+6joWW9aZPZVBYwR0ApBXjy69jwZ0XWoC+pOznupLEsuaSG/WifJqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l/w5x4W7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E46606A31C;
	Wed, 18 Nov 2026 18:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l/w5x4W7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3751F000C4;
	Wed, 18 Nov 2026 18:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027072;
	bh=NvzlI2hDWInl1AYM2d8VTEa5G2P82A9iyyrRnoBTMHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l/w5x4W78kprgMUrXQ2QypT2boUy+5NWp7KHYhVsSIwW7Gz3/k91t92vx8l08XTLt
	 Bkvg8oekJCPQ+lkZb6B9d73dlKZOV04RyxEfOEEbkDU6TIjdwXSfyRLxeevRbxKhO9
	 GqNDFr/HIod+Pxu1fDCk8DuK6CPgI0tlwSVJ8tRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1661/2151] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 15:56:36 +0100
Message-ID: <20261118150222.347969578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefano Munari <stefanomunari.sm@gmail.com>

[ Upstream commit 9272297df14124fe603c81e40b52ff0c5dd88652 ]

The runtime PM handling removed the -EINVAL return for invalid
EEPROM/OTP write requests. These requests now return zero from a
successful usb_autopm_get_interface() call, even though no data is
written.

Set ret to -EINVAL for invalid requests while preserving the runtime
PM reference release.

Fixes: 8a7ffeb795f8 ("lan78xx: Fix for eeprom read/write when device auto suspend")
Signed-off-by: Stefano Munari <stefanomunari.sm@gmail.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Tested-by: Nicolai Buchwitz <nb@tipi-net.de> # Raspberry Pi 3B+ (LAN7515)
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261010213248.15938-1-stefanomunari.sm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index b73490cae3ba7..3597ae6a542ef 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1712,13 +1712,16 @@ static int lan78xx_ethtool_set_eeprom(struct net_device *netdev,
 	/* Invalid EEPROM_INDICATOR at offset zero will result in a failure
 	 * to load data from EEPROM
 	 */
-	if (ee->magic == LAN78XX_EEPROM_MAGIC)
+	if (ee->magic == LAN78XX_EEPROM_MAGIC) {
 		ret = lan78xx_write_raw_eeprom(dev, ee->offset, ee->len, data);
-	else if ((ee->magic == LAN78XX_OTP_MAGIC) &&
+	} else if ((ee->magic == LAN78XX_OTP_MAGIC) &&
 		 (ee->offset == 0) &&
 		 (ee->len == 512) &&
-		 (data[0] == OTP_INDICATOR_1))
+		 (data[0] == OTP_INDICATOR_1)) {
 		ret = lan78xx_write_raw_otp(dev, ee->offset, ee->len, data);
+	} else {
+		ret = -EINVAL;
+	}
 
 	usb_autopm_put_interface(dev->intf);
 
-- 
2.53.0



