Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FB43A383C;
	Wed, 20 May 2026 16:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296132; cv=none; b=ZxvdtTnPekPjekKg8BV8r/XMZrIVGsVVXe/sPmDVI6qsBgiGSICO+2xi6YfuJcnXZJJy2/dCyzEvYZxQiaD1x05jAcpTG9k5SKBbkHJCq4W5g7gMT0g9AZHr4zhwTroMOlFT9md8zQZedDzWXoXWkIdKGwiOAMVrxY95ei7z2To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296132; c=relaxed/simple;
	bh=eO/1EJuyOt1gEtmRCkOAbN+87KbgenXoyMw4ok0RlIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ehWN81Cn9w6iJDxe+kB7YnHUF0b8XpdLrl1xFQPrRD3af7RfjAgF43nGBCbOHKIeGmn5ZNMDXzFR4chjwDFOlxqMZYOIbRl6vxj0PMhtykuXYtj21vjHWnqCmDkcv5iLeVQ2/9rZXNmEhMqWYmNhng/GkKgghVwIfUJ5lPDuZnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W9vD0BRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W9vD0BRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB921F000E9;
	Wed, 20 May 2026 16:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296131;
	bh=8WDXGv/9kGuP/pwjws0uAbPX1VVMbPsdZ/tIy3/SX4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W9vD0BRIheLDg3qZ5X38xc7dqK/MRuselPEt13lt8Z6lmAAJv1jvQnYPmY4EDHqkd
	 Z+HNVn23mObs0o3ILgrLPyMR9Xop7fKJ4NIRKc0J0JRttvU5d1xhEwEAVRZ1H9Cnf4
	 7t4/YWCrUEX6d74i5V7CfV46CFe02rYp+QyW7Uic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Denis Benato <denis.benato@linux.dev>,
	Luke Jones <luke@ljones.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0682/1146] platform/x86: asus-wmi: adjust screenpad power/brightness handling
Date: Wed, 20 May 2026 18:15:32 +0200
Message-ID: <20260520162203.623888309@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 130d29c5627cd50e786e926ad7ef66322c5a0c09 ]

Fix illogical screen off control by hardcoding 0 and 1 depending on the
requested brightness and also do not rely on the last screenpad power
state to issue screen brightness commands.

Fixes: 2c97d3e55b70 ("platform/x86: asus-wmi: add support for ASUS screenpad")
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Signed-off-by: Luke Jones <luke@ljones.dev>
Link: https://patch.msgid.link/20260302174431.349816-2-denis.benato@linux.dev
Link: https://patch.msgid.link/20260326231154.856729-2-ethantidmore06@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 34 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 7c0915e097bae..f3c54290c58d2 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -4419,32 +4419,24 @@ static int read_screenpad_brightness(struct backlight_device *bd)
 
 static int update_screenpad_bl_status(struct backlight_device *bd)
 {
-	struct asus_wmi *asus = bl_get_data(bd);
-	int power, err = 0;
-	u32 ctrl_param;
+	u32 ctrl_param = bd->props.brightness;
+	int err = 0;
 
-	power = read_screenpad_backlight_power(asus);
-	if (power < 0)
-		return power;
+	if (bd->props.power) {
+		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 1, NULL);
+		if (err < 0)
+			return err;
 
-	if (bd->props.power != power) {
-		if (power != BACKLIGHT_POWER_ON) {
-			/* Only brightness > 0 can power it back on */
-			ctrl_param = asus->driver->screenpad_brightness - ASUS_SCREENPAD_BRIGHT_MIN;
-			err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_LIGHT,
-						    ctrl_param, NULL);
-		} else {
-			err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 0, NULL);
-		}
-	} else if (power == BACKLIGHT_POWER_ON) {
-		/* Only set brightness if powered on or we get invalid/unsync state */
-		ctrl_param = bd->props.brightness + ASUS_SCREENPAD_BRIGHT_MIN;
 		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_LIGHT, ctrl_param, NULL);
+		if (err < 0)
+			return err;
 	}
 
-	/* Ensure brightness is stored to turn back on with */
-	if (err == 0)
-		asus->driver->screenpad_brightness = bd->props.brightness + ASUS_SCREENPAD_BRIGHT_MIN;
+	if (!bd->props.power) {
+		err = asus_wmi_set_devstate(ASUS_WMI_DEVID_SCREENPAD_POWER, 0, NULL);
+		if (err < 0)
+			return err;
+	}
 
 	return err;
 }
-- 
2.53.0



