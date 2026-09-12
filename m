Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C590416842;
	Sat, 12 Sep 2026 08:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202512; cv=none; b=LG5HTvnG/rkL5wRP7p1SOgDThQjEq9E6Zd82sDANiATmx+idoDfAOApnVx82lsYa9f/UJj9avH4b+gVZ5ymSQdJAkxbZiil6UV/HWNZgTpZQBgD4SSondh6a3ZYeuLU6ZKsUYH+dyXb8ky+grG4ZlcWB18AqRdL/P35L6fggd80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202512; c=relaxed/simple;
	bh=xdM3e1h/Z2RF+YsixrAYyJN40VKfyfOixtFsxx8ErDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSfw5craJGUGL5fDDgAIZqKCxGI0q2sYDEg2DkX2nsUKVWAe1IKo44U/ObZKhqMlvDiPYzlLaC4fDLfO72dw92hDEfVefuErKOjIyCIq6sHoUAJDO1CLy1xyjEq/75aPSjG+TAJDTQ/Yw8CnyNJ+48I0HQJiNHrXtxq9q/oPZN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t8xC+9p6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t8xC+9p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06E3F1F000FF;
	Sat, 12 Sep 2026 08:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202511;
	bh=bm1xuP7sCxC+JQegjwnQBnGcyPBNa5l59Bl3bz43W4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t8xC+9p6/0MffUgtWenTUqfUmFdpRAZb6lXcW6EZRyMZLElgftX3P1im2ZfDZAfH7
	 k7HfYjzotMKuSGHC50aw0J6hcaKyfeT9ZSykE3fBEwaGNqMu2Alhqc8u1cUCBJbAyn
	 i3CIPgisQGo09hfd6mRhlDHBVJWOZgIxfpLt/MkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1217/1815] Bluetooth: btusb: Record matched usb_device_id into btusb_data
Date: Sat, 12 Sep 2026 08:49:27 +0200
Message-ID: <20260912065717.575200915@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijun Hu <zijun.hu@oss.qualcomm.com>

[ Upstream commit ff50db7a522e7bd3bd1c4db6da715e4bdb53af97 ]

Add @match_id to btusb_data to record the matched usb_device_id
which will be used later.

Signed-off-by: Zijun Hu <zijun.hu@oss.qualcomm.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 33c6a8d01889 ("Bluetooth: btusb: QCA: Fix populating devcoredump fields on unenabled devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btusb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 2dd4d95179c33..df229e33bcd7b 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -1021,6 +1021,7 @@ struct btusb_data {
 	bool usb_alt6_packet_flow;
 	int isoc_altsetting;
 	int suspend_count;
+	const struct usb_device_id *match_id;
 
 	int (*recv_event)(struct hci_dev *hdev, struct sk_buff *skb);
 	int (*recv_acl)(struct hci_dev *hdev, struct sk_buff *skb);
@@ -4119,6 +4120,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (!data)
 		return -ENOMEM;
 
+	data->match_id = id;
 	err = usb_find_common_endpoints(intf->cur_altsetting, &data->bulk_rx_ep,
 					&data->bulk_tx_ep, &data->intr_ep, NULL);
 	if (err)
-- 
2.53.0



