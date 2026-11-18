Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053615;
	b=lhCbC167es3T33B8a+cZJomfmt29FfNEkbWkODGoPywQ2kFO7Aq5lSa9oQv5FxQ65buX
	 wV9weDVeIANe/5qDofEK0US/nPfpDZ+s1Rh6KI4Lhwfy+peadQNwc/v2RaKUQyWIIxQmy
	 h9JTfMJFqSNJ5ldGJyV769nJq5wPq6AYXFxrZgVmSMI+7w7IfpcIl8WtXGvuDnzKQlX7q
	 XhFFGfj4pLY/qzYjvOF6FtJwHH5wltj+UlB1AId7XeVZUODA+ugms9Zuvmam9DUqQcIx6
	 Tf1QfZb4QcAdleVLqG3bbkc8+JbRh/8sdWDjPcn1U6ie3ozrElD2rd3qf++sufZkuZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XmoYdyWgM3o1K6W+yz6WgKoSi6yGM8bd0wPAs2KTLLE=;
	b=0s3odmFCpwi7tN2yhEtw8mhOoLiAFaFrEodWrKd8ablxENyBljkegzU2YLuEzp7KVm2d
	 VX99WzJoVnN4F1YSE9xjwt0pJ6FZis8rTJWsR4+7mDN5CEdIWagnQjVkt5s81IGa6a/Cm
	 mTNlBjmWc0I4k5Ody2ooOCCALSNtNZUccedXX7xuUN99/vrDaBuu7DXtnZYerEk9EFvcA
	 Mr31zOkno9+cbZe2c7g9ktUE/yAOxgOLoGya+e3h0InuX4aAYRr1t1TE39BL+CyJPHHJx
	 OMSz6IhaunclifYkP3e9Pqh6GH+/EwVUGk6A5vA/wlEaeQ0ELlkAO+gWWoNBBBVm9LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/X9z8IC";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE5D606A320;
	Thu, 19 Nov 2026 02:00:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/X9z8IC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBB51F000C4;
	Thu, 19 Nov 2026 02:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053615;
	bh=XmoYdyWgM3o1K6W+yz6WgKoSi6yGM8bd0wPAs2KTLLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/X9z8ICJ+h0wwfl9LBvYnSYQY/s2YNmX88M1K7Dcv5mIwZbLzl5hAfhsZJHrCRqN
	 b6Tf6XhCs5L1F/41z2rGl73bkF+tO/m1D7zP+h98B3C+MfReRGk5nB7s+mxKOATylt
	 zzUxlwxrtx89OIrvB6taYKjDZVw+W10ZCFTfkPdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lee Jones <lee@kernel.org>,
	Ping Cheng <ping.cheng@wacom.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0941/2214] HID: wacom: Fix Use-After-Free in wacom_bamboo_pad
Date: Wed, 18 Nov 2026 15:43:37 +0100
Message-ID: <20261118150049.999615480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 149d3546367f1..39c126bb3f2d4 100644
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
 
@@ -2356,14 +2363,17 @@ static void wacom_set_shared_values(struct wacom_wac *wacom_wac)
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
 
@@ -2379,8 +2389,7 @@ static bool wacom_sibling_pending(struct wacom *wacom)
 		return false;
 
 	if (wacom->wacom_wac.shared) {
-		/* Pairs with smp_store_release() in wacom_set_shared_values() */
-		if (smp_load_acquire(&wacom->wacom_wac.shared->pen))
+		if (rcu_access_pointer(wacom->wacom_wac.shared->pen))
 			return false;
 	}
 
@@ -2850,16 +2859,19 @@ static void wacom_mode_change_work(struct work_struct *work)
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
index 6549439f32031..965f9fdc140a6 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3235,6 +3235,7 @@ static int wacom_bpt_irq(struct wacom_wac *wacom, size_t len)
 static void wacom_bamboo_pad_pen_event(struct wacom_wac *wacom,
 		unsigned char *data)
 {
+	struct hid_device *pen;
 	unsigned char prefix;
 
 	/*
@@ -3247,13 +3248,12 @@ static void wacom_bamboo_pad_pen_event(struct wacom_wac *wacom,
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
index 4f9ef7b21de3f..4d75accb48b4f 100644
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



