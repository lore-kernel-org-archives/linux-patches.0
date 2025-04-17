Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9814502F;
	Thu, 17 Apr 2025 18:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915591; cv=none; b=E4lRq9BijUOkqyUjAgexf0Pgp49wzv8Yl56zyHRwtGZED9feSTOCYN60kFy6sqq7ETY3UzFVl1sfEzwrBSALTKAcHkZjB1dQEkQwpB+S/KcSUWijpu+Il44wiEBSoVycZoIlaIHzzoYyM2uNB0PMkxDzE4pEhUMOYwI6EydlCq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915591; c=relaxed/simple;
	bh=AUdmqSta+GwMLxFRuigPTQk8tXcKPEh1XpJwVrXL0sY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uPk1jOY2VY0zqUo1X4Us+y05LNRuJ99P3NzKQsgnQL/VtKL+nSam2DRDvQNXpHFgYzUd30t78StKRBQZf61Q2In27sH7d3lB0eNSi7irl21JAOx8xnP+L8ud8gq1jl46w8Y2KwlvvfICp+5LYAYM9eAYV2OAB16y5gsEjWBAnKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSjp2qVK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSjp2qVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8D0AC4CEE4;
	Thu, 17 Apr 2025 18:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915591;
	bh=AUdmqSta+GwMLxFRuigPTQk8tXcKPEh1XpJwVrXL0sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSjp2qVKa7X1ldLDCWuugE3l7edciOlshH/JFrFIQrHduI96rDNgVRu0QwIDzxAT0
	 QlCFc0ixteMLzPsFFuv9zACL8pSLXMUXzoC7muqAyxTVJk1H6VvmH40ZpU8YM9trK/
	 G/OBF4G8JaCqHmDqydm63HOKUJ8/XLaWWsJG7svg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Tomasz=20Paku=C5=82a?= <tomasz.pakula.oficjalny@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Kope=C4=87?= <michal@nozomi.space>,
	Paul Dino Jones <paul@spacefreak18.xyz>,
	=?UTF-8?q?Crist=C3=B3ferson=20Bueno?= <cbueno81@gmail.com>,
	Pablo Cisneros <patchkez@protonmail.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/393] HID: pidff: Factor out pool report fetch and remove excess declaration
Date: Thu, 17 Apr 2025 19:49:45 +0200
Message-ID: <20250417175114.680431083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>

[ Upstream commit 5d98079b2d0186e1f586301a9c00144a669416a8 ]

We only want to refetch the pool report during device init. Reset
function is now called when uploading effects to an empty device so
extract pool fetch to separate function and call it from init before
autocenter check (autocenter check triggered reset during init).

Remove a superfluous pointer declaration and assigment as well.

Signed-off-by: Tomasz Pakuła <tomasz.pakula.oficjalny@gmail.com>
Reviewed-by: Michał Kopeć <michal@nozomi.space>
Reviewed-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Paul Dino Jones <paul@spacefreak18.xyz>
Tested-by: Cristóferson Bueno <cbueno81@gmail.com>
Tested-by: Pablo Cisneros <patchkez@protonmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/usbhid/hid-pidff.c | 45 ++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/hid/usbhid/hid-pidff.c b/drivers/hid/usbhid/hid-pidff.c
index b21e844f5f3a3..f23381b6e3447 100644
--- a/drivers/hid/usbhid/hid-pidff.c
+++ b/drivers/hid/usbhid/hid-pidff.c
@@ -591,12 +591,9 @@ static void pidff_modify_actuators_state(struct pidff_device *pidff, bool enable
 
 /*
  * Reset the device, stop all effects, enable actuators
- * Refetch pool report
  */
 static void pidff_reset(struct pidff_device *pidff)
 {
-	int i = 0;
-
 	/* We reset twice as sometimes hid_wait_io isn't waiting long enough */
 	pidff_send_device_control(pidff, PID_RESET);
 	pidff_send_device_control(pidff, PID_RESET);
@@ -604,23 +601,29 @@ static void pidff_reset(struct pidff_device *pidff)
 
 	pidff_send_device_control(pidff, PID_STOP_ALL_EFFECTS);
 	pidff_modify_actuators_state(pidff, 1);
+}
 
-	/* pool report is sometimes messed up, refetch it */
-	hid_hw_request(pidff->hid, pidff->reports[PID_POOL], HID_REQ_GET_REPORT);
-	hid_hw_wait(pidff->hid);
+/*
+ * Refetch pool report
+ */
+static void pidff_fetch_pool(struct pidff_device *pidff)
+{
+	if (!pidff->pool[PID_SIMULTANEOUS_MAX].value)
+		return;
 
-	if (pidff->pool[PID_SIMULTANEOUS_MAX].value) {
-		while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
-			if (i++ > 20) {
-				hid_warn(pidff->hid,
-					 "device reports %d simultaneous effects\n",
-					 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
-				break;
-			}
-			hid_dbg(pidff->hid, "pid_pool requested again\n");
-			hid_hw_request(pidff->hid, pidff->reports[PID_POOL],
-					  HID_REQ_GET_REPORT);
-			hid_hw_wait(pidff->hid);
+	int i = 0;
+	while (pidff->pool[PID_SIMULTANEOUS_MAX].value[0] < 2) {
+		hid_dbg(pidff->hid, "pid_pool requested again\n");
+		hid_hw_request(pidff->hid, pidff->reports[PID_POOL],
+				HID_REQ_GET_REPORT);
+		hid_hw_wait(pidff->hid);
+
+		/* break after 20 tries with SIMULTANEOUS_MAX < 2 */
+		if (i++ > 20) {
+			hid_warn(pidff->hid,
+				 "device reports %d simultaneous effects\n",
+				 pidff->pool[PID_SIMULTANEOUS_MAX].value[0]);
+			break;
 		}
 	}
 }
@@ -916,9 +919,7 @@ static void pidff_autocenter(struct pidff_device *pidff, u16 magnitude)
  */
 static void pidff_set_autocenter(struct input_dev *dev, u16 magnitude)
 {
-	struct pidff_device *pidff = dev->ff->private;
-
-	pidff_autocenter(pidff, magnitude);
+	pidff_autocenter(dev->ff->private, magnitude);
 }
 
 /*
@@ -1424,6 +1425,8 @@ int hid_pidff_init_with_quirks(struct hid_device *hid, u32 initial_quirks)
 	if (error)
 		goto fail;
 
+	/* pool report is sometimes messed up, refetch it */
+	pidff_fetch_pool(pidff);
 	pidff_set_gain_report(pidff, U16_MAX);
 	error = pidff_check_autocenter(pidff, dev);
 	if (error)
-- 
2.39.5



