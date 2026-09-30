Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC343B42E7;
	Wed, 30 Sep 2026 19:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796217; cv=none; b=V3rU2jCj5ll4XtTPflB2b+pDgHbblt+nX2aP8iV3+oU6X201cNYddZbIz/7NplMi6TX/vi3jdmsyB7jevmMQGwOhLpqiTuCTEQdPgSg0Jt8P/DqR5/j6hJVe8AbK2X0xrrJOfJNDqD0LQraQymYq5h79wH8HrVJQAv+qck48814=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796217; c=relaxed/simple;
	bh=e9442hSeu3vmS1xESzKiLhJt5Jc8IiBEZS2eZjCWP+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTpRTy4/YIy0kU7kbhBuoOYgz452YURmjqx1dLEJNTmEMhnys2Dy6mu8CYkjr4gcQR74Cikp3DWlbWlbejJRl82MsZBSwPlrv/DlhB6crGhJC9R/TscQRryO7S9ZApJ9T+6OEfiyLEP3dUB2jsn6neMJodBRggcZWbttbS7hUqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exKtxDXW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exKtxDXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E169A1F000FF;
	Wed, 30 Sep 2026 19:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796216;
	bh=sXt+x6hdLOclA+c2i2vkou1TVw6BjCQ7puTTfRdMzAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exKtxDXW2yMP/6i/z596Ptnk2w1Ccj8CiN08/mcW6zKpmEw2g6bCaxshQr2YBq5pn
	 gd/cZnAisMn2ubYbtLpGFI9qU+hakko63+knCVIyK1PAa310twzLRub1EfFEvrnldy
	 SquebCo5c4s5kZXAmrdjUdJZ2MOBDucHkFwrC2Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Nyberg <SlickStretch3.0@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 0834/1193] Input: xpad - fix PDP Marvel Xbox 360 controller
Date: Wed, 30 Sep 2026 17:25:18 +0200
Message-ID: <20260930152452.772078186@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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
@@ -244,7 +244,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0139, "Afterglow Prismatic Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x013a, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
-	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x0147, "PDP Marvel Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x015d, "PDP Mirror's Edge Official Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },


