Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F0947ACE6;
	Sat, 12 Sep 2026 12:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217635; cv=none; b=FGYUM1q1yUj21Dfxy5uUqxUzdhW5PO3uKEJlx1cscbotjRHK66DWNvq7eBPgB1gJyE0b3h0Tvkfam6+HtiOSy3VZtmhvzxmv7OVkcWgAzgy2QvHJInvYw2Nz1Sey27BSiZ+Wif/gEoRZoexkLcqJvQ43aMbJJVTop1U7itZscfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217635; c=relaxed/simple;
	bh=cUpqv9I8IxR6zhrPrexDAgEZLTUSpzM80rYpCWcm2JQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghAUXaJ9wsuEfzMGLMHM+2RStj/1MX6tgN2Sgt5cNZcAZ1/nxEevwDAyb7m6z7cLqW+Ry3Z5vHUnYLvzKxFYTL6o6bhIxo05bsU6vqrrSphyS9FcJ3mTpGk0U/FKvkRY1v1aSLvl3bYKzAesjOPRWuMDP5OlA/lcPv1VbO1uKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P06dNMGd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P06dNMGd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52151F000FF;
	Sat, 12 Sep 2026 12:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217631;
	bh=eCq0XInLdV0UvI2p58XBMcfJtFJ+fs8b0VnzC5EWSXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P06dNMGd4AreJp+f/4YqPIiouJVlbfCkpLnWBw9ALIZ/dw2ZjJepZa2vRlgSLlB0y
	 ifuPwbhbLVSzSMdyT8cJV6d+TekIzzaLj9XMrv8NoE7kWp56y2unE1JBFrvQyo3IfT
	 Zo25aU7v9rdlBBs3uN9STVJjcJUggR/rlLb5Lsnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijun Hu <zijun.hu@oss.qualcomm.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0972/1376] Bluetooth: btusb: Record matched usb_device_id into btusb_data
Date: Sat, 12 Sep 2026 08:56:38 +0200
Message-ID: <20260912065629.230595491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 4299ba57d48f8..662c9651cc9db 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -949,6 +949,7 @@ struct btusb_data {
 	bool usb_alt6_packet_flow;
 	int isoc_altsetting;
 	int suspend_count;
+	const struct usb_device_id *match_id;
 
 	int (*recv_event)(struct hci_dev *hdev, struct sk_buff *skb);
 	int (*recv_acl)(struct hci_dev *hdev, struct sk_buff *skb);
@@ -3846,6 +3847,7 @@ static int btusb_probe(struct usb_interface *intf,
 	if (!data)
 		return -ENOMEM;
 
+	data->match_id = id;
 	err = usb_find_common_endpoints(intf->cur_altsetting, &data->bulk_rx_ep,
 					&data->bulk_tx_ep, &data->intr_ep, NULL);
 	if (err) {
-- 
2.53.0



