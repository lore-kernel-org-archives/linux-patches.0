Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214799;
	b=3Mo/sGBBp43S4p+xQ85whseDcOICk6iDYioYfsq8Yp5Cjlq6cBouAcH4dfA/99E6lmP5
	 L/r/xPiq3d32PQKPZB8IzkV3T9arKrp+qqTFpGzqMfBHBQxTNuGj1kJfZ9ifQf/N2Wdon
	 /NiVtTygAjj9MVtp8sdoTBHrEQpfPEk4Dh6jBDBeOfyckzgYsA4opOBtAqW6uK0bLOyge
	 CI9HDuKV57uU5YVYVLdZQzq2/BsDVzvwFT1nxeA0PCQ+EtK0sOMot3pw/n3WXzS3E7Ydy
	 lqoFPH+w4DtR9ZeoqdhuSWFD02ETKcx4AiZZHF/+/uM4S9C7kPcQE2i5xh0Xmxn2XuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214799;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PBxBV+7q6J1XmCq/sDdAy4fnl4baTRk4YQ4lrd6TXdM=;
	b=WpAZ0Xa3KagRJlNb+o1cfYOp3EevHtXMRnU6MIYwJ88mfniLPgM2E4lUI+O7sPm3hQI6
	 MlOxMcvalVixYmqLkaQB/+HoBs5LtB9gZJrHDVT1zQiAmRmcarTkwbxbufG8mvU63+yh4
	 DWjOaM+eAS8B4tq44TRNF3JQuEBnXXkFJLhPN0YOnWJZuL8iO8q0YX+uBIyVOJUsmPdWQ
	 llMBxIwykVS0NiKqfVCUMg3CmG/QF+ujSfnbf0S0G2hbkXLuqqBXSdo1+Uan5qye2vAUD
	 MXYZR4CdSftGsuX5OuNuBeabAEs67nz88qCzL+omdOSjjdGocMo/G701sfdc4ssDt2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1OpGDQsA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463C0606A335;
	Wed, 28 Oct 2026 19:13:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1OpGDQsA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962AA1F01825;
	Wed, 28 Oct 2026 19:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214799;
	bh=PBxBV+7q6J1XmCq/sDdAy4fnl4baTRk4YQ4lrd6TXdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1OpGDQsAWCjRBQ3MnseWSXcCl6Sb5d4+D8cf9YBEFdeUy8AI0bFS8zPGWjA/Yafl4
	 L9HPwyrZ2iQz/Fz5gmKCbteBjlwGgyCJ/d4uqgiMDiBnLkdm+v8JrDjrRerezwvqf+
	 lfxEOAU6Y5Y2l+rgafGZWhrefAqM+hSgyOqPijXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cen Zhang <zzzccc427@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0985/1887] Bluetooth: hci_sync: annotate data-races around hdev->req_status
Date: Wed, 28 Oct 2026 17:51:21 +0100
Message-ID: <20261028170521.825076390@linuxfoundation.org>
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

[ Upstream commit b6807cfc195ef99e1ac37b2e1e60df40295daa8c ]

__hci_cmd_sync_sk() sets hdev->req_status under hdev->req_lock:

    hdev->req_status = HCI_REQ_PEND;

However, several other functions read or write hdev->req_status without
holding any lock:

  - hci_send_cmd_sync() reads req_status in hci_cmd_work (workqueue)
  - hci_cmd_sync_complete() reads/writes from HCI event completion
  - hci_cmd_sync_cancel() / hci_cmd_sync_cancel_sync() read/write
  - hci_abort_conn() reads in connection abort path

Since __hci_cmd_sync_sk() runs on hdev->req_workqueue while
hci_send_cmd_sync() runs on hdev->workqueue, these are different
workqueues that can execute concurrently on different CPUs. The plain
C accesses constitute a data race.

Add READ_ONCE()/WRITE_ONCE() annotations on all concurrent accesses
to hdev->req_status to prevent potential compiler optimizations that
could affect correctness (e.g., load fusing in the wait_event
condition or store reordering).

Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_request.c |  2 +-
 net/bluetooth/hci_sync.c    | 20 ++++++++++----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index cf69e973b724f..303fb14fdfad9 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -46,7 +46,7 @@ void hci_req_purge(struct hci_request *req)
 
 bool hci_req_status_pend(struct hci_dev *hdev)
 {
-	return hdev->req_status == HCI_REQ_PEND;
+	return READ_ONCE(hdev->req_status) == HCI_REQ_PEND;
 }
 
 static int req_run(struct hci_request *req, hci_req_complete_t complete,
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 4295c803cfd4a..9529dd7e2a352 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -24,11 +24,11 @@ static void hci_cmd_sync_complete(struct hci_dev *hdev, u8 result, u16 opcode,
 {
 	bt_dev_dbg(hdev, "result 0x%2.2x", result);
 
-	if (hdev->req_status != HCI_REQ_PEND)
+	if (READ_ONCE(hdev->req_status) != HCI_REQ_PEND)
 		return;
 
 	hdev->req_result = result;
-	hdev->req_status = HCI_REQ_DONE;
+	WRITE_ONCE(hdev->req_status, HCI_REQ_DONE);
 
 	if (skb) {
 		struct sock *sk = hci_skb_sk(skb);
@@ -163,20 +163,20 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	hci_cmd_sync_add(&req, opcode, plen, param, event, sk);
 
-	hdev->req_status = HCI_REQ_PEND;
+	WRITE_ONCE(hdev->req_status, HCI_REQ_PEND);
 
 	err = hci_req_sync_run(&req);
 	if (err < 0)
 		return ERR_PTR(err);
 
 	err = wait_event_interruptible_timeout(hdev->req_wait_q,
-					       hdev->req_status != HCI_REQ_PEND,
+					       READ_ONCE(hdev->req_status) != HCI_REQ_PEND,
 					       timeout);
 
 	if (err == -ERESTARTSYS)
 		return ERR_PTR(-EINTR);
 
-	switch (hdev->req_status) {
+	switch (READ_ONCE(hdev->req_status)) {
 	case HCI_REQ_DONE:
 		err = -bt_to_errno(hdev->req_result);
 		break;
@@ -190,7 +190,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 		break;
 	}
 
-	hdev->req_status = 0;
+	WRITE_ONCE(hdev->req_status, 0);
 	hdev->req_result = 0;
 	skb = hdev->req_skb;
 	hdev->req_skb = NULL;
@@ -696,9 +696,9 @@ void hci_cmd_sync_cancel(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		hdev->req_result = err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		queue_work(hdev->workqueue, &hdev->cmd_sync_cancel_work);
 	}
@@ -714,12 +714,12 @@ void hci_cmd_sync_cancel_sync(struct hci_dev *hdev, int err)
 {
 	bt_dev_dbg(hdev, "err 0x%2.2x", err);
 
-	if (hdev->req_status == HCI_REQ_PEND) {
+	if (READ_ONCE(hdev->req_status) == HCI_REQ_PEND) {
 		/* req_result is __u32 so error must be positive to be properly
 		 * propagated.
 		 */
 		hdev->req_result = err < 0 ? -err : err;
-		hdev->req_status = HCI_REQ_CANCELED;
+		WRITE_ONCE(hdev->req_status, HCI_REQ_CANCELED);
 
 		wake_up_interruptible(&hdev->req_wait_q);
 	}
-- 
2.53.0



