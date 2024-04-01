Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6811C4087B;
	Mon,  1 Apr 2024 16:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988658; cv=none; b=ZqkixwkDtrWy9f4dVe/ZOW5qH39ItwEv1tC4Z30aq3bbSBii+7X+XxLSneDqur/A3PcaFWUoIm668UzU47ICNvK52eZbhRN8mSpyFv31n8q0Pet24Z9yz+dOfKSWx3nkPr8eySuZAb6YiFIWfpDgxIx+GibBH/NqGofcjI3iu+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988658; c=relaxed/simple;
	bh=nkL7qpIQxkdKexYKKamR9mHhd2EZ8QjuPgDb8OR3RT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kkom6D7eWev+op/y2CivjWpfBVAKYtyNdyNsVAsJ4/L/D/0iSIL28gJtiZblDstedlLQ8C4aC1km+5XdwETP/x97nbTweJNkzkIXqHHmRAu5snYW3kalAhom/ShgMJq4N8QmjJwmuG61eCvh9EMlMnI4hmZ4vxJYx2jrIGANVUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=musemjHK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="musemjHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86B53C433F1;
	Mon,  1 Apr 2024 16:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988658;
	bh=nkL7qpIQxkdKexYKKamR9mHhd2EZ8QjuPgDb8OR3RT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=musemjHK7mK55GXO5MTZiLArYEY4ao92gBsQ8E+zVNjV57lQFnSSCKQmEvJDnMhDI
	 JlA7wcgYg43f87k0fWLkiEaQanAys6drJm2WfhNyDT//DFkjIC/u+vCoTVBLeo8mI/
	 Kbfc3nFr+InwMXs1Mkz9tmw/HrCaCtmNEK8jwPvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Toledanes <chris.toledanes@hp.com>,
	Carl Ng <carl.ng@hp.com>,
	Max Nguyen <maxwell.nguyen@hp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.7 250/432] Input: xpad - add additional HyperX Controller Identifiers
Date: Mon,  1 Apr 2024 17:43:57 +0200
Message-ID: <20240401152600.596359600@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Nguyen <maxwell.nguyen@hp.com>

commit dd50f771af20fb02b1aecde04fbd085c872a9139 upstream.

Add additional HyperX device identifiers to xpad_device and xpad_table.

Suggested-by: Chris Toledanes<chris.toledanes@hp.com>
Reviewed-by: Carl Ng <carl.ng@hp.com>
Signed-off-by: Max Nguyen <maxwell.nguyen@hp.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/44ad5ffa-76d8-4046-94ee-2ef171930ed2@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -130,7 +130,12 @@ static const struct xpad_device {
 	{ 0x0079, 0x18d4, "GPD Win 2 X-Box Controller", 0, XTYPE_XBOX360 },
 	{ 0x03eb, 0xff01, "Wooting One (Legacy)", 0, XTYPE_XBOX360 },
 	{ 0x03eb, 0xff02, "Wooting Two (Legacy)", 0, XTYPE_XBOX360 },
+	{ 0x03f0, 0x038D, "HyperX Clutch", 0, XTYPE_XBOX360 },			/* wired */
+	{ 0x03f0, 0x048D, "HyperX Clutch", 0, XTYPE_XBOX360 },			/* wireless */
 	{ 0x03f0, 0x0495, "HyperX Clutch Gladiate", 0, XTYPE_XBOXONE },
+	{ 0x03f0, 0x07A0, "HyperX Clutch Gladiate RGB", 0, XTYPE_XBOXONE },
+	{ 0x03f0, 0x08B6, "HyperX Clutch Gladiate", 0, XTYPE_XBOXONE },		/* v2 */
+	{ 0x03f0, 0x09B4, "HyperX Clutch Tanto", 0, XTYPE_XBOXONE },
 	{ 0x044f, 0x0f00, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f03, "Thrustmaster Wheel", 0, XTYPE_XBOX },
 	{ 0x044f, 0x0f07, "Thrustmaster, Inc. Controller", 0, XTYPE_XBOX },
@@ -463,6 +468,7 @@ static const struct usb_device_id xpad_t
 	{ USB_INTERFACE_INFO('X', 'B', 0) },	/* Xbox USB-IF not-approved class */
 	XPAD_XBOX360_VENDOR(0x0079),		/* GPD Win 2 controller */
 	XPAD_XBOX360_VENDOR(0x03eb),		/* Wooting Keyboards (Legacy) */
+	XPAD_XBOX360_VENDOR(0x03f0),		/* HP HyperX Xbox 360 controllers */
 	XPAD_XBOXONE_VENDOR(0x03f0),		/* HP HyperX Xbox One controllers */
 	XPAD_XBOX360_VENDOR(0x044f),		/* Thrustmaster Xbox 360 controllers */
 	XPAD_XBOX360_VENDOR(0x045e),		/* Microsoft Xbox 360 controllers */


