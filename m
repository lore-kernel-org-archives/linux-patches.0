Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DCD11187;
	Tue, 26 Aug 2025 13:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215422; cv=none; b=JTVbvXenokQZtm+jvqVJxvsYB7sPrR8WIwZZDySrbZzGgnQl56MNnGWUM7gqcGiDu1m9wfTMNBq1UrPfCRw5dUM2SmyXhT8ZVMUTpuLzNJT7+Ll9lGAhDlr/2tc6Fie2BGyDGBUj6sF3BsKbrknV3yHBB4gaUDEl5ly+0FRzY/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215422; c=relaxed/simple;
	bh=IUyvY7r76yLlL+A/K2mYMG4PAZ4zC0pZhyw9R5TcPPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0rMMMw+Cpuzl6i3CRZjRF1bhIUYiOwQM+8XUQkNmGzuH+w73gQwnsq38CWEw+Mee8h5ChrW8ROOeyl4E6k7XuI+E8YYWBN8diwaI9gCO7BrqZM8/buQi6bq2eeCxv2VbLcn8xeeoBPwkD02vdQstL1djR2dpP/QtNHwlVaLJvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAFpGLNI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAFpGLNI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3014CC4CEF1;
	Tue, 26 Aug 2025 13:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215422;
	bh=IUyvY7r76yLlL+A/K2mYMG4PAZ4zC0pZhyw9R5TcPPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NAFpGLNIkOeWX7RvsvVnhrN6Ww9ALJxInmBJp+Dv3PoXMkX2mRljjKjHVFCdWgbvg
	 ErG8ALKdFY+6jYQxvaIziU2vltwXkqR9nOmkobG3BBosfR23ywJCrthUfI1R7ihaR1
	 nF+37N681arVqy/+rgU8o9T5SCS+d0nZdJoMjO7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 008/644] Input: xpad - set correct controller type for Acer NGR200
Date: Tue, 26 Aug 2025 13:01:39 +0200
Message-ID: <20250826110946.718073824@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -144,12 +144,12 @@ static const struct xpad_device {
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


