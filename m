Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D47545D84;
	Wed, 23 Sep 2026 14:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174706; cv=none; b=VyvaBihvg/EmJLQNRLSyyDGq7DmIrBIhonSSq2B4zTbxNvqAfFp4eCEWJWd6g6AI0wQ3P3q//xzD6pp7xUrKMwNZbnD8AmBNyIuEjVs65OEwFFoEwHilxbcHRxNPz0x1Z9WEUjYph+r/eLv6gjyj5+98nubk7MlMEs1t7FYPI6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174706; c=relaxed/simple;
	bh=iKxdJnT6ZIMR0KLN8hN9jE5pofusVV6PClkPKpcHL7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QN1+0Ff9jTa739w5sp1Fee2cp1Ah6Km2veVtgPXVj2/odDcvFiZ2UEnpEsQxarvksVNR9d/aaYSqJDsZ0mOxq+fdlhVLrNK4j3GQixs+ZwWDqbfvReu8Y5V93VqvnyZU/JvZLAstf6w3r7WJLukFmqAhBqG52S5dS8avk2O+4Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2a+StRNg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2a+StRNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060821F000FF;
	Wed, 23 Sep 2026 14:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174704;
	bh=lyz+nGFlt9fK/fn9C6HPdnqUuNz68bA512DCxoJB8oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2a+StRNgDDvzby4Lcwq+T2nkDNbHpEOVkybOM5yr6ouBheXe+25TH1mSo8CllsJOx
	 r4MtrbsyX/yGruaX3rA8rYf0DAop/mS8s4gxq8jKpCKwfjtWDQE2EJLM/2yohfgR7H
	 s18MSQ6t/3Nj9CU1ul8c2oGl8+/4rp0CcyRQ0Q5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Nyberg <SlickStretch3.0@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 198/398] Input: xpad - fix PDP Marvel Xbox 360 controller
Date: Wed, 23 Sep 2026 16:04:32 +0200
Message-ID: <20260923140648.556163663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -249,7 +249,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0139, "Afterglow Prismatic Wired Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x013a, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
-	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
+	{ 0x0e6f, 0x0147, "PDP Marvel Xbox 360 Controller", 0, XTYPE_XBOX360 },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x015d, "PDP Mirror's Edge Official Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },


