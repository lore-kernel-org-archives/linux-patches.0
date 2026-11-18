Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026728;
	b=XW+PY9Td2s8dMSgovhoLhGD07YQAMjJ7lPPfUhbo7djILnwXJsKPi0f2K477KDUcXIqY
	 nSo9VtVr27jyKzsTygqIoY7bEYfqJx5dkZyBhmsBy7dIhBjfk9IsKUpKHPUEzkQebmTva
	 NV+AdpSAJPlAJ7l1Fjyi0RgReZT5MjmP2HZJ+MiWDTZHcsd2Nnyf/4PhjgmutHF1ScnVo
	 Vs9qGZNkmkhyqPneJ/aCM7wcBP4uzJvrto1mjPPotmuU8fme6dRPgLd4df4bxABnSPIlL
	 0xGhSwxFUXDrY9Xmg8YzR1hmOAhYe2jo5C5a2+TPGv7TJ8Y7n/lHT4+V6yntPGo1htg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+oRroZOXZefs8y5l8cEoMPP7EVGAFZeZYqVTO2vv/q4=;
	b=uoE3k/NM6TJKjoobDiINalKnf+0abcRLE1uBN0bGDYNXveM5vgbWypMHif4uI4652mfs
	 nbEbymq5evX0OqIbY5k6hMpALMNIipxiifOi+veWQWelwFt2d/HvD6I62VxLokVtds8tV
	 lX7BOXg6C492FhLU053A2Tl5kK+VVI7vRDqDfzgsIHQFFJXYUXEhswS8D/F1l/FgcgbX5
	 Wa/aSF8FUb3cn9HP87hoZYXPaaMjWCTehQUHUpHf/7TzzwBKNxyIf2qOr7+QoZhx/MSPi
	 38OF7bvlOywd9/ATr+sYmEMLnT/Drh5iuqv6CLHQVmRVl32ElbylXxj3kLcG2DoMmzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DWs0TWJ4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CF9606A31C;
	Wed, 18 Nov 2026 18:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DWs0TWJ4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02911F000C4;
	Wed, 18 Nov 2026 18:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026728;
	bh=+oRroZOXZefs8y5l8cEoMPP7EVGAFZeZYqVTO2vv/q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DWs0TWJ42XQPDEsrE3w2/ekRwT4TR9azvhha/KIb1XDq06ZK8VxsmKlKtecAcS9fN
	 Cb/QUvrEqub107YcB87IiMsMiTXFZPDnGXDZucrUuusV6rdrqf1ZbQUt0FnB8tizx/
	 olqNd2MydDmth8bqHMuo8h7AReoSJhT/LBuM9Vn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hitalo Souza <enghitalo@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1538/2151] Bluetooth: Add missing newline to bt_dev_{err,warn}_ratelimited()
Date: Wed, 18 Nov 2026 15:54:33 +0100
Message-ID: <20261118150217.899629086@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hitalo Souza <enghitalo@gmail.com>

[ Upstream commit f51ee3bb5fbe9c2019c31befe330bddd3aee39c2 ]

bt_dev_err_ratelimited() and bt_dev_warn_ratelimited() pass the format
string to bt_err_ratelimited()/bt_warn_ratelimited() without appending
a newline, unlike bt_dev_err() and bt_dev_warn(), which go through
BT_ERR()/BT_WARN() and add one. Only 2 of the 22 in-tree callers (both
in virtio_bt) put the newline in their own format string.

A printk record without a trailing newline is stored with prb_commit()
instead of prb_final_commit(), and readers of the log buffer (/dev/kmsg,
syslog) do not see it until it is finalized, which only happens when the
next record is reserved. These messages therefore stay invisible until
some unrelated message is printed, and journald, which timestamps a
record when it reads it, logs them with the time of that later message.

This was observed with a MediaTek MT7921 controller (USB 04ca:3802):
when an eSCO link is closed, the host still receives a few SCO packets
for the handle after Disconnection Complete, so hci_scodata_packet()
logs "SCO packet for unknown connection handle". Comparing the record's
kernel timestamp (_SOURCE_MONOTONIC_TIMESTAMP) with the time journald
received it, over one capture:

  emitted       logged        delay
  15:36:52.896  15:37:00.214    7.3 s
  15:37:03.410  15:39:05.574  122.2 s
  15:39:05.574  15:39:12.506    6.9 s
  15:39:19.791  15:40:54.109   94.3 s
  15:41:22.021  15:41:24.647    2.6 s

Each message showed up together with the next kernel message; the 94 s
one looked as if it had been logged in the middle of a later, healthy
eSCO connection.

bt_dev_err_ratelimited() lost its newline in commit 657cc646475b
("Bluetooth: Remove usage of BT_ERR_RATELIMITED macro"), which replaced
BT_ERR_RATELIMITED(), the variant that appended "\n", with a direct call
to bt_err_ratelimited(). bt_dev_warn_ratelimited() never had one.

Append the newline in both macros, as BT_ERR() and BT_WARN() do, and
drop it from the two virtio_bt format strings so that their messages do
not gain an empty line.

Fixes: 36278a5d4d35 ("Bluetooth: Adding a bt_dev_warn_ratelimited macro.")
Fixes: 657cc646475b ("Bluetooth: Remove usage of BT_ERR_RATELIMITED macro")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Hitalo Souza <enghitalo@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/virtio_bt.c     | 4 ++--
 include/net/bluetooth/bluetooth.h | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/virtio_bt.c b/drivers/bluetooth/virtio_bt.c
index 152432cc2260c..3551c87b172d4 100644
--- a/drivers/bluetooth/virtio_bt.c
+++ b/drivers/bluetooth/virtio_bt.c
@@ -228,7 +228,7 @@ static void virtbt_rx_handle(struct virtio_bluetooth *vbt, struct sk_buff *skb)
 
 	if (skb->len < min_hdr) {
 		bt_dev_err_ratelimited(vbt->hdev,
-				       "rx pkt_type 0x%02x payload %u < hdr %zu\n",
+				       "rx pkt_type 0x%02x payload %u < hdr %zu",
 				       pkt_type, skb->len, min_hdr);
 		kfree_skb(skb);
 		return;
@@ -251,7 +251,7 @@ static void virtbt_rx_work(struct work_struct *work)
 
 	if (!len || len > VIRTBT_RX_BUF_SIZE) {
 		bt_dev_err_ratelimited(vbt->hdev,
-				       "rx reply len %u outside [1, %u]\n",
+				       "rx reply len %u outside [1, %u]",
 				       len, VIRTBT_RX_BUF_SIZE);
 		kfree_skb(skb);
 	} else {
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 3791915e4a0ac..737554de0b662 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -290,9 +290,9 @@ void bt_err_ratelimited(const char *fmt, ...);
 	BT_DBG("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 #define bt_dev_warn_ratelimited(hdev, fmt, ...)			\
-	bt_warn_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
+	bt_warn_ratelimited("%s: " fmt "\n", bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err_ratelimited(hdev, fmt, ...)			\
-	bt_err_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
+	bt_err_ratelimited("%s: " fmt "\n", bt_dev_name(hdev), ##__VA_ARGS__)
 
 /* Connection and socket states */
 enum bt_sock_state {
-- 
2.53.0



