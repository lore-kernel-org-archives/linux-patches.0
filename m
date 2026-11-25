Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619717;
	b=FqC0yIBPY5ehsVTUbH0VjNK3OmmaKEqZaDE8xhE5VIdIkwsftUkgxBU9tBHBHBFzd5va
	 CoN/64GIGrAqCXpdYYsnBowM2f+IYdKxt3exO9Ysap6Scb/htq1lDecBFdkA0LR5h9ZfM
	 K8As1uVeO/w9hYjFdr9wcMsTf/N00w5Ku6/fSg3yjPwJf2wYLakKr0VjxxjUE85kja/jG
	 SsgDrxiIfGJfM6A8Gnxicmy9GjNcL78yFx6olcWJuaPsYxnPwbNhntw4k6QrqYwfGmi0X
	 p4swe6/utvBhkKZEyGnDR/NmIDgmMtuM4/5vFOY0VRPA4ZvZYjqoyihFTIswM1unYeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GncAzsxCNo+Q0fH15SZ14hFYHTTp8j9lEbbRUzWIL58=;
	b=Rc9olpMOpG36lgSFKp4JRil2lwltBfLvydV/rFoYpm8XWQ/pe1MrJ+591cchaus7Dhn7
	 P7ruyWxeMApE21d24ZvMovetLbCBz3b27JfUcMJlw0eFSOgJTZ3jsRpTVKdzrqsd/5Z/S
	 rt5WhLWyLApLrcH4jdGOsBolfc3fJ4/vmIGpULmafaXN+NrSITuFORdY+sHFtA5AqUx70
	 l1LiPtj610Ferm0sPYGKg7+tjBgFhuR0G8ajQDZ8xah/CQodZtgtzAzEhqJoyjOizuKOw
	 0rOc1MmtojZPknP0aeux5ZW2NqatYZqSMCldS/0AW0VBOliHvUrd0Etb0rENSZNt9Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXXWkKqz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2910D606A339;
	Wed, 25 Nov 2026 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EXXWkKqz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6426F1F000E6;
	Wed, 25 Nov 2026 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619716;
	bh=GncAzsxCNo+Q0fH15SZ14hFYHTTp8j9lEbbRUzWIL58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXXWkKqz85LRBnIEabbnvf8gJRlgsfvUjq3FD18zZbzI9cwaWAd5PTgRrUVp+9Ij/
	 7P6GtOJKj6dUkfD4uKZnjFVhvqIzR4VL0vlMTawdZl9TpT5g3OHXM6xkmP/olla/eK
	 hZ9q08wIevxg9ptnJJk0xALGTHdWlIyUGp5R4lpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Yu <byu@xidian.edu.cn>,
	Cheng Wen <wencheng@xidian.edu.cn>,
	YuanZhe Liu <25031212351@stu.xidian.edu.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 7.3 0684/1005] Bluetooth: btusb: fix use-after-free in force_poll_sync
Date: Wed, 25 Nov 2026 15:33:42 +0100
Message-ID: <20261125143837.775667609@linuxfoundation.org>
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

From: YuanZhe Liu <25031212351@stu.xidian.edu.cn>

commit 868c886f45f7c10dc888b94c6993352702a84d04 upstream.

The force_poll_sync debugfs file uses the driver's struct btusb_data as
its private data. The file is created under hdev->debugfs and is removed
only when the HCI device is released, while btusb_disconnect() frees
btusb_data unconditionally. The HCI device can outlive the driver data,
for example when an HCI socket still references it, so reading or
writing the already opened file then dereferences freed memory:

  BUG: KASAN: slab-use-after-free in force_poll_sync_read+0x129/0x140
  Read of size 1 at addr ffff88800cfb7038
  ...
  Freed by task ...:
   kfree
   btusb_disconnect

Remove the debugfs file before the private data is freed.
debugfs_remove() waits for callers that are already inside the file
operations, and any later access fails with -EIO instead of reaching the
driver, so the force_poll_sync file can no longer dereference btusb_data
after it is gone.

Fixes: 800fe5ec302e ("Bluetooth: btusb: Add support for queuing during polling interval")
Cc: stable@vger.kernel.org
Co-developed-by: Bin Yu <byu@xidian.edu.cn>
Signed-off-by: Bin Yu <byu@xidian.edu.cn>
Co-developed-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: Cheng Wen <wencheng@xidian.edu.cn>
Signed-off-by: YuanZhe Liu <25031212351@stu.xidian.edu.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb_main.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btusb_main.c
+++ b/drivers/bluetooth/btusb_main.c
@@ -1063,6 +1063,8 @@ struct btusb_data {
 	int (*disconnect)(struct hci_dev *hdev);
 
 	int oob_wake_irq;   /* irq for out-of-band wake-on-bt */
+
+	struct dentry *force_poll_sync_dentry;
 };
 
 static void btusb_reset(struct hci_dev *hdev)
@@ -4557,8 +4559,9 @@ static int btusb_probe(struct usb_interf
 
 	usb_set_intfdata(intf, data);
 
-	debugfs_create_file("force_poll_sync", 0644, hdev->debugfs, data,
-			    &force_poll_sync_fops);
+	data->force_poll_sync_dentry =
+		debugfs_create_file("force_poll_sync", 0644, hdev->debugfs,
+				    data, &force_poll_sync_fops);
 
 	return 0;
 
@@ -4599,6 +4602,9 @@ static void btusb_disconnect(struct usb_
 	if (!data)
 		return;
 
+	debugfs_remove(data->force_poll_sync_dentry);
+	data->force_poll_sync_dentry = NULL;
+
 	hdev = data->hdev;
 	usb_set_intfdata(data->intf, NULL);
 


