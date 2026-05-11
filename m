Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC9F299927
	for <patches@lists.linux.dev>; Mon, 11 May 2026 06:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778481348; cv=none; b=Co+yaUPJpmiaEeN/pyt6eIJEFSOZBS9DXwuo3ho1GKfw0cqyXN+RQPM+dGYGjza+FsQxWOmWpGBLWbM5xiMHPw0EHOE+S1dCyYIAj/Jaeop78xsMPky05FZw7HKobGYLGTzfzFj45ASuPH34v3TNvhUuZbAWukGUpkkSCqESJ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778481348; c=relaxed/simple;
	bh=VkgArMLTywl9mlqDGFYvH08cienQvf6siTXeqGcNOMA=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=q4IDJAP2Zkd2feOTa/FJJYBcB/dwlrjhP1KspdkVxjdPtVWtKiWo9bqwotpBnJ7eqBtG94fN6v6SviNzb2jkWERjMCCp9aYHyiJFhnFw69m3hTiu5oar/YtVKC9Z57BhOIo5BLOI4Wtn3yFGe+QkbBStgi1hzzwhYXM6UVrCBuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=cFln1MLa; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="cFln1MLa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1778481341; bh=qLS+EpXLOIxLyxyWCCFfEkydGSZLB601J8mMv9jBlAo=;
	h=From:To:Cc:Subject:Date;
	b=cFln1MLazM76dSVNGwGdZlY8T5Zw0n/P3TuuhMdp2YpdecaFdU4TewSV6ILz39Lba
	 Ng+3Ow0+e3N1EZgt5bEJ+4jlkk8GqR7+phIMzqRCtR9mlcJl1d9/5vqfT4NVxcDJrR
	 RAsUxPNaUtCaFUpyhMmJH+cCLdIB4dRPuqG0oQb4=
Received: from NTT-kernel-dev ([60.247.85.88])
	by newxmesmtplogicsvrsza53-0.qq.com (NewEsmtp) with SMTP
	id 8E711858; Mon, 11 May 2026 14:35:39 +0800
X-QQ-mid: xmsmtpt1778481339t0c34p6y1
Message-ID: <tencent_3D46FCA5631E9197F2E9E88FB394E389B707@qq.com>
X-QQ-XMAILINFO: OATpkVjS499uLtQBCWFBF5Z/looZ4sFDeVOMOdb6Ntk27UjPHXKxNG+9ubqspl
	 D0C4mQ4WDFVAT3aX07Dqm3Tc88a5b4d13nPSW52dIx+GVLwjr+BxHNz03qiPiv1ME82JNGz6tvX0
	 oF9HpJRp7a0QewDiZXqZixRntGxtrlRkGkIHtE5ZXN2nSNLPo0dU/BuLUiRehf+Z41UhDHOeGlVh
	 MoUA/gdizQILqJlM8eWompEKs/YkWhLB27wtLMeRWx0KlaWzXzGlWkHDFuwCd9f0/MGs6hgWSt8Z
	 uor57yZA8IdYanap96ODs7LfKWgljL0aa2JbBqHe+g5nVl2qxus/G94l08zPlIb158R8BTGQP0fM
	 Ss+VtnPK5+Y672ukucxA6/BjzE+XUWCDQuMIWke2VwtWfcf5tR3HWMVUOc9huFT0NR9rIOyWoehj
	 +H7xylcwU0tZkZJbn4jnqeTaBG67DrvU6G37lNs7EaORDIfH8AeA44rpF5hbWFHYUosOijY5OKsV
	 FF9Zvp4VzGqJnUp1dKgN1vFkKKksH4yx3Vz3Et9TXHwPqzVTr6prVs+aBmqNQ9aXxlzjWRjBjMvr
	 pOcQZH3fzTqrh06HxgMI88iKkTjSswbH/r726OsrlurMmPe3JBWSt3O7AacBXv2RxLdOvQE5jypY
	 CzA3PyhJ6fjoxSRevFQTzudf53k2ZRNRZvNtKC+2F4rBVb+xqv5ZNX/PInPQmDUDGBUMXnFeO3EQ
	 X0WYWHxVqxpV2IfIDzdu/sGTqzC6c7JhvlQG8aGnWGV3jzHEasE9jR9igM0il7/jl4G/dD23MWXw
	 /ovg7AAHjIBCgtyfX2DZatdLBh81adA3xoWtf3Y11o9/5DkIcdHxxp1lnJ4R7m5IYx3ZD+11V20G
	 7PT2JWbB/F/QY2OsZqtXu2m5EuprkuIHaS00LYLZSgju3IreMFehaOocKsim0CrcFXN8P5sZovMW
	 Pk1h9r/0VmBr3+z33UXEpJBjzrVxf8bOtHbL3HqFsfp0gxD/E31VpB735qDerwIhGX85Mv9slkES
	 L9Q/llNXycrOXzvgHG
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: Fang Wang <32840572@qq.com>
To: gregkh@linuxfoundation.org,
	stable@vger.kernel.org,
	zzzccc427@gmail.com
