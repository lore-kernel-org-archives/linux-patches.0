Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213442;
	b=1f1zDHmSbfq/DBBalj9ZdwO6TQkQx0nxmFIvLzefyOY3LHT92I66uunCa1jZcGBKV0yE
	 ayPe053wdNM+zCl2+O8l8ENnMooBCZhXeElXhIEVBtT8JZWXbkbMxzYYp69n3ryPQaQ8d
	 VzkNSZKelq8GFcc7Vtw2K+0Xb7hxhrglGFBuslIBCtyoJ8PJkw/3qxzIPBc5NQnWornlD
	 EBdxDOiJ3vOkJYBhF+eXplRMY16I77lnPz3d32fb1ltEM7fRKfzafSIh7AVp6egmvM2M7
	 t6p4B1HPCuaiMqyYBuJTbL23zW1Zwr4w0ONj4Cq2ZcAhw/4ObNSdKtECkb5mHlKkUvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213442;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dgYq4gT+NYhZXqbTENscget/hQv/wTLwPk55ZTZTYSI=;
	b=KU1EJBQACV3yfybEtdN0okh1l0K/rqZiBJpSfeVjYtQpWCZTlg3mdBqPtyqIijWpVM5s
	 eq+/KLRytaGhR1CgT3AQ79zjQUfC89FTS46OFKnHDHcpppgo/ZmyLdQFcm42qQc+pcPiC
	 jKsYegaMyigNet2g0iudyip8xy7zS87qs3SCbjVgWi9ZgNd85E0Q6IK4WjqushzOi5jWI
	 G0EPXSjAU8nvCkxwD3vJVwqKOaNzVhjy62pSEvmmx3uFxHtVa+ITfrxlHbZj/6MJ1Fa8a
	 ZPCKv7gBusgGkD3xpfUhLiN2pAqTYFprESQaO4h1aO6Q6wsk4G2zzDGLtKcA7m6wKlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMwwCIgm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52F41606A32C;
	Wed, 28 Oct 2026 18:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zMwwCIgm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A131F031E0;
	Wed, 28 Oct 2026 18:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213442;
	bh=dgYq4gT+NYhZXqbTENscget/hQv/wTLwPk55ZTZTYSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zMwwCIgmNI+8FvY3SAojTprKB6GKz8WYYlOf+RQcA8+c9/SJQLSui+uB+8gh7YVsz
	 AQRBi1FvU+rzdk4h8Lh7NwSCPDtNwaNex9NVZqEHBbOgetQFCMtrQ5rW+7ua1kX9SN
	 vdwGYLsWMFOHfGZi9FPLN8TAblZWs+cRHAhcG3pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0507/1887] HID: steam: Fully unregister controller when hidraw is opened
Date: Wed, 28 Oct 2026 17:43:23 +0100
Message-ID: <20261028170510.844217228@linuxfoundation.org>
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

[ Upstream commit cd33a91d37eb4d7c6ce56aa7f4688066309808eb ]

To avoid conflicts between anything touching the hidraw and the driver we
had previously detached the evdev nodes when the hidraw is opened. However,
this isn't sufficient to avoid FEATURE reports from conflicting, so we
change to fully unregistering the controller internally, leaving only the
hidraw active until it's closed.

This also unifies the unregister and connect callbacks, as now the logic
between these two callbacks is identical.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Convert steam_client_ll_open() and steam_client_ll_close() to
      schedule work_connect directly and omit sensors, rumble_work,
      mode_switch and unregister_work changes as e133dc99fc07,
      e1147961b214 and 1d4549fd1115 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 78 ++++++++++++++++++++++-------------------
 1 file changed, 42 insertions(+), 36 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 4a0a13b0ae62f..e8f28c59a3033 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -380,6 +380,7 @@ static int steam_battery_register(struct steam_device *steam)
 			&steam->battery_desc, &battery_cfg);
 	if (IS_ERR(battery)) {
 		ret = PTR_ERR(battery);
+		devm_kfree(&steam->hdev->dev, steam->battery_desc.name);
 		hid_err(steam->hdev,
 				"%s:power_supply_register failed with error %d\n",
 				__func__, ret);
@@ -504,12 +505,15 @@ static void steam_battery_unregister(struct steam_device *steam)
 	RCU_INIT_POINTER(steam->battery, NULL);
 	synchronize_rcu();
 	power_supply_unregister(battery);
+	devm_kfree(&steam->hdev->dev, steam->battery_desc.name);
 }
 
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
 	unsigned long client_opened;
+	unsigned long flags;
+	bool do_add;
 
 	/*
 	 * This function can be called several times in a row with the
@@ -535,38 +539,47 @@ static int steam_register(struct steam_device *steam)
 		if (steam->quirks & STEAM_QUIRK_WIRELESS)
 			steam_battery_register(steam);
 
-		mutex_lock(&steam_devices_lock);
-		if (list_empty(&steam->list))
-			list_add(&steam->list, &steam_devices);
-		mutex_unlock(&steam_devices_lock);
+		do_add = true;
 	}
 
-	mutex_lock(&steam->mutex);
+	spin_lock_irqsave(&steam->lock, flags);
 	client_opened = steam->client_opened;
-	if (!client_opened)
-		steam_set_lizard_mode(steam, lizard_mode);
-	mutex_unlock(&steam->mutex);
+	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (!client_opened)
+	if (!client_opened) {
+		mutex_lock(&steam->mutex);
+		steam_set_lizard_mode(steam, lizard_mode);
+		mutex_unlock(&steam->mutex);
 		ret = steam_input_register(steam);
-	else
-		ret = 0;
+		if (ret != 0)
+			goto steam_register_input_fail;
+	}
+
+	if (do_add) {
+		mutex_lock(&steam_devices_lock);
+		if (list_empty(&steam->list))
+			list_add(&steam->list, &steam_devices);
+		mutex_unlock(&steam_devices_lock);
+	}
+	return 0;
 
+steam_register_input_fail:
 	return ret;
 }
 
 static void steam_unregister(struct steam_device *steam)
 {
+	if (!steam->serial_no[0])
+		return;
+
+	hid_info(steam->hdev, "Steam Controller '%s' disconnected",
+			steam->serial_no);
 	steam_battery_unregister(steam);
 	steam_input_unregister(steam);
-	if (steam->serial_no[0]) {
-		hid_info(steam->hdev, "Steam Controller '%s' disconnected",
-				steam->serial_no);
-		mutex_lock(&steam_devices_lock);
-		list_del_init(&steam->list);
-		mutex_unlock(&steam_devices_lock);
-		steam->serial_no[0] = 0;
-	}
+	mutex_lock(&steam_devices_lock);
+	list_del_init(&steam->list);
+	mutex_unlock(&steam_devices_lock);
+	steam->serial_no[0] = 0;
 }
 
 static void steam_work_connect_cb(struct work_struct *work)
@@ -575,19 +588,20 @@ static void steam_work_connect_cb(struct work_struct *work)
 							work_connect);
 	unsigned long flags;
 	bool connected;
+	bool opened;
 	int ret;
 
 	spin_lock_irqsave(&steam->lock, flags);
+	opened = steam->client_opened;
 	connected = steam->connected;
 	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (connected) {
+	if (connected && !opened) {
 		ret = steam_register(steam);
-		if (ret) {
+		if (ret)
 			hid_err(steam->hdev,
 				"%s:steam_register failed with error %d\n",
 				__func__, ret);
-		}
 	} else {
 		steam_unregister(steam);
 	}
@@ -632,12 +646,13 @@ static void steam_client_ll_stop(struct hid_device *hdev)
 static int steam_client_ll_open(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
+	unsigned long flags;
 
-	mutex_lock(&steam->mutex);
+	spin_lock_irqsave(&steam->lock, flags);
 	steam->client_opened++;
-	mutex_unlock(&steam->mutex);
+	spin_unlock_irqrestore(&steam->lock, flags);
 
-	steam_input_unregister(steam);
+	schedule_work(&steam->work_connect);
 
 	return 0;
 }
@@ -645,22 +660,13 @@ static int steam_client_ll_open(struct hid_device *hdev)
 static void steam_client_ll_close(struct hid_device *hdev)
 {
 	struct steam_device *steam = hdev->driver_data;
-
 	unsigned long flags;
-	bool connected;
 
 	spin_lock_irqsave(&steam->lock, flags);
-	connected = steam->connected;
-	spin_unlock_irqrestore(&steam->lock, flags);
-
-	mutex_lock(&steam->mutex);
 	steam->client_opened--;
-	if (connected && !steam->client_opened)
-		steam_set_lizard_mode(steam, lizard_mode);
-	mutex_unlock(&steam->mutex);
+	spin_unlock_irqrestore(&steam->lock, flags);
 
-	if (connected && !steam->client_opened)
-		steam_input_register(steam);
+	schedule_work(&steam->work_connect);
 }
 
 static int steam_client_ll_raw_request(struct hid_device *hdev,
-- 
2.53.0



