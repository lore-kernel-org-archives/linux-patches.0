Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9E53CF1FF;
	Sat, 12 Sep 2026 14:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225066; cv=none; b=pawAnCbogLKitzpTf6BdtE1qEcmBge2BsSbCSKHyw4DGmAgAf2DOOQTNO2+grZj/ZdJMQyn+5u6BtSKA00+eOnM7v6zW8VJ3b5grqFOOhCnVS0ZMHtNHkal/RVR/61vhVvv0k16eWrH59m39EPTMDYt2BEaHP8lyR1Gf93KjY2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225066; c=relaxed/simple;
	bh=Tha4+7Vi7fm5ueG3v4LGdHZyiBsXIehQo46jnm5r+eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3mxqM4Igq1nCIZkm3nOKsUbfRktN6cdwFRAw8qGBAXjIDKX6wjvCBk3t6Nf5EbkVX4pCxWqZ580/3tjTjZuU0wIhG3FDTpdFV1ja3BAxu3ywtizPHpo2yV7VfNyz1ns+QXWccLBzfdUeLdt7EPy3XxH4XwzKeQl4sk6vdLpg5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6Kz7PRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6Kz7PRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12EF1F000FF;
	Sat, 12 Sep 2026 14:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225064;
	bh=UC24p4fifbSomlVMO72IFzwiYEkWXhdAptAnOxqDQ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c6Kz7PRsjZEvqOGHDJhDWvXRXHszYdZENF2iJZE6LX7qUx7db46CyiXn6MkK/lyoU
	 LqfR+lg2de/Ee8nuBqR5NjQg1b80Cs4YDUeamB0VKXhyBou5Es2cqAsEqlDNd4gbiN
	 XQxzLr8XmIz2r2GSv0hZwg7vqvRKqy/jZ/UQXpNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1121/1424] Bluetooth: btusb: Record matched usb_device_id into btusb_data
Date: Sat, 12 Sep 2026 08:59:13 +0200
Message-ID: <20260912065632.406513018@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 6ff4710bb6336..69459a90126df 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -913,6 +913,7 @@ struct btusb_data {
 	bool usb_alt6_packet_flow;
 	int isoc_altsetting;
 	int suspend_count;
+	const struct usb_device_id *match_id;
 
 	int (*recv_event)(struct hci_dev *hdev, struct sk_buff *skb);
 	int (*recv_acl)(struct hci_dev *hdev, struct sk_buff *skb);
@@ -3744,6 +3745,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (!data)
 		return -ENOMEM;
 
+	data->match_id = id;
 	err = usb_find_common_endpoints(intf->cur_altsetting, &data->bulk_rx_ep,
 					&data->bulk_tx_ep, &data->intr_ep, NULL);
 	if (err) {
-- 
2.53.0



