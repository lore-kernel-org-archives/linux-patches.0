Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059234;
	b=h+30m5lI49TeeXI35LvtUocRKdOWXwvYMttxc7z6q+eGFI4Y1+qzS+3VblDGcdzS87aV
	 kI80zaiEKOq5r3qefS7yX6Treqv7cMLUIOdN2teaRqmnOBJN7bZAGl71Uy9IvMwNlI4kN
	 xlQ/fGCg3+kdy4bb5FLPZNcZc//H1QCyUq510oz0vNGme1r5NnNuu8OXFvmp+f/73wxym
	 yf1AaQB5R0w0sihrHXOXMs9YokUkvgJ6WvtsSjEjko8yS70LvwSk1x+KCZCyXE6/+cyfo
	 haOlsTSEAC2KSYxBnkPu5ROSN/Oj6L2eKw7fEc42yECEKC654hEA3tCljNGB5nxEXtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hbnaEqI7+k4mI6L/8Vh5jZ5RW4/9i6vN8rZugfzm7XA=;
	b=RKN+lGnMGce2PUXkEOR+yP9ZKGx/Lpfl9n0ZY3uAYyusf7nDeMAxp9XXdjXBUwzZCVZo
	 ye0HB2Lb57uuFaj8sPaGJJM9nBqLw8LutHhsPzLQfCPtx55U0DUEHwQuoBEWvRnH4uJkc
	 JvS61EF2NTyu0jP39qldtL8VH/l9LCfhRzK8wlnygXzvH4AiF8TnKafNZCsQyxu1Sksg8
	 MKR2m650BbDkGGMWWhn4AS5Zxj9BGvYNNj4I29lxOUWkx372/nf0YLbl/4bd7ZLlB3QhM
	 bxvO8BlitaesEcDUZpNT5RDpD2FGmTGa71qf6xwcU2YO9SDu8bhei+H7qy8DjKCExxA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l06qScGM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B2A606A320;
	Thu, 19 Nov 2026 03:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l06qScGM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 595441F000C4;
	Thu, 19 Nov 2026 03:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059233;
	bh=hbnaEqI7+k4mI6L/8Vh5jZ5RW4/9i6vN8rZugfzm7XA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l06qScGMgxFwidzszwPr4otul0syMCjnTtX9i6RLa7bH1+tFyQwDElXKhP7j+9/aK
	 H8KQai7zJtOw4EZByWB8B0LZUpUOTIxdIjnhNrrqtM8IOGPoucv/cqxSmrhHQ6TOP+
	 0UOeWhfLvHXg5/OUXPrSj9MmolSmI7UbAkW20wmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0770/1848] HID: wacom: Fix Use-After-Free in wacom_bamboo_pad
Date: Wed, 18 Nov 2026 15:46:48 +0100
Message-ID: <20261118145948.622747722@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 3a523ecf9ac3fdd33f5eb31c43937ee44135395b ]

wacom_bamboo_pad_pen_event() accesses wacom->shared->pen locklessly
relative to wacom_remove_shared_data() which nullifies it.  This
can lead to a Use-After-Free if the sibling device is removed while
events are being processed.

Resolve this by introducing RCU protection for pen and touch
pointers:

 - Annotate 'pen' and 'touch' in wacom_shared struct with __rcu.
 - Wrap lockless readers in wacom_bamboo_pad_pen_event() with
   rcu_read_lock() and rcu_dereference().
 - Update writers in wacom_sys.c using rcu_assign_pointer().
 - Use rcu_dereference_protected for comparisons under
   wacom_udev_list_lock.
 - Also use rcu_access_pointer in wacom_sibling_pending() and
   wacom_mode_change_work() to avoid warnings (while lockless access in
   the latter remains a pre-existing issue).

