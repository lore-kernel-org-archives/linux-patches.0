Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058468;
	b=mxspCYveKThE5jOZYTk8TIGJ0OfxkoVIvsY2WwFz1yCjJJu2qSeL97b5axvGH+Zb9y0g
	 j1nF3jplK7J2G1a9zmgC3yCxR3UY9ZBeZQ77o+H+6NdfN/DglTuCgi1GO9TQ2egJfyrbe
	 gmOLCz37YCcQOsCP79XnCgn6qDfXNvpgWuakMEiRlcx5tM7wBOTUJ8abGaOz12aIUVCZS
	 3/VuZHwCq/3J7r5Fl+Om230JsVs7wKUCJfD5TZrSmZIIE7iF1GpUeaMjgiPX5BBOKS1fp
	 xmzbovT35HH0KLcSIZtfC+aS2lWiSU+fvUTAzx6JrpbFPfvNvpjpC0WoUFH6GsHThsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058468;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oCUmko71hgrAmgPtU9qARaAIarijqw21zI6cbyjLCCw=;
	b=ZtZAkQ5GaaL6j6sX9v82vp39Cti6Fv3yRRYSxhij9nhFQMjlRam8m3zfZoLI6ycWbe1+
	 P1wLmkdl0w8R9Oq8HBG29TuZuWgsWPYK9k2846hPjP9RYpCNYno67NeV69CCEcObnu2FH
	 Sr1nPTRX6zW9Kye6RsOZomK/GvLM+cdqB20yLufnTO+b6OKSunEf8OKN8ntwDB8PGaBr9
	 ISTqj/lmB3Yp0luPwXYDofj7FoRZE32ImS1UNRdOOAb/8d9XCHSmoxGkFK+XVEpvj6kGK
	 o6kmG5w4hRj0vdWri7oEPV/h6j5uDkGtjwJUF46OpHGy1v++5Ztty6VaeCY287kX8Wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rfyu971e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C3F5606A320;
	Thu, 19 Nov 2026 03:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rfyu971e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A42E1F000C4;
	Thu, 19 Nov 2026 03:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058467;
	bh=oCUmko71hgrAmgPtU9qARaAIarijqw21zI6cbyjLCCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfyu971e09cXMUtXVltCHtt/tzxhd9jR8Z5HZ/myaXHKydHmrcu1PizF80QiJr9FK
	 Gurd6BsNgWi3pKxyzPnrQn0qhW2UHYTZZTf4jKuYqRReYzKBTqjrjN9dD9I+Am0e7E
	 bqKYpZJH7OidNVPUG/4JGdJKM/TxqE19v2hAsAo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wyraz <michael@wyraz.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0497/1848] USB: serial: option: add support for ASR 1286:4e3c modem
Date: Wed, 18 Nov 2026 15:42:15 +0100
Message-ID: <20261118145935.353647931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Wyraz <michael@wyraz.de>

[ Upstream commit 87c56085bcdfec305f5c350fe1c58a62a7f65843 ]

The ASR modem used in the Tuoshi LT22M exposes an RNDIS function on
interfaces 0 and 1, a diagnostic port on interface 2, and AT ports on
interfaces 3 and 4. Match only the vendor-specific serial interfaces
so option does not bind to the RNDIS function.

Link: https://lore.kernel.org/all/d12635f9-9706-4dbd-8adb-d673c6a77202@wyraz.de/
Signed-off-by: Michael Wyraz <michael@wyraz.de>
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/serial/option.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index bc9373e97ea6c..f065c0248d53c 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -2444,6 +2444,7 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x30) },	/* Compal EXM-G1x */
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x40) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x04b7, 0x8217, 0xff, 0xff, 0x60) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x1286, 0x4e3c, 0xff) },			/* ASR modem */
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x1782, 0x4d10) },						/* Fibocom L610 (AT mode) */
-- 
2.53.0



