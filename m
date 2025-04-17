Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC53E2571CE;
	Thu, 17 Apr 2025 18:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913034; cv=none; b=exSL+NQ8OtkBZdb47W+0KTi7Qfvj19di5lbsDda0b5r5Q+ezlCue2aS+SLaTQCpoKgNmZs71QdV+tLUZnPSMocAOv1bVrkoI9tCbc62BWXjb5KoRJDDloJ8Y19ebDV2uQc6wTkd3oHz/TtxKAK7DnA0E3hXDtu4UI0SGeBnTvno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913034; c=relaxed/simple;
	bh=GKRYehwwR/4HBKsnJt/cj3ufPIdnFG1vozfEqhI2bUQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CCa7DmM/Ggch4GdUnE9JP9srUVxZHeyEYdo6v52A/YD7MfyaywCxu1+Dd7b6LWWlfo2UNygtTlvhJLMQplGwuDj09BFus+eaG1Z/eVM3vSmJja8gH6hEGdyBosD3H6qe2DkX18CUmXM3C0O7PG/1UwPuRcu42j10Regr0H1tmU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5xmVXZh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5xmVXZh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451E4C4CEE4;
	Thu, 17 Apr 2025 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913034;
	bh=GKRYehwwR/4HBKsnJt/cj3ufPIdnFG1vozfEqhI2bUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5xmVXZhtwRCpRNpPhsmt8ycEzthYDvBkSO+H1OqvQ7+RcP+cuw7DFAEtOkZu+88R
	 AyZ6NhFVrVpZOmrPmJSmu7TRESkuws1vgvkBbjROWhfIBE+TmLGZChGQwvpYgcCpHx
	 bXVLrcoUIuuHoIJEyxHRwD1xjS0T5qlD32QikOrY=
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
Subject: [PATCH 6.14 206/449] HID: pidff: Factor out pool report fetch and remove excess declaration
Date: Thu, 17 Apr 2025 19:48:14 +0200
Message-ID: <20250417175126.257003010@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



