Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5F5743ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mnHAU+up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64502C4AF7F;
	Wed, 15 Nov 2023 20:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081431;
	bh=lWDWNAKkMHGHE6JxX2zmYApfj6AIu63ZQGnGtt2b6Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnHAU+upR87lozK4ALaJwWn/D5B7S1xzECNAotccAu+rTKxyHRU3Xjf5Twi01zcJV
	 SQ29p5Z8mDU6++0WAYYa4uFmPR+uFnJPAChKM/vtTEOVtLS3X0SSV1NeEgbzVWr27d
	 7BhR7Ya3drtgRk23ZvKnWcOX3RrIVU/SctuJYsBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Nocera <hadess@hadess.net>,
	Benjamin Tissoires <benjamin.tissoires@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 150/244] Revert "HID: logitech-hidpp: add a module parameter to keep firmware gestures"
Date: Wed, 15 Nov 2023 15:35:42 -0500
Message-ID: <20231115203557.335466050@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Bastien Nocera <hadess@hadess.net>

[ Upstream commit cae253d6033da885e71c29c1591b22838a52de76 ]

Now that we're in 2022, and the majority of desktop environments can and
should support touchpad gestures through libinput, remove the legacy
module parameter that made it possible to use gestures implemented in
firmware.

This will eventually allow simplifying the driver's initialisation code.

This reverts commit 9188dbaed68a4b23dc96eba165265c08caa7dc2a.

Signed-off-by: Bastien Nocera <hadess@hadess.net>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20221220154345.474596-1-hadess@hadess.net
Stable-dep-of: 11ca0322a419 ("HID: logitech-hidpp: Don't restart IO, instead defer hid_connect() only")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 25fa235934880..7681a3fa67dab 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -31,11 +31,6 @@ MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Benjamin Tissoires <benjamin.tissoires@gmail.com>");
 MODULE_AUTHOR("Nestor Lopez Casado <nlopezcasad@logitech.com>");
 
-static bool disable_raw_mode;
-module_param(disable_raw_mode, bool, 0644);
-MODULE_PARM_DESC(disable_raw_mode,
-	"Disable Raw mode reporting for touchpads and keep firmware gestures.");
-
 static bool disable_tap_to_click;
 module_param(disable_tap_to_click, bool, 0644);
 MODULE_PARM_DESC(disable_tap_to_click,
@@ -4137,11 +4132,6 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	    hidpp_application_equals(hdev, HID_GD_KEYBOARD))
 		hidpp->quirks |= HIDPP_QUIRK_HIDPP_CONSUMER_VENDOR_KEYS;
 
-	if (disable_raw_mode) {
-		hidpp->quirks &= ~HIDPP_QUIRK_CLASS_WTP;
-		hidpp->quirks &= ~HIDPP_QUIRK_NO_HIDINPUT;
-	}
-
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP) {
 		ret = wtp_allocate(hdev, id);
 		if (ret)
-- 
2.42.0



