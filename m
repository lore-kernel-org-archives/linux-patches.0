Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060980;
	b=pvNitFLdpEY//0e/aKJl8rXs/M12oKk4YXp8mf8AgH6nsCX2TfZHF+n+jbof11x66uPm
	 p88cJMHSsKj6qreQqarzAQoaG7mvE6ec3+dxY925jIrVhq57y2l14V7VonjmrtKN+UG+B
	 MraVogC803AsRAvtM6jTUz1N5K7EDEDtUHsWZCWos46Mc6ew2m/irOMCedOxh7D9+7cfr
	 i9wNclYfxZibhBI2oahsXgqR9L/hdnxnzjewKTVuQ0k7xkrvVMohXj9mNDqhE+QV3czzU
	 6umZqS6gETVKYBB8a3qIT2Aw33Huq3+BOdh/OTjcHQ7Mu/xD0aePngJQyGHy91oB2pA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mAcr55Rj4Vz7RWTcONmTVIJXrEkhLlpQDc4+F02ZWbY=;
	b=X04Rp4b1deksftqLYrYpJgdfsmRCBDId9c5f0Q7nRTe2PA+VW2nlXfT5/jKAk7vhelBr
	 dgsmqsEnbI6mooh3bKv2PCOXaiJThAY42n5/lwbsdR1mNEyrmkjoyQCAjDY+uGIlH4O2U
	 XzGva2F0kN5PSHg5nQceZJBgfpd/9N/EeUG9+GKMW13mQ6YooKFi0NjF6gw4Ybeipru/W
	 xRlSUrXZ0/PoDtw/ejJf2dWISyOSACZQHf56odcHbtyvS4sXDwmj4ES2casUY1Kzsm2dd
	 F3QINV1fkoEmJ0LvB8tgltUR6lsKwUHT0OlRARowjOFsKNrrW/K+20uYcc9szhn7ihQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcF1YGkz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08F16606A33C;
	Sat,  7 Nov 2026 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XcF1YGkz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41341F0089F;
	Sat,  7 Nov 2026 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060979;
	bh=mAcr55Rj4Vz7RWTcONmTVIJXrEkhLlpQDc4+F02ZWbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XcF1YGkz6wr6z+DAIPnRVOU/zyynfl54BmpbJpcH+XGcmPYD/DcTLnyRY1ZTZQpfK
	 NClrr9elZf2q1749FNsQCyiJ2nm/Vsns1Jyr0HO6v+nxRM2FNugA5XS2OaxMRZNG5L
	 xe/LZESbT4VKCJNqkN8HD2IU3Vw4FFZznffaXvks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0297/1536] Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly
Date: Sat,  7 Nov 2026 08:38:33 -0500
Message-ID: <20261107135006.072323660@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laxman Acharya <acharyalaxman8848@gmail.com>

[ Upstream commit e3643fbddb257c928c075cab05bbd929106b56ee ]

hci_le_per_adv_report_evt() is dispatched with a minimum length of
sizeof(struct hci_ev_le_per_adv_report), which only covers the fixed
part of the event and not the trailing data[] array:

	struct hci_ev_le_per_adv_report {
		__le16   sync_handle;
		__u8     tx_power;
		__u8     rssi;
		__u8     cte_type;
		__u8     data_status;
		__u8     length;
		__u8     data[];
	} __packed;

The handler notifies the ISO layer via hci_proto_connect_ind(), which
reaches iso_connect_ind(). That function retrieves the stored event with
hci_recv_event_data() and, while reassembling the periodic advertising
data, does:

	memcpy(hcon->le_per_adv_data + hcon->le_per_adv_data_offset,
	       ev->data, ev->length);

ev->length is taken directly from the event and is never validated
against the amount of data the event actually carries.  A controller
that reports a length larger than the received event therefore causes
the memcpy() to read past the end of the event buffer.  The leaked bytes
are stored in hcon->le_per_adv_data and can subsequently be read back
from user space via getsockopt(BT_ISO_BASE).

Validate that the event contains ev->length data bytes before it is
consumed, mirroring the check already performed by
hci_le_ext_adv_report_evt() and hci_le_adv_report_evt().

Signed-off-by: Laxman Acharya <acharyalaxman8848@gmail.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bluetooth/hci_event.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cbb1c3ee07525..0716b1a9ddc3f 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6490,6 +6490,13 @@ static void hci_le_per_adv_report_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "sync_handle 0x%4.4x", le16_to_cpu(ev->sync_handle));
 
+	/* The reassembly in iso_connect_ind() copies ev->length bytes from the
+	 * stored event, so make sure the event actually carries that many data
+	 * bytes before it is consumed.
+	 */
+	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PER_ADV_REPORT, ev->length))
+		return;
+
 	hci_dev_lock(hdev);
 
 	mask |= hci_proto_connect_ind(hdev, BDADDR_ANY, PA_LINK, &flags);
-- 
2.53.0



