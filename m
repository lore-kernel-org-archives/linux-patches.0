Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617777;
	b=MAL/euTpHO4rZDlL5PNp7qy60ZwhWWBeevI+sVDXlrXDXjE2OQH9Il4LrH3Qz8ZoMZqI
	 gwLdZC1lq58pn36nHju7lcJ0vivaD6jkti+Tau22dv/hCWlGQSpDh0YqqQftGfvB2KX7d
	 UKdvJBhouJMHiipFlhac+AlIk46OEtxupEMvAdBKnqA10zW5EE1MAxRWS2KKkLx5YPz7c
	 mA0u3c+cpoOauIBemaqeFqHRG2873OIOfpYcRhtwNWmfQk9lSFz2KvWwECiSTQeT7ztNi
	 uc2z5qO80xUB6wY7jkm3vwLZI5w91K2TL39whD8BXFGWdmzgE0aPfbm/iAADkktVE+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nmjglaSJ8LPJEV2XXZKaO8a4rej/A8kxltbitLXfk5o=;
	b=ahiFe4aY6PpzFqkdRQN2mtJbuMuuR3JfrgrOwW06+2B0x67LMVUVsmOkXJyjw7Mvqt/e
	 uZHnqpbg9W20YsjOENB3wsiKCkfIyNlvt9wG4m45X+CCTqPEM/KyY8d1pZz69b6Xa1v/B
	 zwoujoXLIs4In2FdiHYF+P8tctU8cRiwE6rN16bFaOGxFA/6VBle0NTz0SILo9iOY5AS5
	 5CkEBpJyWg7eclIU6v0dQsKwMdh8gNpDBJSs0xP5mMI/0/bPofcu2jbhmUk+EjtwN0ArR
	 xitrotuFmgp7eOhug2XO9oEUGZwTd+2KLnOcPB8vh40ZcjZdyu+NlcDE/PFsWCmS5sQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBGsQKEW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465B2606A32D;
	Wed, 25 Nov 2026 14:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pBGsQKEW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75CBD1F000CF;
	Wed, 25 Nov 2026 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617777;
	bh=nmjglaSJ8LPJEV2XXZKaO8a4rej/A8kxltbitLXfk5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pBGsQKEWhGV88nV0CYXuaNrQrRsQCmjILfEldqC0J1x1elNefKS2HxAf4FNOokrqi
	 KUHXmE5gKnQuxIXmjSvsR1FcOHns+lPw8ebMssptkjGxkhsbFYbGIcheHHk1QWTwq5
	 LovGz56CtI3hiQa/L5kl0+pOQqpXveqiFSjwkXXI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Venenga <nick@venenga.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0026/1005] wifi: rtw89: 8922au: Add support for TP-Link TBE400U
Date: Wed, 25 Nov 2026 15:22:44 +0100
Message-ID: <20261125143822.349644148@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nick Venenga <nick@venenga.com>

[ Upstream commit de2cb461456143a69845c24ce38ac14a61d6e166 ]

idVendor=37ad, idProduct=0104 TP-Link TBE400U (USB-C, no external
antenna)
idVendor=37ad, idProduct=0106 TP-Link Archer TBE400U Plus (USB-A,
antenna)

https://github.com/morrownr/rtw89/pull/123
https://github.com/morrownr/rtw89/commit/c98e6ff31c331be35383b5a500cfaf76620e2d0c

Signed-off-by: Nick Venenga <nick@venenga.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/010f01a04e02d70c-a52abf35-2e60-47a5-99f5-b064b344ac19-000000@us-east-2.amazonses.com
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/rtw8922au.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw89/rtw8922au.c b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
index 2cd2b76d19acf..7854e6aca749d 100644
--- a/drivers/net/wireless/realtek/rtw89/rtw8922au.c
+++ b/drivers/net/wireless/realtek/rtw89/rtw8922au.c
@@ -64,6 +64,10 @@ static const struct usb_device_id rtw_8922au_id_table[] = {
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0101, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0104, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
+	{ USB_DEVICE_AND_INTERFACE_INFO(0x37ad, 0x0106, 0xff, 0xff, 0xff),
+	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0x3822, 0xff, 0xff, 0xff),
 	  .driver_info = (kernel_ulong_t)&rtw89_8922au_info },
 	{ USB_DEVICE_AND_INTERFACE_INFO(0x7392, 0x4822, 0xff, 0xff, 0xff),
-- 
2.53.0



