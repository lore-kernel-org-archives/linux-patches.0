Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8AE937C902;
	Thu, 20 Aug 2026 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238125; cv=none; b=oQZSL0Dp0/ay6Vl8NejysExeIkiPNiq4OLI+AR1MpqI8ubISsUeuBE7w/6ado6O29PoAk1S95yTzsm0tMqEada2g5kmzEUx5e4/I9WO/JwsF72v++RBRIeY0/skj64Mu9oQ5I3s3S2FxDPVb2XyG/Wg3FA6WAoZtBOQ//jvXb1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238125; c=relaxed/simple;
	bh=nEg76aj7j/A/BYmyHWkcIKgSjOw0MPRSJswcOvoEG8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mXdhgMgPPr9p/5JHvZH1sCVsADTY5e/gU4+LVFcQu/fmaNOsm2o0tP2oBRmW3xdZEJDjMfDLz0Jx0CftKbegZX6YQ4DAn/A9rVxo1rNRnYzLxflyQMnjn00PkHt1daM6qm3c60ErrLoVcpL8QSOOv63BZ4lTWyhEQBLRD7K/lOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqtzbjP5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqtzbjP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A62201F000E9;
	Thu, 20 Aug 2026 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238124;
	bh=WMD8fIu4le5Ayw5cfYHfaJ1Idmtqji+OduRRV1vAZM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqtzbjP5uuropFy1y1ngBGHuEs0c2y02F7NQnBvrCxYc1NGczrj0hqEYbnKlTsM5X
	 BJyDhCfkBHkpfQMZuutuWwafWlQQXTQ8dTUCp2G2Rb2YB+qVCCkY7vYPm59DlGSXm5
	 l3A1cMxYZqT2+FPah+ULClb9wUYqTAtztbwuHi7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"KADOTA, Kyohei" <lufia@lufia.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 040/228] Input: xpad - add support for ZENAIM LEVERLESS
Date: Thu, 20 Aug 2026 16:53:02 +0200
Message-ID: <20260820145245.685882957@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyohei Kadota <lufia@lufia.org>

commit 7d971337ebfad0b173cb46097c709db174ac3557 upstream.

Add the VID/PID for the ZENAIM LEVERLESS controller to xpad_device and
the VID to xpad_table.

Signed-off-by: KADOTA, Kyohei <lufia@lufia.org>
Link: https://patch.msgid.link/CAFMepckDUuOHiDDVVhUYc-UqJMeCqrWSfCuxbJ2x2sGgdDD4nw@mail.gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -394,6 +394,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
+	{ 0x3507, 0x000b, "ZENAIM LEVERLESS", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
@@ -557,6 +558,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
+	XPAD_XBOX360_VENDOR(0x3507),		/* ZENAIM Controllers */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x3651),		/* CRKD Controllers */


