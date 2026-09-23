Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4940418368;
	Wed, 23 Sep 2026 14:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173400; cv=none; b=dkMliz0Y7dOqWXYGH0Syk6QJKNWZjh8JfJs6kY2NBUQrn6zcfI84TzzFyfjJQVfvs0NsCBAdndgu9pAJRiz3hn1q9AB6DNPtm3p+/zlFW2Ps2GZmF/N1ZWcd/ChKz6y5js93sIXNRln/CiDst2b4CWzP64oIEZ6Zp1rNvSlx4HQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173400; c=relaxed/simple;
	bh=NaDlkqrbIppJi3HVQsaf8fKMldeVJEKHVMloPKG/kQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZvIabhbLrI0euFujJ60q47d4CjrfqS/897S9PAc77uhKGWDmFLubG7y8lD2eN5la9NsOlodCk5M68WIn8EcYAnttBOPxZbjLlZzlotPM/8LEAmH2dHz9AtCYOtnBZcDiON6p+M8h+Z9ZWaOU1+qCg3JvGThB0GiaVifGozGwhbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b/YOZvAd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b/YOZvAd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAB41F000FF;
	Wed, 23 Sep 2026 14:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173399;
	bh=KdcBuMTi8HBePq1/kKlEn8dlPkYS6882lG5MJwSkook=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b/YOZvAdmk8bM8aApXRG72eOkCJdr8zYOGZSiibp1hDfNutb1V95dyYRuGVEUY146
	 2Jf5Xg3LeqTVFoiRmGi6XpghHsTI2AydXCyc4mZ8+xBnb5zuk0Ro5ZUerkgqws8tlW
	 tFLc70s4rVdikXqQRK+XEIJWKskzZiTo6jVzkx3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Nyberg <SlickStretch3.0@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.2 235/438] Input: xpad - fix PDP Marvel Xbox 360 controller
Date: Wed, 23 Sep 2026 16:04:16 +0200
Message-ID: <20260923140650.860805096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -215,7 +215,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0139, "Afterglow Prismatic Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x013a, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
-	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x0147, "PDP Marvel Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x015d, "PDP Mirror's Edge Official Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },


