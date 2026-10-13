Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532571F91F6;
	Tue, 13 Oct 2026 12:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895697; cv=none; b=FzrWjk7hL8lVJbKMoSbK9AkwOpoBhKLbYnWa373qgaxKUQ6hR7/BqFyysWMP5kgwXHT9SXUCmcVp4kwlK8LVbzIYbUOe8VQfAB8UTF7A9KBKS7ukb0gPjRKl7NTUOyqyZDuXsozssohH4onSu4pwYYB/EIYcTXF00cDWTrd8mq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895697; c=relaxed/simple;
	bh=wUjoccKa0+tu8yXN2Rr36/bq7AE85kdvbZpCTL4NNus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0q1mHETey8v9gHLyHx1zx+TOJnkGcsfuX4g9+ddzsa7drGZP22GTEVCZvOg13TsmKg31JqjxUFsK83QwN3Lc7/tJ91kjRClYSCB1QAaHmtOclhnR6W6+q/nd7x9VXab+BCndb0YU8VVtX/Xa7ZpRs/Bf1IbF1xlmWSeLcFZbH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCtKK+tC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCtKK+tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABAE01F00893;
	Tue, 13 Oct 2026 12:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895696;
	bh=ZVFIi6DawUafALin1jRXq/bv4rdrAKlJgQtpnlZqk6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UCtKK+tCvKPyf/uIK0QILd1shj16sVwgwZ1WF2pjL9HpuTRNZ7Z27p6xYZ6VQNnjr
	 mj336Dkm0hoGuJI5xF4Au2Rgl7HCcpi8UVGciSzUG7Z18IoL5qhyVsMkycVT+bliBo
	 NFAChfvq4JouLaJt0XyNAeLnzLwTefWaE6e+4i+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Furman <krisfur@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 360/497] Input: xpad - add support for Corsair Novablade Pro
Date: Tue, 13 Oct 2026 13:38:47 +0200
Message-ID: <20261013112916.449781496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Krzysztof Furman <krisfur@proton.me>

commit f9282b8aa85a8c97c50d656db75feb6d76fc7cbe upstream.

Add device IDs for the Corsair Novablade Pro leverless fight controller
in both wired (0x2b1f) and 2.4 GHz receiver (0x2b2b) modes, and add
Corsair's vendor ID to the Xbox 360 vendor match list.

Outside of its PS4/PS5 modes the controller uses the Xbox 360 protocol
(vendor-specific class, subclass 93, protocol 1) on interface 0, which
xpad does not currently bind, so no gamepad device is created. The
PS4/PS5 modes present a standard HID gamepad and already work with
hid-generic.

Tested on 7.2.5 with the 2.4 GHz receiver and wired.

Assisted-by: Claude Opus 5.5
Signed-off-by: Krzysztof Furman <krisfur@proton.me>
Link: https://patch.msgid.link/20261009-xpad-corsair-novablade-v1-1-e58746bef99f@proton.me
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -330,6 +330,8 @@ static const struct xpad_device {
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
 	{ 0x1a86, 0xe310, "Legion Go S", 0, XTYPE_XBOX360 },
+	{ 0x1b1c, 0x2b1f, "Corsair Novablade Pro (Wired)", 0, XTYPE_XBOX360 },
+	{ 0x1b1c, 0x2b2b, "Corsair Novablade Pro (2.4 GHz Receiver)", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -565,6 +567,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */
+	XPAD_XBOX360_VENDOR(0x1b1c),		/* Corsair controllers */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
 	XPAD_XBOX360_VENDOR(0x20bc),		/* BETOP wireless dongles */


