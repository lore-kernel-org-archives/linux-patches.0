Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF9C3355808;
	Tue,  6 Jan 2026 18:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722419; cv=none; b=tkTKOA+54bax00f3pGq4RzhQRTmjK6sV0x2hUI/iSZqSWIMKS5WsTeVjiBXwz5Wzry/gXptNKRgQVnYNKWgVKpDcIcUW3Wrzqhrg9Fi4WcHxyC7Az3wcSk+r0MrN5DB9m1N9AiT4cnPdvh5vEyPbvbKSQU58LOIJn/6UbkB1djU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722419; c=relaxed/simple;
	bh=zxIosl0xFQwNTy0IDbqt3sol0mq+wbzEGUAC88w0Tck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ubXbmVcutZtxlG4RJUPI7CAMQav/q0w6Lt47n06WQ5l9rIBu/Hs2xxNANVRWdTy0k34hG7p/gq2yJBlvepHdsbVGuo87wJiIN82ZZlmt0A3QJK3PnZA1toibH114Yq6tUOW687MDxfDFhAfP3d923zvohpxmNE6VbQ57q268lkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSC0qlVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSC0qlVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3FAC116C6;
	Tue,  6 Jan 2026 18:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722418;
	bh=zxIosl0xFQwNTy0IDbqt3sol0mq+wbzEGUAC88w0Tck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mSC0qlVq4osAYUZUaD6Hq9Er5QXHuW8K8RtDr68/JQpjP10IE9Mz8v9jGhj5m5lNl
	 BTzIiD7hdNACMEwll8VgEYMMKMV4XLODHj82kT2K2re0O2nOM1OJ8wvdHozzEfz3Fz
	 PxgFWvIrAXJMrAG/R2XNyS7sqLVL6GWg8rOZj+K4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianni Ceccarelli <dakkar@thenautilus.net>,
	Armin Wolf <W_Armin@gmx.de>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 258/312] platform/x86: samsung-galaxybook: Fix problematic pointer cast
Date: Tue,  6 Jan 2026 18:05:32 +0100
Message-ID: <20260106170557.181727463@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

commit d37cd54ebeac37a763fbf303ed25f8a6e98328ff upstream.

A user reported that reading the charge threshold on his device
results in very strange values (like 78497792) being returned.
The reason for this seems to be the fact that the driver casts
the int pointer to an u8 pointer, leaving the last 3 bytes of
the destination uninitialized. Fix this by using a temporary
variable instead.

Cc: stable@vger.kernel.org
Fixes: 56f529ce4370 ("platform/x86: samsung-galaxybook: Add samsung-galaxybook driver")
Reported-by: Gianni Ceccarelli <dakkar@thenautilus.net>
Closes: https://lore.kernel.org/platform-driver-x86/20251228115556.14362d66@thenautilus.net/
Tested-by: Gianni Ceccarelli <dakkar@thenautilus.net>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://patch.msgid.link/20251228214217.35972-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/samsung-galaxybook.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/platform/x86/samsung-galaxybook.c
+++ b/drivers/platform/x86/samsung-galaxybook.c
@@ -442,12 +442,13 @@ static int galaxybook_battery_ext_proper
 					       union power_supply_propval *val)
 {
 	struct samsung_galaxybook *galaxybook = ext_data;
+	u8 value;
 	int err;
 
 	if (psp != POWER_SUPPLY_PROP_CHARGE_CONTROL_END_THRESHOLD)
 		return -EINVAL;
 
-	err = charge_control_end_threshold_acpi_get(galaxybook, (u8 *)&val->intval);
+	err = charge_control_end_threshold_acpi_get(galaxybook, &value);
 	if (err)
 		return err;
 
@@ -455,8 +456,10 @@ static int galaxybook_battery_ext_proper
 	 * device stores "no end threshold" as 0 instead of 100;
 	 * if device has 0, report 100
 	 */
-	if (val->intval == 0)
-		val->intval = 100;
+	if (value == 0)
+		value = 100;
+
+	val->intval = value;
 
 	return 0;
 }


