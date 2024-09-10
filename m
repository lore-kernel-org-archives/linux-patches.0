Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3798C18FDB9;
	Tue, 10 Sep 2024 10:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962805; cv=none; b=kdvPpDmy34jB42YjBIjjEdTC1DQCz3zoKxKhnTPt7A5tMjs+RsfexVZOk5rYSp3JpEedag1RMSJvGAQOe+7xv9RSGt1t+oBX+G2tWOrHe2lUMWS1pLaupnaSpY5wo1FQ7NKrlG9ang+iZcYSzLHVY58gMUdePFqoEv1LIHSdf2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962805; c=relaxed/simple;
	bh=wlYcoFSCPL0vk8R++32aCaap39EiHp1YM/LVa9Fpb0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qneRX1xfIfLrM5XZHMIDhnz7DeUVfauFIYxTAd/4La42mGFEbQVSSBu6gCBwc1+dpoL5dk3L/6n66A1kVQEFA+qC/lJpVkTvy5pfeZVw7ns2zDljP3tlamfhVc+16i6vLhSV0xILuAbc5LmeKOwFq+qir5PRaJoFkkrbCMkYh70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+qjHR2F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+qjHR2F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BDBC4CEC6;
	Tue, 10 Sep 2024 10:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962805;
	bh=wlYcoFSCPL0vk8R++32aCaap39EiHp1YM/LVa9Fpb0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+qjHR2FI1JO97RkVPXTyWJBLj8SMYU+sl1MuApTb5HcSRGrtSNQIMtMauKLE3TQv
	 zY/m5oYrVFY70Jh7LKDdRl9JMp+TY0EWzoUa0lefx+H7kAozbBv9g4RQQYxGFo0lfA
	 JO8f4NKIlxyRZfOUjAeEJOQNiQJwiC8v5YkEV5zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.1 018/192] Revert "Bluetooth: MGMT/SMP: Fix address type when using SMP over BREDR/LE"
Date: Tue, 10 Sep 2024 11:30:42 +0200
Message-ID: <20240910092558.692826213@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

commit 532f8bcd1c2c4e8112f62e1922fd1703bc0ffce0 upstream.

This reverts commit 59b047bc98084f8af2c41483e4d68a5adf2fa7f7 which
breaks compatibility with commands like:

bluetoothd[46328]: @ MGMT Command: Load.. (0x0013) plen 74  {0x0001} [hci0]
        Keys: 2
        BR/EDR Address: C0:DC:DA:A5:E5:47 (Samsung Electronics Co.,Ltd)
        Key type: Authenticated key from P-256 (0x03)
        Central: 0x00
        Encryption size: 16
        Diversifier[2]: 0000
        Randomizer[8]: 0000000000000000
        Key[16]: 6ed96089bd9765be2f2c971b0b95f624
        LE Address: D7:2A:DE:1E:73:A2 (Static)
        Key type: Unauthenticated key from P-256 (0x02)
        Central: 0x00
        Encryption size: 16
        Diversifier[2]: 0000
        Randomizer[8]: 0000000000000000
        Key[16]: 87dd2546ededda380ffcdc0a8faa4597
@ MGMT Event: Command Status (0x0002) plen 3                {0x0001} [hci0]
      Load Long Term Keys (0x0013)
        Status: Invalid Parameters (0x0d)

Cc: stable@vger.kernel.org
Link: https://github.com/bluez/bluez/issues/875
Fixes: 59b047bc9808 ("Bluetooth: MGMT/SMP: Fix address type when using SMP over BREDR/LE")
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/bluetooth/hci_core.h |    5 -----
 net/bluetooth/mgmt.c             |   25 +++++++------------------
 net/bluetooth/smp.c              |    7 -------
 3 files changed, 7 insertions(+), 30 deletions(-)

