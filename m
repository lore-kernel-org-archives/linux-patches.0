Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026736;
	b=zR8BBE2+2/4I/9kqsfVP9YMtQWmcJ+C0l06swg+tMTFisXhIxYk6V/aM0oimW7W+rF5s
	 jjj7HTO4sbrt4I/AZni9ZHWzCYJ3IMKs8JO779pujeRNd68rtgnElV+a+aGRBksFt/LhT
	 CxfVFQYgoXwXQHlFEkQ9yOoPyOiEhIM3xfW3tDgmKJGHBOZV6/aQLohyUjnnmccEIKTnj
	 V5yHYBW0czFyruJjg3FzJTgKJn8HcuJCX//nZQi5jZe6suZWBARPi8cw8HZefAYQNmjTA
	 ZkgvQqZu1FAb7AmfsE0rUoA4+h8W1a7k3KaT7mAKzOLe7fJt3xgwIiHfbvKDKQNPQfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026736;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wZzdaIyHhlEo53W1610nFEhyjIqT+3KS3gYnUNRuX9g=;
	b=gpLtFQROOg5fBc4uDoriX9zdkI/WTkBaXXzX806q4XpD/qReM5iLKfqANTd6CbT8lYr0
	 t7WV9ysh5RF0dqgki3R4v04xK6yVHFlNTFZqY6VywJi7qCagqjwY1l8rbL/DyGN0IdHG4
	 Rmtj0a35u7XXi+3lqou48IS02HgMDtR9CXpG64ZI5xch4FHShHXoREjawFU8LY4dahMcZ
	 wMOtOdLmOgwFbMWSZO6OSFiFZfWZW9zYr9ZgSPxzzD/qcTF3YJLJ4XwAw2haJZqEajyS/
	 TMG5zwakkL4pA3PCK4MSkuba+eZYgufSKiw5JoGYeIGsO48LBXhGPYtNs1zYkCE8Itw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2lPHYJg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5BC4606A31C;
	Wed, 18 Nov 2026 18:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r2lPHYJg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 267951F000C4;
	Wed, 18 Nov 2026 18:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026736;
	bh=wZzdaIyHhlEo53W1610nFEhyjIqT+3KS3gYnUNRuX9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r2lPHYJg99eg4j4EbVEiNZEMgQGui3BO1v9xwnprZ9l44aEuHP5p4U1sgCi4kB4T4
	 u05qw8CgZXunuK6L3tPf71mRd0iK4xgH2Zs0h9aJ2SU+IU/+ft5sJJLqfx9ly8A6z5
	 OYBv4h+UGidkJLzZGi6yYAibltRSVgodE52hFOiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1540/2151] Bluetooth: hci_sync: Serialize devcoredump reset during device open
Date: Wed, 18 Nov 2026 15:54:35 +0100
Message-ID: <20261118150217.970255408@linuxfoundation.org>
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

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 6d91353f6dbcc5c4fbb47bbd0c7f885453cfc939 ]

An ACTIVE devcoredump's buffer cursors must remain valid from the
packet handler's state check through its copy. hci_devcd_rx() holds
hdev->lock across that interval, and hci_devcd_reset() requires the
same lock. However, hci_dev_open_sync() invokes reset without taking
it.

A registered VHCI controller can collect a dump through its debugfs
interface while the controller is down. If a successful open overlaps
with handling a nonempty dump packet, reset can run after the receiver's
ACTIVE check and before its copy:

  hci_devcd_rx()                    hci_dev_open_sync()
    dequeue nonempty skb
    hci_dev_lock(hdev)
    handler observes ACTIVE
                                     hdev->open(hdev) succeeds
                                     hci_devcd_reset(hdev)
                                       dump.tail = NULL
                                       dump.state = IDLE
    hci_devcd_copy()
      compare against old dump.end
      memcpy(NULL, ..., skb->len)
    hci_dev_unlock(hdev)

Reset leaves dump.end pointing at the old buffer and purges only queued
packets, so it cannot discard the skb already dequeued by the receiver.
The bounds check can pass with a NULL tail, leading to a nonempty copy
to address zero. KASAN reported a 24-byte NULL write in hci_devcd_rx().

Take hdev->lock around the open-time reset. The receiver then finishes
its state check and copy using valid cursors before reset, or observes
IDLE after reset and skips the copy.

KASAN report as below:

    BUG: KASAN: null-ptr-deref in hci_devcd_rx+0x5d5/0x1a80
    Write of size 24 at addr 0000000000000000 by task kworker/u17:0/496

        CPU: 0 UID: 0 PID: 496 Comm: kworker/u17:0 Not tainted
    7.2.0-rc6-pmb-bt-functional-v1+ #1 PREEMPT(lazy)
        Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps
    fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
    Workqueue: hci0 hci_devcd_rx
    Call Trace:
     <TASK>
     dump_stack_lvl+0x93/0xd0
     kasan_report+0xe0/0x110
     ? hci_devcd_rx+0x5d5/0x1a80
     kasan_check_range+0x105/0x1b0
     __asan_memcpy+0x3c/0x60
     hci_devcd_rx+0x5d5/0x1a80
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? __pfx_hci_devcd_rx+0x10/0x10
     ? srso_alias_return_thunk+0x5/0xfbef5
     ? lock_release+0xc8/0x280
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
    ==================================================================
    Disabling lock debugging due to kernel taint

Fixes: 9695ef876fd1 ("Bluetooth: Add support for hci devcoredump")
Assisted-by: LLM
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_sync.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index b592dd152b5a9..bff27bcf9d4e6 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5347,7 +5347,9 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_dev_lock(hdev);
 	hci_devcd_reset(hdev);
+	hci_dev_unlock(hdev);
 
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
-- 
2.53.0



