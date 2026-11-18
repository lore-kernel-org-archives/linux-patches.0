Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038807;
	b=1fkT3l+ixYESk9wcKLdTJCrO4SqxqrKNsT8yTYY0sintsIYnDiOoaKTD1rIHIakMLk/p
	 2vxTbw9SfR8W94I/Ch6EIxCuQR/rCCqTpl0DeAX4czQmBWUFP61FRCKXJZVzABRfLIHqR
	 CJ4NEO/mENzJuXv8f/4TILC0p8JOUWwKwDoxypuFZ68a5vnvG/xbceUOeJw8eolzNL44Z
	 1DNdlfig3NSAEPCw64AMtzCpNU2OKzKKKE/sJclc1nA5fi/0uJSjhwulokdYbGXE6aZi6
	 r7guuo9rncAOq+o0HoTeB/jpfd/zAw0yljEHL4JVklMNL4di+xx8Ry5HFqc1yAdXuag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Or1WKawZg07+rSWrZ4zxfpJmQECLNPEn88RwrVab/FA=;
	b=anbIye8b8nBRIfN+yAIvuTj5494aQO7C51TsqWqCVbVQWDAcBB0sQmNopND47MAfxAGn
	 E+/klioRrBRKhkXoY23DLs0/qT+ASZbLTnCrxtfcsV9M2SPGHUk5H7MYoe54wH8/Rgzns
	 KYLPwiU2/QJ+0Mz1mLvRsL+fw45xcEFDZeHgp1JKdUA19y99KybVO031RXPKWuU6liAjz
	 6sINRJinwGrv/8UT8iqNYXuraijQnRAm1k5unBgajbU21J8eDD+FtYQrIWKNZQEixao5I
	 9Jza8SKtCNtDveD1wxfd+WAuNGpQIRotUGwSKScfjkbVoQ8iwnz1txpxaYtl9mSVJqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8ROzgzi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D0F606A31C;
	Wed, 18 Nov 2026 21:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y8ROzgzi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C18F1F000C4;
	Wed, 18 Nov 2026 21:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038807;
	bh=Or1WKawZg07+rSWrZ4zxfpJmQECLNPEn88RwrVab/FA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8ROzgziID36lSsT51jN56Znb5ffPCNofWCIZzBBEW9VRb/0VFGMqhk7ehJ1IZEHl
	 e0gwB309isTVrbEBwujPDGOU2EzTJsNOJUvQfbiDiEE2lgmPsirxoKU7Br3gKfEDG7
	 Jh+An180eZTwokj/Rf6F/KpS2X3k9zU/a1Ri+r/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Orlando <francesco.orlando99@libero.it>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1832/3318] Input: xpad - add GameSir Nova Lite support
Date: Wed, 18 Nov 2026 15:40:54 +0100
Message-ID: <20261118150416.820023894@linuxfoundation.org>
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

From: Francesco Orlando <francesco.orlando99@libero.it>

[ Upstream commit 2e6f2e5799f328ca0879dad14d7f3709c7f7496b ]

Add vendor and product ID for GameSir Nova Lite (0x3537:0x1040) in
XInput mode to enable force feedback rumble support.

Signed-off-by: Francesco Orlando <francesco.orlando99@libero.it>
Link: https://patch.msgid.link/20261011165821.72698-1-francesco.orlando99@libero.it
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
[ sashal: adjusted device table context due to missing CRKD SG and ByoWave Proteus Controller entries ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index d46e0ad742307..904e701ed6ae7 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -431,6 +431,7 @@ static const struct xpad_device {
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
+	{ 0x3537, 0x1040, "GameSir Nova Lite", 0, XTYPE_XBOX360 },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0x413d, 0x2104, "Black Shark Green Ghost Gamepad", 0, XTYPE_XBOX360 },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
-- 
2.53.0



