Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041652;
	b=KIVtn5FqVYaW607OPZwVeH2oT++cM1MvfmIuVw9wsiJ6b519xis8xl9DLnz1OuIH9U8/
	 KC3MfeI8fTAL8sGv8JEAOg8dJDkLgHA6GUrLl6yUqG8ADxZ630E07PobFYIIjoIM1dJM0
	 gjoCRcVIXcuXx49ugDLTw4A9xexHy76cyspCWzEsivnajJSZjJu3dUEksRcfLD5kNys9i
	 chdAuXZZJ8S7/5Vps37psqeswl3ZGg/wopRQiHgm1uS6W0/eQe1qgu7YTSlLSn49HfMmA
	 3qECkzfSQBZKB3j1bmd95YB3VhoJKmzEXnLE653Mcr2mG0ygmZpwjp+jLGMtz7O/D0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGMLYKwV6buCNlRvwuD+/ssuYHaAaYWXMsI/cc1EaTs=;
	b=jsPc0uU+Fsyh4q6wfH7LyRoGwj1UMZ5rQCrA5F/EcB71jfFTT19e1yaELfyYKG/yKlng
	 NqNvgmDVXRJsxPm7n0Liw7WfHRhS+cGN4Q/sQVe4baGV4CpBGjn+6DzsaIrSrfz3yPEtB
	 CVHSPjFtvr1J5g80sn9NlMifnKFhLrWzevY8v3NQimkQPAIn5xHXO4XwrTHCRKaEbmZXG
	 pWAJbSP/B4p1jrUks2L8vXGWcizn0txhFFseB+mdJ5dScY8RV4TZlKWau371RA5SRRRlB
	 3qunyMu1sKxxuCfj98yWmd+0pr98+uKmodCH8OQY2FmmyB7L8/D53GsHq4jybcgLPeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="nfTYbCE/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61AAA606A31C;
	Wed, 18 Nov 2026 22:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nfTYbCE/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A491F000C4;
	Wed, 18 Nov 2026 22:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041652;
	bh=nGMLYKwV6buCNlRvwuD+/ssuYHaAaYWXMsI/cc1EaTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nfTYbCE/jCwxfYeurb3mj4Y7yBQaRnCWnC5NOSOBToWa9VBNBPNJ3Ueq24LszlWXv
	 RIBX1cJA7Y2N2ICQgnxk4TwNjjwECaDiu+z3yRuD7hO58XT9PylnfJaODBuzZYhC/i
	 yd+upUryd6m1qtJA8r1bUdd3k4L3OdcFkzOgiywY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2888/3318] Bluetooth: MGMT: Reject quality report requests during unregister
Date: Wed, 18 Nov 2026 15:58:30 +0100
Message-ID: <20261118150447.158097984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 213e7a99bea19e2f29f394321b86c792eec73a24 ]

A quality report request must not call a driver callback after its
module text has been released. hci_mgmt_cmd() holds an hci_dev reference
through set_exp_feature(), but that reference only preserves the device
allocation. set_quality_report_func() takes req_lock and invokes
hdev->set_quality_report without checking HCI_UNREGISTER.

This is unsafe when a SET_EXP_FEATURE request for an Intel controller
would change HCI_QUALITY_REPORT and is delayed before taking req_lock
while the controller is removed. With btintel_pcie and btintel built as
modules and no other btintel dependents, the following order is
possible:

  Management request                Removal and module unload
  ------------------                -------------------------
  hci_mgmt_cmd(): retain hdev
                                    hci_unregister_dev():
                                      set HCI_UNREGISTER
                                      remove hdev from lookup
                                      close under req_lock
                                      release req_lock
                                    btintel_pcie_remove(): return
                                    unload btintel_pcie, then btintel
  set_quality_report_func():
    take req_lock
    call hdev->set_quality_report

When the request resumes after btintel unload, the indirect call targets
released module text and can cause an instruction-fetch page fault. The
close operation serializes with a running callback but does not prevent
a delayed management handler from invoking it afterwards.

Check HCI_UNREGISTER immediately after acquiring the existing req_lock
and return MGMT_STATUS_INVALID_INDEX via the common unlock path. If
unregister passed its close section first, the request now rejects the
removed controller before accessing the callback. If the request passes
the check first, hci_dev_do_close() must wait for req_lock until the
callback has returned, so unregister cannot finish before the use.

