Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020261;
	b=J0d7WmQ7o09GE1PIaHosVWQGi+u7H4lBIn/S206rILFLNYPfV6ligeTcVK2Bz4fWAQbI
	 A6f8MZH7yMrZYJ8TX9EiU8dftq0uBGCTyzxTWzJwU9wUVs2BHy8M5/aS9AF4xVFQKvf31
	 AAi7fDnSr/7akfG1OeLjlimVxfBqJlW4qEW9hGStNo155jEmnWSYfdKtg1cEPh+g+F+Y0
	 HqMIc4A6LXOE6IZBwvuBCHny0sY0fsTUWb4VuQ8VEzsVsFTUhAOb7dZdA0rSV/EThsrXm
	 TpNYBo+vJ7fj+e4oGjyFu/vb2evYixG2+lwu1xFP5rST/SAHQlr9mu3nJy2Ll7y84HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7fICGaCj/STWthz2ZkqmTeKBUOb+LmpPSwY0qFOIaDA=;
	b=OPXZ9PA6bhopsZrSno9juTeAH6+9wTQD1dzX8D05Mnt60iEQEGqKL0S/aN3YTNe2RyUA
	 3+18KuccnbI1/+uyY1GGbRYTMHmvytH/zQ1Y83LeYX94z1aVYLnnx+mkfa+0YAzSlypPO
	 JS/ERbc8C2VDHh1PsnT+94d6U0vnVHDlWzYZqlgVT4q0Uk594e6RfC52AI5f3tJsLNWoq
	 EYPY6lV6+lhBO2lVkQpgBMlh7ounxeiO8CggR8IbHEdL4r9MW67o9IzGP39PhheqXlNeB
	 Yhamc7tTLyCDw0ZkWsxHI1fesrHwgAAjQdoI5tRiKoqQ3PEnwbyxhbIzSwpeaWg1zmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T9x1dsIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1772606A333;
	Wed, 18 Nov 2026 16:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T9x1dsIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 572AE1F000C5;
	Wed, 18 Nov 2026 16:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020260;
	bh=7fICGaCj/STWthz2ZkqmTeKBUOb+LmpPSwY0qFOIaDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T9x1dsIs1eX5fZpqwlmwzflkwrFSPggeyGad05vYgd8JnYD8oU3dh9xc7f3uq7U4x
	 gWuKU7jLFxyJh9fosI5YoDFiiw9+s2CnGJ86i5uTsQUMcNQjwCQHnY3RZKR6kWvbom
	 3BO/g7VE0KYCiezxHrOoU3mnAaQqRXh1SYIjjTtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1889/2651] Bluetooth: MGMT: Fix advertising instances with Global Advertising
Date: Wed, 18 Nov 2026 15:52:09 +0100
Message-ID: <20261118150354.894889423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 0ad48c88a2ed3b58164fa771977868503b0abac3 ]

Global Advertising, enabled with MGMT_OP_SET_ADVERTISING, uses instance
0 and with extended advertising it has its own advertising set, but
instances were still being treated as if they shared the same set:

 - Add Advertising and Add Extended Advertising Data would return
   success without ever enabling the instance.
 - Removing the last instance would disable all advertising sets,
   stopping Global Advertising while leaving its setting enabled.
 - Disabling Global Advertising would disable all sets, including
   active instances.

Fix this by only overriding instances that share the advertising set of
Global Advertising, and by tracking HCI_LE_ADV_0 rather than HCI_LE_ADV
to determine the state of Global Advertising.

Fixes: 0d92808024b4 ("Bluetooth: HCI: Fix tracking of advertisement set/instance 0x00")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h |  1 +
 net/bluetooth/hci_event.c        | 11 ++++-
 net/bluetooth/hci_sync.c         |  2 +-
 net/bluetooth/mgmt.c             | 83 +++++++++++++++++++++++++++-----
 4 files changed, 83 insertions(+), 14 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index a6579a8686782..59cb918d1405b 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -122,6 +122,7 @@ int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance);
 int hci_remove_advertising_sync(struct hci_dev *hdev, struct sock *sk,
 				u8 instance, bool force);
 int hci_disable_advertising_sync(struct hci_dev *hdev);
