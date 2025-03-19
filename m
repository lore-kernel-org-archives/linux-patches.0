Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33FEF20A5D3;
	Wed, 19 Mar 2025 14:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395237; cv=none; b=Z+H0Bjxp045GnG71klekj+At2PHgZRgZLQ0QwOy1baVBL95EzU6khP8HATEpD7CAj5qQGJFRChI+BEBQeFnq10npFX8Hctq56Kzfik9lh6T/+xYhpZPw74BhEKf8xVEu3e1Uxb6HvxW2ts/eVyb+BhycZfbxtyzoIVRZteeIrCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395237; c=relaxed/simple;
	bh=6Gd4oHg2VT2EgqUKhDS79l5EywiyKarpZnSTHJxgkoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHeZLzQvbu5tdG52bjo8gEXebYzftudR2i8Xu7MnxbW4PjmJQJtiGCUngApVfs/1/MJJZ722e1jOIQiIf8ZnpxFPjtZX3vhv8fc3EqGtGxpIMhsrivT7N92w2Y1YjED8BXDZpIts9AD6JLMuRry1dPm6fC/6XsijTUqgMJRx8JA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCaP2W5d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCaP2W5d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C969C4CEE4;
	Wed, 19 Mar 2025 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395237;
	bh=6Gd4oHg2VT2EgqUKhDS79l5EywiyKarpZnSTHJxgkoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCaP2W5dqyueAOvNvtUHfiNN1BHaKkUxNUZln1/joi4wQIFmRrGXiHCN7hkO9DKgB
	 thPXcj/LN8rdn3XrzgT4E5UBQqxjaqw+H6H8iJDq+XCgkJ6fK/djtoeI7vJnNZrLAP
	 FUvIGeY8baXpEwoyeXRoN7tqkknE5H2b6ZM3OWiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 110/166] Input: xpad - rename QH controller to Legion Go S
Date: Wed, 19 Mar 2025 07:31:21 -0700
Message-ID: <20250319143022.996508372@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Antheas Kapenekakis <lkml@antheas.dev>

commit 659a7614dd72e2835ac0b220c2fa68fabd8d1df9 upstream.

The QH controller is actually the controller of the Legion Go S, with
the manufacturer string wch.cn and product name Legion Go S in its
USB descriptor. A cursory lookup of the VID reveals the same.

Therefore, rename the xpad entries to match.

Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://lore.kernel.org/r/20250222170010.188761-4-lkml@antheas.dev
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -312,7 +312,7 @@ static const struct xpad_device {
 	{ 0x1689, 0xfe00, "Razer Sabertooth", 0, XTYPE_XBOX360 },
 	{ 0x17ef, 0x6182, "Lenovo Legion Controller for Windows", 0, XTYPE_XBOX360 },
 	{ 0x1949, 0x041a, "Amazon Game Controller", 0, XTYPE_XBOX360 },
-	{ 0x1a86, 0xe310, "QH Electronics Controller", 0, XTYPE_XBOX360 },
+	{ 0x1a86, 0xe310, "Legion Go S", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0002, "Harmonix Rock Band Guitar", 0, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0003, "Harmonix Rock Band Drumkit", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
 	{ 0x1bad, 0x0130, "Ion Drum Rocker", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360 },
@@ -537,7 +537,7 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOX360_VENDOR(0x1689),		/* Razer Onza */
 	XPAD_XBOX360_VENDOR(0x17ef),		/* Lenovo */
 	XPAD_XBOX360_VENDOR(0x1949),		/* Amazon controllers */
-	XPAD_XBOX360_VENDOR(0x1a86),		/* QH Electronics */
+	XPAD_XBOX360_VENDOR(0x1a86),		/* Nanjing Qinheng Microelectronics (WCH) */
 	XPAD_XBOX360_VENDOR(0x1bad),		/* Harmonix Rock Band guitar and drums */
 	XPAD_XBOX360_VENDOR(0x1ee9),		/* ZOTAC Technology Limited */
 	XPAD_XBOX360_VENDOR(0x20d6),		/* PowerA controllers */


