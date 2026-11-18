Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049966;
	b=k9pUdm2YwxmVey1e45NeNtUqSKm4doyPU7D3JsVpUr045oJ7uNY10AYONnNnkylG9Nkn
	 pd9M4Z0fCfzFKzRXr+vha/lz8+z8A09GKM4Qb8dkSUhF7NRsgLj/DCrPvjkBU+HTb2/3Y
	 gQ7gzv3nGswq7dy8GY3TZMQ8oqIYzHP5YQ5hP0/PjJOQNpfPwb955sP/tivyIWdRI2nH0
	 Rk+CUj1zXrKfw6VzenoooV/EDGdMmqG1R7TlAkFYPzp27tgWdOxNvyG0/qO2VFzoU+KYF
	 F1MDmM9vrJmsSYYB5HCexm9XBJl2mTFhzKMHDDqg4G17lRMcf+2kEZdM4Z/4oM77c+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=82ACdM5tSG0KVO0jiHS+b11FQeXA8JAIfUJv14Irs9M=;
	b=zApZ8TJzyayHnNUd4DNd6Ih9p66/CfmcnzdwhH+leOKH/4pAePaUSYGNhku81C+zDLRP
	 yTDR1tZLC8kbu6KZx9zJYFOWAIye5cB8zdreE7XAcTB/WSzgvaoKkLIevVWHVGdzXee9D
	 696ju7guJNJdwKYz4oPJ7My2pb+KR6K2qc8HNXT9xB9GMrc8xELChGbEVruN3d6gAFxh0
	 u6HuNFXdbXmHs/vpfHssVnQ/+6ANkui1n7SqEz/26BaKUjLg2kYt56p7uM2AjdX6GkdWP
	 JyShlx6g4xP65CDtugpl3SP/40v+jDCh83omd8TwF8MzLwGMLzmG+Aec7ZKEe8N9WuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VT9UveVS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880F8606A32A;
	Thu, 19 Nov 2026 00:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VT9UveVS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62241F000C4;
	Thu, 19 Nov 2026 00:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049966;
	bh=82ACdM5tSG0KVO0jiHS+b11FQeXA8JAIfUJv14Irs9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VT9UveVSpYNgW67dqPg7ZANTMnQweaob4yrxytUJ/3YNTan/NUjlUT+DGDegbuc50
	 gEOUhvgYxu6dbcS32FHCftMLF82MERHz4G1RY6Qgh7od41dqBQcoG+1AQi0zMy54HB
	 5nKP1UVK2XgWWmodAYB0c/wh76nIVtRlTs6aMiik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2499/2857] Bluetooth: MGMT: Reject quality report requests during unregister
Date: Wed, 18 Nov 2026 15:58:53 +0100
Message-ID: <20261118150331.536356938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 1e05c1bbdbd3c..574ef8bc7845d 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4847,6 +4847,13 @@ static int set_quality_report_func(struct sock *sk, struct hci_dev *hdev,
 
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



