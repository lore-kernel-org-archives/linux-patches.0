Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049960;
	b=ceuTl5x7UuvFHf6ZT2JdthEUJfhqg+8PmKmNLZhPO2mS6MH3Vx0TKYaSYRcUH7TCRyKb
	 uKdG2xFrLAlK8WgpSMoFUC0tVibYKwSMZ1OjQ6j40ApQPOiDd7kNjHmGWdq87uwg0yb8X
	 f9WWX7tvy8272Mwn6jzxtrq6bMEgq7Aq+v2OktQ6eFF+tcDse+MhS5DnCWQC/LTIeoklm
	 DW2E2LqUkLAIxct0NMdClGgN7Od4mxJ71L/F0yTdQrgi0WL2Pal+lbww2xE6C5QmaMfXb
	 hJBtEi7MMCa4/YQ0fTYqW8G+l6z2nLuXCG21VYKE2g2jNOk3q9Vw375QyFHZg26c7KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HAn+0e93pTNwkmHlpBveV3JWR6DshxNE1pijWFKcHIE=;
	b=5hi5OE2qFGVeV42ZoLNEFU2D7eh4jKdW2QqENvpeWUcDBXvN1Zr1L65Cu98U//wkn9i+
	 sNmK2NySSUZ/T4vR7IQGsjsBWacmufGqYfX+yTlXuudNNTuY7dDNoXORo/+YxYG4HSp6l
	 UEuRRtK1tlAfRabNKLggI+OWtlgY8UNpQjxzpGf5Vq1Bs1676zG59OGLQWMrJvNC/93Tt
	 S6HVPuv70H+GKOR+8ZoIxRoFT+oGn5aqASapIBp7+tbdQeepecZpMUAzlFD+VeSsD4znt
	 65fW+ngFp+q4oG1endkM/jRy8aG8QhwBwdC6tjs6Xl4qZPbq61d6YgUGfWwarA7PpVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anNSpGP+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E0F606A325;
	Thu, 19 Nov 2026 00:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anNSpGP+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193841F000C4;
	Thu, 19 Nov 2026 00:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049960;
	bh=HAn+0e93pTNwkmHlpBveV3JWR6DshxNE1pijWFKcHIE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anNSpGP+EFthdJIutbpmR5KL11bUMCmyVRP6D0zhcxRjxi6GZgT+oFdAr4mTrWePI
	 ahmQXAzCwcUZ40zfwK/6iWpW6EcMfstYoKRH03sBanmmpfzMpgY5EJ6MbmPZtK0Wc1
	 ZFxPOQNr7BRbgq8Cj7Q6EjHbVVVi4S2evH4ENeqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2497/2857] Bluetooth: hci_sync: Serialize devcoredump reset during device open
Date: Wed, 18 Nov 2026 15:58:51 +0100
Message-ID: <20261118150331.465611192@linuxfoundation.org>
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
index 7b3b256adf276..dbed234626fd3 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -5221,7 +5221,9 @@ int hci_dev_open_sync(struct hci_dev *hdev)
 		goto done;
 	}
 
+	hci_dev_lock(hdev);
 	hci_devcd_reset(hdev);
+	hci_dev_unlock(hdev);
 
 	set_bit(HCI_RUNNING, &hdev->flags);
 	hci_sock_dev_event(hdev, HCI_DEV_OPEN);
-- 
2.53.0



