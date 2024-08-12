Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D545518732C;
	Mon, 12 Aug 2024 16:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479923; cv=none; b=ktkI2YBuYhTQY6V84Pi1wXzA8NTI6Gr/g+oR08VmwVaGohwWg1iUrNLvw9Pw5DKzPztJHHS73tI+eGzYB8zTstOvTewgPzLca12fIZH4y6X3WxAQgimBcpjnDr26+Cerf7DrbNcEcjJ2TpwNBSka+UHn/PObXk2/yttRAXQcxgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479923; c=relaxed/simple;
	bh=LHHdRNtQx3NHRcPUNg4Qf+WAJL9IQPW21r/6weLtfOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gCXwKWsJZ7ltxH2RYJNX+2VszNvxhDpVfjmQpKAU9p8vn02j17IiP9w2yS2QK/C4OjJjsgW2m12VMwkd96tTuEF3UIz/1dbiFAWITCd8qB9g6D7lB/ojX1v7nuc03TLVKXbbP0m5HUZtkop2GRQB0FNy1dZRaKyytz7Y7Wegz7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nV+XF14/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nV+XF14/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595A2C32782;
	Mon, 12 Aug 2024 16:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479923;
	bh=LHHdRNtQx3NHRcPUNg4Qf+WAJL9IQPW21r/6weLtfOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nV+XF14/PmCBb8uhbwFi7QxxfkVnLFKv6SHHlW0Wn2B6JPRa2vvY8sF51BBk54hxY
	 YDe8dcoHBnlYVJbQGX40gBXN69ExMjd2noxRVPMmSVn5EJ1ZAqMdn/2oZomlUcefop
	 5LTTcyNjeUWBnHMpeR8AXhh6jtP9mHAcPN42azIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 042/263] hwmon: corsair-psu: add USB id of HX1200i Series 2023 psu
Date: Mon, 12 Aug 2024 18:00:43 +0200
Message-ID: <20240812160148.154585759@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