+int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev);
 int hci_clear_adv_instance_sync(struct hci_dev *hdev, struct sock *sk,
 				u8 instance, bool force);
 int hci_update_passive_scan_sync(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 03b805207ab00..7309159a8930a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1664,15 +1664,22 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
 
 			/* If just one instance was disabled check if there are
-			 * any other instance enabled before clearing HCI_LE_ADV
+			 * any other instance enabled, including instance 0,
+			 * before clearing HCI_LE_ADV
 			 */
+			if (hci_dev_test_flag(hdev, HCI_LE_ADV_0))
+				goto unlock;
+
 			list_for_each_entry_safe(adv, n, &hdev->adv_instances,
 						 list) {
 				if (adv->enabled)
 					goto unlock;
 			}
 		} else {
-			/* All instances shall be considered disabled */
+			/* All instances shall be considered disabled, except
+			 * instance 0 whose state is preserved so it can be
+			 * re-enabled by hci_resume_advertising_sync.
+			 */
 			list_for_each_entry_safe(adv, n, &hdev->adv_instances,
 						 list)
 				adv->enabled = false;
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index ea75c823ac522..7219742531124 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1158,7 +1158,7 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
 	return 0;
 }
 
-static int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
+int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_ext_adv_enable *cp;
 	struct hci_cp_ext_adv_set *set;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 251a896babd59..c669c80d74bfb 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6533,7 +6533,12 @@ static void set_advertising_complete(struct hci_dev *hdev, void *data, int err)
 		return;
 	}
 
-	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
+	/* With extended advertising global advertising (instance 0) has its
+	 * own advertising set so only consider its state, other instances may
+	 * still be enabled.
+	 */
+	if (ext_adv_capable(hdev) ? hci_dev_test_flag(hdev, HCI_LE_ADV_0) :
+				    hci_dev_test_flag(hdev, HCI_LE_ADV))
 		hci_dev_set_flag(hdev, HCI_ADVERTISING);
 	else
 		hci_dev_clear_flag(hdev, HCI_ADVERTISING);
@@ -6553,6 +6558,34 @@ static void set_advertising_complete(struct hci_dev *hdev, void *data, int err)
 	    list_empty(&hdev->adv_instances))
 		return;
 
+	/* With extended advertising instances are not overridden by global
+	 * advertising, except the ones sharing its set, so only (re)start the
+	 * instances that are not already enabled.
+	 *
+	 * Lookup instances by identifier while holding hdev->lock since the
+	 * list may change while waiting for the HCI commands to complete.
+	 */
+	if (ext_adv_capable(hdev)) {
+		u16 i;
+
+		for (i = 1; i <= hdev->le_num_of_adv_sets + 1; i++) {
+			bool enabled;
+
+			hci_dev_lock(hdev);
+			adv_instance = hci_find_adv_instance(hdev, i);
+			enabled = !adv_instance || adv_instance->enabled;
+			hci_dev_unlock(hdev);
+
+			if (enabled)
+				continue;
+
+			err = hci_schedule_adv_instance_sync(hdev, i, true);
+			enable_advertising_instance(hdev, err);
+		}
+
+		return;
+	}
+
 	instance = hdev->cur_adv_instance;
 	if (!instance) {
 		adv_instance = list_first_entry_or_null(&hdev->adv_instances,
@@ -6608,6 +6641,11 @@ static int set_adv_sync(struct hci_dev *hdev, void *data)
 			hci_update_scan_rsp_data_sync(hdev, 0x00);
 			hci_enable_advertising_sync(hdev);
 		}
+	} else if (ext_adv_capable(hdev)) {
+		/* Only disable global advertising (instance 0) leaving other
+		 * instances untouched.
+		 */
+		hci_disable_ext_adv_legacy_instance_sync(hdev);
 	} else {
 		hci_disable_advertising_sync(hdev);
 	}
