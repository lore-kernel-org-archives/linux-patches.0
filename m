Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214664;
	b=FS3wKDNmyOo+jlS3DTAPGVKDGmJlKtpoNHEsu4s4sAP5ekH8Wf8Abv/nE45Q10ALT6q/
	 bWHxKOfU3ctXERUqUH9fpM8FZm4V7vCDzJYfUKVJT/WPKLqnEevOddN2LuyV1xv+13N37
	 iGxxGe2LJ4q80ug336nDQiLAxbtvxIMQCn+x8UNBDbVpuBCeycUDhnG/NCITS8yXaj1NB
	 eFsV29pF3pHZX9HAH9K+STXIojivYxTv7UwUw9TkulJPvtOl/V4XiyF+uNcBxNXjEjCqi
	 LhPKqD4taFsn0RCI85zEw9VAjC6mvoXBJUp5hwF8RG2NjQqZErwtUej2aLWE7ZzOQwg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214664;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YmnLsest+gyq3hZGhiGMtbNo4BaXWdnC1TSWtmWTafs=;
	b=dzaUbA/UdE/pgVY0qzAFp/qO6VlnVf8JqYytXIpYw5RBqKOwxpzcLHVtf3GHNUEgVG2r
	 R0pb7e8U/ZLqe+Esag3jBd6mjzQn9R4KdK8hflxBqDtY76ME61aLvYq5T8SVxo/jm2cm2
	 vSKyWxZLLIMWd6kbTNcWNEG2ujK6PUClN0KxXkKcn3Pj+EDK3DqF0IgeLi6JHMMBiTP2l
	 QBf9uY/3chogf5UEz0AHou1Q29h8JZy+2g9qL942bW3aZRuUVq84TEtU7kYpfKtJk4uNM
	 wwFzBoYBFsc0+iKqDGNCbkRqkmm8XBYhgwMIHFI/ZPohXndatPKyP7/5NlaIlVkwSgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azsohrL+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C9C606B7CF;
	Wed, 28 Oct 2026 19:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=azsohrL+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2FAF1F031E0;
	Wed, 28 Oct 2026 19:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214663;
	bh=YmnLsest+gyq3hZGhiGMtbNo4BaXWdnC1TSWtmWTafs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=azsohrL+urCactZKVrCJc3XwCzHspS4HQ5WLyH+/NrNa6lhPcdBhBsU4SEH6gQT7q
	 RUJoqo5zyknYxXqMMZ5m8NojmBsiGKMhpFOJBUHf8Rkzsq0kMvsw9pJGnB7BmH3XUg
	 e/KtSpKS+XgyyBpiN2kUoCIDZ8cgS8I1g1Plvkvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0937/1887] nfc: nci: complete pending data exchange on device close
Date: Wed, 28 Oct 2026 17:50:33 +0100
Message-ID: <20261028170520.735555481@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 66083581945bd5b8e99fe49b5aeb83d03f62d053 ]

In nci_close_device(), complete any pending data exchange before
closing. The data exchange callback (e.g.
rawsock_data_exchange_complete) holds a socket reference.

NIPA occasionally hits this leak:

unreferenced object 0xff1100000f435000 (size 2048):
  comm "nci_dev", pid 3954, jiffies 4295441245
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    27 00 01 40 00 00 00 00 00 00 00 00 00 00 00 00  '..@............
  backtrace (crc ec2b3c5):
    __kmalloc_noprof+0x4db/0x730
    sk_prot_alloc.isra.0+0xe4/0x1d0
    sk_alloc+0x36/0x760
    rawsock_create+0xd1/0x540
    nfc_sock_create+0x11f/0x280
    __sock_create+0x22d/0x630
    __sys_socket+0x115/0x1d0
    __x64_sys_socket+0x72/0xd0
    do_syscall_64+0x117/0xfc0
    entry_SYSCALL_64_after_hwframe+0x4b/0x53

Fixes: 38f04c6b1b68 ("NFC: protect nci_data_exchange transactions")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index bc5f7068e6db1..bfbe405a474eb 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -566,6 +566,10 @@ static int nci_close_device(struct nci_dev *ndev)
 		flush_workqueue(ndev->cmd_wq);
 		del_timer_sync(&ndev->cmd_timer);
 		del_timer_sync(&ndev->data_timer);
+		if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+			nci_data_exchange_complete(ndev, NULL,
+						   ndev->cur_conn_id,
+						   -ENODEV);
 		mutex_unlock(&ndev->req_lock);
 		return 0;
 	}
@@ -596,6 +600,11 @@ static int nci_close_device(struct nci_dev *ndev)
 	flush_workqueue(ndev->cmd_wq);
 
 	del_timer_sync(&ndev->cmd_timer);
+	del_timer_sync(&ndev->data_timer);
+
+	if (test_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+		nci_data_exchange_complete(ndev, NULL, ndev->cur_conn_id,
+					   -ENODEV);
 
 	/* Clear flags except NCI_UNREG */
 	ndev->flags &= BIT(NCI_UNREG);
-- 
2.53.0



