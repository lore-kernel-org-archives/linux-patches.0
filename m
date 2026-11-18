Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034207;
	b=xdKA8Q0GF7oI2PtQyAxiwHFmiydaitbxc+PdhBdWQnaGbXkbUSmVBuC8IOyvHhuMH2nl
	 tQNSbuXLCcadvVAL7WOTnrHiEq4tw0fyw/qrGMJtUAmhcNTorZC6wZ16M6bmHKYJUQE8H
	 /uQW249CRJzRc6lbr1i8frYdQ4PiyC09lG5Fo8Dc+RgPJiMuHzoRwZ1JBCasadrMxwpiA
	 tUJJUOZ8L6Pv56pk/o/3rcj0Q9dQoqPZiLgOoijPd0FX5ombwh7S9HUkPYuaZf9PA9s5B
	 WnnqqdTgyZ0vWFgWlPojp91ZuBB0coYZMLWJdnBFjUW2mQIYqzXtdTP5ylvK0IBgzPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/uodmAHlpjnFUuM/wfe4/9c2M4/88jpJG8Tgqlpod1Q=;
	b=mOvQHHi49sNLM4eCtBQrJKyN8UEyhBD9cSEY83CxU8mVgAQntBkq5cXf4YjDAq8sWzZH
	 zRjMQXQlznJvQoek91UW9DxvTV/LwJ3bGaE7pxXTrEEuXXMvaqkD1ujbMZVsfjC0wAf9o
	 i5MXIgceCsk1T+XJ4DsPP//YjbZ9zP7okh9oFnf3x9+7GvrHEfx5aiDwBRcBXjPBvM21K
	 sO7GldCgcG4ngsRacOOooD4FGwz5+ZCCFV2D5RrJO0wWD/91DOyI+xondzz+p0B+1XljA
	 yPuPlQGqIUam5txa5ib7NgMFDVDsfuiyJn1YSmyZwYzPT1AS8gYCUcpp57C2uh+Cu9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="G/ggX/LD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E17606A32C;
	Wed, 18 Nov 2026 20:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G/ggX/LD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B70F41F000C4;
	Wed, 18 Nov 2026 20:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034207;
	bh=/uodmAHlpjnFUuM/wfe4/9c2M4/88jpJG8Tgqlpod1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G/ggX/LD2sGskBlLfMSU1NHCBJxlTEdX+3b58dhYRaJaPSJvRKnGGEWWlqU5SvZt+
	 woP46SHref14IdJ8UU+72KJn1BuETQyYO+GNjgP52AmCL9C7aPVhcLDg9J3erYvhE/
	 mJTelS3iUffyqRRP6dEONOXU9Zh2g94lYNMUNHtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0252/3318] Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly
Date: Wed, 18 Nov 2026 15:14:34 +0100
Message-ID: <20261118150322.868273628@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4c3fd5631c64e..982f96c1acb28 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6447,6 +6447,13 @@ static void hci_le_per_adv_report_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "sync_handle 0x%4.4x", le16_to_cpu(ev->sync_handle));
 
+	/* The reassembly in iso_connect_ind() copies ev->length bytes from the
+	 * stored event, so make sure the event actually carries that many data
+	 * bytes before it is consumed.
+	 */
+	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PER_ADV_REPORT, ev->length))
+		return;
+
 	hci_dev_lock(hdev);
 
 	mask |= hci_proto_connect_ind(hdev, BDADDR_ANY, BIS_LINK, &flags);
-- 
2.53.0