Oops report as below:

    BUG: unable to handle page fault for address: ffffffffc0408e10
    #PF: supervisor instruction fetch in kernel mode
    #PF: error_code(0x0010) - not-present page
    PGD 80a9067 P4D 80a9067 PUD 80ab067 PMD 0
    Oops: Oops: 0010 [#1] SMP KASAN NOPTI
    CPU: 1 UID: 0 PID: 439 Comm: btmgmt Tainted: G           O        7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
    Tainted: [O]=OOT_MODULE
    Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    RIP: 0010:0xffffffffc0408e10
    Code: Unable to access opcode bytes at 0xffffffffc0408de6.
    RSP: 0018:ffff888110927838 EFLAGS: 00010293
    RAX: 0000000000000000 RBX: 1ffff11022124f0c RCX: ffffffff85b1a1b6
    RDX: ffff888117511d00 RSI: 0000000000000001 RDI: ffff888117598000
    RBP: ffff888110927950 R08: 0000000000000001 R09: 0000000000000001
    R10: ffffffff893d3057 R11: ffff888117511d00 R12: ffff888117598000
    R13: 0000000000000001 R14: ffffffffc0408e10 R15: ffff888117599970
    FS:  00007f15453f2040(0000) GS:ffff8881fd852000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffffc0408de6 CR3: 000000010b832005 CR4: 0000000000770ef0
    PKRU: 55555554
    Call Trace:
     <TASK>
     ? set_quality_report_func+0x232/0x660
     ? __pfx_set_quality_report_func+0x10/0x10
     ? pmbd_gate_maybe+0x47/0x60
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xe7/0x1c0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? pmbd_probe_hit_cookie+0xee/0x1c0
     set_exp_feature+0xf7/0x260
     ? set_exp_feature+0xf7/0x260
     ? hci_sock_sendmsg+0x12b2/0x2400
     ? __pfx_hci_sock_sendmsg+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? selinux_socket_sendmsg+0x160/0x280
     ? sock_write_iter+0x4c0/0x550
     ? __pfx_hci_sock_sendmsg+0x10/0x10
     ? __pfx_sock_write_iter+0x10/0x10
     ? __file_has_perm+0x25e/0x420
     ? __pfx___file_has_perm+0x10/0x10
     ? do_iter_readv_writev+0x59c/0x860
     ? __pfx_do_iter_readv_writev+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? security_file_permission+0x26/0x80
     ? vfs_writev+0x30e/0xc10
     ? __pfx_vfs_writev+0x10/0x10
     ? __pfx_do_epoll_wait+0x10/0x10
     ? __pfx_do_epoll_ctl+0x10/0x10
     ? do_writev+0x241/0x2f0
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? do_writev+0x241/0x2f0
     ? __pfx_do_writev+0x10/0x10
     ? irqentry_exit+0xbe/0x820
     ? do_syscall_64+0x115/0x6a0
     ? entry_SYSCALL_64_after_hwframe+0x77/0x7f
     </TASK>
    Modules linked in: [last unloaded: btintel(O)]
    CR2: ffffffffc0408e10
    ---[ end trace 0000000000000000 ]---
    RIP: 0010:0xffffffffc0408e10
    Code: Unable to access opcode bytes at 0xffffffffc0408de6.
    RSP: 0018:ffff888110927838 EFLAGS: 00010293
    RAX: 0000000000000000 RBX: 1ffff11022124f0c RCX: ffffffff85b1a1b6
    RDX: ffff888117511d00 RSI: 0000000000000001 RDI: ffff888117598000
    RBP: ffff888110927950 R08: 0000000000000001 R09: 0000000000000001
    R10: ffffffff893d3057 R11: ffff888117511d00 R12: ffff888117598000
    R13: 0000000000000001 R14: ffffffffc0408e10 R15: ffff888117599970
    FS:  00007f15453f2040(0000) GS:ffff8881fd852000(0000) knlGS:0000000000000000
    CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
    CR2: ffffffffc0408de6 CR3: 000000010b832005 CR4: 0000000000770ef0
    PKRU: 55555554
    Kernel panic - not syncing: Fatal exception
    Kernel Offset: disabled
    Rebooting in 1 seconds..

Fixes: ae7d925b5c04 ("Bluetooth: Support the quality report events")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/mgmt.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 23dd8a68c372f..3307a86709280 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4917,6 +4917,13 @@ static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
 
 	hci_req_sync_lock(hdev);
 
+	if (hci_dev_test_flag(hdev, HCI_UNREGISTER)) {
+		err = mgmt_cmd_status(sk, hdev->id,
+				      MGMT_OP_SET_EXP_FEATURE,
+				      MGMT_STATUS_INVALID_INDEX);
+		goto unlock_quality_report;
+	}
+
 	val = !!cp->param[0];
 	changed = (val != hci_dev_test_flag(hdev, HCI_QUALITY_REPORT));
 
-- 
2.53.0



