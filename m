Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214751;
	b=YQJ4JDO+ptyFaO36byVTV6smqo6J5PwIs8B290Hgw9BmdheOik811zQQt38cVTHpqLr9
	 PMWCgTy7RP0pq4o9lSdoncpF8T+EgQf6d6f6GtfgRphm/1+bT9HjlzJxibbaZC5LqA1kK
	 9vOZ2H2w+m5BRtBn6TpGx94rJFA9qnTuNSaBMl/fd0pGMzVImO6I/dJ0xoBw3VOQ4l9Sh
	 ZpxUEq7awcwUfIQ3eMn+NehNL79lbFRhFfgRv2Hs1XfudjJElskbfQuprBL2OFuDM89Qx
	 YQgOEyLhLUXcwRxtBy6ARMC6V2621u0K8KSIR9hNv/Bmyuzkw0lS1lgLEP0geHV3ujw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214751;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PXBmW6OuiJmLFoMmgFA7kGqqEkhjiHtmSBzSwn0Ow8s=;
	b=s/2+2LCiMSppfhcuQ0KxuHkw+dOqhkS/+kIjE9mqqIpVrYH+Zwf7VrvuewD84wEbhZSD
	 uO/xe5LmvXH5E1RjsloQDrH1sCI+xcV0/PBS6Ufx1OcCuoRvB0Ujo+d8l1Ao8qtkIO9xT
	 VeYapBSL7AVoPIsNvbaR2APuZNVdoB+NIz731stl5zsukoevpxDddQsI/wg2XkhMfUSb3
	 GXltoGfWtjP+xNvwp3d+KEjlREMFGhP29JFe3QoC8jw1n9jTIOrp2+3fHjkVzc1kJIfG8
	 CHgtuOYyE8uyiM/amAGp+NbQ3DJjJjK7amgWrI7NPpK5wJA25Q2QGuokXQSpFdP87Ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e43c4Rc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506BF606AB3D;
	Wed, 28 Oct 2026 19:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1e43c4Rc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C91F01829;
	Wed, 28 Oct 2026 19:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214751;
	bh=PXBmW6OuiJmLFoMmgFA7kGqqEkhjiHtmSBzSwn0Ow8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1e43c4RcaHHj25XccSc1GzlsXWoWTd19fjP8zJaigf1592xY6j979hC943Hbe/PdB
	 Fsq61OqQzYDMsc6wA0DqZHcBbulbAKS9FmOo29YVEVZW7ABSCAXJqkkMw1jHB9G/q1
	 UnVbQ2PtVyzzT69aBmxjwL0SOfk/UAvFgB4KmRF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleh Konko <security@1seal.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0969/1887] Bluetooth: hci_event: move wake reason storage into validated event handlers
Date: Wed, 28 Oct 2026 17:51:05 +0100
Message-ID: <20261028170521.462579121@linuxfoundation.org>
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

From: Oleh Konko <security@1seal.org>

[ Upstream commit 2b2bf47cd75518c36fa2d41380e4a40641cc89cd ]

hci_store_wake_reason() is called from hci_event_packet() immediately
after stripping the HCI event header but before hci_event_func()
enforces the per-event minimum payload length from hci_ev_table.
This means a short HCI event frame can reach bacpy() before any bounds
check runs.

Rather than duplicating skb parsing and per-event length checks inside
hci_store_wake_reason(), move wake-address storage into the individual
event handlers after their existing event-length validation has
succeeded. Convert hci_store_wake_reason() into a small helper that only
stores an already-validated bdaddr while the caller holds hci_dev_lock().
Use the same helper after hci_event_func() with a NULL address to
preserve the existing unexpected-wake fallback semantics when no
validated event handler records a wake address.

Annotate the helper with __must_hold(&hdev->lock) and add
lockdep_assert_held(&hdev->lock) so future call paths keep the lock
contract explicit.

Call the helper from hci_conn_request_evt(), hci_conn_complete_evt(),
hci_sync_conn_complete_evt(), le_conn_complete_evt(),
hci_le_adv_report_evt(), hci_le_ext_adv_report_evt(),
hci_le_direct_adv_report_evt(), hci_le_pa_sync_established_evt(), and
hci_le_past_received_evt().

