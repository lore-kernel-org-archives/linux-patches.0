Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015008;
	b=DPP0wr9MRSZdfmJ/dU1f7tCQah08YZdUz0vtwC069QWbBrYAAzNMH/TV5LvAvMHzSGSi
	 5vYcGkxHJdpkZnOYTMmrZgiUgV3wW8a+YfAwCqD3rqT5ejoci+WK5gdlyLwMlSRUC5Ur1
	 jo0uwm5wrbHM2UXWupno1YAhi3VgpFjwD54CSEQL5umzuykQCqCfM4GjLADGpbWL3pp/j
	 Dd/LaDtylbmJUaQ4PVd67OWTLGCt9+eE5VeaeeTVfypNpziAxH387cKQ+WEytPmMNjq0s
	 anRjq4IaOy2Mf9wQHNRGZ6Q4REPNaRrjXb4dse3SDsACssvA9LOapsm1CtFnKBCMlmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015008;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aG6+n0TWkLUazo50Aro7L33c535SCya3pkxG1Qm6LSA=;
	b=3Moi1e5JucoOmcSfPoiHT3+uZTCTE9YyQBuBiTb0sArbVvHwvRZbramrgauAWlg1sW1v
	 IbUpg543Y1RuIWqu9Hwq5a1ocCh3Xj1ZDy+d+5GY1/oPXxOH02sXkPgVUKCI1EntMpwHy
	 jHccoGgJmjSfE9+F96i5y0fEMnBbYXDualKUrSQqE8PfHy15qI5Y3NSbL/IN1OxBMYAdn
	 fDFg4twhoKEZ52SDBywigdQ6SNbFWgfOoe4/tSfQp9wPsA8wCYwIgK19BHKM3yzTeLHiG
	 Hr9dfMEl/zvA0yeToE2jggYpp3AyXLBm9npfbN22ksG2QnNrUS9dxFsN7/SMyI9jOCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIlvt6vo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29023606A32F;
	Wed, 18 Nov 2026 15:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sIlvt6vo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81E601F000C9;
	Wed, 18 Nov 2026 15:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015008;
	bh=aG6+n0TWkLUazo50Aro7L33c535SCya3pkxG1Qm6LSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sIlvt6vokKcVY5puF2zfJDlcI5wpZPMc4OyJtEHJyl7alcE3XvYTZE65INUBMiESh
	 99y1A0UCk3lc4/lKADOPIp6QWXlnE2Y+FGj94343oDJRgDuXzkb9MUFv171XXP0La6
	 YANwku6kLKhNaJLqKAgFFbI+AvKURgJEVgjVWCvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0020/2651] Bluetooth: Move H:4 reassembly into the Bluetooth core
Date: Wed, 18 Nov 2026 15:21:00 +0100
Message-ID: <20261118150248.716441549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>

[ Upstream commit 5299db91df03894253e8fa08627cfb9ec1429e89 ]

h4_recv_buf() is currently implemented in hci_h4.c which is only built as
part of the hci_uart module, and only when CONFIG_BT_HCIUART_H4 is
enabled. That makes the H:4 reassembly logic unusable by drivers which do
not depend on hci_uart, e.g. btusb which needs it to implement Bulk
Serialization Mode.

Move the transport agnostic part into the Bluetooth core as
h4_recv_skb(), which takes a struct hci_dev instead of a struct hci_uart,
along with struct h4_recv_pkt and the H4_RECV_* helpers, and keep
h4_recv_buf() as a thin wrapper for the hci_uart protocols.

Since every Bluetooth driver already depends on the bluetooth module this
introduces no new module dependency and no new Kconfig symbol.

Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: df5e35f1663a ("Bluetooth: btusb: drop BROKEN_EXT_SCAN quirk for 0bda:a728")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_h4.c     | 123 ++-----------------------
 drivers/bluetooth/hci_uart.h   |  39 +-------
 include/net/bluetooth/hci_h4.h |  60 +++++++++++++
 net/bluetooth/Makefile         |   2 +-
 net/bluetooth/hci_h4.c         | 160 +++++++++++++++++++++++++++++++++
 5 files changed, 229 insertions(+), 155 deletions(-)
 create mode 100644 include/net/bluetooth/hci_h4.h
 create mode 100644 net/bluetooth/hci_h4.c

