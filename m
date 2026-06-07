Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11A5A2DFF04;
	Sun,  7 Jun 2026 10:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829344; cv=none; b=TvIL0iJd50gS8fYjzAHruZ1PfPYxLC2ujXiYDH731BsqvttQp0YqKVUlemPxccCwafKiJVAskJ4ksjXc9kJEWK92SpJl425JnrTq4wa120TypeT4Wtk0a79yl5ym3PrvCMc0L8PeV2dd8d4gXjpCq0X0vegPTsfQKXpe7cBwKkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829344; c=relaxed/simple;
	bh=Qo11P9MIVJ0CCvnt98hlv1mDcBhdMAsyBsUkvTOba3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=logv9RDj06fV0Kv7k9iN48MdIVpxSMw9N2Z+/crlcjKJMQyjeFcMSlv1cxuV3bB9JXvTWE7EL1oz7RYaj4at96gcGmFVyUkkBrRen97wrqHzRIT1A5PgXNfjzwrOlQwTkt6X/2lyw3CILr2KW/2uli54kL99aTPmN471w5KJb7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr1U58vB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr1U58vB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55D391F00893;
	Sun,  7 Jun 2026 10:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829343;
	bh=TMPdvlV5btR6fJ0eY9V9SMpVYumptgAUOJ9GhCEGJ8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qr1U58vBFOGZ2ZTaIHB4lS3VI5l36VxnQm/xOpk1tyBlxJt/NyyuEQSiSSk+3eU93
	 RnzEciRdQMKV2Prd8IQDkKeu0yHla2hAKPdE9rXxJc7kfUQgYNtFNQKphpVOuXTWAC
	 xPYNMJCRfaymZ/hZqCFrVFsSMisTUSOE7Mi3Pec4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qbeliw Tanaka <q.tanaka@gmx.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.0 237/332] Input: xpad - add "Nova 2 Lite" from GameSir
Date: Sun,  7 Jun 2026 12:00:06 +0200
Message-ID: <20260607095736.758650230@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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


