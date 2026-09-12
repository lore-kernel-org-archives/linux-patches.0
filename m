Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ADC46C4AF;
	Sat, 12 Sep 2026 10:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210253; cv=none; b=K7SxTyk73+Yl2biVRfwzX9uD6VRQBDRf7o3Fzs/qKUCx/o199W0Cfes0Rkc46ZnEhWGYimOavKXEMeQWtHSUoJrdSJJ5inp45AfCsZq2dipswGAkHnHxHGkLJPiFV3R/ExD5AagXm14ZJjO1h10905IO+9/fuGOsqZcARFGysQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210253; c=relaxed/simple;
	bh=KRp1d0RCe6ATR8e6kprrUiVumA7uXx1ZI3dfZuVOHLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/wz3p/H+Kd459aZou4fYNqBvDQo99GDhmKZhFMrrSsfygmfZ+2sjTTPpjz+zSPWsYZ0XOKxhkehFjaGKCcDVHSHoi4BkQ/QAQSgIjJzrBdX5aSWVYWuU/EzEfKxvGqXTLjq6FeK1jOQnkuA+4Q2d2ObqRzMJkRuLNk+WsGmQxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxEl/tOc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxEl/tOc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB851F000FF;
	Sat, 12 Sep 2026 10:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210252;
	bh=YBqVhksCx1080VqFi3TsA5Nta6X6aF6jaLtnTT2Ossk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wxEl/tOcEsncilwMaiEbNxjt+KVmH10tC8uVcmk+6DEPloSd9FksG3kS+/JzGt7G9
	 g8ySWRfAktoVL2bNnECfDkae7ca7pa5GV/jHF8mumOH4hJ3yDpxVEo2Cd9roGTRyLj
	 wWhJXUs3q5EdqLw2IC6b6t7ZestnBUO3wNMcD4rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0988/1518] Bluetooth: btusb: Record matched usb_device_id into btusb_data
Date: Sat, 12 Sep 2026 08:52:37 +0200
Message-ID: <20260912065645.808478980@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f399599f4b3bf..68480ed7043b9 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -976,6 +976,7 @@ struct btusb_data {
 	bool usb_alt6_packet_flow;
 	int isoc_altsetting;
 	int suspend_count;
+	const struct usb_device_id *match_id;
 
 	int (*recv_event)(struct hci_dev *hdev, struct sk_buff *skb);
 	int (*recv_acl)(struct hci_dev *hdev, struct sk_buff *skb);
@@ -4037,6 +4038,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (!data)
 		return -ENOMEM;
 
+	data->match_id = id;
 	err = usb_find_common_endpoints(intf->cur_altsetting, &data->bulk_rx_ep,
 					&data->bulk_tx_ep, &data->intr_ep, NULL);
 	if (err) {
-- 
2.53.0



