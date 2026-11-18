Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054195;
	b=TlGi/0ShTECdJKqa2TAyhVgs5qQmpa0o8DKWPiRNCNHgIjXv47H67X77DcqmfXvjo0NZ
	 lnVH/wpJUVC3xRYjMmOR+xUGDMngi3+Qx0J1+Yihu6al2IYDkGuRc2DGy2Q0nXtuQfbwS
	 +YYL18sMc+64qxHyp+cLtZ40XoGJcc3I5AoJC3IDnbuJqn+7ZbJRevpeg0co9MtE3AcYf
	 U3z9Q6SgEPT4ygFVoExaMmahkWBkXc/kEM4Pt1IlGwyiNKRAFnWZRBkE7c7iOsdAHlxYC
	 t1CGxJMs78jwEC9dpAX7E/CWxUmJto4cF79k0Okp76El9mvwnidtqMM86VSLYWlpQ1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zs8Idcot8mHN9bk5TKLYZk5gfhjR1jwbok2ttTdZxIo=;
	b=YPG5HEBxeu4IHggVfEYtOerHN1hmK3JG6Lzi5Sv5BnZRFHaZ1EBRRuPo3xQVNfeG1Y7Q
	 zcM5X8W8v5Km7gyrPMmKbgBfef6gjFi/hoeYe6tsvifpP6x4Mn079pOkhwgEKzYPPm09+
	 Eksm34B1sBTp+tB52SeZT1dDVOSEDP0M2kFvAB100IXfvMRM0fdfgv5xPnqV4JgpS/YR7
	 LSdFYmZvC6JhKwR90LHdyeRwIHseIqqCGjN1gKgrZng8C82gmBhkz1C96pZjsCIXlrz+y
	 AtRyDlyGzIQcyfArrNFF2P+VMK+eqgtEuOkl6NKvnaLLn2Y8HXWQ8PPdnSRnOzVlPKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uwl1fMKA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44544606A325;
	Thu, 19 Nov 2026 02:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Uwl1fMKA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CAA61F000C4;
	Thu, 19 Nov 2026 02:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054194;
	bh=zs8Idcot8mHN9bk5TKLYZk5gfhjR1jwbok2ttTdZxIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uwl1fMKA71OjefmVLxyr9xVkt8fl72Vx2fyDlanN5L3dnnrzTof57RMjMvFv5ZK1F
	 UfcA/JFw2AnZ4ekXD2xMDBVP3xtH4h6N8lEwb3Qj4sdb9/KwoifVGQj1yHDzGBS6tP
	 4SPwFmIEGNOc8u2TjpNg46OkbzGv/6Gwtc7cKgJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1187/2214] Input: xpad - add GameSir Nova Lite support
Date: Wed, 18 Nov 2026 15:47:43 +0100
Message-ID: <20261118150059.398821697@linuxfoundation.org>
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
index 4417cd8fa6d31..32f5d9ef34cd5 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -363,6 +363,7 @@ static const struct xpad_device {
 	{ 0x31e3, 0x1300, "Wooting 60HE (AVR)", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1310, "Wooting 60HE (ARM)", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0607, "Nacon GC-100", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -493,6 +494,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
+	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	{ }
 };
 
-- 
2.53.0



