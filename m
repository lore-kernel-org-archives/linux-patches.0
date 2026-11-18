Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047292;
	b=z+hreZPx6qxgGm3p8JEEqQXWhnghTy2g3HI1OKhU0l7WVidpGXH8Z11Euj/Rouaq+2ud
	 fWyi6GtR6DAIdcQbn7gjMgD6qZkNWtY/jRj3J2dUdOxgxJy7yk96EY23n1pET+LRjrHS/
	 XvZOUWHCjCpBJw/mrSvNPtjjEZI0q8XIQUF7/arpAuNOiAesvt0lI5dLGe3m4ikHWdg7U
	 QsBmz9HSrjS2U9PrGZpl2dottjdWEHCx8drzRWhN88GTyCxmKGn53R56nJ3cEPnc7qiyt
	 XvP1ho0LDz5bttjfFGOlBXD3PSolN+42fcjSmz+1t2eqxa27htqJgB45T17NxNUqbtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047292;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gItKfY1zHUK+8uD0pWOfJj/h3V0fEZZQ6F9viSxEPOM=;
	b=wnux+7L8hBck7RAWs7WxnXN9LOT44TeL5peT6yE5Ws+ne6tcmZP0nyBvj9HpkobcKSzO
	 /pSzVslRy8WPpm7/KtV9mhEjC9+REt1U2AdHtm3pUmeYejP5ZW9Xg9wKVKpU6lc7BQgpd
	 z56ml6W3rrexDEwvXJUdmrGMuo34riq71ul8G+vCv03/1KurcVZ8+9ihTflaiI62oTXxV
	 1v5QDmUDFcQKAbSf4x7ZAKx0/gYb3JTToMVjp3qQn4e/RBn4k/dEIJERAcCx4FYCIIExH
	 OEQdw+mRKjF4u931grM0tJ7nKnwK2KisiLzrz9sgHtGeKOU2549swvejwMZ6ncdm3gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oODXTa9S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CF89606A31C;
	Thu, 19 Nov 2026 00:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oODXTa9S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA1441F000C4;
	Thu, 19 Nov 2026 00:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047292;
	bh=gItKfY1zHUK+8uD0pWOfJj/h3V0fEZZQ6F9viSxEPOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oODXTa9S9VXwIXKvLXcTGmYMcDT0olRyCic2nMhd1ka5CHHOnPWBgTAJ7Nu8ollcn
	 cIhwvTbxVhv+fEr+fSIlrBOpci9XuyUMqARwk5gxRpZCkoGuKqmpp+qlz05Zpbf6JC
	 SSnQ+HJoqI4/HJD/o3osJOh3B7FNQftIfJkSU1YE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1586/2857] Input: xpad - add GameSir Nova Lite support
Date: Wed, 18 Nov 2026 15:43:40 +0100
Message-ID: <20261118150258.480696645@linuxfoundation.org>
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

From: Francesco Orlando <francesco.orlando99@libero.it>

[ Upstream commit 2e6f2e5799f328ca0879dad14d7f3709c7f7496b ]

Add vendor and product ID for GameSir Nova Lite (0x3537:0x1040) in
XInput mode to enable force feedback rumble support.

Signed-off-by: Francesco Orlando <francesco.orlando99@libero.it>
Link: https://patch.msgid.link/20261011165821.72698-1-francesco.orlando99@libero.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Added the missing XPAD_XBOX360_VENDOR(0x3537) prerequisite entry already present upstream. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 458e166b97095..85c58e512bd40 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -383,6 +383,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -521,6 +522,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
+	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	{ }
 };
 
-- 
2.53.0



