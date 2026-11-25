Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618179;
	b=waQaaYQr2wR7zjHpab/4OIaKTNI8zELz/hehiE+UuxnAdUOMdxU8jY6gF+pagq4gq5/Z
	 hSRt1LXm4scRuzLXUl2Sm1/sgEil5jBVBLeYBcpjbc6P52Lad94+xTklqM6c5SkopNQyj
	 IT51862mQO/yqOZCZEA0TU2Y0oHZMb5PKOGumA/zCMMnAkNQ18kTxatYkWDPK5bWt4+Z9
	 dzB7IRLrrxWSBdKSLJXANH8IzpQIYvbkjAylW69m0gTlk6PvYXAdegXjLA578dV3xfTCZ
	 sMLIaXkclcwSVhp+n/lx6peNnldThrtKb+3GP1auh9XxmxsxHNA5pa5MHgN7DL7/t3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y0Bb5zltQsxtnU6zehG5Fu40WbV9p7/Z+AxfkBsdr9M=;
	b=krQtFbClp5lJPNUf5XVKWY5jJw19ffg3VIbjCEJJ05d1orQWOnlb27LU043CSwHV9zoZ
	 UgntYam+di10UGrjq3JoET1W9imdQkULahrLpEnVNsIaoFM5n8NkUXD+grNEmxqERmZ3e
	 B1pxJKZlnDWEwpTrXrv3/e3bHn3l1ifQpNt1hCyCspSZBv8zoF0smIouFN8vlIoI9HNMi
	 SFBeeVriqM5vNlP4bZsxniyWHTKAbV2BA7L/UbQ8B0KnAHq6+PpLIk4mtf76uTJ65Nlpw
	 3//Xe7PXLxESyVbfk9Ki2gPqmzNz9cFzGdKygWWVRapnDdUD5t6vTwZvXhLAtEfw4Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="i3cM/lRh";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63EA606A31E;
	Wed, 25 Nov 2026 14:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3cM/lRh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C39F1F000C6;
	Wed, 25 Nov 2026 14:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618179;
	bh=y0Bb5zltQsxtnU6zehG5Fu40WbV9p7/Z+AxfkBsdr9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3cM/lRhdw1hJbum83NSRRwstXEVeVepdS+v5NfYhgSaOaHRh1onXdX+Enoc7ydBz
	 OEE6Y3uadiGqLMoh+UO/8X+UMIvz1llgz/ELMG5zYRNAt8GTYFa00N6rVFviEY4T6l
	 Z+ukX4Kctnuy5KZJTpT4161W6A8yP6civfxa3Ktw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0197/1005] Bluetooth: L2CAP: Hold incoming data until encryption key size is known
Date: Wed, 25 Nov 2026 15:25:35 +0100
Message-ID: <20261125143826.355667380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

[ Upstream commit 5d005ded2cb14531c4d4ab5d02383407c75dbee6 ]

Once encryption is enabled on an ACL link, the encryption key size is
read from the controller, using hdev->min_enc_key_size in the meantime.
Data received before the reply is processed with that key size, so a
peer starting SMP over BR/EDR right after encryption, which it may do,
gets its Pairing Request rejected with "Encryption Key Size" whenever
the pending security level is FIPS, as that requires a 16 octet key:

  > HCI Event: Encryption Change (0x08) plen 4
  > ACL Data RX: Handle 1 flags 0x02 dlen 11
        BR/EDR SMP: Pairing Request (0x01) len 6
  @ MGMT Event: Authentication Failed (0x0011) plen 8
        Status: Authentication Failed (0x05)
  < HCI Command: Read Encryption Key Size (0x05|0x0008) plen 2
  > HCI Event: Command Complete (0x0e) plen 7
        Key size: 16
  < ACL Data TX: Handle 1 flags 0x00 dlen 6
        BR/EDR SMP: Pairing Failed (0x05) len 1
        Reason: Encryption key size (0x06)

Mark the connection with HCI_CONN_ENC_KEY_SIZE_PEND while the key size
is read and hold incoming L2CAP data back in pending_rx meanwhile,
processing it once the reply is handled.

Found with mgmt-tester "Pairing Acceptor - SMP over BR/EDR 2" under User
Mode Linux time travel, where the emulated peer always replies before
the key size is read.

