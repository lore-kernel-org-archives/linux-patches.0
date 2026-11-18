Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031913;
	b=aBth2MwY6cTc1I3ic321jUvdBYNSs/6xzMLiqJxSb3BbIGHTdoQH/7DrkE71Zj0+PfkI
	 /wWGu3lra1qjSX6D5S4lsHyjoailMXBBuxYTXc2cgoRqE74JUACUFOFWDSdR0p5/m077O
	 w4EHRvRwJVF1XmqZW++Pr1eHd5JOjYvSAcufq/7zQpUOhrUhTCmzej0j+SLfE5pGa/NKj
	 FY7kZHClzIIDGbgIDEbpm9YD3QPfmnat/7mCffTsrbTa7s3tGNUxToKPgJEg6o93a5zKJ
	 Snx86WZXbxUeBRmsO/zzgGaJ+BMvIzBvVOt0fMHGDVoyzVLcNksQS+EHjNZGUWOMb9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ReS4g8na9ScrQI2C7lH3VlNh3yeU7RvpcrtiJrQlzWw=;
	b=hgrmyBf88tHS2eG8JOaLaOWIS74us69N/qxDTGw6u2CR6bZ0mdrIDYrKZFM8qBgEDaaQ
	 5+m/VdzdpGHEAf3Lz+JSbPA73BMZFKdQuzZw43TPPeJFSexWqYuJs8S3GLAcJL/AWcG/Z
	 ba+AnHsX2ZS4IRTIEGdpEYPxLUvjteG/XoQUMGL6n3u9znZWJUt+3e9CoLgeiSuaJHpE0
	 +2aGKWlonjpekZzR2TnvSsD2rcnzdQo1q2KNDD6Q0pDuIBnrAfs2G6ueqh+sCNWv/fW7R
	 ojleR2zNLcpZy2tHxIHjq8Y9uTHlscM89muRVEmXOiv5zCKFglLU+usW1XGY/fjS/3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5YLGXk5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7A33606A320;
	Wed, 18 Nov 2026 19:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S5YLGXk5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2868B1F000C4;
	Wed, 18 Nov 2026 19:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031913;
	bh=ReS4g8na9ScrQI2C7lH3VlNh3yeU7RvpcrtiJrQlzWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5YLGXk5ovLqQZYpB2kDion8ZlrMBac7oqXRjknfa4mOisGkOPHJPVdPGahy5yRle
	 GFrJe5obhoEbfoaOZnV4dSfkVurDHuUnv9xQpE95bS3QIHjbXzq9e+Qpg/GR3/A/9/
	 ORgUGtyNMNyYct+yEXbdq6V6rymXK5J8ulef184E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1225/1756] Bluetooth: MGMT: Fix advertising instances with Global Advertising
Date: Wed, 18 Nov 2026 15:55:52 +0100
Message-ID: <20261118150058.591542455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4d3132a50ef05..3b9c2bd1c5191 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -124,6 +124,7 @@ int hci_disable_per_advertising_sync(struct hci_dev *hdev, u8 instance);
 int hci_remove_advertising_sync(struct hci_dev *hdev, struct sock *sk,
 				u8 instance, bool force);
 int hci_disable_advertising_sync(struct hci_dev *hdev);
+int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev);
 int hci_clear_adv_instance_sync(struct hci_dev *hdev, struct sock *sk,
 				u8 instance, bool force);
 int hci_update_passive_scan_sync(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0716b1a9ddc3f..849d4c2556cc8 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1620,15 +1620,22 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
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
index e0bcb000107c5..da3ef487b2feb 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1184,7 +1184,7 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
 	return 0;
 }
 
-static int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
+int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_ext_adv_enable *cp;
 	struct hci_cp_ext_adv_set *set;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index fbcaf27f4d7be..d2fe93d0b3b1e 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6536,7 +6536,12 @@ static void set_advertising_complete(struct hci_dev *hdev, void *data, int err)
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
@@ -6556,6 +6561,34 @@ static void set_advertising_complete(struct hci_dev *hdev, void *data, int err)
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
@@ -6611,6 +6644,11 @@ static int set_adv_sync(struct hci_dev *hdev, void *data)
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
@@ -8896,6 +8934,21 @@ static bool adv_busy(struct hci_dev *hdev)
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
@@ -9057,12 +9110,12 @@ static int add_advertising(struct sock *sk, struct hci_dev *hdev,
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
@@ -9237,8 +9290,11 @@ static int add_ext_adv_params(struct sock *sk, struct hci_dev *hdev,
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
@@ -9388,11 +9444,12 @@ static int add_ext_adv_data(struct sock *sk, struct hci_dev *hdev, void *data,
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
@@ -9468,7 +9525,11 @@ static int remove_advertising_sync(struct hci_dev *hdev, void *data)
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



