Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049868;
	b=JIeML27hmOa0X+i1pUoxNQ7l752CE1MwckdwT6OJ96uA3EyCt/bwA3/BFD1IrS45ktku
	 ARENjVthZnoqsGtjPfhKs8T/KmKoNpsJGYoLranWgG6o3HfckELA7Q3NJm/IJYK6ZFXoc
	 wO8o4tWmsn8oA88l5HsdvM6Hd+HrE0cFZB4QyjVPe68FQ2YVldENWWCXsJuM7eEIdGD1l
	 FUog5D71f972rZHdq3B3OdEhH8z53kv5AMHyZpmMsYbOUyqPY79KqIZaZo0vjVazq3jIW
	 s5L4j610wwApUr52KW6AfEg8vY8RbFRppC5UHU2Sy9FKvLES9ozkuQop/z0WzQCfwiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UlWhTKYMkw1nFPu3iD6SecB/igRC9Cb90Q/rwezEFhA=;
	b=lvWbDnQ6jqWobpSKh+n7d3y5tgNytykOUxLSmb+cg5Ru6m/ToIZpY6Z5SpllCwYXywR8
	 JoXbb0LhJTv0c4xiNS4Q2qSK52mFwz1lb2gza5ZWMyb8bs/+CIaFbmOF0MPSvfGQ1HRJk
	 qFgwnYzESWbgUPLDkvsDSJxtMK3xSL7aemVY6G5YGEqEzob3DMt0KvgPC+NOTHfcG89jy
	 BVvrdnM8A7DRmmtr0sNn5XAkereyewgQl6eW0xbZQcREY2aSyVG82ue44fyAbKQ4v/DLq
	 6MAFcRxqRRl+ruyKnv1yTdxy/QFdkFWiplOAmvQUwo8AMkhZ0a+micFp575Rh634tMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osLeGj00;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB83B606A332;
	Thu, 19 Nov 2026 00:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osLeGj00
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F17B1F000C5;
	Thu, 19 Nov 2026 00:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049868;
	bh=UlWhTKYMkw1nFPu3iD6SecB/igRC9Cb90Q/rwezEFhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osLeGj00/+Sabi7vX3WvIqIlhn+xaAR1MyyeBTMW5EE8oWjmqOz/PgL6WGXFkwjk7
	 AKV3PlMRWPmE99p0f5uU/aHgwv/h6+zeI4bCm44+xsRZ59Uj/yHLtruxEv+J7SEi4J
	 OQOjdZGx3n8jGhcEcjQdhFSzdI4dhZ56Xk3VUdxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Chou <max.chou@realtek.com>,
	Hilda Wu <hildawu@realtek.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2506/2857] Bluetooth: btusb: Ignore zero length of USB packets on ALT 6 for specific chip
Date: Wed, 18 Nov 2026 15:59:00 +0100
Message-ID: <20261118150331.784359363@linuxfoundation.org>
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

From: Hilda Wu <hildawu@realtek.com>

[ Upstream commit a479e71322ced3e663b0baf17a6d250c973454c8 ]

For USB ALT 6 settings some Realtek chips need to transmit mSBC data
continuously without the zero length of USB packets.
In this commit, create BTUSB_ALT6_CONTINUOUS_TX to manage the behavior.
Therefore, create REALTEK_ALT6_CONTINUOUS_TX_CHIP to manage the specific
chip model for the behavior.

Signed-off-by: Max Chou <max.chou@realtek.com>
Signed-off-by: Hilda Wu <hildawu@realtek.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Stable-dep-of: 56e20c3d8ad3 ("Bluetooth: MSFT: Serialize handle map cleanup with event processing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btrtl.c |  7 +++++++
 drivers/bluetooth/btusb.c | 25 +++++++++++++++++++++++--
 2 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
index e5112331594a8..140eb43a32ac1 100644
--- a/drivers/bluetooth/btrtl.c
+++ b/drivers/bluetooth/btrtl.c
@@ -890,6 +890,13 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
 	case CHIP_ID_8851B:
 		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
+
+		/* RTL8852C needs to transmit mSBC data continuously without
+		 * the zero length of USB packets for the ALT 6 supported chips
+		 */
+		if (btrtl_dev->project_id == CHIP_ID_8852C)
+			btrealtek_set_flag(hdev, REALTEK_ALT6_CONTINUOUS_TX_CHIP);
+
 		hci_set_aosp_capable(hdev);
 		break;
 	default:
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index b850b6835334b..9f91b7521a0e6 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -792,6 +792,7 @@ static const struct dmi_system_id btusb_needs_reset_resume_table[] = {
 #define BTUSB_TX_WAIT_VND_EVT	13
 #define BTUSB_WAKEUP_AUTOSUSPEND	14
 #define BTUSB_USE_ALT3_FOR_WBS	15
+#define BTUSB_ALT6_CONTINUOUS_TX	16
 
 struct btusb_data {
 	struct hci_dev       *hdev;
@@ -1453,11 +1454,17 @@ static void btusb_isoc_complete(struct urb *urb)
 static inline void __fill_isoc_descriptor_msbc(struct urb *urb, int len,
 					       int mtu, struct btusb_data *data)
 {
-	int i, offset = 0;
+	int i = 0, offset = 0;
 	unsigned int interval;
 
 	BT_DBG("len %d mtu %d", len, mtu);
 
+	/* For mSBC ALT 6 settings some chips need to transmit the data
+	 * continuously without the zero length of USB packets.
+	 */
+	if (test_bit(BTUSB_ALT6_CONTINUOUS_TX, &data->flags))
+		goto ignore_usb_alt6_packet_flow;
+
 	/* For mSBC ALT 6 setting the host will send the packet at continuous
 	 * flow. As per core spec 5, vol 4, part B, table 2.1. For ALT setting
 	 * 6 the HCI PACKET INTERVAL should be 7.5ms for every usb packets.
@@ -1477,6 +1484,7 @@ static inline void __fill_isoc_descriptor_msbc(struct urb *urb, int len,
 		urb->iso_frame_desc[i].length = offset;
 	}
 
+ignore_usb_alt6_packet_flow:
 	if (len && i < BTUSB_MAX_ISOC_FRAMES) {
 		urb->iso_frame_desc[i].offset = offset;
 		urb->iso_frame_desc[i].length = len;
@@ -2507,6 +2515,19 @@ static int btusb_send_frame_intel(struct hci_dev *hdev, struct sk_buff *skb)
 	return -EILSEQ;
 }
 
+static int btusb_setup_realtek(struct hci_dev *hdev)
+{
+	struct btusb_data *data = hci_get_drvdata(hdev);
+	int ret;
+
+	ret = btrtl_setup_realtek(hdev);
+
+	if (btrealtek_test_flag(data->hdev, REALTEK_ALT6_CONTINUOUS_TX_CHIP))
+		set_bit(BTUSB_ALT6_CONTINUOUS_TX, &data->flags);
+
+	return ret;
+}
+
 /* UHW CR mapping */
 #define MTK_BT_MISC		0x70002510
 #define MTK_BT_SUBSYS_RST	0x70002610
@@ -4140,7 +4161,7 @@ static int btusb_probe(struct usb_interface *intf,
 
 	if (IS_ENABLED(CONFIG_BT_HCIBTUSB_RTL) &&
 	    (id->driver_info & BTUSB_REALTEK)) {
-		hdev->setup = btrtl_setup_realtek;
+		hdev->setup = btusb_setup_realtek;
 		hdev->shutdown = btrtl_shutdown_realtek;
 		hdev->cmd_timeout = btusb_rtl_cmd_timeout;
 
-- 
2.53.0



