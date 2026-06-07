Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8BA1E98EF;
	Sun,  7 Jun 2026 10:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829024; cv=none; b=Uf3uQ5Qs0taYpohSZs6qPFgZdYKhCI0cb/7jGmZosNubnCwPWrJqLPnaxBDfReosdS5SmcXdfi4mWOKnJFQzpTDxxLmxe66RSlGYXf+aIcovP8R1DyXpZlnuNWmUumgo6z34xAkJX/C5rDUWbRi+Z11iq7T3WBzW/0vfqSnsQ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829024; c=relaxed/simple;
	bh=ISZfvGtEI6K+EjaEaAkmd5ynSN4xemTKAWTkjtKLaJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ArHoOuWeB/nVenCkD4AsMOEhl31pTCKkAiGPv1r9p7VvQILqlGrH5vNfqkpdYVjQZmdQbVWFmzjCNyB7UbSFNLHkoGDKi2PulO10pJrUWlKLcGeif9+8V19mIvOmche4Ly1g68L5dk6nl7QQp84nJ+3r9Xz0OISeIN1NjFBqP5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WPSIrQ8i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WPSIrQ8i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C1441F00893;
	Sun,  7 Jun 2026 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829022;
	bh=85XtFziLiyMJL7a7uxWMTmc2gLeIyMEEmHC6qA5KEOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WPSIrQ8iSJ2JKLV7HNATKntxBEbqbVCBpNBBObhM79If9QNbjPlnHmQ8WWSgameIa
	 T/10LPx4J0v6rslplTROaQWnE+uL8ewPh58ORfYEr54TIgdj/0Ez6XLSml29MaKR6U
	 EijzTIjexwtUnICJqbSRfvsah2TrGDPur0QkpupY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qbeliw Tanaka <q.tanaka@gmx.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 210/315] Input: xpad - add "Nova 2 Lite" from GameSir
Date: Sun,  7 Jun 2026 11:59:57 +0200
Message-ID: <20260607095735.270733190@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qbeliw Tanaka <q.tanaka@gmx.com>

commit 1f6ac0f8441c48c4cc250141e1da8486c13512ba upstream.

Add support for the gamepad "Nova 2 Lite" from GameSir, compatible with
the Xbox 360 gamepad.

Signed-off-by: Qbeliw Tanaka <q.tanaka@gmx.com>
Link: https://patch.msgid.link/20260429.162040.930225048583399359.q.tanaka@gmx.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -425,6 +425,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
 	{ 0x3651, 0x1000, "CRKD SG", 0, XTYPE_XBOX360 },
 	{ 0x366c, 0x0005, "ByoWave Proteus Controller", MAP_SHARE_BUTTON, XTYPE_XBOXONE, FLAG_DELAY_INIT },