Cc: patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	marcel@holtmann.org,
	johan.hedberg@gmail.com,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	luiz.von.dentz@intel.com
Subject: [PATCH 6.1.y 2/2] Bluetooth: btintel: serialize btintel_hw_error() with hci_req_sync_lock
Date: Mon, 11 May 2026 14:35:39 +0800
X-OQ-MSGID: <20260511063539.856296-1-32840572@qq.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 94d8e6fe5d0818e9300e514e095a200bd5ff93ae ]

btintel_hw_error() issues two __hci_cmd_sync() calls (HCI_OP_RESET
and Intel exception-info retrieval) without holding
hci_req_sync_lock().  This lets it race against
hci_dev_do_close() -> btintel_shutdown_combined(), which also runs
__hci_cmd_sync() under the same lock.  When both paths manipulate
hdev->req_status/req_rsp concurrently, the close path may free the
response skb first, and the still-running hw_error path hits a
slab-use-after-free in kfree_skb().

Wrap the whole recovery sequence in hci_req_sync_lock/unlock so it
is serialized with every other synchronous HCI command issuer.

Below is the data race report and the kasan report:

  BUG: data-race in __hci_cmd_sync_sk / btintel_shutdown_combined

  read of hdev->req_rsp at net/bluetooth/hci_sync.c:199
  by task kworker/u17:1/83:
   __hci_cmd_sync_sk+0x12f2/0x1c30 net/bluetooth/hci_sync.c:200
   __hci_cmd_sync+0x55/0x80 net/bluetooth/hci_sync.c:223
   btintel_hw_error+0x114/0x670 drivers/bluetooth/btintel.c:254
   hci_error_reset+0x348/0xa30 net/bluetooth/hci_core.c:1030

  write/free by task ioctl/22580:
   btintel_shutdown_combined+0xd0/0x360
    drivers/bluetooth/btintel.c:3648
   hci_dev_close_sync+0x9ae/0x2c10 net/bluetooth/hci_sync.c:5246
   hci_dev_do_close+0x232/0x460 net/bluetooth/hci_core.c:526

  BUG: KASAN: slab-use-after-free in
   sk_skb_reason_drop+0x43/0x380 net/core/skbuff.c:1202
  Read of size 4 at addr ffff888144a738dc
  by task kworker/u17:1/83:
   __hci_cmd_sync_sk+0x12f2/0x1c30 net/bluetooth/hci_sync.c:200
   __hci_cmd_sync+0x55/0x80 net/bluetooth/hci_sync.c:223
   btintel_hw_error+0x186/0x670 drivers/bluetooth/btintel.c:260

Fixes: 973bb97e5aee ("Bluetooth: btintel: Add generic function for handling hardware errors")
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Fang Wang <32840572@qq.com>
---
 drivers/bluetooth/btintel.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 7a9d2da3c814..1cba08e9403a 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -225,11 +225,13 @@ static void btintel_hw_error(struct hci_dev *hdev, u8 code)
 
 	bt_dev_err(hdev, "Hardware error 0x%2.2x", code);
 
+	hci_req_sync_lock(hdev);
+
 	skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL, HCI_INIT_TIMEOUT);
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Reset after hardware error failed (%ld)",
 			   PTR_ERR(skb));
-		return;
+		goto unlock;
 	}
 	kfree_skb(skb);
 
@@ -237,18 +239,21 @@ static void btintel_hw_error(struct hci_dev *hdev, u8 code)
 	if (IS_ERR(skb)) {
 		bt_dev_err(hdev, "Retrieving Intel exception info failed (%ld)",
 			   PTR_ERR(skb));
-		return;
+		goto unlock;
 	}
 
 	if (skb->len != 13) {
 		bt_dev_err(hdev, "Exception info size mismatch");
 		kfree_skb(skb);
-		return;
+		goto unlock;
 	}
 
 	bt_dev_err(hdev, "Exception info %s", (char *)(skb->data + 1));
 
 	kfree_skb(skb);
+
+unlock:
+	hci_req_sync_unlock(hdev);
 }
 
 int btintel_version_info(struct hci_dev *hdev, struct intel_version *ver)
-- 
2.34.1

