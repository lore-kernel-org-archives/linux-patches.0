Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020263;
	b=oDviBhkCe2X31ZTk/VhuG5ol/IKR7jH/OVkWTI+nGkDkbsMzDQswTqb8voa5BXeQ0LL+
	 aHqmXl2MIOQX7AiZdAtcN7yoUfKvxIB8BX3wd1pfsdQr+EP+Mosg2ftvUvU5vjN6C+JF1
	 DrJAoNe9JE2uhkoFZ3jHLvBPCoPk0eiSkwCQ9CyrmVGa54/xq0keVxVzbHV6WbgfoATvB
	 E8rcddiWhk3aXCYk0Pmww+LY8u9pE6AXFkov1+SN6CV4shEKODetS7NOYoDVS6ysS41ir
	 aR3jAIBLfMkdsQimHP4OzZ+buR+xmbXnPKunGptXsG3wbG6bRSTGq7YAiuAxr95tOVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8nxUQGYfkA7EMzMbldCuaEIZjGjCGn8sHsN8+BOpPKM=;
	b=o0EJbC1Z/LhhS+dETP1tTWQ5r/EdU/xJ+eKcHRRU66MwjN9g1vgBR0snOoLpZf7n3o9U
	 eDT5xIKEqiEUuJePN/X/7yyH11zLJg5bOLgDbM6G/JYgwd2KcDlOzkirB0YD18Li3a4vk
	 7DT3rBdR3a95S9ZSvh8eqXwNigFkajjZUE6Fh2wk1xpMRg/4mTyQvXCi3TbVnooHgwwIy
	 kxG2kU6OtRqAMc3YKOSAId6nZNYfJPWMpk+rZo6F0T+FI/G4Ktm8sXJkHBa+nviay+klO
	 fUnrl9NdRWOmxbb7qZCyxDlhtuAoAW6yWxR5HZWJaTveIgB9M5fv8u4IwyXXmFtzu8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAMXI2qF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B5F606A320;
	Wed, 18 Nov 2026 16:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vAMXI2qF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14ED01F000C6;
	Wed, 18 Nov 2026 16:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020263;
	bh=8nxUQGYfkA7EMzMbldCuaEIZjGjCGn8sHsN8+BOpPKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vAMXI2qFIy6shVt8m9fDvX8WRHCXo6dvg4+ih7bMoi2/FPnqnjTR0oGPHPq2vOSSV
	 O82gUnlT2h9dR0wu5n5gCBzXsqp6/taoULkl6XUlds90a3aw44uPHbZCLNpw5/hqAe
	 QxhMoguB5BXmtSOiro3t0riYsSq60MvokkzSVBnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1890/2651] Bluetooth: HCI: Fix tracking of instances sharing handle 0x00
Date: Wed, 18 Nov 2026 15:52:10 +0100
Message-ID: <20261118150354.928997377@linuxfoundation.org>
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

[ Upstream commit 1bfecdbd031711e5205ae78f3b8c296e5a53bc55 ]

When the controller supports a single advertising set, instance 1 uses
handle 0x00 which is the same handle used by instance 0 (Global
Advertising), but hci_cc_le_set_ext_adv_enable would lookup the instance
using the handle as instance identifier, marking instance 0 as
enabled/disabled instead of instance 1, leaving its state out of sync.

Fix this by matching instances by handle and, for handle 0x00, using
hdev->cur_adv_instance, now set when enabling an instance, to determine
which instance owns the set. Also disable the instance sharing the
advertising set of instance 0 before overriding it.

Fixes: e77f43d531af ("Bluetooth: hci_core: Fix not handling hdev->le_num_of_adv_sets=1")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 47 ++++++++++++++++++++++++++++++---------
 net/bluetooth/hci_sync.c  | 35 ++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 12 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 7309159a8930a..c9cf7f27d21b9 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1617,6 +1617,39 @@ static u8 hci_cc_le_set_adv_enable(struct hci_dev *hdev, void *data,
 	return rp->status;
 }
 
