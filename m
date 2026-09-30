Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C176A4D1784;
	Wed, 30 Sep 2026 17:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788649; cv=none; b=rWo9494ySU8AEWxTqV0A+m0W5fWnuL9jgvAupTzG4ElqDRmZK19nIjU3bv3vBpoYpedtnFeUVoySt9k1b4kh82/N+z1qi84LK4SP2q/S9d44eJcE9Wt4DXpHco6MpQLOmSbTIJatqOZrQZNTJT8L2LKkmECexbL/345JhqgPUaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788649; c=relaxed/simple;
	bh=NtqkG7Z6T3x8vgQ0ULqqZ5VA8h4VRsQh9BaTsmq7Zy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvY5HCixrXrTRSXWjukScGuz4HX6g7KvNDY5mdBUBujKa63b3W57JW3KIbE780Fo368+EbJBLlf8hBoNzS6K+nhZpuvbfUPdLjq4JlOAwIzBoQh3FIXx/I5AEgvftF3gFRZuzc22lEpGllD9EDQ52eavhG8lg/xMtMv4h/Adqzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFTncytf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFTncytf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CED31F000FF;
	Wed, 30 Sep 2026 17:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788648;
	bh=0g52N9TodR0cYAoP8cch6Oz3ToUd5FMFy0rA3I7RYJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFTncytfuqJyKa7CI8EjzwuPpqnYh+I/I3hsqJg8ZkBP1kz4hWZAFtnyKrooTWgqj
	 2kJBrVZ4ZVVJvUCVTEF4vemT12Z43jXWTl47q7QuugOgZGaS+ddbTHO2HsxRUMFBHK
	 VSrd/FjFyxNT9mpJH5TtX1b8UBijqjg+eWig0has=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberts Kursitis <roberts.kursitis@azeron.eu>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 162/877] Input: xpad - add support for Azeron devices
Date: Wed, 30 Sep 2026 17:17:53 +0200
Message-ID: <20260930152418.217377103@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Roberts Kursitis <roberts.kursitis@azeron.eu>

commit cba76c0f47af1a389d718c5bb69e75cbd67bba98 upstream.

Azeron controllers (Cyro, Cyborg, Classic/Compact, Cyro Lefty,
Cyborg II and Keyzen) present a standard Xbox 360 controller
interface, so they work with the existing xpad driver once their
USB IDs are added.

The 0x16d0 vendor ID is a shared block, but this is safe because
xpad only binds interfaces that match the Xbox 360 signature.

Tested with an Azeron Keyzen.

Signed-off-by: Roberts Kursitis <roberts.kursitis@azeron.eu>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260906143040.162418-1-roberts.kursitis@azeron.eu
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -321,6 +321,12 @@ static const struct xpad_device {
 	{ 0x1689, 0xfd00, "Razer Onza Tournament Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfd01, "Razer Onza Classic Edition", 0, XTYPE_XBOX360 },
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x1103, "Azeron Cyro", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x113c, "Azeron Cyborg", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x1192, "Azeron Classic/Compact", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x1212, "Azeron Cyro Lefty", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x12f7, "Azeron Cyborg II", 0, XTYPE_XBOX360 },
+	{ 0x16d0, 0x13ea, "Azeron Keyzen", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
 	{ 0x1a86, 0xe310, "Legion Go S", 0, XTYPE_XBOX360 },
@@ -555,6 +561,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x15e4),		/* Numark Xbox 360 controllers */
 	XPAD_XBOX360_VENDOR(0x162e),		/* Joytech Xbox 360 controllers */
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
+	XPAD_XBOX360_VENDOR(0x16d0),		/* Azeron controllers */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
 	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */


