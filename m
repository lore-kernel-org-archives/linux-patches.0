Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1731F4F3922;
	Tue, 13 Oct 2026 12:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892837; cv=none; b=ha/DjKXPezxSH1kZJ4jw874EsA+GbRQgx7khEh8+7bB++NkdBhY6kSPay7eIHciQarS2ebSoF1pBiMmdG7Uxs8/uWgY8JGTNdqcMDYFTqZ7KH1AMG5JqgBgZ8uScohzE69nqGBm8sHRLBfGul/jg4iw2lLDpYV1ucBViroZ9kRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892837; c=relaxed/simple;
	bh=TzKdOs/4WUgrlzJxgmHkF456xxLJdTYAYv6jxt+X9lQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9IFOs/8GzcMyjQ1NABWL37rf3/PmShe7Aa6oUSkULBqP12qc3yRjvks4lq83pWQDK3ADPAHoM2XUvqB+n6cA1HREUvfTMiCE9N1nReROe3CmEnY1RcAW8pVYF9HDTyJIttOlV3LeIzX+/UuIW1KFPuwTMztTwTdKlxoyDL79Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LaUPWV5I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LaUPWV5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7153C1F000FF;
	Tue, 13 Oct 2026 12:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892836;
	bh=zXCswFkVG1uL8xj4CqUeoCRAYPbXppa8cChxCBCNFDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LaUPWV5I/E/F361fXb4c8by8G/+qtBqpOJP5sBLpfUzvxi1g8pet/sqgei8zqLN1R
	 6Y2Qmb7OnSfDFu8mcNwQoJnNxLP9M4Eki6JbGQRa9x2h+oregRWh/nQZekMyK4J9Xc
	 pLKNqNT227aRIIry1DSzfwVoX4yXqvCniK2PTf74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Furman <krisfur@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 025/621] Input: xpad - add support for Corsair Novablade Pro
Date: Tue, 13 Oct 2026 13:30:20 +0200
Message-ID: <20261013112921.463747269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
@@ -336,6 +336,8 @@ static const struct xpad_device {
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
 	{ 0x1a86, 0xe310, "Legion Go S", 0, XTYPE_XBOX360 },
+	{ 0x1b1c, 0x2b1f, "Corsair Novablade Pro (Wired)", 0, XTYPE_XBOX360 },
+	{ 0x1b1c, 0x2b2b, "Corsair Novablade Pro (2.4 GHz Receiver)", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -580,6 +582,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */
+	XPAD_XBOX360_VENDOR(0x1b1c),		/* Corsair controllers */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
 	XPAD_XBOX360_VENDOR(0x20bc),		/* BETOP wireless dongles */


