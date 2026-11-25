Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618197;
	b=knN6XLxRdvbeV+vpwC82JtuYnIXO9SZmyGNtSRDfv4qRjmieNoOj6cc/gSwy2DB7+0rp
	 UXVAVI5cL+XUt9UeoobdXL/P7TYglcXnXtHEv2UwGMsDbds2V1+Xr4Szh5nvGE5IkuyQ5
	 xSWFK2b7rwIjlclsD96sK2k67jVMUTsyUtESCUxg5dmvsocbsEadhj+T2d0zEtvFuuKr9
	 2BGWxyKK/aOcHhNHRJVk5O5GRHj1oOTw7ycAEELhhyDKhgOQhZOsaEC+ZZbqNEz9FSUO1
	 dRl4gDfUZXLJdjqzzktnYpxGLAppc566u8/p4vq9psc1EV4bkE4OMjCptOXkgLcPoSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q7LZbdoqWvImewXeOOyK+rB38qR3kVVaCUAFghN+BGU=;
	b=lZieeT7sksi8AIfQwhq3zwcvpJOIFKVxm8lX5fyQkqvtS0i3WE7b76AWnxBZd22wYEpn
	 6pt1p0qAo+l0adAR0PJV+nZEtoM10xe0qr2l49uD/VkQvXFRx9H+1L+hANgy1R6RlEDG9
	 +imiaT587RV6C8jUJtDncNA6tQpb3mSdUvR3KHEE4SASvWEBWLSxsamPMXUVvQUjXlDBZ
	 eRwscqiGiN7rwWmiRqBXamBlxBR3sL1zH0RzUO4efpXTRp+OgKmeQplZVXnAb9n4lR4Sk
	 S4KesuEq0MZLjbB4qCves5BpzwKR/A+khkX1MYV9FKtkssWyt+K/vcnnrXozVAvfxWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DE4QMbqo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F490606A323;
	Wed, 25 Nov 2026 14:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DE4QMbqo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 415AF1F000CA;
	Wed, 25 Nov 2026 14:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618196;
	bh=Q7LZbdoqWvImewXeOOyK+rB38qR3kVVaCUAFghN+BGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DE4QMbqo4EACKwTXketcV7rVXKQ58G20SCmzz5Je9V5GzEfz/mCq/EUDcRjXznZe7
	 evYoy3oBFalQrbX4bvYIEZ5NVNx+PwMkv0s8hrj/fU8khvzMpbjlYMopj2RhIqznrL
	 xGcMTUg0kr8SspkH0eOGPC7HVVKqB+ToHtWWx7nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0202/1005] Bluetooth: hci_sync: Copy the LE accept list under hdev->lock
Date: Wed, 25 Nov 2026 15:25:40 +0100
Message-ID: <20261125143826.472877332@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 674006912777747170ad70d7727804ad4f2d047f ]

The LE accept-list mirror consists of bdaddr_list entries that are
added, removed and freed under hdev->lock. The ordinary branch of
hci_update_accept_list_sync() traverses this list without that lock.
The request worker's req_lock does not serialize raw HCI completions,
and the RCU sections protect connection and pending-action lookups,
not the accept-list nodes.

Changing connectability can reach this iterator through
set_connectable_sync(), hci_update_connectable_sync(),
hci_update_passive_scan_sync() and hci_passive_scan_sync(). With a
populated mirror, a privileged raw HCI sender can issue
HCI_OP_LE_CLEAR_ACCEPT_LIST while request work is reconciling it:

  Request work                    HCI event work
  select b and successor t
                                  hci_cc_le_clear_accept_list()
                                    hci_dev_lock(hdev)
                                    hci_bdaddr_list_clear()
                                      unlink nodes and kfree(b)
                                    hci_dev_unlock(hdev)
  read b->bdaddr_type

The clear completion can therefore free the selected node before its
field read, or the saved successor before the iterator advances.
KASAN reported a one-byte read of bdaddr_type from the freed node.

Copy each entry's address and type under hdev->lock and reconcile the
private array instead. Release the mutex before issuing synchronous
commands, since their completion handlers also acquire it. Free the
copy after iteration and use the existing error path to disable
accept-list filtering if allocation fails.

