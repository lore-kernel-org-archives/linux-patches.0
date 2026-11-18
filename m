Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043463;
	b=WXKKpDj5M+lUUWgRA7loDxGnBMOlVsh/xpXF3rlz6+UEqwJkmNZh3755CeXskt9QFX7y
	 q4ObEfVU6srC4ag6kq0FWn5VYF9O365mJBiyzGt/r72bZ14JpeFqXmps0CRXHxJ+hd0eD
	 to7EcE/hUp9kDS4dR5KKyjlAS9tAXNQuKk6XY/6BIV0YFPXzOA0IZXn8ojGCrlF2HcIdJ
	 VPKp95I3QPM8JuoWjHuO5qcKRRft3nkXCVAzjdrsRmyFCzC8nKG+0jW/dMwcetfMjpxLw
	 3UGi/U2EQV8He43tLy3rugwIDpDZW6WR2Ufj8Vo6I9HW4Ti+w44SMIFfKDQVDEOe+Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OtmUbW5x/mb6IrlAH8SZ9wXh/8avgInuuZwA3GOxFcE=;
	b=MPpzmSAfmUxp6LNGoIA91PKxdPhcXgfriTkWiZ2bSx2ald1G5MvPdEI4uhlkCNN0o+Ea
	 cyTloF758RKJLM+pSAha4EZTey+Ef+l9QCQHutSlrLx8o3DpRT9PyiF69KtPEXGGyw06x
	 mpiYliHM7fHW0aWvHalpuDnl1izdW6z+RUA3iEKgsEkwsTC5O4rId4tkywq0H2VILdiQ8
	 z0S8d/WeXYMoYSpn28fBGfJe2dym8rpQsUv9y2V9FZY2uHjaxtWkiXez69L/69jR7bEqh
	 vV45giLDODGQZVlta0Q7IH/FE4QVSrs2zZFfP2QNHvWeFChFjHON/TwJELTfiDzU3ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7+oMdLY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC13606A946;
	Wed, 18 Nov 2026 23:11:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=U7+oMdLY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1391F000C4;
	Wed, 18 Nov 2026 23:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043462;
	bh=OtmUbW5x/mb6IrlAH8SZ9wXh/8avgInuuZwA3GOxFcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7+oMdLYCiT7XI+GvWEhRpHk2JtaXlzvVBqAejKY5J6Jst6KMxDvSUjoHX6Cb5tZ4
	 3KtDX1NtmMxXnq/orrZUC9np+CopTNi8ZakUt0zY7oEB9Jr4zJCRXNtEwahi0HLTUP
	 oakBF3QV83GmRGLAlP9khvSgtWrrdLSVyIN+82w8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya <acharyalaxman8848@gmail.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0219/2857] Bluetooth: hci_event: fix out-of-bounds read in LE PA report reassembly
Date: Wed, 18 Nov 2026 15:20:53 +0100
Message-ID: <20261118150209.347135926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e319d55dc0068..13c1fa740b480 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -6406,6 +6406,13 @@ static void hci_le_per_adv_report_evt(struct hci_dev *hdev, void *data,
 
 	bt_dev_dbg(hdev, "sync_handle 0x%4.4x", le16_to_cpu(ev->sync_handle));
 
+	/* The reassembly in iso_connect_ind() copies ev->length bytes from the
+	 * stored event, so make sure the event actually carries that many data
+	 * bytes before it is consumed.
+	 */
+	if (!hci_le_ev_skb_pull(hdev, skb, HCI_EV_LE_PER_ADV_REPORT, ev->length))
+		return;
+
 	hci_dev_lock(hdev);
 
 	mask |= hci_proto_connect_ind(hdev, BDADDR_ANY, ISO_LINK, &flags);
-- 
2.53.0