Fixes: e3f6a257a73d ("Bluetooth: Use actual encryption key size for SMP over BR/EDR")
Assisted-by: OpenCode:claude-opus-5.5
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_core.h |  1 +
 net/bluetooth/hci_event.c        | 12 +++++++++++-
 net/bluetooth/l2cap_core.c       | 16 ++++++++++++++--
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 75633476266cb..19870576bd90b 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -711,6 +711,7 @@ enum {
 	HCI_CONN_CREATE_PA_SYNC,
 	HCI_CONN_PA_SYNC,
 	HCI_CONN_PA_SYNC_FAILED,
+	HCI_CONN_ENC_KEY_SIZE_PEND,
 
 	__HCI_CONN_NUM_FLAGS,
 };
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 0e73f32c2682d..33d89319db0c3 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -724,6 +724,8 @@ static u8 hci_cc_read_enc_key_size(struct hci_dev *hdev, void *data,
 		goto done;
 	}
 
+	clear_bit(HCI_CONN_ENC_KEY_SIZE_PEND, conn->flags);
+
 	/* While unexpected, the read_enc_key_size command may fail. The most
 	 * secure approach is to then assume the key size is 0 to force a
 	 * disconnection.
@@ -3190,6 +3192,7 @@ static int hci_read_enc_key_size(struct hci_dev *hdev, struct hci_conn *conn)
 {
 	struct hci_cp_read_enc_key_size cp;
 	u8 *key_enc_size = hci_conn_key_enc_size(conn);
+	int err;
 
 	if (!read_key_size_capable(hdev)) {
 		conn->enc_key_size = HCI_LINK_KEY_SIZE;
@@ -3211,7 +3214,14 @@ static int hci_read_enc_key_size(struct hci_dev *hdev, struct hci_conn *conn)
 	else
 		conn->enc_key_size = hdev->min_enc_key_size;
 
-	return hci_send_cmd(hdev, HCI_OP_READ_ENC_KEY_SIZE, sizeof(cp), &cp);
+	/* L2CAP holds incoming data back until the key size is known */
+	set_bit(HCI_CONN_ENC_KEY_SIZE_PEND, conn->flags);
+
+	err = hci_send_cmd(hdev, HCI_OP_READ_ENC_KEY_SIZE, sizeof(cp), &cp);
+	if (err)
+		clear_bit(HCI_CONN_ENC_KEY_SIZE_PEND, conn->flags);
+
+	return err;
 }
 
 static void hci_conn_complete_evt(struct hci_dev *hdev, void *data,
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index daf3ea47fae4b..01d3fa02c7502 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7253,7 +7253,11 @@ static void l2cap_recv_frame(struct l2cap_conn *conn, struct sk_buff *skb)
 	u16 cid, len;
 	__le16 psm;
 
-	if (hcon->state != BT_CONNECTED) {
+	/* Also hold data back while the encryption key size is read, as
+	 * the security of the link, e.g. for SMP over BR/EDR, depends on it.
+	 */
+	if (hcon->state != BT_CONNECTED ||
+	    test_bit(HCI_CONN_ENC_KEY_SIZE_PEND, hcon->flags)) {
 		BT_DBG("queueing pending rx skb");
 		skb_queue_tail(&conn->pending_rx, skb);
 		return;
@@ -7316,7 +7320,11 @@ static void process_pending_rx(struct work_struct *work)
 
 	mutex_lock(&conn->lock);
 
-	while ((skb = skb_dequeue(&conn->pending_rx)))
+	/* l2cap_recv_frame() would queue it all again while the encryption
+	 * key size is read, l2cap_security_cfm() schedules this once known.
+	 */
+	while (!test_bit(HCI_CONN_ENC_KEY_SIZE_PEND, conn->hcon->flags) &&
+	       (skb = skb_dequeue(&conn->pending_rx)))
 		l2cap_recv_frame(conn, skb);
 
 	mutex_unlock(&conn->lock);
@@ -7899,6 +7907,10 @@ static void l2cap_security_cfm(struct hci_conn *hcon, u8 status, u8 encrypt)
 	}
 
 	mutex_unlock(&conn->lock);
+
+	/* Process data held back while the encryption key size was read */
+	if (!skb_queue_empty(&conn->pending_rx))
+		queue_work(hcon->hdev->workqueue, &conn->pending_rx_work);
 }
 
 /* Append fragment into frame respecting the maximum len of rx_skb */
-- 
2.53.0