--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -187,7 +187,6 @@ struct blocked_key {
 struct smp_csrk {
 	bdaddr_t bdaddr;
 	u8 bdaddr_type;
-	u8 link_type;
 	u8 type;
 	u8 val[16];
 };
@@ -197,7 +196,6 @@ struct smp_ltk {
 	struct rcu_head rcu;
 	bdaddr_t bdaddr;
 	u8 bdaddr_type;
-	u8 link_type;
 	u8 authenticated;
 	u8 type;
 	u8 enc_size;
@@ -212,7 +210,6 @@ struct smp_irk {
 	bdaddr_t rpa;
 	bdaddr_t bdaddr;
 	u8 addr_type;
-	u8 link_type;
 	u8 val[16];
 };
 
@@ -220,8 +217,6 @@ struct link_key {
 	struct list_head list;
 	struct rcu_head rcu;
 	bdaddr_t bdaddr;
-	u8 bdaddr_type;
-	u8 link_type;
 	u8 type;
 	u8 val[HCI_LINK_KEY_SIZE];
 	u8 pin_len;
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2903,8 +2903,7 @@ static int load_link_keys(struct sock *s
 	for (i = 0; i < key_count; i++) {
 		struct mgmt_link_key_info *key = &cp->keys[i];
 
-		/* Considering SMP over BREDR/LE, there is no need to check addr_type */
-		if (key->type > 0x08)
+		if (key->addr.type != BDADDR_BREDR || key->type > 0x08)
 			return mgmt_cmd_status(sk, hdev->id,
 					       MGMT_OP_LOAD_LINK_KEYS,
 					       MGMT_STATUS_INVALID_PARAMS);
@@ -7141,7 +7140,6 @@ static int load_irks(struct sock *sk, st
 
 	for (i = 0; i < irk_count; i++) {
 		struct mgmt_irk_info *irk = &cp->irks[i];
-		u8 addr_type = le_addr_type(irk->addr.type);
 
 		if (hci_is_blocked_key(hdev,
 				       HCI_BLOCKED_KEY_TYPE_IRK,
@@ -7151,12 +7149,8 @@ static int load_irks(struct sock *sk, st
 			continue;
 		}
 
-		/* When using SMP over BR/EDR, the addr type should be set to BREDR */
-		if (irk->addr.type == BDADDR_BREDR)
-			addr_type = BDADDR_BREDR;
-
 		hci_add_irk(hdev, &irk->addr.bdaddr,
-			    addr_type, irk->val,
+			    le_addr_type(irk->addr.type), irk->val,
 			    BDADDR_ANY);
 	}
 
@@ -7237,7 +7231,6 @@ static int load_long_term_keys(struct so
 	for (i = 0; i < key_count; i++) {
 		struct mgmt_ltk_info *key = &cp->keys[i];
 		u8 type, authenticated;
-		u8 addr_type = le_addr_type(key->addr.type);
 
 		if (hci_is_blocked_key(hdev,
 				       HCI_BLOCKED_KEY_TYPE_LTK,
@@ -7272,12 +7265,8 @@ static int load_long_term_keys(struct so
 			continue;
 		}
 
-		/* When using SMP over BR/EDR, the addr type should be set to BREDR */
-		if (key->addr.type == BDADDR_BREDR)
-			addr_type = BDADDR_BREDR;
-
 		hci_add_ltk(hdev, &key->addr.bdaddr,
-			    addr_type, type, authenticated,
+			    le_addr_type(key->addr.type), type, authenticated,
 			    key->val, key->enc_size, key->ediv, key->rand);
 	}
 
@@ -9545,7 +9534,7 @@ void mgmt_new_link_key(struct hci_dev *h
 
 	ev.store_hint = persistent;
 	bacpy(&ev.key.addr.bdaddr, &key->bdaddr);
-	ev.key.addr.type = link_to_bdaddr(key->link_type, key->bdaddr_type);
+	ev.key.addr.type = BDADDR_BREDR;
 	ev.key.type = key->type;
 	memcpy(ev.key.val, key->val, HCI_LINK_KEY_SIZE);
 	ev.key.pin_len = key->pin_len;
@@ -9596,7 +9585,7 @@ void mgmt_new_ltk(struct hci_dev *hdev,
 		ev.store_hint = persistent;
 
 	bacpy(&ev.key.addr.bdaddr, &key->bdaddr);
-	ev.key.addr.type = link_to_bdaddr(key->link_type, key->bdaddr_type);
+	ev.key.addr.type = link_to_bdaddr(LE_LINK, key->bdaddr_type);
 	ev.key.type = mgmt_ltk_type(key);
 	ev.key.enc_size = key->enc_size;
 	ev.key.ediv = key->ediv;
@@ -9625,7 +9614,7 @@ void mgmt_new_irk(struct hci_dev *hdev,
 
 	bacpy(&ev.rpa, &irk->rpa);
 	bacpy(&ev.irk.addr.bdaddr, &irk->bdaddr);
-	ev.irk.addr.type = link_to_bdaddr(irk->link_type, irk->addr_type);
+	ev.irk.addr.type = link_to_bdaddr(LE_LINK, irk->addr_type);
 	memcpy(ev.irk.val, irk->val, sizeof(irk->val));
 
 	mgmt_event(MGMT_EV_NEW_IRK, hdev, &ev, sizeof(ev), NULL);
@@ -9654,7 +9643,7 @@ void mgmt_new_csrk(struct hci_dev *hdev,
 		ev.store_hint = persistent;
 
 	bacpy(&ev.key.addr.bdaddr, &csrk->bdaddr);
-	ev.key.addr.type = link_to_bdaddr(csrk->link_type, csrk->bdaddr_type);
+	ev.key.addr.type = link_to_bdaddr(LE_LINK, csrk->bdaddr_type);
 	ev.key.type = csrk->type;
 	memcpy(ev.key.val, csrk->val, sizeof(csrk->val));
 
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1059,7 +1059,6 @@ static void smp_notify_keys(struct l2cap
 	}
 
 	if (smp->remote_irk) {
-		smp->remote_irk->link_type = hcon->type;
 		mgmt_new_irk(hdev, smp->remote_irk, persistent);
 
 		/* Now that user space can be considered to know the
@@ -1074,28 +1073,24 @@ static void smp_notify_keys(struct l2cap
 	}
 
 	if (smp->csrk) {
-		smp->csrk->link_type = hcon->type;
 		smp->csrk->bdaddr_type = hcon->dst_type;
 		bacpy(&smp->csrk->bdaddr, &hcon->dst);
 		mgmt_new_csrk(hdev, smp->csrk, persistent);
 	}
 
 	if (smp->responder_csrk) {
-		smp->responder_csrk->link_type = hcon->type;
 		smp->responder_csrk->bdaddr_type = hcon->dst_type;
 		bacpy(&smp->responder_csrk->bdaddr, &hcon->dst);
 		mgmt_new_csrk(hdev, smp->responder_csrk, persistent);
 	}
 
 	if (smp->ltk) {
-		smp->ltk->link_type = hcon->type;
 		smp->ltk->bdaddr_type = hcon->dst_type;
 		bacpy(&smp->ltk->bdaddr, &hcon->dst);
 		mgmt_new_ltk(hdev, smp->ltk, persistent);
 	}
 
 	if (smp->responder_ltk) {
-		smp->responder_ltk->link_type = hcon->type;
 		smp->responder_ltk->bdaddr_type = hcon->dst_type;
 		bacpy(&smp->responder_ltk->bdaddr, &hcon->dst);
 		mgmt_new_ltk(hdev, smp->responder_ltk, persistent);
@@ -1115,8 +1110,6 @@ static void smp_notify_keys(struct l2cap
 		key = hci_add_link_key(hdev, smp->conn->hcon, &hcon->dst,
 				       smp->link_key, type, 0, &persistent);
 		if (key) {
-			key->link_type = hcon->type;
-			key->bdaddr_type = hcon->dst_type;
 			mgmt_new_link_key(hdev, key, persistent);
 
 			/* Don't keep debug keys around if the relevant