Cc: stable@vger.kernel.org
Fixes: 8c97a765467c ("HID: wacom: add full support of the Wacom Bamboo PAD")
Signed-off-by: Lee Jones <lee@kernel.org>
Acked-by: Ping Cheng <ping.cheng@wacom.com>
Tested-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Use explicit lock/unlock calls and top-of-block declarations in
      wacom_remove_shared_data() and wacom_bamboo_pad_pen_event() for
      -std=gnu89 compatibility, and adapt to res_wacom]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/wacom_sys.c | 40 ++++++++++++++++++++++++++--------------
 drivers/hid/wacom_wac.c | 14 +++++++-------
 drivers/hid/wacom_wac.h |  4 ++--
 3 files changed, 35 insertions(+), 23 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 94e12c56e040a..465d075d16f90 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -882,15 +882,22 @@ static void wacom_remove_shared_data(void *res)
 	struct wacom_wac *wacom_wac = &res_wacom->wacom_wac;
 
 	if (wacom_wac->shared) {
+		struct hid_device *touch, *pen;
+
 		data = container_of(wacom_wac->shared, struct wacom_hdev_data,
 				    shared);
 
 		mutex_lock(&wacom_udev_list_lock);
-		if (wacom_wac->shared->touch == res_wacom->hdev) {
-			wacom_wac->shared->touch = NULL;
+		touch = rcu_dereference_protected(wacom_wac->shared->touch,
+						  lockdep_is_held(&wacom_udev_list_lock));
+		pen = rcu_dereference_protected(wacom_wac->shared->pen,
+						lockdep_is_held(&wacom_udev_list_lock));
+
+		if (touch == res_wacom->hdev) {
+			rcu_assign_pointer(wacom_wac->shared->touch, NULL);
 			rcu_assign_pointer(wacom_wac->shared->touch_input, NULL);
-		} else if (wacom_wac->shared->pen == res_wacom->hdev) {
-			wacom_wac->shared->pen = NULL;
+		} else if (pen == res_wacom->hdev) {
+			rcu_assign_pointer(wacom_wac->shared->pen, NULL);
 		}
 		mutex_unlock(&wacom_udev_list_lock);
 
@@ -2350,14 +2357,17 @@ static void wacom_set_shared_values(struct wacom_wac *wacom_wac)
 	}
 
 	if (wacom_wac->features.device_type & WACOM_DEVICETYPE_TOUCH) {
-		if (wacom_wac->shared->touch == wacom->hdev || !wacom_wac->shared->touch) {
+		struct hid_device *touch =
+			rcu_dereference_protected(wacom_wac->shared->touch,
+						  lockdep_is_held(&wacom_udev_list_lock));
+
+		if (touch == wacom->hdev || !touch) {
 			wacom_wac->shared->type = wacom_wac->features.type;
-			wacom_wac->shared->touch = wacom->hdev;
+			rcu_assign_pointer(wacom_wac->shared->touch, wacom->hdev);
 			rcu_assign_pointer(wacom_wac->shared->touch_input, wacom_wac->touch_input);
 		}
 	} else if (wacom_wac->features.device_type & WACOM_DEVICETYPE_PEN) {
-		/* Pairs with smp_load_acquire() in wacom_sibling_pending() */
-		smp_store_release(&wacom_wac->shared->pen, wacom->hdev);
+		rcu_assign_pointer(wacom_wac->shared->pen, wacom->hdev);
 	}
 }
 
@@ -2373,8 +2383,7 @@ static bool wacom_sibling_pending(struct wacom *wacom)
 		return false;
 
 	if (wacom->wacom_wac.shared) {
-		/* Pairs with smp_store_release() in wacom_set_shared_values() */
-		if (smp_load_acquire(&wacom->wacom_wac.shared->pen))
+		if (rcu_access_pointer(wacom->wacom_wac.shared->pen))
 			return false;
 	}
 
@@ -2844,16 +2853,19 @@ static void wacom_mode_change_work(struct work_struct *work)
 	bool is_direct = wacom->wacom_wac.is_direct_mode;
 	int error = 0;
 
-	if (shared->pen) {
-		wacom1 = hid_get_drvdata(shared->pen);
+	struct hid_device *pen = rcu_access_pointer(shared->pen);
+	struct hid_device *touch = rcu_access_pointer(shared->touch);
+
+	if (pen) {
+		wacom1 = hid_get_drvdata(pen);
 		wacom_release_resources(wacom1);
 		hid_hw_stop(wacom1->hdev);
 		wacom1->wacom_wac.has_mode_change = true;
 		wacom1->wacom_wac.is_direct_mode = is_direct;
 	}
 
-	if (shared->touch) {
-		wacom2 = hid_get_drvdata(shared->touch);
+	if (touch) {
+		wacom2 = hid_get_drvdata(touch);
 		wacom_release_resources(wacom2);
 		hid_hw_stop(wacom2->hdev);
 		wacom2->wacom_wac.has_mode_change = true;
diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 059572ea05097..4c7ad9dc543e5 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3203,6 +3203,7 @@ static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
 static void wacom_bamboo_pad_pen_event(struct wacom_wac *wacom,
 		unsigned char *data)
 {
+	struct hid_device *pen;
 	unsigned char prefix;
 
 	/*
@@ -3215,13 +3216,12 @@ static void wacom_bamboo_pad_pen_event(struct wacom_wac *wacom,
 	prefix = data[0];
 	data[0] = WACOM_REPORT_BPAD_PEN;
 
-	/*
-	 * actually reroute the event.
-	 * No need to check if wacom->shared->pen is valid, hid_input_report()
-	 * will check for us.
-	 */
-	hid_input_report(wacom->shared->pen, HID_INPUT_REPORT, data,
-			 WACOM_PKGLEN_PENABLED, 1);
+	rcu_read_lock();
+	pen = rcu_dereference(wacom->shared->pen);
+	if (pen)
+		hid_input_report(pen, HID_INPUT_REPORT, data,
+				 WACOM_PKGLEN_PENABLED, 1);
+	rcu_read_unlock();
 
 	data[0] = prefix;
 }
diff --git a/drivers/hid/wacom_wac.h b/drivers/hid/wacom_wac.h
index 957247e6ba1c9..56d54ac53b3da 100644
--- a/drivers/hid/wacom_wac.h
+++ b/drivers/hid/wacom_wac.h
@@ -287,8 +287,8 @@ struct wacom_shared {
 	unsigned touch_max;
 	int type;
 	struct input_dev __rcu *touch_input;
-	struct hid_device *pen;
-	struct hid_device *touch;
+	struct hid_device __rcu *pen;
+	struct hid_device __rcu *touch;
 	bool has_mute_touch_switch;
 	bool is_touch_on;
 };
-- 
2.53.0



