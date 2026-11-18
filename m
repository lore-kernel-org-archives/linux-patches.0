Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059861;
	b=NLpGNIeyXdhJ9Ue+K4gRsw2tSInDJpdKq4+/Ii4c0crc6jnJoTrDdQZbTR51ESW1O4jH
	 qgK/8pHV1YEsOjzrPMVVWxzwx7Cvv3/AQy/csjxMaG1DQ1sgRVodcnQhjHVgYrXH9sNlB
	 chpOXswYHk4muxE5kGMj7o8TCEHaQ32yulIOpB8ZANhDQLiUWA1mVPdX8egzZuLCbruci
	 c4/MN0w6T4ekDNxLEyOmnn0TmCC3KA9FAtuz6Joww9LRcHEsorzWtgL5UyVns/Hx1pn8l
	 HlpAJeOm/VbWk8H3YcFvS8ujbdZvErzokSVho9YZzwlmoo7G2K13eglJcoiyeuiNogQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059861;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zXsSGBZE3MdssI0jMQzA9j2j0es1zbtlxnT+5/IqSq8=;
	b=5YoFd0KiySa38ckzFtnTHPvTcBLkazBJTxqEBNeyancfv8JUBq1s2Ra5ZDraoZCV6X4S
	 qNYVYeEfjDi1le9ShLteJzvBSbZy/INOzGaWXMIXkdEBMtXs+e5305t3H8jVd1ejXmqjA
	 sh0OJobOITiggkWTFFmpJ+Hp/30sQCpCF52qTtORzNCGmJgOLaNmEab9+exXNGaM8VOIm
	 KltNo6vWGKB+CglBv7cvuG1M/yj8jtz0ESlQNYmdVl6/S4SrBj38z+QG0jxl0CSZX0TkD
	 5dANS3xrv8iT6BoADeBkeSAoz+sBAom5AN1NJgN/GFJZKIjSI6jXJLCRkxo1LjjqKYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7do5x5i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC09606A320;
	Thu, 19 Nov 2026 03:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7do5x5i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3CD71F000C4;
	Thu, 19 Nov 2026 03:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059861;
	bh=zXsSGBZE3MdssI0jMQzA9j2j0es1zbtlxnT+5/IqSq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7do5x5iyh1sV8MiqsVJKWwiiPlvc4dXAc8PI/maF6ycpN4rp4eH1IiGTfivfoQfG
	 1hefBHh2e7DLf0GSDFDiufxuKqlezJHEW11y8t1giQGxJGb3Pc6+XDQGaJJE1sCIFe
	 /MvNsdSU7w/+nxYhkFaf3dwq/Q+YYfmqdLDhG94o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0993/1848] Input: xpad - add GameSir Nova Lite support
Date: Wed, 18 Nov 2026 15:50:31 +0100
Message-ID: <20261118145958.439632915@linuxfoundation.org>
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

From: Francesco Orlando <francesco.orlando99@libero.it>

[ Upstream commit 2e6f2e5799f328ca0879dad14d7f3709c7f7496b ]

Add vendor and product ID for GameSir Nova Lite (0x3537:0x1040) in
XInput mode to enable force feedback rumble support.

Signed-off-by: Francesco Orlando <francesco.orlando99@libero.it>
Link: https://patch.msgid.link/20261011165821.72698-1-francesco.orlando99@libero.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: added the missing XPAD_XBOX360_VENDOR(0x3537) entry to the USB device ID table ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index b5c3b8f73011e..f3d32527d7527 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -354,6 +354,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -482,6 +483,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
+	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	{ }
 };
 
-- 
2.53.0



