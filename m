Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216171;
	b=EKyefSroZQ7TXb0XeQr+WynU4m3vXB34un3mk9lVG6wkwYLaa/WXCNcNBoTrenmL1aFB
	 gkAzBM0ueJh6OOp0k6IP4pYAUJ4Fua78xMrII6tQFrLsLVfL0zc6jltiVpZ+HEHBu0+il
	 eFmyOHbkM4L50/k6txiqb8qu1xjAP1+yKci0sfGlgbGog5rWKNn42JHQYvFfGmOWVSQGq
	 09YaVwjOsLgb/H/4XcFEiEJwFdT5nnTV3dTfXnYc6erVr2GTkhiwWgbTX53vMKad2jQzV
	 ep1IEsqEtc6IcSo9VJBgK0bejeMtUk9gZQabMkoGkEL4bY86OEuCaZQRue0o3aQYvig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216171;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e82IiJuNOW0ov9D1SoVNf72CIk8Sorli6pCqiHc/Xq0=;
	b=LRJMy4MP2yQtSIYYp1yNs18J9dm5ssWMt3Ro1/qojnrLfvC4LAMEGpMdzJehc5ILRfUi
	 FVHd9TW1pE31b3uV56aDCcmgvh6t4xrUBDnTXP8rULSNAZ1m3HPf0XuKc03TUN44qUp3S
	 8Hos+Bnp+M5if19VE1jI5a7vsPQ8gJA6u8ckg368W+ZgjpGn5nvKwP2oi4DfG8HOiJJXa
	 CwrnQC7/OjvdEQhuGTCI4SueRnzR3BemkSKoFVXMAevaTJ1r+ITrYHmsXyzhaV8Qmzrmn
	 bDU8q70VaYb3KaO1aw9M+BnjmOZW7Ewn/E2ZWo2oF+05zSlokzG/gxcgK3NI1xSdU9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1c6rQcO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC8606A31C;
	Wed, 28 Oct 2026 19:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R1c6rQcO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005EE1F01825;
	Wed, 28 Oct 2026 19:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216170;
	bh=e82IiJuNOW0ov9D1SoVNf72CIk8Sorli6pCqiHc/Xq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1c6rQcO/EI+XG0gZxC4Nqoce3NSU3jWl6SffRLS9ZpXoAhUNg1L87qKcdszfq0JE
	 YWRz11Q+9UUJm1eW4BIkNtgls58lCb/BvdnCPSTK3mIL4xUdKQClHR8irhQ4I3wi+0
	 1VpTOu75ahx+ef8okxRuV+bl2V8XRGpADMABu/58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1458/1887] Bluetooth: 6lowpan: hold L2CAP conn across debugfs control
Date: Wed, 28 Oct 2026 17:59:14 +0100
Message-ID: <20261028170532.639070122@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 518aa9505fa10ea5662349e5d2efd8c9e32a820b ]

get_l2cap_conn() looks up an LE hci_conn under hdev protection, but
then drops that protection before reading hcon->l2cap_data and before
lowpan_control_write() later dereferences conn->hcon.  A disconnect or
device close can tear down the same L2CAP connection in that window.

The buggy scenario involves two paths, with each column showing the order
within that path:

6LoWPAN control write:              HCI disconnect/device close:
  1. get_l2cap_conn() finds hcon      1. hci_disconn_cfm() dispatches
     and hcon->l2cap_data.               the L2CAP disconnect callback.
  2. get_l2cap_conn() drops hdev      2. l2cap_conn_del() clears
     protection and returns conn.        hcon->l2cap_data and drops the
                                         L2CAP connection reference.
  3. lowpan_control_write() reads     3. hci_conn_del() removes and drops
     conn->hcon.                         the HCI connection.

Take a reference to the L2CAP connection with
l2cap_conn_hold_unless_zero() while hdev is still locked, and drop that
reference after the debugfs command's last use of conn.  This mirrors the
existing L2CAP ACL receive-side handoff and keeps the connection
dereferenceable after leaving hdev protection.  Export the existing helper
so the bluetooth_6lowpan module can use the same lifetime primitive.

Validation reproduced this kernel report:
BUG: KASAN: slab-use-after-free in lowpan_control_write+0x374/0x520
The buggy address belongs to the object at ffff888111b9d000 which belongs
to the cache kmalloc-1k of size 1024
The buggy address is located 0 bytes inside of freed 1024-byte region
[ffff888111b9d000, ffff888111b9d400)
Read of size 8
Call trace:
  dump_stack_lvl+0x66/0xa0
  print_report+0xce/0x5f0
  lowpan_control_write+0x374/0x520 (net/bluetooth/6lowpan.c:1131)
  srso_alias_return_thunk+0x5/0xfbef5
  __virt_addr_valid+0x19f/0x330
  kasan_report+0xe0/0x110
  __debugfs_file_get+0xf7/0x400
  full_proxy_write+0x9e/0xd0
  vfs_write+0x1b0/0x810
  ksys_write+0xd2/0x170
  dnotify_flush+0x32/0x220
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Allocated by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x17/0x60
  __kasan_kmalloc+0xaa/0xb0
  l2cap_conn_add+0x45/0x520
  l2cap_chan_connect+0xac6/0xd90
  l2cap_sock_connect+0x216/0x350
  __sys_connect+0x101/0x130
  __x64_sys_connect+0x40/0x50
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
Freed by task stack:
  kasan_save_stack+0x33/0x60
  kasan_save_track+0x17/0x60
  kasan_save_free_info+0x3b/0x60
  __kasan_slab_free+0x5f/0x80
  kfree+0x313/0x590
  hci_conn_hash_flush+0xc0/0x140
  hci_dev_close_sync+0x41a/0xb00
  hci_dev_close+0x12f/0x160
  hci_sock_ioctl+0x157/0x570
  sock_do_ioctl+0xf7/0x210
  sock_ioctl+0x32f/0x490
  __x64_sys_ioctl+0xc7/0x110
  do_syscall_64+0x115/0x6a0 (arch/x86/entry/syscall_64.c:87)
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
  kasan_record_aux_stack+0xa7/0xc0
  insert_work+0x32/0x100
  __queue_work+0x262/0xa60
  queue_work_on+0xad/0xb0
  l2cap_connect_cfm+0x4ef/0x670
  hci_le_remote_feat_complete_evt+0x247/0x430
  hci_event_packet+0x360/0x6f0
  hci_rx_work+0x2ae/0x7a0
  process_one_work+0x4fd/0xbc0
  worker_thread+0x2d8/0x570
  kthread+0x1ad/0x1f0
  ret_from_fork+0x3c9/0x540
  ret_from_fork_asm+0x1a/0x30