@@ -8939,6 +8977,21 @@ static bool adv_busy(struct hci_dev *hdev)
 	return pending_find(MGMT_OP_SET_LE, hdev);
 }
 
+/* Global advertising, enabled with MGMT_OP_SET_ADVERTISING, uses instance 0
+ * and takes precedence over any instance that would share its advertising
+ * set: with legacy advertising there is only a single set so all instances
+ * are overridden, whereas with extended advertising only an instance using
+ * handle 0x00 is.
+ */
+static bool adv_overridden_by_global(struct hci_dev *hdev,
+				     struct adv_info *adv)
+{
+	if (!hci_dev_test_flag(hdev, HCI_ADVERTISING))
+		return false;
+
+	return !ext_adv_capable(hdev) || !adv->handle;
+}
+
 static void add_adv_complete(struct hci_dev *hdev, struct sock *sk, u8 instance,
 			     int err)
 {
@@ -9100,12 +9153,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
 		schedule_instance = cp->instance;
 	}
 
-	/* If the HCI_ADVERTISING flag is set or the device isn't powered or
-	 * there is no instance to be advertised then we have no HCI
-	 * communication to make. Simply return.
+	/* If the instance is overridden by global advertising or the device
+	 * isn't powered or there is no instance to be advertised then we have
+	 * no HCI communication to make. Simply return.
 	 */
 	if (!hdev_is_powered(hdev) ||
-	    hci_dev_test_flag(hdev, HCI_ADVERTISING) ||
+	    adv_overridden_by_global(hdev, adv) ||
 	    !schedule_instance) {
 		rp.instance = cp->instance;
 		err = mgmt_cmd_complete(sk, hdev->id, MGMT_OP_ADD_ADVERTISING,
@@ -9280,8 +9333,11 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
 		goto unlock;
 	}
 
-	/* Submit request for advertising params if ext adv available */
-	if (ext_adv_capable(hdev)) {
+	/* Submit request for advertising params if ext adv available, unless
+	 * the set is in use by global advertising in which case the params
+	 * will be programmed once the instance is scheduled.
+	 */
+	if (ext_adv_capable(hdev) && !adv_overridden_by_global(hdev, adv)) {
 		cmd = mgmt_pending_new(sk, MGMT_OP_ADD_EXT_ADV_PARAMS, hdev,
 				       data, data_len);
 		if (!cmd) {
@@ -9431,11 +9487,12 @@ static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
 		schedule_instance = cp->instance;
 	}
 
-	/* If the HCI_ADVERTISING flag is set or there is no instance to
-	 * be advertised then we have no HCI communication to make.
+	/* If the instance is overridden by global advertising or there is no
+	 * instance to be advertised then we have no HCI communication to make.
 	 * Simply return.
 	 */
-	if (hci_dev_test_flag(hdev, HCI_ADVERTISING) || !schedule_instance) {
+	if (adv_overridden_by_global(hdev, adv_instance) ||
+	    !schedule_instance) {
 		if (adv_instance->pending) {
 			mgmt_advertising_added(sk, hdev, cp->instance);
 			adv_instance->pending = false;
@@ -9511,7 +9568,11 @@ static int remove_advertising_sync(struct hci_dev *hdev, void *data)
 	if (err)
 		return err;
 
-	if (list_empty(&hdev->adv_instances))
+	/* Don't disable advertising if global advertising (instance 0) is
+	 * enabled since it is not affected by removing instances.
+	 */
+	if (list_empty(&hdev->adv_instances) &&
+	    !hci_dev_test_flag(hdev, HCI_ADVERTISING))
 		err = hci_disable_advertising_sync(hdev);
 
 	return err;
-- 
2.53.0