This change has not been runtime-tested.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in hci_passive_scan_sync+0x1cc4/0x1f80
    Read of size 1 at addr ffff888105ee6c56 by task kworker/u17:1/499

    Workqueue: hci0 hci_cmd_sync_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? hci_passive_scan_sync+0x1cc4/0x1f80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? hci_passive_scan_sync+0x1cc4/0x1f80
     kasan_report+0xe0/0x110
     ? hci_passive_scan_sync+0x1cc4/0x1f80
     hci_passive_scan_sync+0x1cc4/0x1f80
     ? pmbd_gate_site_armed+0x31/0x1c0
     ? __pfx_hci_passive_scan_sync+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0x10/0x1c0
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ? hci_update_passive_scan_sync+0x43f/0x9e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x280
     hci_update_passive_scan_sync+0x473/0x9e0
     hci_update_connectable_sync+0x13c/0x250
     set_connectable_sync+0x39/0xb0
     hci_cmd_sync_work+0x1b3/0x450
     ? srso_alias_return_thunk+0x5/0xfbef5
     process_one_work+0x908/0x19c0
     ? __pfx_process_one_work+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_is_held_type+0x8f/0x100
     ? srso_alias_return_thunk+0x5/0xfbef5
     worker_thread+0x65c/0xe40
     ? __pfx_worker_thread+0x10/0x10
     kthread+0x34f/0x460
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_kthread+0x10/0x10
     ret_from_fork+0x659/0x940
     ? __pfx_ret_from_fork+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __switch_to+0x74f/0xf80
     ? __pfx_kthread+0x10/0x10
     ret_from_fork_asm+0x1a/0x30
     </TASK>

    Allocated by task 511:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     hci_bdaddr_list_add+0x179/0x390
     hci_cc_le_add_to_accept_list+0x189/0x2d0
     hci_cmd_complete_evt+0x373/0xab0
     hci_event_packet+0x4e8/0xc70
     hci_rx_work+0x367/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 511:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     kfree+0x307/0x580
     hci_bdaddr_list_clear+0x134/0x230
     hci_cc_le_clear_accept_list+0x80/0x1f0
     hci_cmd_complete_evt+0x373/0xab0
     hci_event_packet+0x4e8/0xc70
     hci_rx_work+0x367/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    The buggy address belongs to the object at ffff888105ee6c40
                                                                which
                                belongs to the cache kmalloc-32 of size 32
    The buggy address is located 22 bytes inside of
                                                                freed
                                32-byte region [ffff888105ee6c40,
                                ffff888105ee6c60)

    The buggy address belongs to the physical page:
        page: refcount:0 mapcount:0 mapping:0000000000000000
    index:0xffff888105ee69c0 pfn:0x105ee6
    flags: 0x200000000000200(workingset|node=0|zone=2)
    page_type: f5(slab)
        raw: 0200000000000200 ffff888100042780 ffffea0004187150
    ffffea00042534d0
        raw: ffff888105ee69c0 000000000040003f 00000000f5000000
    0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff888105ee6b00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
     ffff888105ee6b80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
    >ffff888105ee6c00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
                                                     ^
     ffff888105ee6c80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
     ffff888105ee6d00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
    ==================================================================

Fixes: e8907f76544f ("Bluetooth: hci_sync: Make use of hci_cmd_sync_queue set 3")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 53 ++++++++++++++++++++++++++++++++--------
 1 file changed, 43 insertions(+), 10 deletions(-)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b0536742a48ee..f7edd55b92e2b 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -2885,6 +2885,31 @@ static struct conn_params *conn_params_copy(struct list_head *list, size_t *n)
 	return p;
 }
 
+static struct conn_params *le_accept_list_copy(struct hci_dev *hdev,
+					       size_t *n)
+{
+	struct bdaddr_list *entry;
+	struct conn_params *params;
+	size_t i = 0;
+
+	hci_dev_lock(hdev);
+
+	*n = list_count_nodes(&hdev->le_accept_list);
+	params = kvzalloc_objs(struct conn_params, *n);
+	if (!params)
+		goto unlock;
+
+	list_for_each_entry(entry, &hdev->le_accept_list, list) {
+		bacpy(&params[i].addr, &entry->bdaddr);
+		params[i].addr_type = entry->bdaddr_type;
+		i++;
+	}
+
+unlock:
+	hci_dev_unlock(hdev);
+	return params;
+}
+
 /* Clear LE Accept List */
 static int hci_le_clear_accept_list_sync(struct hci_dev *hdev)
 {
@@ -2915,7 +2940,6 @@ static int hci_le_clear_accept_list_sync(struct hci_dev *hdev)
 static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 {
 	struct conn_params *params;
-	struct bdaddr_list *b, *t;
 	u8 num_entries = 0;
 	bool pend_conn, pend_report;
 	u8 filter_policy;
@@ -2980,20 +3004,27 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 	 * report. If not present in either list, then remove it from
 	 * the controller.
 	 */
-	list_for_each_entry_safe(b, t, &hdev->le_accept_list, list) {
+	params = le_accept_list_copy(hdev, &n);
+	if (!params) {
+		err = -ENOMEM;
+		goto done;
+	}
+
+	for (i = 0; i < n; i++) {
 		rcu_read_lock();
 
-		if (hci_conn_hash_lookup_le(hdev, &b->bdaddr, b->bdaddr_type)) {
+		if (hci_conn_hash_lookup_le(hdev, &params[i].addr,
+					    params[i].addr_type)) {
 			rcu_read_unlock();
 			continue;
 		}
 
 		pend_conn = hci_pend_le_action_lookup(&hdev->pend_le_conns,
-						      &b->bdaddr,
-						      b->bdaddr_type);
-		pend_report = hci_pend_le_action_lookup(&hdev->pend_le_reports,
-							&b->bdaddr,
-							b->bdaddr_type);
+						      &params[i].addr,
+						      params[i].addr_type);
+		pend_report = hci_pend_le_action_lookup(
+			&hdev->pend_le_reports, &params[i].addr,
+			params[i].addr_type);
 
 		rcu_read_unlock();
 
@@ -3001,14 +3032,16 @@ static u8 hci_update_accept_list_sync(struct hci_dev *hdev)
 		 * remove it from the acceptlist.
 		 */
 		if (!pend_conn && !pend_report) {
-			hci_le_del_accept_list_sync(hdev, &b->bdaddr,
-						    b->bdaddr_type);
+			hci_le_del_accept_list_sync(hdev, &params[i].addr,
+						    params[i].addr_type);
 			continue;
 		}
 
 		num_entries++;
 	}
 
+	kvfree(params);
+
 	/* Since all no longer valid accept list entries have been
 	 * removed, walk through the list of pending connections
 	 * and ensure that any new device gets programmed into
-- 
2.53.0