+/* Update the enabled state of the instance(s) using the advertising set
+ * identified by handle.
+ *
+ * Instances may share handle 0x00 with instance 0 (Global Advertising), e.g.
+ * when the controller supports a single advertising set, in which case the
+ * set is owned by the instance last enabled (hdev->cur_adv_instance) and any
+ * other instance sharing it shall be considered disabled.
+ */
+static void hci_le_ext_adv_set_enabled(struct hci_dev *hdev, u8 handle,
+				       bool enable)
+{
+	struct adv_info *adv;
+	bool owned = false;
+
+	list_for_each_entry(adv, &hdev->adv_instances, list) {
+		if (adv->handle != handle)
+			continue;
+
+		adv->enabled = enable &&
+			       (handle ||
+				adv->instance == hdev->cur_adv_instance);
+		owned |= adv->enabled;
+	}
+
+	if (handle)
+		return;
+
+	if (enable && !owned)
+		hci_dev_set_flag(hdev, HCI_LE_ADV_0);
+	else
+		hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
+}
+
 static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 				       struct sk_buff *skb)
 {
@@ -1638,18 +1671,13 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	if (cp->num_of_sets)
-		adv = hci_find_adv_instance(hdev, set->handle);
-
 	if (cp->enable) {
 		struct hci_conn *conn;
 
 		hci_dev_set_flag(hdev, HCI_LE_ADV);
 
-		if (adv)
-			adv->enabled = true;
-		else if (!set->handle)
-			hci_dev_set_flag(hdev, HCI_LE_ADV_0);
+		if (cp->num_of_sets)
+			hci_le_ext_adv_set_enabled(hdev, set->handle, true);
 
 		conn = hci_lookup_le_connect(hdev);
 		if (conn)
@@ -1658,10 +1686,7 @@ static u8 hci_cc_le_set_ext_adv_enable(struct hci_dev *hdev, void *data,
 					   conn->conn_timeout);
 	} else {
 		if (cp->num_of_sets) {
-			if (adv)
-				adv->enabled = false;
-			else if (!set->handle)
-				hci_dev_clear_flag(hdev, HCI_LE_ADV_0);
+			hci_le_ext_adv_set_enabled(hdev, set->handle, false);
 
 			/* If just one instance was disabled check if there are
 			 * any other instance enabled, including instance 0,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 7219742531124..1e7ff1414e215 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1158,6 +1158,30 @@ int hci_update_random_address_sync(struct hci_dev *hdev, bool require_privacy,
 	return 0;
 }
 
+/* Check if the advertising set with handle 0x00 is in use, either by instance
+ * 0 or by an instance sharing its advertising set.
+ */
+static bool hci_ext_adv_handle_0_enabled(struct hci_dev *hdev)
+{
+	struct adv_info *adv;
+	bool enabled;
+
+	hci_dev_lock(hdev);
+
+	enabled = hci_dev_test_flag(hdev, HCI_LE_ADV_0);
+
+	list_for_each_entry(adv, &hdev->adv_instances, list) {
+		if (!adv->handle && adv->enabled) {
+			enabled = true;
+			break;
+		}
+	}
+
+	hci_dev_unlock(hdev);
+
+	return enabled;
+}
+
 int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
 {
 	struct hci_cp_le_set_ext_adv_enable *cp;
@@ -1165,7 +1189,7 @@ int hci_disable_ext_adv_legacy_instance_sync(struct hci_dev *hdev)
 	u8 data[sizeof(*cp) + sizeof(*set) * 1];
 	u8 size;
 
-	if (!hci_dev_test_flag(hdev, HCI_LE_ADV_0))
+	if (!hci_ext_adv_handle_0_enabled(hdev))
 		return 0;
 
 	memset(data, 0, sizeof(data));
@@ -1411,6 +1435,9 @@ int hci_setup_ext_adv_instance_sync(struct hci_dev *hdev, u8 instance)
 			return -EINVAL;
 		}
 	} else {
+		/* Disable the advertising set with handle 0x00, including any
+		 * instance sharing it, since it is going to be overridden.
+		 */
 		err = hci_disable_ext_adv_legacy_instance_sync(hdev);
 		if (err)
 			return err;
@@ -1679,6 +1706,12 @@ int hci_enable_ext_advertising_sync(struct hci_dev *hdev, u8 instance)
 		set->duration = cpu_to_le16(duration / 10);
 	}
 
+	/* Track which instance owns the advertising set since the handle
+	 * alone is ambiguous when instances share handle 0x00, see
+	 * hci_cc_le_set_ext_adv_enable.
+	 */
+	hdev->cur_adv_instance = instance;
+
 	return __hci_cmd_sync_status(hdev, HCI_OP_LE_SET_EXT_ADV_ENABLE,
 				     sizeof(*cp) +
 				     sizeof(*set) * cp->num_of_sets,
-- 
2.53.0