Fixes: 6b8d4a6a0314 ("Bluetooth: 6LoWPAN: Use connected oriented channel instead of fixed one")
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/l2cap.h |  1 +
 net/bluetooth/6lowpan.c       | 22 ++++++++++++++++------
 net/bluetooth/l2cap_core.c    |  3 ++-
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/include/net/bluetooth/l2cap.h b/include/net/bluetooth/l2cap.h
index ce799df6cbb36..b317c89935e90 100644
--- a/include/net/bluetooth/l2cap.h
+++ b/include/net/bluetooth/l2cap.h
@@ -980,6 +980,7 @@ void __l2cap_physical_cfm(struct l2cap_chan *chan, int result);
 
 struct l2cap_conn *l2cap_conn_get(struct l2cap_conn *conn);
 void l2cap_conn_put(struct l2cap_conn *conn);
+struct l2cap_conn *l2cap_conn_hold_unless_zero(struct l2cap_conn *conn);
 
 int l2cap_register_user(struct l2cap_conn *conn, struct l2cap_user *user);
 void l2cap_unregister_user(struct l2cap_conn *conn, struct l2cap_user *user);
diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index e59032c67116a..1b5a5bee3d07f 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -998,16 +998,20 @@ static int get_l2cap_conn(char *buf, bdaddr_t *addr, u8 *addr_type,
 
 	hci_dev_lock(hdev);
 	hcon = hci_conn_hash_lookup_le(hdev, addr, le_addr_type);
-	hci_dev_unlock(hdev);
-	hci_dev_put(hdev);
-
-	if (!hcon)
+	if (!hcon) {
+		hci_dev_unlock(hdev);
+		hci_dev_put(hdev);
 		return -ENOENT;
+	}
 
-	*conn = (struct l2cap_conn *)hcon->l2cap_data;
+	*conn = hcon->l2cap_data ?
+		l2cap_conn_hold_unless_zero(hcon->l2cap_data) : NULL;
 
 	BT_DBG("conn %p dst %pMR type %u", *conn, &hcon->dst, hcon->dst_type);
 
+	hci_dev_unlock(hdev);
+	hci_dev_put(hdev);
+
 	return 0;
 }
 
@@ -1131,18 +1135,22 @@ static ssize_t lowpan_control_write(struct file *fp,
 		if (conn) {
 			struct lowpan_peer *peer;
 
-			if (!is_bt_6lowpan(conn->hcon))
+			if (!is_bt_6lowpan(conn->hcon)) {
+				l2cap_conn_put(conn);
 				return -EINVAL;
+			}
 
 			peer = lookup_peer(conn);
 			if (peer) {
 				BT_DBG("6LoWPAN connection already exists");
+				l2cap_conn_put(conn);
 				return -EALREADY;
 			}
 
 			BT_DBG("conn %p dst %pMR type %d user %u", conn,
 			       &conn->hcon->dst, conn->hcon->dst_type,
 			       addr_type);
+			l2cap_conn_put(conn);
 		}
 
 		ret = bt_6lowpan_connect(&addr, addr_type);
@@ -1158,6 +1166,8 @@ static ssize_t lowpan_control_write(struct file *fp,
 			return ret;
 
 		ret = bt_6lowpan_disconnect(conn, addr_type);
+		if (conn)
+			l2cap_conn_put(conn);
 		if (ret < 0)
 			return ret;
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e570b44c16003..15bb4ca915134 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -7821,7 +7821,7 @@ static void l2cap_recv_reset(struct l2cap_conn *conn)
 	conn->rx_len = 0;
 }
 
-static struct l2cap_conn *l2cap_conn_hold_unless_zero(struct l2cap_conn *c)
+struct l2cap_conn *l2cap_conn_hold_unless_zero(struct l2cap_conn *c)
 {
 	BT_DBG("conn %p orig refcnt %u", c, kref_read(&c->ref));
 
@@ -7830,6 +7830,7 @@ static struct l2cap_conn *l2cap_conn_hold_unless_zero(struct l2cap_conn *c)
 
 	return c;
 }
+EXPORT_SYMBOL(l2cap_conn_hold_unless_zero);
 
 void l2cap_recv_acldata(struct hci_conn *hcon, struct sk_buff *skb, u16 flags)
 {
-- 
2.53.0



