Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A4C62BE621;
	Thu, 28 May 2026 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001566; cv=none; b=sk50R40cIkCRFfasCfWRly3tUcN3/JzQTEF2GO2MrHC774OjQDA71bW/Itijw6SufhKcz0U/W9vW0KsifbASfH1FHNWESgocqPgce6Gi70aG26IXwFW8o2Du4TKjN3h6LRxTGlItnHJUdnppYF3iF7viFuUrkXCoYa6FSNHhKUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001566; c=relaxed/simple;
	bh=ineA5+IVLXXC8y+luaqHhagX1lz7krAZzD8MWfRJuHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OsTDH2xr0h0avAgkS+nsGzz315N+9p54v2qFDgfxTcsvU0qFvQHcEayH0qVJQ4LFEOrBH8xA/buBwKkFOolc9T5UsqdIA1b1yVilbadWRBLo1yN6LYMw6RAz2AMzcAerWWPyqjpO5kJOUASSDeMrK3Tp6e1kzSoPFj01llkuQ/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijSp4jHT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijSp4jHT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89741F000E9;
	Thu, 28 May 2026 20:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001565;
	bh=JXliSiZ2NxIL/TbFtY94zjet0Qf/u6CcbdHpj/MtBPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ijSp4jHTNraqxJDnEhKxqqXaGlLzTK20p2HDUFzXosY5MPHkhksf9WS37B9GB3s1f
	 6x9t/SCqBKrq0ZYcnutLhRtHxSoiCKRH14Vw9qfyI9xdyIOo4e/tWJthoRAIQ9RKF+
	 gnrXyD5y0K4jeslS6q2bD8IX9Hizh+/nRcsXs934=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 173/186] Bluetooth: btmtk: rename btmediatek_data
Date: Thu, 28 May 2026 21:50:53 +0200
Message-ID: <20260528194933.648505546@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit d3e6236053958a8f1c7c7a885d9cecdd383e4615 ]

Rename btmediatek_data to have a consistent prefix throughout the driver.

Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: dd1dda6b8d6e ("Bluetooth: btmtk: fix urb->setup_packet leak in error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 10 +++++-----
 drivers/bluetooth/btmtk.h |  2 +-
 drivers/bluetooth/btusb.c |  9 ++++-----
 3 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 31fca4529b5ad..0290ba9ace9a9 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -64,7 +64,7 @@ static void btmtk_coredump(struct hci_dev *hdev)
 
 static void btmtk_coredump_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct btmediatek_data *data = hci_get_priv(hdev);
+	struct btmtk_data *data = hci_get_priv(hdev);
 	char buf[80];
 
 	snprintf(buf, sizeof(buf), "Controller Name: 0x%X\n",
@@ -85,7 +85,7 @@ static void btmtk_coredump_hdr(struct hci_dev *hdev, struct sk_buff *skb)
 
 static void btmtk_coredump_notify(struct hci_dev *hdev, int state)
 {
-	struct btmediatek_data *data = hci_get_priv(hdev);
+	struct btmtk_data *data = hci_get_priv(hdev);
 
 	switch (state) {
 	case HCI_DEVCOREDUMP_IDLE:
@@ -355,7 +355,7 @@ EXPORT_SYMBOL_GPL(btmtk_set_bdaddr);
 
 void btmtk_reset_sync(struct hci_dev *hdev)
 {
-	struct btmediatek_data *reset_work = hci_get_priv(hdev);
+	struct btmtk_data *reset_work = hci_get_priv(hdev);
 	int err;
 
 	hci_dev_lock(hdev);
@@ -371,7 +371,7 @@ EXPORT_SYMBOL_GPL(btmtk_reset_sync);
 int btmtk_register_coredump(struct hci_dev *hdev, const char *name,
 			    u32 fw_version)
 {
-	struct btmediatek_data *data = hci_get_priv(hdev);
+	struct btmtk_data *data = hci_get_priv(hdev);
 
 	if (!IS_ENABLED(CONFIG_DEV_COREDUMP))
 		return -EOPNOTSUPP;
@@ -387,7 +387,7 @@ EXPORT_SYMBOL_GPL(btmtk_register_coredump);
 
 int btmtk_process_coredump(struct hci_dev *hdev, struct sk_buff *skb)
 {
-	struct btmediatek_data *data = hci_get_priv(hdev);
+	struct btmtk_data *data = hci_get_priv(hdev);
 	int err;
 	bool complete = false;
 
diff --git a/drivers/bluetooth/btmtk.h b/drivers/bluetooth/btmtk.h
index e76b8a358be88..dde6fbdeb2b3b 100644
--- a/drivers/bluetooth/btmtk.h
+++ b/drivers/bluetooth/btmtk.h
@@ -135,7 +135,7 @@ struct btmtk_coredump_info {
 	int state;
 };
 
-struct btmediatek_data {
+struct btmtk_data {
 	u32 dev_id;
 	btmtk_reset_sync_func_t reset_sync;
 	struct btmtk_coredump_info cd_info;
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 04eaf7abf75c4..4413ff997aa08 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -3137,7 +3137,7 @@ static int btusb_mtk_subsys_reset(struct hci_dev *hdev, u32 dev_id)
 static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
 {
 	struct btusb_data *data = hci_get_drvdata(hdev);
-	struct btmediatek_data *mtk_data;
+	struct btmtk_data *btmtk_data = hci_get_priv(hdev);
 	int err;
 
 	/* It's MediaTek specific bluetooth reset mechanism via USB */
@@ -3152,9 +3152,8 @@ static int btusb_mtk_reset(struct hci_dev *hdev, void *rst_data)
 
 	btusb_stop_traffic(data);
 	usb_kill_anchored_urbs(&data->tx_anchor);
-	mtk_data = hci_get_priv(hdev);
 
-	err = btusb_mtk_subsys_reset(hdev, mtk_data->dev_id);
+	err = btusb_mtk_subsys_reset(hdev, btmtk_data->dev_id);
 
 	usb_queue_reset_device(data->intf);
 	clear_bit(BTUSB_HW_RESET_ACTIVE, &data->flags);
@@ -3176,7 +3175,7 @@ static int btusb_mtk_setup(struct hci_dev *hdev)
 	char fw_bin_name[64];
 	u32 fw_version = 0;
 	u8 param;
-	struct btmediatek_data *mediatek;
+	struct btmtk_data *mediatek;
 
 	calltime = ktime_get();
 
@@ -4434,7 +4433,7 @@ static int btusb_probe(struct usb_interface *intf,
 		data->recv_event = btusb_recv_event_realtek;
 	} else if (id->driver_info & BTUSB_MEDIATEK) {
 		/* Allocate extra space for Mediatek device */
-		priv_size += sizeof(struct btmediatek_data);
+		priv_size += sizeof(struct btmtk_data);
 	}
 
 	data->recv_acl = hci_recv_frame;
-- 
2.53.0