diff --git a/drivers/bluetooth/hci_h4.c b/drivers/bluetooth/hci_h4.c
index 7673727074985..cbdf51458ec3c 100644
--- a/drivers/bluetooth/hci_h4.c
+++ b/drivers/bluetooth/hci_h4.c
@@ -29,6 +29,7 @@
 
 #include <net/bluetooth/bluetooth.h>
 #include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci_h4.h>
 
 #include "hci_uart.h"
 
@@ -112,8 +113,9 @@ static int h4_recv(struct hci_uart *hu, const void *data, int count)
 	if (!h4)
 		return -ENODEV;
 
-	h4->rx_skb = h4_recv_buf(hu, h4->rx_skb, data, count,
-				 h4_recv_pkts, ARRAY_SIZE(h4_recv_pkts));
+	h4->rx_skb = h4_recv_skb(hu->hdev, &hu->alignment, &hu->padding,
+				 h4->rx_skb, data, count, h4_recv_pkts,
+				 ARRAY_SIZE(h4_recv_pkts));
 	if (IS_ERR(h4->rx_skb)) {
 		int err = PTR_ERR(h4->rx_skb);
 		bt_dev_err(hu->hdev, "Frame reassembly failed (%d)", err);
@@ -155,120 +157,7 @@ struct sk_buff *h4_recv_buf(struct hci_uart *hu, struct sk_buff *skb,
 			    const unsigned char *buffer, int count,
 			    const struct h4_recv_pkt *pkts, int pkts_count)
 {
-	u8 alignment = hu->alignment ? hu->alignment : 1;
-	struct hci_dev *hdev = hu->hdev;
-
-	/* Check for error from previous call */
-	if (IS_ERR(skb))
-		skb = NULL;
-
-	while (count) {
-		int i, len;
-
-		/* remove padding bytes from buffer */
-		for (; hu->padding && count > 0; hu->padding--) {
-			count--;
-			buffer++;
-		}
-		if (!count)
-			break;
-
-		if (!skb) {
-			for (i = 0; i < pkts_count; i++) {
-				if (buffer[0] != (&pkts[i])->type)
-					continue;
-
-				skb = bt_skb_alloc((&pkts[i])->maxlen,
-						   GFP_ATOMIC);
-				if (!skb)
-					return ERR_PTR(-ENOMEM);
-
-				hci_skb_pkt_type(skb) = (&pkts[i])->type;
-				hci_skb_expect(skb) = (&pkts[i])->hlen;
-				break;
-			}
-
-			/* Check for invalid packet type */
-			if (!skb)
-				return ERR_PTR(-EILSEQ);
-
-			count -= 1;
-			buffer += 1;
-		}
-
-		len = min_t(uint, hci_skb_expect(skb) - skb->len, count);
-		skb_put_data(skb, buffer, len);
-
-		count -= len;
-		buffer += len;
-
-		/* Check for partial packet */
-		if (skb->len < hci_skb_expect(skb))
-			continue;
-
-		for (i = 0; i < pkts_count; i++) {
-			if (hci_skb_pkt_type(skb) == (&pkts[i])->type)
-				break;
-		}
-
-		if (i >= pkts_count) {
-			kfree_skb(skb);
-			return ERR_PTR(-EILSEQ);
-		}
-
-		if (skb->len == (&pkts[i])->hlen) {
-			u16 dlen;
-
-			switch ((&pkts[i])->lsize) {
-			case 0:
-				/* No variable data length */
-				dlen = 0;
-				break;
-			case 1:
-				/* Single octet variable length */
-				dlen = skb->data[(&pkts[i])->loff];
-				hci_skb_expect(skb) += dlen;
-
-				if (skb_tailroom(skb) < dlen) {
-					kfree_skb(skb);
-					return ERR_PTR(-EMSGSIZE);
-				}
-				break;
-			case 2:
-				/* Double octet variable length */
-				dlen = get_unaligned_le16(skb->data +
-							  (&pkts[i])->loff);
-				hci_skb_expect(skb) += dlen;
-
-				if (skb_tailroom(skb) < dlen) {
-					kfree_skb(skb);
-					return ERR_PTR(-EMSGSIZE);
-				}
-				break;
-			default:
-				/* Unsupported variable length */
-				kfree_skb(skb);
-				return ERR_PTR(-EILSEQ);
-			}
-
-			if (!dlen) {
-				hu->padding = (skb->len + 1) % alignment;
-				hu->padding = (alignment - hu->padding) % alignment;
-
-				/* No more data, complete frame */
-				(&pkts[i])->recv(hdev, skb);
-				skb = NULL;
-			}
-		} else {
-			hu->padding = (skb->len + 1) % alignment;
-			hu->padding = (alignment - hu->padding) % alignment;
-
-			/* Complete frame */
-			(&pkts[i])->recv(hdev, skb);
-			skb = NULL;
-		}
-	}
-
-	return skb;
+	return h4_recv_skb(hu->hdev, &hu->alignment, &hu->padding, skb, buffer,
+			   count, pkts, pkts_count);
 }
 EXPORT_SYMBOL_GPL(h4_recv_buf);
diff --git a/drivers/bluetooth/hci_uart.h b/drivers/bluetooth/hci_uart.h
index 48ac7ca9334e5..7fbe8dffab988 100644
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -8,6 +8,8 @@
  *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
  */
 
+#include <net/bluetooth/hci_h4.h>
+
 #ifndef N_HCI
 #define N_HCI	15
 #endif
@@ -121,43 +123,6 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable);
 void hci_uart_set_speeds(struct hci_uart *hu, unsigned int init_speed,
 			 unsigned int oper_speed);
 
