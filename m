Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044212;
	b=2ggeNrVUI/dDDSbtQOSQWt4/0CR3HFHYnIGWL5jVkBy1vY7aSpozZm8YqEtwFLXYexDb
	 z3pluk6x5HaBGb8kSBY4F/3PItsOlj2MBaGhwvfCgwGmZdRCX/Svv3WtnmuePdqB8AU33
	 AXz3uJqGeLvfhkB3r2JAYzgXqAuS5TOr9b2a49lbUbW1UPCzZtOh4OLFUgk5Y/Jqo8+VC
	 /TLU91pJjz+g8Bm96rjRqKajqBDS8rThaAosCy4PtJ31WIzUKOgYPHQt+kz3aScJ4+vql
	 QbrkQfYaGhqoNzUvq/1y6oOxWVx4IMaKG09XThpKsOK3s9QLPFCivN/X66zEMfZiT5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044212;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U2y8LsoZXizz0U5YYHt5BVgOlAC5wazSYD6wddNhRSM=;
	b=NzBjo00o03uGhwHHpypdovH0QbtlmcVBl5YIAdYZMVldNEEHQFLpNsm+OKFawHWBnfKT
	 3q3mcczUpyDcbulvr+rK4I80XIcR7RWX4YF3zObMSPxqJTtbLs9RuXrPghry3hpX7yxRh
	 E3fssWEs2/4ooJEJOvnN0l7DPAXGUyMTE1I7RJH8mPYWwNQZzvauehVfW+U+wb0CsCmYj
	 hCo9u7i/G0JyKns4Qv0ynnz8bi8aBvaix9iasopcVBUgVdyilXHoMA9aRB2A0nJia6ZLc
	 5hoV87WmOp//9a+bT4uIQy2HxNJ5Wl5G+Gcc1RgM7+Mx5MY8tFqWAfmRLswhLj/xqCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmeUTcCs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E78F606A31C;
	Wed, 18 Nov 2026 23:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmeUTcCs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E08C1F000C5;
	Wed, 18 Nov 2026 23:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044211;
	bh=U2y8LsoZXizz0U5YYHt5BVgOlAC5wazSYD6wddNhRSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmeUTcCsR0X/tFq0xKqWYbbyVHrCgsTj7/Xa0ITP+3Mfmk11nfqQaxKrcW4kmn26g
	 dUyBfSNtlSUOuzsfMZBJqzTnMBjISDICxHXM61F8O+pllYcQpPDBSACgGgILJQmbB8
	 fSEknt6/6IN03gZUrVEe/tpGIAsiJzvrapx7120k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Furman <krisfur@proton.me>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0487/2857] Input: xpad - add support for Corsair Novablade Pro
Date: Wed, 18 Nov 2026 15:25:21 +0100
Message-ID: <20261118150218.986653986@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Furman <krisfur@proton.me>

[ Upstream commit f9282b8aa85a8c97c50d656db75feb6d76fc7cbe ]

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
[ sashal: Adjusted context lines in both tables because neighboring entries (Legion Go S, WCH, ZOTAC, BETOP) are missing, and added the three Corsair lines without them. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/joystick/xpad.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 91d6ecbf63a28..458e166b97095 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -307,6 +307,8 @@ static const struct xpad_device {
 	{ 0x16d0, 0x13ea, "Azeron Keyzen", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
+	{ 0x1b1c, 0x2b1f, "Corsair Novablade Pro (Wired)", 0, XTYPE_XBOX360 },
+	{ 0x1b1c, 0x2b2b, "Corsair Novablade Pro (2.4 GHz Receiver)", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -506,6 +508,7 @@ static const struct usb_device_id xpad_table[] = {
 	XPAD_XBOX360_VENDOR(0x16d0),		/* Azeron controllers */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
+	XPAD_XBOX360_VENDOR(0x1b1c),		/* Corsair controllers */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harminix Rock Band Guitar and Drums */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA Controllers */
 	XPAD_XBOXONE_VENDOR(0x20d6),		/* PowerA Controllers */
-- 
2.53.0



