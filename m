Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 451338F5C;
	Mon,  1 Apr 2024 16:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990004; cv=none; b=LkoCiQEDsZBVCB19S4/sPAOuYYGrTd8bQ+tNTMOLK9LcM+C3utn7Zl0BhpMxdTt6xdgmTGk0aF9Zi+FFbJ/lMC/FZ7CQRrpHld1KgKAqejwjQ3ppesKong/j17r32dnBQkL83DYOakdbG6SQDRZHadfoXPdtuLaUAPP/SjE8V0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990004; c=relaxed/simple;
	bh=bIzdrpNYkf5xtLCFdEdySceg04t/x8qOgj/MGt8dH34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fwwPsxE3Z8V5rOHRDxAj2/CO046omCmhn8Rht6Y6Pm+90l8NTRzRLPSgulmMcsFXez1UFVvepBR7ajvc9DYQhx/Yz3KWeyvyUWoVKNHOHewFVsEWB0H+G+ji7cvwKxBXayQJy/WJqguXnU79sEsxNy59ca34c06r254W5NMoy9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F63SBR9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F63SBR9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD96C433F1;
	Mon,  1 Apr 2024 16:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990003;
	bh=bIzdrpNYkf5xtLCFdEdySceg04t/x8qOgj/MGt8dH34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F63SBR9iySFXni45usQ8sMsEWAAMC02ovTB/6Yts3/bgbftryPjXJ9l5DorKoL04A
	 /hqgAhd8II1ZtujM3zEfNcsVj1T1UZl40XWqCZKlIvmn//ejdHJRdgyEL8L8p4wxGI
	 61cGEr2A4PfJl9NHBUs1nIkI4SQj+K/1ZQTnvGsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Toledanes <chris.toledanes@hp.com>,
	Carl Ng <carl.ng@hp.com>,
	Max Nguyen <maxwell.nguyen@hp.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 210/396] Input: xpad - add additional HyperX Controller Identifiers
Date: Mon,  1 Apr 2024 17:44:19 +0200
Message-ID: <20240401152554.189429695@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