-struct h4_recv_pkt {
-	u8  type;	/* Packet type */
-	u8  hlen;	/* Header length */
-	u8  loff;	/* Data length offset in header */
-	u8  lsize;	/* Data length field size */
-	u16 maxlen;	/* Max overall packet length */
-	int (*recv)(struct hci_dev *hdev, struct sk_buff *skb);
-};
-
-#define H4_RECV_ACL \
-	.type = HCI_ACLDATA_PKT, \
-	.hlen = HCI_ACL_HDR_SIZE, \
-	.loff = 2, \
-	.lsize = 2, \
-	.maxlen = HCI_MAX_FRAME_SIZE \
-
-#define H4_RECV_SCO \
-	.type = HCI_SCODATA_PKT, \
-	.hlen = HCI_SCO_HDR_SIZE, \
-	.loff = 2, \
-	.lsize = 1, \
-	.maxlen = HCI_MAX_SCO_SIZE
-
-#define H4_RECV_EVENT \
-	.type = HCI_EVENT_PKT, \
-	.hlen = HCI_EVENT_HDR_SIZE, \
-	.loff = 1, \
-	.lsize = 1, \
-	.maxlen = HCI_MAX_EVENT_SIZE
-
-#define H4_RECV_ISO \
-	.type = HCI_ISODATA_PKT, \
-	.hlen = HCI_ISO_HDR_SIZE, \
-	.loff = 2, \
-	.lsize = 2, \
-	.maxlen = HCI_MAX_FRAME_SIZE \
-
 #ifdef CONFIG_BT_HCIUART_H4
 int h4_init(void);
 int h4_deinit(void);
