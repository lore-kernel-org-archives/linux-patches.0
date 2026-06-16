Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59922478E5B;
	Tue, 16 Jun 2026 16:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628694; cv=none; b=hWvqVUBkIV5pKJ5cBEUr5/J6m3mw/FcEFyKljJJb9Q8dL0MXfvzjt2PViT0uN9bMi1hFv0pwPqv2ta4EdqOibSsAlkEfWY2XWDYR5BKv/+JxeJdMgzH/RorG20FY/HEuyaaiYTfuz/ASHvu6F/kQPjGq0M4HHKlJ5tC333t2pQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628694; c=relaxed/simple;
	bh=fZuSh8px1FkvdqMfdeOVVf5sOdpvEgIvHEuqWLzhoc8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=am1IUokUChthhbpcheUeX3EgVfw/1Ira3H6TuQLHKePGYd3b85YdEd+cQISlZLzukztIPJ6n4IT4Bwy7LryttEemn8daCrWpGkEnRhIHmhgvP9GDftht+j2nHzZY2VZf0gPXzElyRWR4AJpcalbYe4DJ0hdeOOV1hIQn6Csq+7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7a09ght; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7a09ght"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BB1C1F000E9;
	Tue, 16 Jun 2026 16:51:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628693;
	bh=fcSQvV0Wt+n2a+3d3Hha1Dpd6exgyjWkD7sbVEdooMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n7a09ghtuTw9vkvT89U4Hu8ah8HEE4ffc2/hSpRjKdwNjOv89wYzXTxV6KWvZAPuk
	 DurkDLus/wwqs9G3HeMMh4Ctb3RCntorBxyGikZMOOMRrfCZ/RHVCvxAggZcT/juiX
	 MpNYLsC5ZBnDvB77SimgJO+Fm9jZgaTjlaOzSyJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitriy Zharov <contact@zharov.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 143/452] Input: xpad - add support for ASUS ROG RAIKIRI II
Date: Tue, 16 Jun 2026 20:26:10 +0530
Message-ID: <20260616145125.218594317@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Dmitriy Zharov <contact@zharov.dev>

commit c897cf120696b94f56ed0f3197ba9a77071a59ec upstream.

Add the VID/PIDs for the ASUS ROG RAIKIRI II controller to xpad_device
and the VID to xpad_table. The controller has a physical PC/XBOX toggle
which switches between XBOX360 and XBOXONE protocols.

Signed-off-by: Dmitriy Zharov <contact@zharov.dev>
Link: https://patch.msgid.link/20260430183522.122151-1-contact@zharov.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -215,6 +215,10 @@ static const struct xpad_device {
 	{ 0x07ff, 0xffff, "Mad Catz GamePad", 0, XTYPE_XBOX360 },
 	{ 0x0b05, 0x1a38, "ASUS ROG RAIKIRI", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x0b05, 0x1abb, "ASUS ROG RAIKIRI PRO", 0, XTYPE_XBOXONE },
+	{ 0x0b05, 0x1c91, "ASUS ROG RAIKIRI II", 0, XTYPE_XBOX360 },
+	{ 0x0b05, 0x1c92, "ASUS ROG RAIKIRI II WIRELESS", 0, XTYPE_XBOX360 },
+	{ 0x0b05, 0x1c96, "ASUS ROG RAIKIRI II XBOX", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
+	{ 0x0b05, 0x1d04, "ASUS ROG RAIKIRI II XBOX WIRELESS", MAP_SHARE_BUTTON, XTYPE_XBOXONE },
 	{ 0x0c12, 0x0005, "Intec wireless", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8801, "Nyko Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0c12, 0x8802, "Zeroplus Xbox Controller", 0, XTYPE_XBOX },
@@ -527,6 +531,7 @@ static const struct usb_device_id xpad_t
 	{ USB_DEVICE(0x0738, 0x4540) },		/* Mad Catz Beat Pad */
 	XPAD_XBOXONE_VENDOR(0x0738),		/* Mad Catz FightStick TE 2 */
 	XPAD_XBOX360_VENDOR(0x07ff),		/* Mad Catz Gamepad */
+	XPAD_XBOX360_VENDOR(0x0b05),		/* ASUS controllers */
 	XPAD_XBOXONE_VENDOR(0x0b05),		/* ASUS controllers */
 	XPAD_XBOX360_VENDOR(0x0c12),		/* Zeroplus X-Box 360 controllers */
 	XPAD_XBOX360_VENDOR(0x0db0),		/* Micro Star International X-Box 360 controllers */


