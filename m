Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618221;
	b=haL04bZRY9RyXu5l1FpQEG5USezGeaygY1Ponz+Ty3EroPrIMty5S04yo3x9qa4EhMwT
	 m0RwR+L0cODNr3daDeoyUJ9Ea3JxzSjPDpkXpa90ukItbzSPOHsNfJzdDFeYneoLIAgBv
	 oauqSH3vUcJMGHYidvnSq8vinx/8b+mx0eb11ABWv0L3skJ1eJcJzBMM8j1RqDH3Umu0j
	 rkXbeTVTtcOiq9X725NHa4KXsw3T26HywmzfVUzz9nn6qWhX8B71rTDt3Hy40mM6nURTV
	 lHEHel0+N+Y7rZKJOy2ZiA1zxN+OpiEQAX4a0XVkqa3AvsN4ciIDpFvy5wsqsrN3dXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=okh3C1XM3CkrcOPmJK1ZU6n8yW3Ksy1RMGZf2U37HKc=;
	b=FGKZKEIJQVVfgC8fNlVtg2uZQs7BOG4XNS1TM40lWOOORnnserhemN0iv0pMKOenSku+
	 G0jdvuIdYkVUJpul76UFt0r1jDObJNJbu3RL8TwDhRsuh4bE9N8Q0VclmcF7TjB9KAs6w
	 HlFPRn2/eN26szVN7jFPjjSNmresL75NRVfhu/g7tYhM1J+lWyxKPuhMaQetiFNCPEp7p
	 YKjTNkfbV7KYHYMF/xgPmUH36l40NulANDQLd7nB9c+1EjtyXIjHOqMU1yKiqTRYC9EY6
	 1ezYwTKodEWrTZq89v2eIhAkwNAmCe2qrJ2JCzu0WMe+LbxrT7d4UEGhXVrvzVzIDSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KUxz/lPv";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F394606A323;
	Wed, 25 Nov 2026 14:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KUxz/lPv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45BE11F000C4;
	Wed, 25 Nov 2026 14:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618220;
	bh=okh3C1XM3CkrcOPmJK1ZU6n8yW3Ksy1RMGZf2U37HKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUxz/lPvcv8PxoraMdo1ufSa9ycdxOxiKbG7ntA2y/h3AZ6CYWy+RyiYkSNZhTo8m
	 vhz5X2x/yIbGYMQkgFm2T5t3wna3aXIwUxPIbDMyOCN2wdnOIOPKqY4NuNjih67NdV
	 h7WDbgHixtBnzU/+XDFjr/drLpvsOQ2Y597rWryE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0208/1005] Bluetooth: SMP: Protect link keys during LTK derivation
Date: Wed, 25 Nov 2026 15:25:46 +0100
Message-ID: <20261125143826.613160934@linuxfoundation.org>
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

[ Upstream commit ebc4f217c1fbe8364b5ef2ad8e3a8e9a1b2701a7 ]

sc_generate_ltk() reads the type and value of the peer link key after
hci_find_link_key() has returned. The finder ends its RCU read-side
section before returning the borrowed entry, and the SMP receive path
does not hold hdev->lock: l2cap_recv_acldata() releases it before the
PDU is dispatched. The L2CAP connection and channel locks held by SMP
do not serialize with management link-key removal.

When BR/EDR Secure Connections pairing derives an LTK from the stored
link key, MGMT_OP_LOAD_LINK_KEYS can free that key mid-derivation:

  HCI RX worker (SMP)              Management / RCU reclamation
  sc_generate_ltk()
    key = hci_find_link_key()
                                   load_link_keys()
                                     hci_dev_lock(hdev)
                                     hci_link_keys_clear(hdev)
                                       list_del_rcu(), kfree_rcu()
                                     hci_dev_unlock(hdev)
                                   grace period ends, key is freed
    read key->type
    smp_h6() or smp_h7() reads key->val

Hold an RCU read-side section from the lookup until the type and value
have been consumed. smp_h6() and smp_h7() only run the synchronous
AES-CMAC library code, which neither sleeps nor allocates. Release the
section before sc_add_ltk(), which allocates with GFP_KERNEL.

KASAN reported this on a test kernel whose scheduling hook paused the
receive worker after the lookup; the hook frames appear in the trace.

