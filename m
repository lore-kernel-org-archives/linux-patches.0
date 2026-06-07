Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50799296BCC;
	Sun,  7 Jun 2026 10:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829219; cv=none; b=FvF6MCxGMU4gN3g9oekAwQ7xq1OdmacmVeHQdFucorb33hgXa85PV0AkRv3P5oVbxMVP//MS1uRMGfWWv05MYqbMPpUeolwq59LALHAEmQVxnqKverHFKMNU59+ifteqwdOuoKn0u+mtl6w8S+9ZV40KpNPsIamS2/IT8fbDXLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829219; c=relaxed/simple;
	bh=qkKZP1BErSepaU5JmEyvzM9VpPABHH0gADfs5Rg/TZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbPx8SInD254sUuUDkza25m/EfnztVDY/qHLrgEQB/RRqJb9JieClPByP4Qk6pndcYfpnLpbqbuuiFDhbxRmAEScmd76iPn76ryLyRl37oS2MLyv7iiEccIVjXIHINnE12j2xx6x4YgdVsM8HeIRDx5tdwmH1rEnGZcz2J45YM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKKp7Q+Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKKp7Q+Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BFD1F00893;
	Sun,  7 Jun 2026 10:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829218;
	bh=XJJuf0ZWm+3TyhguEOEci2uxApaggbLqZ3gOXKUnaiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zKKp7Q+ZE6dxuoSLUsdIjwshnZH44u2cB5yM/JSuNnnP8ba3gPARoFrY8Tgu8AFaJ
	 Y1ploqgr0boYXo0HnkNJLt/LH6L/9yjV5UgaFLbxAH2ilkPelo/ddsMdugRILQD8Am
	 5Pf4jGx7EEgcueaZVWu1u51jgmSC7TDHoyC2tiGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qbeliw Tanaka <q.tanaka@gmx.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 205/307] Input: xpad - add "Nova 2 Lite" from GameSir
Date: Sun,  7 Jun 2026 12:00:02 +0200
Message-ID: <20260607095735.253884191@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -415,6 +415,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0x413d, 0x2104, "Black Shark Green Ghost Gamepad", 0, XTYPE_XBOX360 },


