Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052565;
	b=IL09qBMQl6kV5sCBgDbpWZq50SKMqYZrsJ0k5apymhIAC+lLswNgL1tOYlnE/G6iNEaF
	 fHJdTYKedSCgU6HETEHrifUUAntYHqY1RoWXGgAqdHWqRAJDYPoHG+A34Kre2txOgCjj5
	 TzqbwsK15oZmn212Z7+ooTJaQ/jJPsf7yTWkNvw1rpfDLpcLPWHd6FJMTM3PW/tRpz+vG
	 77COov1mzCSBw4Q9Ahtb/DTRlihd5JkAuaxzcnya2BKsZp4IO1yr3ombaxbO1PwZUDBRA
	 W4qiGt72yxsaYOMfhYuUkN2AD7urLTdbiJ4TVEz8PAW3uA+iU6eefjq0n0nDL4BoWgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bv4xfwHGGW8rCTErXFG8jYoz8gev2NTrp2Y8qv7I8/k=;
	b=pR7IUlF4I2mPZbyJQMXzGrYdShiqISwH7cWj99wmlpoUEnIhfokqwKU5WF2Nxw4s6CIC
	 nn2JJyaJC0dLd3aIBkjmyZRLE0TuAEo/UtyZLgHt4sMlRgeSzwiqrTR38q1y9Dp4mkV39
	 23Ws9Et8jo72HfYKth0vS5TGd1bNnTPgnK4SHGIlxSpSQ4B+TsxCmUNxMrpwq8OylGVl4
	 sSUfokcL1n6j+rkc+egWr7kmCZMmD1mj4g85wDQja7ft/6Yst4nqXMmKoraRCm4D2Ptyy
	 7MI4YHe15kF/u/2J2sdlvAE5GsUfs5ahOLqXCDZodIo4m7SmwXYmHxmvWqjz1GKZv+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUxrqFjl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5293606A320;
	Thu, 19 Nov 2026 01:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AUxrqFjl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342981F000C4;
	Thu, 19 Nov 2026 01:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052565;
	bh=Bv4xfwHGGW8rCTErXFG8jYoz8gev2NTrp2Y8qv7I8/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AUxrqFjlxyr7nUyn7D2rUAMGHSBxFe5oYwnZNxe8NkidQGM8sTmO4cn6HLNmppwGt
	 GgV2f5HLDMm/b9Bqn05R8IzwGtcZk2bMA3h20q5nTALmnQNHrHPZ7oC/fAdoEkpWCC
	 5Atq5zwm+KfCtSUZh2j8NQf7WrxRo34vghlEtKM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Wyraz <michael@wyraz.de>,
	Johan Hovold <johan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0608/2214] USB: serial: option: add support for ASR 1286:4e3c modem
Date: Wed, 18 Nov 2026 15:38:04 +0100
Message-ID: <20261118150035.468361035@linuxfoundation.org>
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
index ea418fbd7149c..6663b352d7a63 100644
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



