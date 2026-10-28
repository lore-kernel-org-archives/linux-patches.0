Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213451;
	b=Lhuw4+HhYmrMut+AW0TbYeUs4tXzSCJYxmBRBn0jjZGS83lfiWyJs4HBw5RfpSSlUO2O
	 0k/fJXtq7Fmv9M8yXQqrRFNdoUk44IRqsaYaL3CUhBWQETHkc27ziT3L1Hrm2ZvWcZ1IK
	 BmeOWKrRQFBSoGQAxZPUWT+4yumaLnVII1IrhLFuyBpCdA8DSFY7HQS0NMSqtaUxGxJ09
	 gQyatsBM7rc9x+esNtsQuS57BWbpVDukmtxqkVD/gG3v/8gMcWh8wcek3D+l89Vzv6tls
	 kYtRmS3Rphiqu+SJvZ6RhUc79Fd27XO76K2Y7RHbSzNwfThUvaiGX6/XQGg+XxKYkbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Aye2kPzTl74pUpHo61oxRCnKBKGDBN1eenEZnROTLWI=;
	b=G0/IeR3fuJug6ZSWBM39xKVAMlbM0JNs+oXTQ8cSIdSXniL38aG78i8Vbr7/aTILFOzd
	 8BzEfF6yQAiNnF6X8Ca+OCSPOIKsuDQl2uD2jBWQ+ngJoKbqMhFvIsViVwyljNkcwJW77
	 kxnETbhR7NSPF99Pk5lD+MaOycVK7xp49fBGJlvX5FycabNjbUctbO1kPXQT7Zt8fIU2d
	 FxzdPUCdT3V73nHp3IFxAb60C4rfTGZMviZy95aJoankYCnjZeG9dxG91li9y0cbvAlPR
	 zHUGP/b6T6jqqWlgOStH0smc30H6OZgo8j+J9EovjGmbUcZ8IxQllY+GUHK3U4oNwfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pIl3cWm8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC35B606A31D;
	Wed, 28 Oct 2026 18:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pIl3cWm8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08B291F01825;
	Wed, 28 Oct 2026 18:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213450;
	bh=Aye2kPzTl74pUpHo61oxRCnKBKGDBN1eenEZnROTLWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIl3cWm8zE84NW0Wf7O5/8IsSY/yDjri+m9e4GhYoyirtUE7muwNRm1AUyPOqpk5K
	 GJ1yrKdzHJjKFyAdky9KnYxvj2g6ogm4lu3mwqW8PUiTN710OjsKl19Nk3F5C1qwwE
	 w1yLIO9yZXuQsXh1M6FEi9Sg7wMIzmv3FBvLMBu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0510/1887] HID: steam: Clean up locking
Date: Wed, 28 Oct 2026 17:43:26 +0100
Message-ID: <20261028170510.916321405@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vicki Pfau <vi@endrift.com>

[ Upstream commit de1d341b9b3ec9655f31fb8b44f784cca5e670ad ]