Fixes: 2f20216c1d6f ("Bluetooth: Emit controller suspend and resume events")
Cc: stable@vger.kernel.org
Signed-off-by: Oleh Konko <security@1seal.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 93 ++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 59 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 97899057a262c..e319d55dc0068 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -80,6 +80,10 @@ static void *hci_le_ev_skb_pull(struct hci_dev *hdev, struct sk_buff *skb,
 	return data;
 }
 
+static void hci_store_wake_reason(struct hci_dev *hdev,
+				  const bdaddr_t *bdaddr, u8 addr_type)
+	__must_hold(&hdev->lock);
+
 static u8 hci_cc_inquiry_cancel(struct hci_dev *hdev, void *data,
 				struct sk_buff *skb)
 {
@@ -3078,6 +3082,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, BDADDR_BREDR);
 
 	/* Check for existing connection:
 	 *
@@ -3262,6 +3267,10 @@ static void hci_conn_request_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "bdaddr %pMR type 0x%x", &ev->bdaddr, ev->link_type);
 
+	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, BDADDR_BREDR);
+	hci_dev_unlock(hdev);
+
 	/* Reject incoming connection from device with same BD ADDR against
 	 * CVE-2020-26555
 	 */
@@ -4915,6 +4924,7 @@ static void hci_sync_conn_complete_evt(struct hci_dev *hdev, void *data,
 	bt_dev_dbg(hdev, "status 0x%2.2x", status);
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, BDADDR_BREDR);
 
 	conn = hci_conn_hash_lookup_ba(hdev, ev->link_type, &ev->bdaddr);
 	if (!conn) {
@@ -5623,6 +5633,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 	u8 addr_type;
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, bdaddr, bdaddr_type);
 
 	/* Advertising stops when a connection is created. On a failed
 	 * connection it keeps running, so leave the state bit alone.
@@ -6251,6 +6262,8 @@ static void hci_le_adv_report_evt(struct hci_dev *hdev, void *data,
 					info->length + 1))
 			break;
 
+		hci_store_wake_reason(hdev, &info->bdaddr, info->bdaddr_type);
+
 		if (info->length <= max_adv_len(hdev)) {
 			rssi = info->data[info->length];
 			process_adv_report(hdev, info->type, &info->bdaddr,
@@ -6334,6 +6347,8 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
 					info->length))
 			break;
 
+		hci_store_wake_reason(hdev, &info->bdaddr, info->bdaddr_type);
+
 		evt_type = __le16_to_cpu(info->type);
 		legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
 		if (legacy_evt_type != LE_ADV_INVALID) {
@@ -6371,6 +6386,7 @@ static void hci_le_pa_sync_estabilished_evt(struct hci_dev *hdev, void *data,
 		return;
 
 	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, &ev->bdaddr, ev->bdaddr_type);
 
 	hci_dev_clear_flag(hdev, HCI_PA_SYNC);
 
@@ -6608,6 +6624,8 @@ static void hci_le_direct_adv_report_evt(struct hci_dev *hdev, void *data,
 	for (i = 0; i < ev->num; i++) {
 		struct hci_ev_le_direct_adv_info *info = &ev->info[i];
 
+		hci_store_wake_reason(hdev, &info->bdaddr, info->bdaddr_type);
+
 		process_adv_report(hdev, info->type, &info->bdaddr,
 				   info->bdaddr_type, &info->direct_addr,
 				   info->direct_addr_type, info->rssi, NULL, 0,
@@ -7063,73 +7081,29 @@ static bool hci_get_cmd_complete(struct hci_dev *hdev, u16 opcode,
 	return true;
 }
 
-static void hci_store_wake_reason(struct hci_dev *hdev, u8 event,
-				  struct sk_buff *skb)
+static void hci_store_wake_reason(struct hci_dev *hdev,
+				  const bdaddr_t *bdaddr, u8 addr_type)
+	__must_hold(&hdev->lock)
 {
-	struct hci_ev_le_advertising_info *adv;
-	struct hci_ev_le_direct_adv_info *direct_adv;
-	struct hci_ev_le_ext_adv_info *ext_adv;
-	const struct hci_ev_conn_complete *conn_complete = (void *)skb->data;
-	const struct hci_ev_conn_request *conn_request = (void *)skb->data;
-
-	hci_dev_lock(hdev);
+	lockdep_assert_held(&hdev->lock);
 
 	/* If we are currently suspended and this is the first BT event seen,
 	 * save the wake reason associated with the event.
 	 */
 	if (!hdev->suspended || hdev->wake_reason)
