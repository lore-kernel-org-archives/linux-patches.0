Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42F2036D4E1;
	Wed, 30 Sep 2026 18:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792048; cv=none; b=l9hHR+bMnGElZ66y3WICSeir0Lk2Hoedx8sxRuTUOIAZW4jExul9hx8ueC5rsW+6O0vCpiY5CT9qXoAFHFZyxAmTaeCeHqVEk/YOZwGobgld6YYz6UCefE6l7jatZuk67d5I0V4rZSI2G0aqEA4lQdjle8EwuftV0ae8zGsytI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792048; c=relaxed/simple;
	bh=OVAp6WSo/vjapULwgB7Kvq9rNsTYNHMcVPDNOUPEDLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BNPxx+Pf7e2CuGITcjuZNYVhUBAyqJ/TmZbm0IgXISSs8kgjwfT8XQy3Mxtu2NuPLKxPdSNhRIBNzOCGCZTgXDb7aMNa+RDlsqIXZRklVvnEelXUqk2HPHEHGBNQTeFYuXDQcsuRgOu+Pi1057udLH3xhf7UZbDz21nv0005rhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUHN8QPW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUHN8QPW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1491F000FF;
	Wed, 30 Sep 2026 18:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792047;
	bh=OQxbueDrmTpuC7MEAbv8P2ZoNmzbQzvrbZNmYoYT2a4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WUHN8QPWTSUPyuAICLh4zPlAkdlkr5PFZefkYNIQsUSMRVA6GozBbeTiuvLjZQ0MR
	 TznkSt6z5QzQYjyInqLoNQJCHgKOLzjFuOcuK3rXI/gRi/isdw25QmJtlVBYDWnX+p
	 1I3uXaXNh5wBnWJD4lB80fbIkTUwzNzF4zcT5c3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Nyberg <SlickStretch3.0@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 518/752] Input: xpad - fix PDP Marvel Xbox 360 controller
Date: Wed, 30 Sep 2026 17:26:28 +0200
Message-ID: <20260930152409.464776493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Nyberg <slickstretch3.0@gmail.com>

commit 7bc369cb3d3f3656eb77285628ee264264d28ad4 upstream.

The PDP Marvel Xbox 360 controller with USB ID 0e6f:0147 is
incorrectly classified as an Xbox One controller.

With the current XTYPE_XBOXONE classification, the controller is
detected but produces no input, while its four player LEDs continue
blinking indefinitely.

Classify USB ID 0e6f:0147 as an Xbox 360 controller instead.

Tested on a PDP Marvel Xbox 360 controller with USB ID 0e6f:0147.
All inputs register correctly and the player LED indicates the
current player.

Fixes: c225370e01b8 ("Input: xpad - sync supported devices with 360Controller")
Cc: stable@vger.kernel.org
Signed-off-by: Jeremy Nyberg <SlickStretch3.0@gmail.com>
Link: https://patch.msgid.link/20260910071627.236014-1-SlickStretch3.0@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -211,7 +211,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0139, "Afterglow Prismatic Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x013a, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
-	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x0147, "PDP Marvel Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0162, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },


