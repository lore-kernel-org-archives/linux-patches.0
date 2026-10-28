Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213448;
	b=AW75b4QWTFyk7Y+6Omv0EH86Zzl+AcHiowlqZCvbhIMjP3Xg1lmWSac2x+62e+R5vUv2
	 PIGfvJYYZHqdUS73tlxEUVYVdOUDohC9G/I+ow6tHbuogW2zTw20hAgReFBa52XVJitHx
	 9QCnweSgtUYcZXEF5Q7+VM1cvxEW6W9aUSGNYzikAKgLaPzwmHTs1Pccia2yqoynzaWVP
	 7Q6zvFS0m1i1qoJznRnzZdDn6tS5zYMJvP0b3n+Hl2XnE/lj8ST/LmMEp5PnLPjRL86Bg
	 wGTpfL6/sjooySt4+qzPKqC7adARCP3Qi/fyMKv6KvA81Ud3QERAWHREU46j7dVkHug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213448;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CN2NWLMPApW2NuUYNKW7+XyIZ/Edl2Z0RexujKoe/mA=;
	b=DUnZk8J4IQf/se06fvAlw5kJi/lOCbAVsOb6rQaIM8/+cpUR5g6kl1MzR5wVmziE/XzS
	 9EVOk/SJatHxzc5KJ800mQJsBQThew32tQJOZJe5wScFpdbu5umoIHN9coHXU1Z9a+REU
	 J19t9GSilsPR67q4zmRP7CtukqjyAl+k387lxTfH/tsei5VQgWxhF/qAXlRHql9/yTYE4
	 hP8mBu36pxX1CP6cIClqh8xRn41ydmItSXWgnzb21oBqDE+RQgF9G4w9loBiT521VwUmv
	 zz/siGHga8GuGNFwvxX2q3p1cpcvr5fU/zWeWTSgq6As2aQFgx09e7sxlbJcQL8OjwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMpgrYAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DD8606A321;
	Wed, 28 Oct 2026 18:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cMpgrYAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FAAB1F031E5;
	Wed, 28 Oct 2026 18:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213447;
	bh=CN2NWLMPApW2NuUYNKW7+XyIZ/Edl2Z0RexujKoe/mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cMpgrYAjP1W74fU6Wq3Uf05uIACF/kQ9E4gDuzJBujJZZIjEXdwcAs4DalWStGfr6
	 Jfq4+68aiI7NDIN1iyZs2jqn0RV+VO3bSl7lZ2pGbcMGoJRgnpF72tGP0p4MHUhhBb
	 Wu8vWEj2M6B2EmMVzXac6N4ht+RrRZpYCoEafE5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vicki Pfau <vi@endrift.com>,
	Jiri Kosina <jkosina@suse.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0509/1887] HID: steam: Refactor registration
Date: Wed, 28 Oct 2026 17:43:25 +0100
Message-ID: <20261028170510.892043348@linuxfoundation.org>
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

[ Upstream commit 6f9b740c31ba7e061b2ebb330d9a3d63f1358f29 ]

This refactors and simplifies the registration/unregistration flow. Since
we now only perform registration when the client isn't opened anymore, the
logic for handling that can be removed, and the rest of the function
streamlined.

We also remove the previous assumption that we have a serial number to show
we're registered, replacing it with a single purpose boolean.

In a previous refactor the code for unregistering a battery if later
registration steps failed was accidentally left out. As a result, a
lingering power_supply object could get left over after the steam object
was torn down. This is also fixed here.

Signed-off-by: Vicki Pfau <vi@endrift.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
[Lee: Omit sensors, steam_get_attributes(), rumble_work,
      coalesce_rumble_work and mode_switch changes as e133dc99fc07,
      a0fbd9437d7d and 1d4549fd1115 are not present]
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-steam.c | 70 ++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 39 deletions(-)

