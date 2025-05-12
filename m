Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7F1251788;
	Mon, 12 May 2025 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071873; cv=none; b=QBoqWYFFlLmPPjNG5FQHliVrAZMuh3ATbgLB50r0REU4FSH+opXamZQeTGxI5nh6pKzZw9ilkZU4TgfQQLBwHdod3QlpTCJcFlbLL2TYabIM363+rbBiapckl4DASvCBsoQ7gifW6eia6Q6mSzEvruIocmbmb5OWr8lYjwFZF18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071873; c=relaxed/simple;
	bh=AOCIjWUC0Ke0hJwc1N0IAeIo5Z1pcUzqow5GEVZXtBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOJ2pkdHnmVoKxIPHVtDdxq3b4de0fbWwYRnvg8G74YImupeLzjIYeVwZ+6B24fmy7RX1AO6ViqXrytwKEiPVkr/UnC6lIEgmnXsOCV1TxrzragNTCMZ6RVszDcGRaiOvy4m9fubjBaLJkLIzGArfwTkkbpB5O6H84yMAVfLUys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkHBg7Dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkHBg7Dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E5D6C4CEE9;
	Mon, 12 May 2025 17:44:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071872;
	bh=AOCIjWUC0Ke0hJwc1N0IAeIo5Z1pcUzqow5GEVZXtBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkHBg7Dnm7GYVe7YIc0W3fx1qs6xyKokavoFQXPq420l84nk1XGaF5yuKITw+g8aY
	 ytiO029hpbzt4iAq6JIKQ38EbjhVH5GJnpL20C6ZU7zu++VAdXq7IG+2gFiB7as4c9
	 t9J5rrVMtJ9aUB1myj8hlyulZLs7miQ1vhT2oCDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.14 059/197] Input: xpad - fix two controller table values
Date: Mon, 12 May 2025 19:38:29 +0200
Message-ID: <20250512172046.786570022@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

commit d05a424bea9aa3435009d5c462055008cc1545d8 upstream.

Two controllers -- Mad Catz JOYTECH NEO SE Advanced and PDP Mirror's
Edge Official -- were missing the value of the mapping field, and thus
wouldn't detect properly.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Link: https://lore.kernel.org/r/20250328234345.989761-1-vi@endrift.com
Fixes: 540602a43ae5 ("Input: xpad - add a few new VID/PID combinations")
Fixes: 3492321e2e60 ("Input: xpad - add multiple supported devices")
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/joystick/xpad.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -206,7 +206,7 @@ static const struct xpad_device {
 	{ 0x0738, 0x9871, "Mad Catz Portable Drum", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xb726, "Mad Catz Xbox controller - MW2", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xb738, "Mad Catz MVC2TE Stick 2", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOX360 },
-	{ 0x0738, 0xbeef, "Mad Catz JOYTECH NEO SE Advanced GamePad", XTYPE_XBOX360 },
+	{ 0x0738, 0xbeef, "Mad Catz JOYTECH NEO SE Advanced GamePad", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xcb02, "Saitek Cyborg Rumble Pad - PC/Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xcb03, "Saitek P3200 Rumble Pad - PC/Xbox 360", 0, XTYPE_XBOX360 },
 	{ 0x0738, 0xcb29, "Saitek Aviator Stick AV8R02", 0, XTYPE_XBOX360 },
@@ -241,7 +241,7 @@ static const struct xpad_device {
 	{ 0x0e6f, 0x0146, "Rock Candy Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0147, "PDP Marvel Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x015c, "PDP Xbox One Arcade Stick", MAP_TRIGGERS_TO_BUTTONS, XTYPE_XBOXONE },
-	{ 0x0e6f, 0x015d, "PDP Mirror's Edge Official Wired Controller for Xbox One", XTYPE_XBOXONE },
+	{ 0x0e6f, 0x015d, "PDP Mirror's Edge Official Wired Controller for Xbox One", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0161, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0162, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },
 	{ 0x0e6f, 0x0163, "PDP Xbox One Controller", 0, XTYPE_XBOXONE },