This cleans up several issues with locking behavior, including RCU accesses
not being guarded behind a lock.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Adapt to steam->mutex and omit Steam Deck sensors, mode_switch,
      rumble_work, coalesce_rumble_work and Ibex changes as
      691ead124a0c, e133dc99fc07, a0fbd9437d7d, 1d4549fd1115,
      fcfa7db89f7a and 0a80b4e8ec6a are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 59 ++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 22 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index aa001a293a361..bbc150167a7f1 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -114,6 +114,7 @@ struct steam_device {
 	spinlock_t lock;
 	struct hid_device *hdev, *client_hdev;
 	struct mutex mutex;
+	struct mutex registration_mutex;
 	unsigned long client_opened;
 	struct input_dev __rcu *input;
 	unsigned long quirks;
@@ -294,22 +295,30 @@ static void steam_set_lizard_mode(struct steam_device *steam, bool enable)
 static int steam_input_open(struct input_dev *dev)
 {
 	struct steam_device *steam = input_get_drvdata(dev);
+	unsigned long flags;
+	bool client_opened;
 
-	mutex_lock(&steam->mutex);
-	if (!steam->client_opened && lizard_mode)
+	spin_lock_irqsave(&steam->lock, flags);
+	client_opened = steam->client_opened;
+	spin_unlock_irqrestore(&steam->lock, flags);
+	guard(mutex)(&steam->mutex);
+	if (!client_opened && lizard_mode)
 		steam_set_lizard_mode(steam, false);
-	mutex_unlock(&steam->mutex);
 	return 0;
 }
 
 static void steam_input_close(struct input_dev *dev)
 {
 	struct steam_device *steam = input_get_drvdata(dev);
+	unsigned long flags;
+	bool client_opened;
 
-	mutex_lock(&steam->mutex);
-	if (!steam->client_opened && lizard_mode)
+	spin_lock_irqsave(&steam->lock, flags);
+	client_opened = steam->client_opened;
+	spin_unlock_irqrestore(&steam->lock, flags);
+	guard(mutex)(&steam->mutex);
+	if (!client_opened && lizard_mode)
 		steam_set_lizard_mode(steam, true);
-	mutex_unlock(&steam->mutex);
 }
 
 static enum power_supply_property steam_battery_props[] = {
@@ -513,40 +522,43 @@ static int steam_register(struct steam_device *steam)
 {
 	int ret;
 
+	mutex_lock(&steam->registration_mutex);
 	/*
 	 * This function can be called several times in a row with the
 	 * wireless adaptor, without steam_unregister() between them, because
 	 * another client send a get_connection_status command, for example.
 	 * The battery and serial number are set just once per device.
 	 */
-	if (steam->registered)
+	if (steam->registered) {
+		mutex_unlock(&steam->registration_mutex);
 		return 0;
+	}
 
+	mutex_lock(&steam->mutex);
 	/*
 	 * Unlikely, but getting the serial could fail, and it is not so
 	 * important, so make up a serial number and go on.
 	 */
-	mutex_lock(&steam->mutex);
 	if (steam_get_serial(steam) < 0 || !steam->serial_no[0])
 		strscpy(steam->serial_no, "XXXXXXXXXX",
 				sizeof(steam->serial_no));
-	mutex_unlock(&steam->mutex);
 
 	hid_info(steam->hdev, "Steam Controller '%s' connected",
 			steam->serial_no);
 
+	steam_set_lizard_mode(steam, lizard_mode);
+	mutex_unlock(&steam->mutex);
+
 	/* ignore battery errors, we can live without it */
 	if (steam->quirks & STEAM_QUIRK_WIRELESS)
 		steam_battery_register(steam);
 
-	mutex_lock(&steam->mutex);
-	steam_set_lizard_mode(steam, lizard_mode);
-	mutex_unlock(&steam->mutex);
 	ret = steam_input_register(steam);
 	if (ret != 0)
 		goto steam_register_input_fail;
 
 	steam->registered = true;
+	mutex_unlock(&steam->registration_mutex);
 	mutex_lock(&steam_devices_lock);
 	if (list_empty(&steam->list))
 		list_add(&steam->list, &steam_devices);
@@ -555,6 +567,7 @@ static int steam_register(struct steam_device *steam)
 
 steam_register_input_fail:
 	steam_battery_unregister(steam);
+	mutex_unlock(&steam->registration_mutex);
 	return ret;
 }
 
@@ -565,9 +578,11 @@ static void steam_unregister(struct steam_device *steam)
 
 	hid_info(steam->hdev, "Steam Controller '%s' disconnected",
 			steam->serial_no);
+	mutex_lock(&steam->registration_mutex);
 	steam->registered = false;
 	steam_battery_unregister(steam);
 	steam_input_unregister(steam);
+	mutex_unlock(&steam->registration_mutex);
 	mutex_lock(&steam_devices_lock);
 	list_del_init(&steam->list);
 	mutex_unlock(&steam_devices_lock);
@@ -745,6 +760,7 @@ static int steam_probe(struct hid_device *hdev,
 	hid_set_drvdata(hdev, steam);
 	spin_lock_init(&steam->lock);
 	mutex_init(&steam->mutex);
+	mutex_init(&steam->registration_mutex);
 	steam->quirks = id->driver_data;
 	INIT_WORK(&steam->work_connect, steam_work_connect_cb);
 	INIT_LIST_HEAD(&steam->list);
@@ -835,13 +851,10 @@ static void steam_remove(struct hid_device *hdev)
 
 static void steam_do_connect_event(struct steam_device *steam, bool connected)
 {
-	unsigned long flags;
 	bool changed;
 
-	spin_lock_irqsave(&steam->lock, flags);
 	changed = steam->connected != connected;
 	steam->connected = connected;
-	spin_unlock_irqrestore(&steam->lock, flags);
 
 	if (changed && schedule_work(&steam->work_connect) == 0)
 		dbg_hid("%s: connected=%d event already queued\n",
@@ -1008,8 +1021,6 @@ static void steam_do_input_event(struct steam_device *steam,
 static void steam_do_battery_event(struct steam_device *steam,
 		struct power_supply *battery, u8 *data)
 {
-	unsigned long flags;
-
 	s16 volts = steam_le16(data + 12);
 	u8 batt = data[14];
 
@@ -1017,10 +1028,8 @@ static void steam_do_battery_event(struct steam_device *steam,
 	rcu_read_lock();
 	battery = rcu_dereference(steam->battery);
 	if (likely(battery)) {
-		spin_lock_irqsave(&steam->lock, flags);
 		steam->voltage = volts;
 		steam->battery_charge = batt;
-		spin_unlock_irqrestore(&steam->lock, flags);
 		power_supply_changed(battery);
 	}
 	rcu_read_unlock();
@@ -1037,6 +1046,7 @@ static int steam_raw_event(struct hid_device *hdev,
 	if (!steam)
 		return 0;
 
+	guard(spinlock_irqsave)(&steam->lock);
 	if (steam->client_opened)
 		hid_input_report(steam->client_hdev, HID_FEATURE_REPORT,
 				data, size, 0);
@@ -1108,6 +1118,8 @@ static int steam_param_set_lizard_mode(const char *val,
 {
 	struct steam_device *steam;
 	int ret;
+	bool client_opened;
+	unsigned long flags;
 
 	ret = param_set_bool(val, kp);
 	if (ret)
@@ -1115,10 +1127,13 @@ static int steam_param_set_lizard_mode(const char *val,
 
 	mutex_lock(&steam_devices_lock);
 	list_for_each_entry(steam, &steam_devices, list) {
-		mutex_lock(&steam->mutex);
-		if (!steam->client_opened)
+		spin_lock_irqsave(&steam->lock, flags);
+		client_opened = steam->client_opened;
+		spin_unlock_irqrestore(&steam->lock, flags);
+		if (!client_opened) {
+			guard(mutex)(&steam->mutex);
 			steam_set_lizard_mode(steam, lizard_mode);
-		mutex_unlock(&steam->mutex);
+		}
 	}
 	mutex_unlock(&steam_devices_lock);
 	return 0;
-- 
2.53.0



