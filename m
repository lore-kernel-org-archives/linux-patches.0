Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB4184527;
	Mon, 12 Aug 2024 16:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479372; cv=none; b=e2WGBwMZbj1k8TelK3u/gXY260UO4ZaA4I6sXd5TS+KrrpYajFuuFk8V0Q6bzS96HKNQgbhgRcET33y6RoUYX26qfvUXA9GUfaRe1sB6yTIX2SjwNQtUY/nD3Pw6pErsV7fJujZPj4Xl2RtExLwzC8/996B/wtup15g2SvpH6mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479372; c=relaxed/simple;
	bh=cDAkF1xCMsPk8j7cfLONqMOkYnT9z1p/ozV/vy63h2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWRzzR5LVSQQLCMMtYfKZ5CPkV/Wk4CoWl28r6XmpRMA+0SeQuPD8CihyJOpmf168F9gX27c6N4KSEGJTNhRqq2XkKxlkFMyV+2fibqlIQIgYztVICRkbeoEJJBTcg1IwLHBSQV7OM39Is9hJUIa5zvOrSpTnvvnCsIeTvCDvrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LF3CIysa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LF3CIysa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C14C32782;
	Mon, 12 Aug 2024 16:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479372;
	bh=cDAkF1xCMsPk8j7cfLONqMOkYnT9z1p/ozV/vy63h2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LF3CIysanSu6Az6U57nvlCcYFYZdOlB5eeJNUdbMYE5ZlNnzayn89KpbErguPihjc
	 390LTt017SWBdEs18fXbAA29RsOpcwny3oYNbyflsXnFvBUXTSVUlaVmwZvg95svn3
	 qLOkF+94V4f5bHW58iM2WIUIlXooYV3TFiVqGNL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 025/189] hwmon: corsair-psu: add USB id of HX1200i Series 2023 psu
Date: Mon, 12 Aug 2024 18:01:21 +0200
Message-ID: <20240812160133.114869896@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilken Gottwalt <wilken.gottwalt@posteo.net>

[ Upstream commit b9c15c96ccb47ad860af2e075c5f3c90c4cd1730 ]

Add the usb id of the HX1200i Series 2023. Update the documentation
accordingly. Also fix the version comments, there are no Series 2022
products. That are legacy or first version products going back many
many years.

Signed-off-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/ZlAZs4u0dU7JxtDf@monster.localdomain
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/hwmon/corsair-psu.rst | 6 +++---
 drivers/hwmon/corsair-psu.c         | 7 ++++---
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/corsair-psu.rst b/Documentation/hwmon/corsair-psu.rst
index 16db34d464dd6..7ed794087f848 100644
--- a/Documentation/hwmon/corsair-psu.rst
+++ b/Documentation/hwmon/corsair-psu.rst
@@ -15,11 +15,11 @@ Supported devices:
 
   Corsair HX850i
 
-  Corsair HX1000i (Series 2022 and 2023)
+  Corsair HX1000i (Legacy and Series 2023)
 
-  Corsair HX1200i
+  Corsair HX1200i (Legacy and Series 2023)
 
-  Corsair HX1500i (Series 2022 and 2023)
+  Corsair HX1500i (Legacy and Series 2023)
 
   Corsair RM550i
 
diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 2c7c92272fe39..f8f22b8a67cdf 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -875,15 +875,16 @@ static const struct hid_device_id corsairpsu_idtable[] = {
 	{ HID_USB_DEVICE(0x1b1c, 0x1c04) }, /* Corsair HX650i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c05) }, /* Corsair HX750i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c06) }, /* Corsair HX850i */
-	{ HID_USB_DEVICE(0x1b1c, 0x1c07) }, /* Corsair HX1000i Series 2022 */
-	{ HID_USB_DEVICE(0x1b1c, 0x1c08) }, /* Corsair HX1200i */
+	{ HID_USB_DEVICE(0x1b1c, 0x1c07) }, /* Corsair HX1000i Legacy */
+	{ HID_USB_DEVICE(0x1b1c, 0x1c08) }, /* Corsair HX1200i Legacy */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c09) }, /* Corsair RM550i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c0a) }, /* Corsair RM650i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c0b) }, /* Corsair RM750i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c0c) }, /* Corsair RM850i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c0d) }, /* Corsair RM1000i */
 	{ HID_USB_DEVICE(0x1b1c, 0x1c1e) }, /* Corsair HX1000i Series 2023 */
-	{ HID_USB_DEVICE(0x1b1c, 0x1c1f) }, /* Corsair HX1500i Series 2022 and 2023 */
+	{ HID_USB_DEVICE(0x1b1c, 0x1c1f) }, /* Corsair HX1500i Legacy and Series 2023 */
+	{ HID_USB_DEVICE(0x1b1c, 0x1c23) }, /* Corsair HX1200i Series 2023 */
 	{ },
 };
 MODULE_DEVICE_TABLE(hid, corsairpsu_idtable);
-- 
2.43.0



