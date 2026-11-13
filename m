Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591639;
	b=VndEVoUIltge8Fz4AqccuBWbwDFcn5K2qSEdow/hFYM4kZPbuBNMZeFdHFTB88ivU+dG
	 3LLOYSXwLYEcip9a06wDNMufRCOCIfol8ZrmEJELaJBcNxiB/Gbfz1ZubSxf0gu2BMh7m
	 KjRTzsZ9QyywCOCfrKtn48/uIpYg+SBPcPw9APRhdzH2MfBF70+MpAkiyU+mJKR0EPRq6
	 8JjtcC/nHBpH9cHK5SIAoJtPn972+E17oRKZD41xukitOfoXZoleclA6+YPYxLlXsh/Lb
	 0aAfCHqRhUBn1fZxsfEVjuiv8SobWq2T9bISrIq0wCsmVRWN0TfBckz3Zf3zhcHMhfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591639;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kQMtG4bQLtTmI3/V55HkdSylNgp3FD8oDguAld6rgw0=;
	b=b+Ditl+lX7b0QgVThA//cyYcfzPk0PVxBYAoNYtcO2Qvxo972uYfS9PuXlX7bLWCDYAk
	 oyqhVWCc4Wb+pGi/4FxEC6ZaMX5byYRyPoXc9qAi4MJgUaWpbL17xaFc38z/xnH/sAHnZ
	 gVqNZld6L2R121Ew5p28r6WZkcn+6szl0bAn6WfTWPHntT7FzVY8x6Q0dbzBpRQ+fw8zC
	 8ArWySNKWZ2UJy4IWM9aZtKMjY+b8bzjppepkoJ6xcdhEn5qp0WLi1gEMLC/01iFw9um8
	 Ui9F/UhqGqgz0fa3JJ3F//O5aSE29PyCGlXvZSQDHz8jiw08n1LQWOeAAJOpeyEQmNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5XrkNmu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0FC6606B46F;
	Fri, 13 Nov 2026 17:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t5XrkNmu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0721F000C6;
	Fri, 13 Nov 2026 17:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591638;
	bh=kQMtG4bQLtTmI3/V55HkdSylNgp3FD8oDguAld6rgw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5XrkNmuaxBmVFd2G2xhqj6R464KLnkeNIYZpT3YukO/Q/c9dVzJ19M1q9P6CqEh7
	 EbDM+pcwnCU2YgWEEe8Cc8QfOvU7MsQL3PhIsV4iNawt84CZvNfXfSYdTTJB5PbHNN
	 hUPuaYm51cvmWBoYjN2IhrQzAw8/Hhds3rIw9BFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 657/670] Input: xpad - add GameSir Nova Lite support
Date: Fri, 13 Nov 2026 10:53:41 -0500
Message-ID: <20261113153834.175993698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Orlando <francesco.orlando99@libero.it>

[ Upstream commit 2e6f2e5799f328ca0879dad14d7f3709c7f7496b ]

Add vendor and product ID for GameSir Nova Lite (0x3537:0x1040) in
XInput mode to enable force feedback rumble support.

Signed-off-by: Francesco Orlando <francesco.orlando99@libero.it>
Link: https://patch.msgid.link/20261011165821.72698-1-francesco.orlando99@libero.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: Adjusted context to account for missing CRKD SG and ByoWave Proteus entries. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 3086fc4a0642f..5e83766a308f9 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -432,6 +432,7 @@ static const struct xpad_device {
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0x413d, 0x2104, "Black Shark Green Ghost Gamepad", 0, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
-- 
2.53.0



