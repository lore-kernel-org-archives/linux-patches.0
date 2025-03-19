Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027811A4F0A;
	Wed, 19 Mar 2025 14:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395099; cv=none; b=ArxO6im9rc6nGMwFkqDzsCwY56oMYSbMP01mBGaoPvSaltKEzZi81h2eQjLzewDbAp+eQKaXw9wBRKHuY9yTNTvszbq3qlqWy2Qoal1gv/1oDHxVKQruo598o/dFOBZlTMBCWdEp5NDdNPqZ4AKgH5ptTkz93mN/D+XfcnZG/yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395099; c=relaxed/simple;
	bh=ytqwsCDq3xMK6psviW7nQQo8zcP+Ttm1Sv21u/PG5jo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tsy0SGUUkavLrtIdIfM4+uQhivZ7n8+acAO6luOq4jMsn9rFNtZ5jQCzXU41GU8qWySVS/Nz3CtSBq6QttiYq6sx6AU4zuwzWQyeeiwTQdhHNP11XV4xzfo5cCi9hURHXJZwPgB3z+J5NF9vqxRgsbdpU2LaI+5Oc1r5roh/3Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fr57KJs0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fr57KJs0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EF5C4CEE4;
	Wed, 19 Mar 2025 14:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395098;
	bh=ytqwsCDq3xMK6psviW7nQQo8zcP+Ttm1Sv21u/PG5jo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fr57KJs0ui7bbgXExamQRDjFDudeFick5vHob6K6UXNFDk66bTAhC2FGLUjTStCLI
	 gFniuXI5DhcYc2T+cVWRalOrJHdXHtb41Gv19WSgZlHWUIybiov8Lf84J00SKZKBsb
	 9QPAWa0vGUlRB+lUzUR9X7YPeXXfIVn2Zva5bATY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilton Perim Neto <niltonperimneto@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 149/231] Input: xpad - add 8BitDo SN30 Pro, Hyperkin X91 and Gamesir G7 SE controllers
Date: Wed, 19 Mar 2025 07:30:42 -0700
Message-ID: <20250319143030.521726493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilton Perim Neto <niltonperimneto@gmail.com>

commit 36e093c8dcc585d0a9e79a005f721f01f3365eba upstream.

Add 8BitDo SN30 Pro, Hyperkin X91 and Gamesir G7 SE to the list of
recognized controllers, and update vendor comments to match.

Signed-off-by: Nilton Perim Neto <niltonperimneto@gmail.com>
Link: https://lore.kernel.org/r/20250122214814.102311-2-niltonperimneto@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -376,8 +376,10 @@ static const struct xpad_device {
 	{ 0x294b, 0x3404, "Snakebyte GAMEPAD RGB X", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x2000, "8BitDo Pro 2 Wired Controller fox Xbox", 0, XTYPE_XBOXONE },
 	{ 0x2dc8, 0x3106, "8BitDo Ultimate Wireless / Pro 2 Wired Controller", 0, XTYPE_XBOX360 },
+	{ 0x2dc8, 0x6001, "8BitDo SN30 Pro", 0, XTYPE_XBOX360 },
 	{ 0x2dc8, 0x310a, "8BitDo Ultimate 2C Wireless Controller", 0, XTYPE_XBOX360 },
 	{ 0x2e24, 0x0652, "Hyperkin Duke X-Box One pad", 0, XTYPE_XBOXONE },
+	{ 0x2e24, 0x1688, "Hyperkin X91 X-Box One pad", 0, XTYPE_XBOXONE },
 	{ 0x31e3, 0x1100, "Wooting One", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1200, "Wooting Two", 0, XTYPE_XBOX360 },
 	{ 0x31e3, 0x1210, "Wooting Lekker", 0, XTYPE_XBOX360 },
@@ -389,6 +391,7 @@ static const struct xpad_device {
 	{ 0x3285, 0x0646, "Nacon Pro Compact", 0, XTYPE_XBOXONE },
 	{ 0x3285, 0x0663, "Nacon Evol-X", 0, XTYPE_XBOXONE },
 	{ 0x3537, 0x1004, "GameSir T4 Kaleid", 0, XTYPE_XBOX360 },
+	{ 0x3537, 0x1010, "GameSir G7 SE", 0, XTYPE_XBOXONE },
 	{ 0x3767, 0x0101, "Fanatec Speedster 3 Forceshock Wheel", 0, XTYPE_XBOX },
 	{ 0xffff, 0xffff, "Chinese-made Xbox Controller", 0, XTYPE_XBOX },
 	{ 0x0000, 0x0000, "Generic X-Box pad", 0, XTYPE_UNKNOWN }
@@ -528,12 +531,12 @@ static const struct usb_device_id xpad_t
 	XPAD_XBOXONE_VENDOR(0x24c6),		/* PowerA controllers */
 	XPAD_XBOX360_VENDOR(0x2563),		/* OneXPlayer Gamepad */
 	XPAD_XBOX360_VENDOR(0x260d),		/* Dareu H101 */
-       XPAD_XBOXONE_VENDOR(0x294b),            /* Snakebyte */
+	XPAD_XBOXONE_VENDOR(0x294b),		/* Snakebyte */
 	XPAD_XBOX360_VENDOR(0x2c22),		/* Qanba Controllers */
-	XPAD_XBOX360_VENDOR(0x2dc8),            /* 8BitDo Pro 2 Wired Controller */
-	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Pro 2 Wired Controller for Xbox */
-	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Duke Xbox One pad */
-	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir controllers */
+	XPAD_XBOX360_VENDOR(0x2dc8),		/* 8BitDo Controllers */
+	XPAD_XBOXONE_VENDOR(0x2dc8),		/* 8BitDo Controllers */
+	XPAD_XBOXONE_VENDOR(0x2e24),		/* Hyperkin Controllers */
+	XPAD_XBOX360_VENDOR(0x2f24),		/* GameSir Controllers */
 	XPAD_XBOX360_VENDOR(0x31e3),		/* Wooting Keyboards */
 	XPAD_XBOX360_VENDOR(0x3285),		/* Nacon GC-100 */
 	XPAD_XBOXONE_VENDOR(0x3285),		/* Nacon Evol-X */


