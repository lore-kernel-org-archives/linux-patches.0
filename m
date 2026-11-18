Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035074;
	b=lWe1SzMplIIXH9rj5/JoJ7lgR49vpzaJqwFthAJMp1M6By/qNgaM2HDTOL9mzDcu17+R
	 oMjaJ8Wa5wQAEAnIRMGSGYP8FGLgumFmY+Vv6EePSvQYeSM5LxCyTixeD7cr+/xoD5oi2
	 VBcLMuDovN8D4h8o7aGMfyLnlJUs5K+oO0/hakajKkxR0t8qaMbkvqfFjNKqRbnT7sK68
	 5AomYaMNtxkxcDV3k3rQsv+26rO/yHOwTFpIhxgvOrrvY6CszQs4DFgT8cPtfX4Hs+YZQ
	 RWK+F4HQxT06i4HD/Am7QVjO2QxXLn8SQ3yCVx6gMfXsMnFD8sUp8jXdVVjIPf0tq7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dhWeeQvSZo0ntCtoSg3HY28yjN7GKvni7NedMRp24qo=;
	b=WhLkG5Dgs3ceHWV4SQBsXFf1lhtvIQnVo96WqSdHgPCANmfFqK6RdzTZst0VUZsIbv7v
	 jx5tig3Nv9DKiPSfyBsnTAe7dF465A3DuxFt741Ru67W5B08ZDtkRTuAM2Qp9Z14GVBMf
	 E1GTl4IHeV4zb2fNLme0sCL6/0RwSRY5q5ofQEK+HAFY+7n6DQp6k2GUC0oDojR9WQZoP
	 wZZI1a/nfNddm7JRiYr/Z/Swc8lIUm/B2uiotDgrFOLqcuhW6Eqjq4kQ2AvJOpVXsHJzM
	 MhXanaSQ5e3P2cx3QOU4D3Ukcosv+d/sLo1NMrb6/sUf2GB0JSoHUYW0pnuRX7677og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2j9Ncvz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BDF5606A320;
	Wed, 18 Nov 2026 20:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2j9Ncvz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE8C1F000C4;
	Wed, 18 Nov 2026 20:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035074;
	bh=dhWeeQvSZo0ntCtoSg3HY28yjN7GKvni7NedMRp24qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2j9Ncvzob7I0AAo2Gen8lWxZ6GcYmF2gqyowExWRRxT0fs3Tx4A824Km2kAQtG2Z
	 97RXhAcbtuXKBxb6hRoE+VzheLNntSYiMXvE0wS89nhWc7zxAYjyjO25m028gNCNBG
	 9btNbKOImkONStEkgg1plawcTaZ9E3idEskUCWaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bihaan Sen <stevewholikesthings@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0536/3318] Input: xpad - add support for 8BitDo Pro 2 Wired Controller for Xbox
Date: Wed, 18 Nov 2026 15:19:18 +0100
Message-ID: <20261118150333.328602810@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bihaan Sen <stevewholikesthings@gmail.com>

[ Upstream commit 41363c27b8509bd4efcba244803edac9ba25d1b5 ]

The 8BitDo Pro 2 Wired Controller for Xbox is already matched by the
vendor-wide XPAD_XBOXONE_VENDOR(0x2dc8) entry, but a later hardware
revision reports product ID 0x201e, which has no entry in the
xpad_device table. The device therefore binds and functions but is
exposed to userspace as "Generic X-Box pad".

Add the VID/PID pair so the controller is named correctly, and set
MAP_SHARE_BUTTON to expose the share button as KEY_RECORD.

Signed-off-by: Bihaan Sen <stevewholikesthings@gmail.com>
Link: https://patch.msgid.link/20260925114459.110253-1-stevewholikesthings@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Dropped the context that referred to the neighboring 0x200f entry, which is missing here, and added the single 0x201e table entry after the 0x2000 entry. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 04cc323e30147..d46e0ad742307 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -405,6 +405,7 @@ static const struct xpad_device {
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2993, 0x2001, "TECNO Pocket Go", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
+	{ 0x2dc8, 0x201e, "8BitDo Pro 2 Wired Controller for Xbox", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x3109, "8BitDo Ultimate Wireless Bluetooth", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
-- 
2.53.0



