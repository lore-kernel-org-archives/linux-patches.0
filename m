Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93133485CCF;
	Thu, 20 Aug 2026 17:36:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247367; cv=none; b=RnqWvBaAazyrKYx8Y8qO9VZm66TblbERl5K0452gGiZxXuyFbGghvx/3UB7uKUWTjQhRa6DmISKtfMv3XEwRifNjMbcAa2C07UcNrffge1mlszuNKOBLT7e782P0y3SeeXNVZRjkpZc5rfVkOZnxG0TmEFIAFxx1L8Fv09/RUBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247367; c=relaxed/simple;
	bh=2cdwz04vHK20S6TLdSrgzQz9OR8wunjDTTHsB25LEys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ouZSriFN/m6T0mWdwc5yhBqWKFxoGKWut6xRjBgv0UejXM+qwwB6hV4N5pNgiFZLoRhZfgzpRt0/iguTVBiBOymXNb1IplVf9UiV0/w1KOA+KxmAvuYvBB+Zh/ojQ0BRsSeplmIpc7su6YY9rXCzhdxhDEiKxBvuDBJoaQnR/b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WpMpltX5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WpMpltX5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05291F000E9;
	Thu, 20 Aug 2026 17:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247366;
	bh=Kfveos4Tvk62zIKkS5C4+sjvi2vztMemdZapzq8YuEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WpMpltX56OtTYAT9/csCyl5W4lPk5dwU4bmNBcDUlv4sBVsYOCaHu4+PlfeWHCeAx
	 q+CrMGj62u0MalMjyPlLy3UQnHFY+QiFutZlx7NzaZVWrwxhBQ3sKTxFvX8Iy2wULm
	 JK2FuIotBueYnFEJe/6CsiaTAeEGX6fxVS45qPBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"KADOTA, Kyohei" <lufia@lufia.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 021/166] Input: xpad - add support for ZENAIM LEVERLESS
Date: Thu, 20 Aug 2026 16:54:40 +0200
Message-ID: <20260820145211.826033435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -417,6 +417,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0662, "Nacon Revolution5 Pro", 0, XTYPE_XBOX360 },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
+	{ 0x3507, 0x000b, "ZENAIM LEVERLESS", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x100f, "GameSir Nova 2 Lite", 0, XTYPE_XBOX360 },
 	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
@@ -575,6 +576,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */
+	XPAD_XBOX360_VENDOR(0x3507),		/* ZENAIM Controllers */
 	XPAD_XBOX360_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOXONE_VENDOR(0x3537),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x413d),		/* Black Shark Green Ghost Controller */


