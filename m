Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAA412EA163;
	Tue, 22 Jul 2025 13:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192263; cv=none; b=dsDFzASnTeRlIK7zGMRigUI6kNn33nN/9vTvCKd/yFv38pg3toG7lC93v1CMhLwEN+EpH4Z+SswDLXwiiMN0BmEMe2cGJk9chNm75L2D1+Q73Fd8QKWhv8SlvRxqfumS6JUwZFxVOFIkWYc0NacsUQeuDaDBhFHvpTpURL4LUwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192263; c=relaxed/simple;
	bh=RNwbgpTgIbb2hc0dnC8KNQS0wGA40VEPGe+X+rOyi0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDVPfLkqENTB6QELmjDB25oaaijw6AbJhQW80S6e0SxXrsEefirAb8fRIM3Vrt+c6gjE9296boTPJCnljYTNyMhYJBGqX27oJI1U27G2XBxZpXvBfCWnXEZzDrLNbv/5p+m8lrIES1Ew4JJIlsFd4fiYOF2TejS6+K9Cns5hw6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T5cJeELp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T5cJeELp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB9CC4CEEB;
	Tue, 22 Jul 2025 13:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192262;
	bh=RNwbgpTgIbb2hc0dnC8KNQS0wGA40VEPGe+X+rOyi0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T5cJeELpywdMRSh1WYMZWXTU/fgBGcNRY+zh/+VQPl6RBV2e2YlqwTx9sG6nij89f
	 IqQdPZX21oMQYfzAIsSaKBCOJ543stOaxIyeGif2NbDYxOp1OXDKSTnMogvYIwRTJf
	 B5qE9Vf1qAR3WAS5zG0DFjNUZZNnfWUTwXwV+XAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 013/111] Input: xpad - set correct controller type for Acer NGR200
Date: Tue, 22 Jul 2025 15:43:48 +0200
Message-ID: <20250722134333.886942407@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
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

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit bcce05041b21888f10b80ea903dcfe51a25c586e upstream.

The controller should have been set as XTYPE_XBOX360 and not XTYPE_XBOX.
Also the entry is in the wrong place. Fix it.

Reported-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250708033126.26216-2-niltonperimneto@gmail.com
Fixes: 22c69d786ef8 ("Input: xpad - support Acer NGR 200 Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -169,12 +169,12 @@ static const struct xpad_device {
 	{ 0x046d, 0xca88, "Logitech Compact Controller for Xbox", 0, XTYPE_XBOX },
 	{ 0x046d, 0xca8a, "Logitech Precision Vibration Feedback Wheel", 0, XTYPE_XBOX },
 	{ 0x046d, 0xcaa3, "Logitech DriveFx Racing Wheel", 0, XTYPE_XBOX360 },
+	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX360 },
 	{ 0x056e, 0x2004, "Elecom JC-U3613M", 0, XTYPE_XBOX360 },
 	{ 0x05fd, 0x1007, "Mad Catz Controller (unverified)", 0, XTYPE_XBOX },
 	{ 0x05fd, 0x107a, "InterAct 'PowerPad Pro' X-Box pad (Germany)", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3030, "Chic Controller", 0, XTYPE_XBOX },
 	{ 0x05fe, 0x3031, "Chic Controller", 0, XTYPE_XBOX },
-	{ 0x0502, 0x1305, "Acer NGR200", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0020, "Logic3 Xbox GamePad", 0, XTYPE_XBOX },
 	{ 0x062a, 0x0033, "Competition Pro Steering Wheel", 0, XTYPE_XBOX },
 	{ 0x06a3, 0x0200, "Saitek Racing Wheel", 0, XTYPE_XBOX },


