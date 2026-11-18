Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056482;
	b=vVmG/tp2uZzU8TU45b0CSftcUKg0Vm/e6WsejECg/jHNy4rQNg7vDDlcUxDrk6Kvuwn0
	 um+2hHb5SnSL4vpwVS0/o6hKn59veiZsZVuP9SbUSLLzei9MDXxELGHbm36p5wPBsAqam
	 CFVX1HGxdTN303+Cv06MenRwyE5XEvUB6WopO0MfvUBDoKc4oN4lDhYK7OCb8HeGeE/qI
	 CYNW7WcwC7r3Pofzferd92Ol+Gi/UxKiQGGG/IAMYxsvik+maCfdB2MpCF60qZ/FMXNWq
	 5JeSc8JRyjTZKycDWYrmo/MWYHTL8BH16hLoyJtq5jfG8ZEVbgpXZzoO4apEzOhn5JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HlWkGSAKrqo2cCtCmAGBF/sPTBo4EfFGUpWEz9MWcIM=;
	b=H/mbqFomw6cMipA1PIVVKqbDFY3FCv1K3IVV/pi3QBw4ZKAA84BAhH9QlNLWfcNQDABO
	 XDvhsLZZ/wL+KAfaaDP514XqmM8TSImZlzP1Mer6XxqsGC3J4E+Lk5pwrAjmgfe+UlAID
	 LU76r70NcLVmfmx+T7fcIO35oL7TtL+HRyFc4YyheqtUyGMk5DlAhRDubHdOSoi1g6KMM
	 mS875f5QQTgZ626P50pwOWQz1UrVi8x5SoTc9EuapVOk4/hLCvDhByUmTVuME3yh3BfJG
	 EWVpPChAyH30r/wyB0xMhTZIrR2eacKzL2oSMV9zVvXMk9qpxgCKAVGBUci/Htm834A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMfbpqTd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D863260A2607;
	Thu, 19 Nov 2026 02:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMfbpqTd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C8B1F000C4;
	Thu, 19 Nov 2026 02:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056482;
	bh=HlWkGSAKrqo2cCtCmAGBF/sPTBo4EfFGUpWEz9MWcIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMfbpqTdSPFHDw1qEUnMWrop+zpPzM1t0YnzYqH0Zo1ZWsNaQFum5asQZZMo8yasK
	 ywCxRpYBvQLRviIdWDvh3qq5OkeQFbmZKKpfdc0HJoaD+zTU2xVSfXHFpzZrcQrqgj
	 ic8vSlnBgCcYLnQXadMgfKqBkwNCjKZPqbWyfaaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Munari <stefanomunari.sm@gmail.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2005/2214] net: usb: lan78xx: reject invalid EEPROM write requests
Date: Wed, 18 Nov 2026 16:01:21 +0100
Message-ID: <20261118150130.975154458@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 82fd04b24c97f..de6304b5ca8e1 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1428,13 +1428,16 @@ static int lan78xx_ethtool_set_eeprom(struct net_device *netdev,
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



