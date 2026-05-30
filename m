Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 487FD2E92B3;
	Sat, 30 May 2026 16:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160287; cv=none; b=l/PlIV32ovrHW17dNfbhJcLGuRKSx2jWB5nkY1HnN62LKeWaANDOKtaAvpdiofSVsk6hps7CFOSWv6Wd0rMpKYBbQdrfOolurkQc0OGb3EdG2s1boDjRcxEVt/9L0WwZp6hRNbbkDHVahRvcO6mTRKoKoR9ovVrIBkx98zjvSIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160287; c=relaxed/simple;
	bh=2orBNCKwnptj1WJjdFZ8cETvvW+SPIeFkjtW75F8X3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9DXLGR1doPXCSbaxBRzM3zf3ETEVgFD4OHOiYBmtJI9VNpfZW+dbrsWKHTqWzzn6jfm/ejCFVH4F7WVSj3jPdZlKrNo1jFzRm0XctLPAHKqpBKXxYKV/QruTANlq51pVMgTktmXlCLmiT4GMooGGykipyF1Xf9sG8GlSN02YuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjFeszNz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjFeszNz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FE61F00893;
	Sat, 30 May 2026 16:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160285;
	bh=VOkmSGBozst6mXp9FS0gTAittxxzgRonJhHbuTpejk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjFeszNzQxi9rtRHUpfuB/Wy+PpTQrvr53QkfS59ipyJ6DklLgXUBuw3UVgevbAFy
	 PGvXno0il6Dw/FrQj+YV/ZoQ8wrPzY7mIRLNL2XJfUlM0szCjqsFj1Smd0oahjBn7k
	 IBJvakr+6dNjQ5bw84d9PkHgppXfqh6QuGKfybUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Fang Wang <32840572@qq.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 296/969] Bluetooth: hci_sync: Remove remaining dependencies of hci_request
Date: Sat, 30 May 2026 17:57:00 +0200
Message-ID: <20260530160308.617814289@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f2d89775358606c7ab6b6b6c4a02fe1e8cd270b1 ]

This removes the dependencies of hci_req_init and hci_request_cancel_all
from hci_sync.c.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Fang Wang <32840572@qq.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/bluetooth/hci_sync.h | 17 +++++++++++++++++
 net/bluetooth/hci_request.h      | 21 ---------------------
 net/bluetooth/hci_sync.c         | 14 +++++++++++---
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index a8b106d884d41..a68ddf5c02286 100644
--- a/include/net/bluetooth/hci_sync.h
+++ b/include/net/bluetooth/hci_sync.h
@@ -5,6 +5,23 @@
  * Copyright (C) 2021 Intel Corporation
  */
 
+#define HCI_REQ_DONE	  0
+#define HCI_REQ_PEND	  1
+#define HCI_REQ_CANCELED  2
+
+#define hci_req_sync_lock(hdev)   mutex_lock(&hdev->req_lock)
+#define hci_req_sync_unlock(hdev) mutex_unlock(&hdev->req_lock)
+
+struct hci_request {
+	struct hci_dev		*hdev;
+	struct sk_buff_head	cmd_q;
+
+	/* If something goes wrong when building the HCI request, the error
+	 * value is stored in this field.
+	 */
+	int			err;
+};
+
 typedef int (*hci_cmd_sync_work_func_t)(struct hci_dev *hdev, void *data);
 typedef void (*hci_cmd_sync_work_destroy_t)(struct hci_dev *hdev, void *data,
 					    int err);
diff --git a/net/bluetooth/hci_request.h b/net/bluetooth/hci_request.h
index 0be75cf0efed8..b730da4a8b476 100644
--- a/net/bluetooth/hci_request.h
+++ b/net/bluetooth/hci_request.h
@@ -22,27 +22,6 @@
 
 #include <asm/unaligned.h>
 
-#define HCI_REQ_DONE	  0
-#define HCI_REQ_PEND	  1
-#define HCI_REQ_CANCELED  2
-
-#define hci_req_sync_lock(hdev)   mutex_lock(&hdev->req_lock)
-#define hci_req_sync_unlock(hdev) mutex_unlock(&hdev->req_lock)
-
-#define HCI_REQ_DONE	  0
-#define HCI_REQ_PEND	  1
-#define HCI_REQ_CANCELED  2
-
-struct hci_request {
-	struct hci_dev		*hdev;
-	struct sk_buff_head	cmd_q;
-
-	/* If something goes wrong when building the HCI request, the error
-	 * value is stored in this field.
-	 */
-	int			err;
-};
-
 void hci_req_init(struct hci_request *req, struct hci_dev *hdev);
 void hci_req_purge(struct hci_request *req);
 bool hci_req_status_pend(struct hci_dev *hdev);
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index c6f9d07a48194..4d23455e90bbe 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -11,7 +11,6 @@
 #include <net/bluetooth/hci_core.h>
 #include <net/bluetooth/mgmt.h>
 
-#include "hci_request.h"
 #include "hci_codec.h"
 #include "hci_debugfs.h"
 #include "smp.h"
@@ -142,6 +141,13 @@ static int hci_cmd_sync_run(struct hci_request *req)
 	return 0;
 }
 
+static void hci_request_init(struct hci_request *req, struct hci_dev *hdev)
+{
+	skb_queue_head_init(&req->cmd_q);
+	req->hdev = hdev;
+	req->err = 0;
+}
+
 /* This function requires the caller holds hdev->req_lock. */
 struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 				  const void *param, u8 event, u32 timeout,
@@ -153,7 +159,7 @@ struct sk_buff *__hci_cmd_sync_sk(struct hci_dev *hdev, u16 opcode, u32 plen,
 
 	bt_dev_dbg(hdev, "Opcode 0x%4.4x", opcode);
 
-	hci_req_init(&req, hdev);
+	hci_request_init(&req, hdev);
 
 	hci_cmd_sync_add(&req, opcode, plen, param, event, sk);
 
@@ -5188,7 +5194,9 @@ int hci_dev_close_sync(struct hci_dev *hdev)
 	cancel_delayed_work(&hdev->le_scan_disable);
 	cancel_delayed_work(&hdev->le_scan_restart);
 
-	hci_request_cancel_all(hdev);
+	hci_cmd_sync_cancel_sync(hdev, ENODEV);
+
+	cancel_interleave_scan(hdev);
 
 	if (hdev->adv_instance_timeout) {
 		cancel_delayed_work_sync(&hdev->adv_instance_expire);
-- 
2.53.0