KASAN report as below:

    ==================================================================
    BUG: KASAN: slab-use-after-free in smp_distribute_keys+0x2983/0x2b70
    Read of size 1 at addr ffff88810618e9a6 by task kworker/u17:0/500

    CPU: 0 UID: 0 PID: 500 Comm: kworker/u17:0 Not tainted 7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: hci1 hci_rx_work
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     print_report+0xce/0x630
     ? smp_distribute_keys+0x2983/0x2b70
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __virt_addr_valid+0x20d/0x410
     ? smp_distribute_keys+0x2983/0x2b70
     kasan_report+0xe0/0x110
     ? smp_distribute_keys+0x2983/0x2b70
     smp_distribute_keys+0x2983/0x2b70
     ? __pfx_smp_distribute_keys+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_gate_maybe+0x47/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xee/0x1c0
     ? __pfx_pmbd_probe_hit_cookie+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __asan_memset+0x23/0x50
     ? smp_recv_cb+0x12e2/0x8f30
     ? srso_alias_return_thunk+0x5/0xfbef5
     smp_recv_cb+0x12e2/0x8f30
     ? __pfx_smp_recv_cb+0x10/0x10
     ? __pfx___might_resched+0x10/0x10
     ? __pfx_sched_balance_find_src_group+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mutex_lock+0x182c/0x2590
     ? l2cap_recv_frame+0x9ef/0x8830
     ? __pfx___mutex_lock+0x10/0x10
     ? __lock_acquire+0x466/0x2260
     ? __pfx_l2cap_chan_hold_unless_zero+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? l2cap_recv_frame+0x13cc/0x8830
     ? __pfx_smp_recv_cb+0x10/0x10
     l2cap_recv_frame+0x13cc/0x8830
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mutex_lock+0x182c/0x2590
     ? __pfx_l2cap_recv_frame+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? find_held_lock+0x2b/0x80
     ? l2cap_recv_acldata+0x1eb/0x10e0
     ? __pfx___mutex_lock+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __mutex_unlock_slowpath+0x147/0x920
     ? __pfx_l2cap_conn_hold_unless_zero+0x10/0x10
     ? __pfx_hci_conn_enter_active_mode+0x10/0x10
     ? l2cap_recv_acldata+0x13d/0x10e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     l2cap_recv_acldata+0xe9f/0x10e0
     ? srso_alias_return_thunk+0x5/0xfbef5
     hci_rx_work+0x5a6/0xf00
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

    Allocated by task 500:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     __kasan_kmalloc+0xaa/0xb0
     __kmalloc_cache_noprof+0x251/0x610
     hci_add_link_key+0x474/0x840
     hci_link_key_notify_evt+0x492/0xce0
     hci_event_packet+0x894/0xc70
     hci_rx_work+0x367/0xf00
     process_one_work+0x908/0x19c0
     worker_thread+0x65c/0xe40
     kthread+0x34f/0x460
     ret_from_fork+0x659/0x940
     ret_from_fork_asm+0x1a/0x30

    Freed by task 0:
     kasan_save_stack+0x33/0x60
     kasan_save_track+0x14/0x30
     kasan_save_free_info+0x3b/0x60
     __kasan_slab_free+0x5f/0x80
     __rcu_free_sheaf_prepare+0x65/0x2a0
     rcu_free_sheaf+0x1f/0xe0
     rcu_core+0x661/0x1d10
     handle_softirqs+0x201/0x930
     __irq_exit_rcu+0x110/0x1e0
     irq_exit_rcu+0xe/0x20
     sysvec_apic_timer_interrupt+0x6c/0x80
     asm_sysvec_apic_timer_interrupt+0x1a/0x20

    The buggy address belongs to the object at ffff88810618e980
     which belongs to the cache kmalloc-64 of size 64
    The buggy address is located 38 bytes inside of
     freed 64-byte region [ffff88810618e980, ffff88810618e9c0)

    The buggy address belongs to the physical page:
    page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10618e
    flags: 0x200000000000000(node=0|zone=2)
    page_type: f5(slab)
    raw: 0200000000000000 ffff8881000428c0 dead000000000122 0000000000000000
    raw: 0000000000000000 0000000000200020 00000000f5000000 0000000000000000
    page dumped because: kasan: bad access detected

    Memory state around the buggy address:
     ffff88810618e880: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810618e900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    >ffff88810618e980: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                                   ^
     ffff88810618ea00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
     ffff88810618ea80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
    ==================================================================

Fixes: b5ae344d4c0f ("Bluetooth: Add full SMP BR/EDR support")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/smp.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 0e6f3adb0bf26..d783126076ee7 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -1184,9 +1184,13 @@ static void sc_generate_ltk(struct smp_chan *smp)
 	struct hci_conn *hcon = smp->conn->hcon;
 	struct hci_dev *hdev = hcon->hdev;
 	struct link_key *key;
+	int err;
+
+	rcu_read_lock();
 
 	key = hci_find_link_key(hdev, &hcon->dst);
 	if (!key) {
+		rcu_read_unlock();
 		bt_dev_err(hdev, "no Link Key found to generate LTK");
 		return;
 	}
@@ -1198,16 +1202,19 @@ static void sc_generate_ltk(struct smp_chan *smp)
 		/* SALT = 0x000000000000000000000000746D7032 */
 		const u8 salt[16] = { 0x32, 0x70, 0x6d, 0x74 };
 
-		if (smp_h7(key->val, salt, smp->tk))
-			return;
+		err = smp_h7(key->val, salt, smp->tk);
 	} else {
 		/* From core spec. Spells out in ASCII as 'tmp2'. */
 		const u8 tmp2[4] = { 0x32, 0x70, 0x6d, 0x74 };
 
-		if (smp_h6(key->val, tmp2, smp->tk))
-			return;
+		err = smp_h6(key->val, tmp2, smp->tk);
 	}
 
+	rcu_read_unlock();
+
+	if (err)
+		return;
+
 	if (smp_h6(smp->tk, brle, smp->tk))
 		return;
 
-- 
2.53.0



