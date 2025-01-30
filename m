Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DD41E98F3;
	Thu, 30 Jan 2025 14:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246853; cv=none; b=gSIwN/VRy5VlMRwn6zf9W8nz4D3ML+T+a1OvKGx8oxomh2MU1VTagNdizm6dpy+i8gwK4JR3Pa4sTRLl5YqVkrYgu8/MNvHx7+gjgHru7PpeUIn9jkE9siD55T+577Hevi9cqqOcNFePsXev+bDB49JcuSOpmZaEwUmTnXvScqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246853; c=relaxed/simple;
	bh=5Ivz5oSFCS+7jADpJQg2KSCnS81w0zB+uic8Xz9rQL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hOuvnyqG8ZAhyEYNTyUqby51LmgeS+rpq0IqvxInZfwv9PCHK+veb8iTjuuEtaj1aKdvTQfpcjDWQo9dJJwhCYpHv/nUojdPu1kYghvtdLAudl4onAQga86wlPMKs7JyUWzT7YKqcfcwVouSzVMrz9Zs16lNTb15Y/0RUDdib8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OlMKqty9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OlMKqty9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56CBC4CED2;
	Thu, 30 Jan 2025 14:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246853;
	bh=5Ivz5oSFCS+7jADpJQg2KSCnS81w0zB+uic8Xz9rQL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OlMKqty9GwLUkCtFalGssGygAF8N0et+dCxS03jIxTNpZ6MnCW2p41v+F8ZRLO0U0
	 EYEwuqNi0Jiedz2lnNgI0WYEZMlB1vtyEdM9riXIjZ2ZNDqSKDOLAGMH2//ZSQ7zLE
	 DaQB1Tcik/GRow0IvOd2hSC/f1c43W5/V7DzTGH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Pavel Rojtberg <rojtberg@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.4 90/91] Input: xpad - add unofficial Xbox 360 wireless receiver clone
Date: Thu, 30 Jan 2025 15:01:49 +0100
Message-ID: <20250130140137.301869417@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit e4940fe6322c851659c17852b671c6e7b1aa9f56 upstream.

Although it mimics the Microsoft's VendorID, it is in fact a clone.
Taking into account that the original Microsoft Receiver is not being
manufactured anymore, this drive can solve dpad issues encontered by
those who still use the original 360 Wireless controller
but are using a receiver clone.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
Link: https://lore.kernel.org/r/20250107192830.414709-12-rojtberg@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -128,6 +128,7 @@ static const struct xpad_device {
 	{ 0x045e, 0x028e, "Microsoft X-Box 360 pad", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x028f, "Microsoft X-Box 360 pad v2", 0, XTYPE_XBOX360 },
 	{ 0x045e, 0x0291, "Xbox 360 Wireless Receiver (XBOX)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
+	{ 0x045e, 0x02a9, "Xbox 360 Wireless Receiver (Unofficial)", MAP_DPAD_TO_BUTTONS, XTYPE_XBOX360W },
 	{ 0x045e, 0x02d1, "Microsoft X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02dd, "Microsoft X-Box One pad (Firmware 2015)", 0, XTYPE_XBOXONE },
 	{ 0x045e, 0x02e3, "Microsoft X-Box One Elite pad", 0, XTYPE_XBOXONE },