diff --git a/include/net/bluetooth/hci_h4.h b/include/net/bluetooth/hci_h4.h
new file mode 100644
index 0000000000000..a37e7df8c9ce8
--- /dev/null
+++ b/include/net/bluetooth/hci_h4.h
@@ -0,0 +1,60 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ *  Bluetooth HCI H:4 packet reassembly
+ *
+ *  Copyright (C) 2000-2001  Qualcomm Incorporated
+ *  Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
+ *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
+ */
+
+#ifndef __HCI_H4_H
+#define __HCI_H4_H
+
+#include <linux/skbuff.h>
+#include <linux/types.h>
+
+struct hci_dev;
+
+struct h4_recv_pkt {
+	u8  type;	/* Packet type */
+	u8  hlen;	/* Header length */
+	u8  loff;	/* Data length offset in header */
+	u8  lsize;	/* Data length field size */
+	u16 maxlen;	/* Max overall packet length */
+	int (*recv)(struct hci_dev *hdev, struct sk_buff *skb);
+};
+
+#define H4_RECV_ACL \
+	.type = HCI_ACLDATA_PKT, \
+	.hlen = HCI_ACL_HDR_SIZE, \
+	.loff = 2, \
+	.lsize = 2, \
+	.maxlen = HCI_MAX_FRAME_SIZE \
+
+#define H4_RECV_SCO \
+	.type = HCI_SCODATA_PKT, \
+	.hlen = HCI_SCO_HDR_SIZE, \
+	.loff = 2, \
+	.lsize = 1, \
+	.maxlen = HCI_MAX_SCO_SIZE
+
+#define H4_RECV_EVENT \
+	.type = HCI_EVENT_PKT, \
+	.hlen = HCI_EVENT_HDR_SIZE, \
+	.loff = 1, \
+	.lsize = 1, \
+	.maxlen = HCI_MAX_EVENT_SIZE
+
+#define H4_RECV_ISO \
+	.type = HCI_ISODATA_PKT, \
+	.hlen = HCI_ISO_HDR_SIZE, \
+	.loff = 2, \
+	.lsize = 2, \
+	.maxlen = HCI_MAX_FRAME_SIZE \
+
+struct sk_buff *h4_recv_skb(struct hci_dev *hdev, u8 *alignment, u8 *padding,
+			    struct sk_buff *skb, const unsigned char *buffer,
+			    int count, const struct h4_recv_pkt *pkts,
+			    int pkts_count);
+
+#endif /* __HCI_H4_H */
diff --git a/net/bluetooth/Makefile b/net/bluetooth/Makefile
index ff466ea97436a..b78ad98864d4f 100644
--- a/net/bluetooth/Makefile
+++ b/net/bluetooth/Makefile
@@ -14,7 +14,7 @@ bluetooth_6lowpan-y := 6lowpan.o
 bluetooth-y := af_bluetooth.o hci_core.o hci_conn.o hci_event.o mgmt.o \
 	hci_sock.o hci_sysfs.o l2cap_core.o l2cap_sock.o smp.o lib.o \
 	ecdh_helper.o mgmt_util.o mgmt_config.o hci_codec.o eir.o hci_sync.o \
-	hci_drv.o
+	hci_drv.o hci_h4.o
 
 bluetooth-$(CONFIG_DEV_COREDUMP) += coredump.o
 
