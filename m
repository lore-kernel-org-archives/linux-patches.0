Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624317;
	b=IkOzuUmtKBERSS0gsJ1Ru0Reojumcu0TlIzvDkus6Wm17m3Sk0hEmEwxvDdhWWf2+1db
	 oYliDIdTihbmAq/hMCNirPZ2qr6qQaTa8PBm/WQTQoyx03uwzHWOFLiwGZ02IIoWicPBI
	 YqMlJ4HG4Nyc1HaRS0DSveC0j4i7XFkutBSTaqSgr35XymW24wBiJhy/W8wyCmTOGfMQf
	 3tFba3vL1fM8no2iw3kr1zvA+ED2Bl9C+KJizpvXUhKOWDS4jlVxtYN/eC+/3NDRmfZX1
	 QZZ7zaN2og8S3hUvuazAjBCS9IsWR8+Y5g9wQ7F/qW4J0jcKMc+VAYC0mBA9+Tfv6Bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+GDBO7wiUeJBZGOoLsy3nDBezfdmHyByTKbcBYMiG9o=;
	b=bTEDb+aN7b6z7//NlJVbRPVHPuA5/fcRSOlOh1QI/2X/XPs1NBEm/329MIc7zHhz0FJT
	 gYCg3Uf3xnGyCmTyFKP/8US+yIkuXRZIwh/6Hm3r01viNTETw/j9yF7BnLnNaJr+3Cwzl
	 z6XHaag5CwFylhWOJZrIctBIjKGjDqNeqp94ZBLwAW2GzBWpU3UlYfeaPySmGHINLSn8K
	 6DPHVeJ4rA0NzqZPLECN9NQ6nCEZYSU/m9FHTgpp1GSPF4I2oOc3CvPMBYC1nvDeYEqm9
	 /aakpSVe8NT/HDahN/yVAe5XhyhZhyMrettc/0+bMNhSrRRG0U0OxAHObH33hDumjQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Go0auaoj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1148F606A33C;
	Wed, 25 Nov 2026 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Go0auaoj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F021F000C0;
	Wed, 25 Nov 2026 16:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624316;
	bh=+GDBO7wiUeJBZGOoLsy3nDBezfdmHyByTKbcBYMiG9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Go0auaojjK4tKcTPst5ukdCXgfJNtfq+/LhvUZvWG8VCdbnZnZBXz+70IhHgG7Jsw
	 axBvske4LLR6iE65xdsrwobqDD7tf9kuFKL8Xmk4ml+6DpZmo8sohVEio50zN+2m8r
	 +RCR0zPhdDHb6A7Sy2ELNOu/OyAtPuL3okxwCHdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Qin <hao.qin@mediatek.com>,
	Wenlong Tian <ot_wenlong.tian@mediatek.com>,
	Chris Lu <chris.lu@mediatek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/816] Bluetooth: btmtk: drop zero-length ISO packets from endpoint padding
Date: Wed, 25 Nov 2026 15:28:22 +0100
Message-ID: <20261125143852.760026305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Chris Lu <chris.lu@mediatek.com>

[ Upstream commit 8524c3588fbb9d5c1b876e6f908c42926845650d ]

The ISO interrupt IN endpoint delivers a fixed-size transfer that holds
one HCI ISO packet and zero-fills the remainder. That padding belongs to
the transfer rather than to the stream, so it has to be dropped instead of
reported to the host.

btmtk_recv_isopkt() keeps parsing it: the zero bytes read as an ISO header
with handle 0 and a Data_Total_Length of zero, and each one is passed to
hci_recv_frame() as a complete frame. A single transfer yields a long run
of them, which is what fills the HCI log with malformed ISO packets, and
iso_recv() drops the SDU it is reassembling whenever handle 0 belongs to a
live CIS/BIS.

A zero Data_Total_Length carries no ISO Data Load, so such a packet is
never part of the stream. Check for the zero-filled remainder before
starting to parse the next frame, rather than after assembling a 4-byte
header: a remainder shorter than HCI_ISO_HDR_SIZE would otherwise be held
across calls as a partial header, corrupting the next transfer's framing.
This also means a fully zero-filled remainder no longer costs an skb
allocation that gets immediately freed. Reaching a zero Data_Total_Length
any other way is then a genuine error, not padding.

This was observed on MT7925, but btmtk_recv_isopkt() is shared by every
MediaTek USB controller that supports ISO data.

Fixes: ceac1cb0259d ("Bluetooth: btusb: mediatek: add ISO data transmission functions")
Co-developed-by: Hao Qin <hao.qin@mediatek.com>
Signed-off-by: Hao Qin <hao.qin@mediatek.com>
Co-developed-by: Wenlong Tian <ot_wenlong.tian@mediatek.com>
Signed-off-by: Wenlong Tian <ot_wenlong.tian@mediatek.com>
Signed-off-by: Chris Lu <chris.lu@mediatek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btmtk.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/bluetooth/btmtk.c b/drivers/bluetooth/btmtk.c
index 0444804a472cf..212177d7773ee 100644
--- a/drivers/bluetooth/btmtk.c
+++ b/drivers/bluetooth/btmtk.c
@@ -7,6 +7,7 @@
 #include <linux/usb.h>
 #include <linux/iopoll.h>
 #include <linux/overflow.h>
+#include <linux/string.h>
 #include <linux/unaligned.h>
 
 #include <net/bluetooth/bluetooth.h>
@@ -1176,6 +1177,14 @@ static int btmtk_recv_isopkt(struct hci_dev *hdev, void *buffer, int count)
 		int len;
 
 		if (!skb) {
+			/* Drop the endpoint's zero-filled padding before
+			 * allocating an skb for it; a zero Data_Total_Length
+			 * check below would miss a padding remainder
+			 * shorter than an ISO header.
+			 */
+			if (mem_is_zero(buffer, count))
+				break;
+
 			skb = bt_skb_alloc(HCI_MAX_ISO_SIZE, GFP_ATOMIC);
 			if (!skb) {
 				err = -ENOMEM;
@@ -1199,6 +1208,17 @@ static int btmtk_recv_isopkt(struct hci_dev *hdev, void *buffer, int count)
 			/* Complete ISO header */
 			hci_skb_expect(skb) = __le16_to_cpu(dlen);
 
+			if (!hci_skb_expect(skb)) {
+				/* Zero padding was ruled out above, so a
+				 * zero Data_Total_Length here is invalid.
+				 */
+				kfree_skb(skb);
+				skb = NULL;
+
+				err = -EILSEQ;
+				break;
+			}
+
 			if (skb_tailroom(skb) < hci_skb_expect(skb)) {
 				kfree_skb(skb);
 				skb = NULL;
-- 
2.53.0



