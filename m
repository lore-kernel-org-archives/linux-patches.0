Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455F82BE05F
	for <patches@lists.linux.dev>; Mon, 11 May 2026 06:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778481262; cv=none; b=PwDKVO4+lIVR1R5bWxPHu5q0fpMWRppR30ECjXUKsMXjdxYThY1XSgknAZ+DrBUNQLICgV5HnCj/dhdlBtl1TBf0VuzHZ/x9mIlzznEAPfpUZyRZUXlponrUos+ncDVxCnCdphc5d9nBzL+ES5eH4GaMd/MSJDCgghIrKIXNsjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778481262; c=relaxed/simple;
	bh=odYTO9CzqRZ/MB/1W9FvnzdFiRY6G5Wu2JuRefiGKYQ=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=iVK/sosh6VOYa0wPAcC3O9popFAiTP4gJcK3AvhkCJ1wBvJD3HmZDat69c0XFx+oV+7gjn4EiTaTMdXJ0xrZgzzi2Gi3NCoeZCc+7sDA7F60XpSq0zMIRospbne3aFoneekmm/0g+aCkXBUwghQzJPR9ldqHE0fFNs3ih+u9D2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=GEfRqvDm; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="GEfRqvDm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778481248; bh=vfGr/xAlGhPhpi/P77prhoa1++/Z64kxSalCOXbvdkg=;
	h=From:To:Cc:Subject:Date;
	b=GEfRqvDm5qsvFdyd0ILcEB/TCHbv2gkXvGyGcxWvG+fjvqHoo8Lq6Y+kkWdsprebN
	 L6bds87uG4rt1bG85qEWP1BSIj4NgsAwW2fg1ZFSuQ9ygbY7celH9uKq63XBjrdadm
	 pZjOypm9A2beD+BIDQXvrvbQdky9b9ntSDsNwRNU=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 885872EF; Mon, 11 May 2026 14:34:05 +0800
X-QQ-mid: xmsmtpt1778481245tdw4aubn2
Message-ID: <tencent_CA96C7486F1CF8F0C72A2274E56AD1766708@qq.com>
X-QQ-XMAILINFO: NwU6Bou9okj/7K0UsUOIqEkkX7LoAHgssLC4vzLHV88f2rEERYEgwZugsKgSue
	 ckNx0IsdeYGRUFV4zLfySeZO87Wzuq7jv9i2d5v9JwMYmD4/KOHE6m01jSammBGT1spcss7v0ISe
	 G2+6b4tRRBY6Jy4sMDvZ+bkHldZLXvO4tddx3NRPgFX9lPXxCkX49aul5R5t7ocrtmEWUDxwBcpm
	 8tauVBRJLlkBw5ig7iuQItwKoIesqHl6grJhl7YwLsI0ehvAITsinYZ/sOSlQrI2kcV8CYVD5TvJ
	 wI4fiyfBfmdgxWfBPfEh1wnP3tXMnccDPAPgYtwnZbvo2qi8+GNzs0llOCmN+tgOVIUPzxe1z9Mf
	 YNBboknkIpy6u/dX62HkNDVQPQPAcmfDn7KZX1gkyhTHGD+eVwdqhtAGwXPjC3JBLQqWrZ2byR9Q
	 3XK0CATKaTVNc8HNF9dQ3urTptNIyOTPrFcSe1A6XeQMG2m4r5BdjbameqbJnmYXH0g+mJu4urzY
	 lRtroy7sXiecYhx/r64Tq5HyHrf5KaLr8Cxqvbxb+AWpS9xqhw4Obkc+elvMSriPNbZsRY6cHg88
	 8nkqBVqDGpBDf7GIBK66aepNuRFmjPiTTxzEZtplsi+NcGyDQdwk1JMnUx0tdCzUA2cwKu+NOaAC
	 Ul2CMuTaEhWOUiHolZbW0rlT5TVXzn6xHNXlxqdcg2pbNmjsjxWtMxcZFKRdi7BjNtEuHt1HMKJB
	 k40Pc0F1W9vy+Pm4vC6nEK3P8+obiiiUWU4Ls7MP/OLpCmq6MyjmAM2WIx77iqF2gd6lwBTvqsRF
	 ukr9k5rFlkJOvx+WTbgyD92jIl8vZNywEJzmrCSFl6zVcfoEp0K4E1xbrYY0QCCV7BVhUyTnelGa
	 D4zaAgoVjlIy6+gB1ZuCsz6V5FePG9NYsyPAfKexyhZSkxnXYaH0vUSDtYzDYnW7sqBkD0Q8GqRn
	 FDIj5X14wZ8WV4XbaoI5FevxDU7wz0AK1ThvIeXZf8dlyA1vivmdW67Cq0AJ8SiimJHBPWzxWWIg
	 7neRFipA==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	luiz.von.dentz@intel.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	linux-bluetooth@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 6.1.y 1/2] Bluetooth: hci_sync: Remove remaining dependencies of hci_request
Date: Mon, 11 May 2026 14:34:05 +0800
X-OQ-MSGID: <20260511063405.856013-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit f2d89775358606c7ab6b6b6c4a02fe1e8cd270b1 ]

This removes the dependencies of hci_req_init and hci_request_cancel_all
from hci_sync.c.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Fang Wang <32840572@qq.com>
---
 include/net/bluetooth/hci_sync.h | 17 +++++++++++++++++
 net/bluetooth/hci_request.h      | 21 ---------------------
 net/bluetooth/hci_sync.c         | 14 +++++++++++---
 3 files changed, 28 insertions(+), 24 deletions(-)

diff --git a/include/net/bluetooth/hci_sync.h b/include/net/bluetooth/hci_sync.h
index a8b106d884d4..a68ddf5c0228 100644
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
index 0be75cf0efed..b730da4a8b47 100644
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
index c6f9d07a4819..4d23455e90bb 100644
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
2.34.1