diff --git a/drivers/hid/hid-steam.c b/drivers/hid/hid-steam.c
index 0e5fba060c913..aa001a293a361 100644
--- a/drivers/hid/hid-steam.c
+++ b/drivers/hid/hid-steam.c
@@ -119,6 +119,7 @@ struct steam_device {
 	unsigned long quirks;
 	struct work_struct work_connect;
 	bool connected;
+	bool registered;
 	char serial_no[STEAM_SERIAL_LEN + 1];
 	struct power_supply_desc battery_desc;
 	struct power_supply __rcu *battery;
@@ -511,9 +512,6 @@ static void steam_battery_unregister(struct steam_device *steam)
 static int steam_register(struct steam_device *steam)
 {
 	int ret;
-	unsigned long client_opened;
-	unsigned long flags;
-	bool do_add;
 
 	/*
 	 * This function can be called several times in a row with the
@@ -521,59 +519,53 @@ static int steam_register(struct steam_device *steam)
 	 * another client send a get_connection_status command, for example.
 	 * The battery and serial number are set just once per device.
 	 */
-	if (!steam->serial_no[0]) {
-		/*
-		 * Unlikely, but getting the serial could fail, and it is not so
-		 * important, so make up a serial number and go on.
-		 */
-		mutex_lock(&steam->mutex);
-		if (steam_get_serial(steam) < 0)
-			strscpy(steam->serial_no, "XXXXXXXXXX",
-					sizeof(steam->serial_no));
-		mutex_unlock(&steam->mutex);
-
-		hid_info(steam->hdev, "Steam Controller '%s' connected",
-				steam->serial_no);
+	if (steam->registered)
+		return 0;
 
-		/* ignore battery errors, we can live without it */
-		if (steam->quirks & STEAM_QUIRK_WIRELESS)
-			steam_battery_register(steam);
+	/*
+	 * Unlikely, but getting the serial could fail, and it is not so
+	 * important, so make up a serial number and go on.
+	 */
+	mutex_lock(&steam->mutex);
+	if (steam_get_serial(steam) < 0 || !steam->serial_no[0])
+		strscpy(steam->serial_no, "XXXXXXXXXX",
+				sizeof(steam->serial_no));
+	mutex_unlock(&steam->mutex);
 
-		do_add = true;
-	}
+	hid_info(steam->hdev, "Steam Controller '%s' connected",
+			steam->serial_no);
 
-	spin_lock_irqsave(&steam->lock, flags);
-	client_opened = steam->client_opened;
-	spin_unlock_irqrestore(&steam->lock, flags);
+	/* ignore battery errors, we can live without it */
+	if (steam->quirks & STEAM_QUIRK_WIRELESS)
+		steam_battery_register(steam);
 
-	if (!client_opened) {
-		mutex_lock(&steam->mutex);
-		steam_set_lizard_mode(steam, lizard_mode);
-		mutex_unlock(&steam->mutex);
-		ret = steam_input_register(steam);
-		if (ret != 0)
-			goto steam_register_input_fail;
-	}
+	mutex_lock(&steam->mutex);
+	steam_set_lizard_mode(steam, lizard_mode);
+	mutex_unlock(&steam->mutex);
+	ret = steam_input_register(steam);
+	if (ret != 0)
+		goto steam_register_input_fail;
 
-	if (do_add) {
-		mutex_lock(&steam_devices_lock);
-		if (list_empty(&steam->list))
-			list_add(&steam->list, &steam_devices);
-		mutex_unlock(&steam_devices_lock);
-	}
+	steam->registered = true;
+	mutex_lock(&steam_devices_lock);
+	if (list_empty(&steam->list))
+		list_add(&steam->list, &steam_devices);
+	mutex_unlock(&steam_devices_lock);
 	return 0;
 
 steam_register_input_fail:
+	steam_battery_unregister(steam);
 	return ret;
 }
 
 static void steam_unregister(struct steam_device *steam)
 {
-	if (!steam->serial_no[0])
+	if (!steam->registered)
 		return;
 
 	hid_info(steam->hdev, "Steam Controller '%s' disconnected",
 			steam->serial_no);
+	steam->registered = false;
 	steam_battery_unregister(steam);
 	steam_input_unregister(steam);
 	mutex_lock(&steam_devices_lock);
-- 
2.53.0