-		goto unlock;
+		return;
+
+	if (!bdaddr) {
+		hdev->wake_reason = MGMT_WAKE_REASON_UNEXPECTED;
+		return;
+	}
 
 	/* Default to remote wake. Values for wake_reason are documented in the
 	 * Bluez mgmt api docs.
 	 */
 	hdev->wake_reason = MGMT_WAKE_REASON_REMOTE_WAKE;
-
-	/* Once configured for remote wakeup, we should only wake up for
-	 * reconnections. It's useful to see which device is waking us up so
-	 * keep track of the bdaddr of the connection event that woke us up.
-	 */
-	if (event == HCI_EV_CONN_REQUEST) {
-		bacpy(&hdev->wake_addr, &conn_request->bdaddr);
-		hdev->wake_addr_type = BDADDR_BREDR;
-	} else if (event == HCI_EV_CONN_COMPLETE) {
-		bacpy(&hdev->wake_addr, &conn_complete->bdaddr);
-		hdev->wake_addr_type = BDADDR_BREDR;
-	} else if (event == HCI_EV_LE_META) {
-		struct hci_ev_le_meta *le_ev = (void *)skb->data;
-		u8 subevent = le_ev->subevent;
-		u8 *ptr = &skb->data[sizeof(*le_ev)];
-		u8 num_reports = *ptr;
-
-		if ((subevent == HCI_EV_LE_ADVERTISING_REPORT ||
-		     subevent == HCI_EV_LE_DIRECT_ADV_REPORT ||
-		     subevent == HCI_EV_LE_EXT_ADV_REPORT) &&
-		    num_reports) {
-			adv = (void *)(ptr + 1);
-			direct_adv = (void *)(ptr + 1);
-			ext_adv = (void *)(ptr + 1);
-
-			switch (subevent) {
-			case HCI_EV_LE_ADVERTISING_REPORT:
-				bacpy(&hdev->wake_addr, &adv->bdaddr);
-				hdev->wake_addr_type = adv->bdaddr_type;
-				break;
-			case HCI_EV_LE_DIRECT_ADV_REPORT:
-				bacpy(&hdev->wake_addr, &direct_adv->bdaddr);
-				hdev->wake_addr_type = direct_adv->bdaddr_type;
-				break;
-			case HCI_EV_LE_EXT_ADV_REPORT:
-				bacpy(&hdev->wake_addr, &ext_adv->bdaddr);
-				hdev->wake_addr_type = ext_adv->bdaddr_type;
-				break;
-			}
-		}
-	} else {
-		hdev->wake_reason = MGMT_WAKE_REASON_UNEXPECTED;
-	}
-
-unlock:
-	hci_dev_unlock(hdev);
+	bacpy(&hdev->wake_addr, bdaddr);
+	hdev->wake_addr_type = addr_type;
 }
 
 #define HCI_EV_VL(_op, _func, _min_len, _max_len) \
@@ -7374,14 +7348,15 @@ void hci_event_packet(struct hci_dev *hdev, struct sk_buff *skb)
 
 	skb_pull(skb, HCI_EVENT_HDR_SIZE);
 
-	/* Store wake reason if we're suspended */
-	hci_store_wake_reason(hdev, event, skb);
-
 	bt_dev_dbg(hdev, "event 0x%2.2x", event);
 
 	hci_event_func(hdev, event, skb, &opcode, &status, &req_complete,
 		       &req_complete_skb);
 
+	hci_dev_lock(hdev);
+	hci_store_wake_reason(hdev, NULL, 0);
+	hci_dev_unlock(hdev);
+
 	if (req_complete) {
 		req_complete(hdev, status, opcode);
 	} else if (req_complete_skb) {
-- 
2.53.0