diff --git a/net/bluetooth/hci_h4.c b/net/bluetooth/hci_h4.c
new file mode 100644
index 0000000000000..86f809018062f
--- /dev/null
+++ b/net/bluetooth/hci_h4.c
@@ -0,0 +1,160 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ *  Bluetooth HCI H:4 packet reassembly
+ *
+ *  Copyright (C) 2000-2001  Qualcomm Incorporated
+ *  Copyright (C) 2002-2003  Maxim Krasnyansky <maxk@qualcomm.com>
+ *  Copyright (C) 2004-2005  Marcel Holtmann <marcel@holtmann.org>
+ */
+
+#include <linux/export.h>
+#include <linux/skbuff.h>
+#include <linux/unaligned.h>
+
+#include <net/bluetooth/bluetooth.h>
+#include <net/bluetooth/hci_core.h>
+#include <net/bluetooth/hci_h4.h>
+
+/* h4_recv_skb - Reassemble H:4 framed packets
+ * @hdev: HCI device the packets are received on
+ * @alignment: optional packet alignment, NULL or 0 means no alignment
+ * @padding: optional padding state carried over between calls
+ * @skb: partially received packet from a previous call, may be NULL or an
+ *	 ERR_PTR returned by a previous call
+ * @buffer: buffer holding the received data
+ * @count: number of bytes in @buffer
+ * @pkts: table of supported packet types
+ * @pkts_count: number of entries in @pkts
+ *
+ * Returns the partially received packet to be passed to the next call, or an
+ * ERR_PTR on error. The returned value can be fed back into this function as
+ * is, but must be checked with IS_ERR() before being freed.
+ */
+struct sk_buff *h4_recv_skb(struct hci_dev *hdev, u8 *alignment, u8 *padding,
+			    struct sk_buff *skb, const unsigned char *buffer,
+			    int count, const struct h4_recv_pkt *pkts,
+			    int pkts_count)
+{
+	u8 align = alignment && *alignment ? *alignment : 1;
+
+	/* Check for error from previous call */
+	if (IS_ERR(skb))
+		skb = NULL;
+
+	while (count) {
+		int i, len;
+
+		/* remove padding bytes from buffer */
+		if (padding) {
+			for (; (*padding) && count > 0; (*padding)--) {
+				count--;
+				buffer++;
+			}
+		}
+
+		if (!count)
+			break;
+
+		if (!skb) {
+			for (i = 0; i < pkts_count; i++) {
+				if (buffer[0] != pkts[i].type)
+					continue;
+
+				skb = bt_skb_alloc(pkts[i].maxlen,
+						   GFP_ATOMIC);
+				if (!skb)
+					return ERR_PTR(-ENOMEM);
+
+				hci_skb_pkt_type(skb) = pkts[i].type;
+				hci_skb_expect(skb) = pkts[i].hlen;
+				break;
+			}
+
+			/* Check for invalid packet type */
+			if (!skb)
+				return ERR_PTR(-EILSEQ);
+
+			count -= 1;
+			buffer += 1;
+		}
+
+		len = min_t(uint, hci_skb_expect(skb) - skb->len, count);
+		skb_put_data(skb, buffer, len);
+
+		count -= len;
+		buffer += len;
+
+		/* Check for partial packet */
+		if (skb->len < hci_skb_expect(skb))
+			continue;
+
+		for (i = 0; i < pkts_count; i++) {
+			if (hci_skb_pkt_type(skb) == pkts[i].type)
+				break;
+		}
+
+		if (i >= pkts_count) {
+			kfree_skb(skb);
+			return ERR_PTR(-EILSEQ);
+		}
+
+		if (skb->len == pkts[i].hlen) {
+			u16 dlen;
+
+			switch (pkts[i].lsize) {
+			case 0:
+				/* No variable data length */
+				dlen = 0;
+				break;
+			case 1:
+				/* Single octet variable length */
+				dlen = skb->data[pkts[i].loff];
+				hci_skb_expect(skb) += dlen;
+
+				if (skb_tailroom(skb) < dlen) {
+					kfree_skb(skb);
+					return ERR_PTR(-EMSGSIZE);
+				}
+				break;
+			case 2:
+				/* Double octet variable length */
+				dlen = get_unaligned_le16(skb->data +
+							  pkts[i].loff);
+				hci_skb_expect(skb) += dlen;
+
+				if (skb_tailroom(skb) < dlen) {
+					kfree_skb(skb);
+					return ERR_PTR(-EMSGSIZE);
+				}
+				break;
+			default:
+				/* Unsupported variable length */
+				kfree_skb(skb);
+				return ERR_PTR(-EILSEQ);
+			}
+
+			if (!dlen) {
+				if (padding) {
+					*padding = (skb->len + 1) % align;
+					*padding = (align - *padding) % align;
+				}
+
+				/* No more data, complete frame */
+				pkts[i].recv(hdev, skb);
+				skb = NULL;
+			}
+		} else {
+			if (padding) {
+				*padding = (skb->len + 1) % align;
+				*padding = (align - *padding) % align;
+			}
+
+			/* Complete frame */
+			pkts[i].recv(hdev, skb);
+			skb = NULL;
+		}
+	}
+
+	return skb;
+}
+EXPORT_SYMBOL_GPL(h4_recv_skb);
-- 
2.53.0



