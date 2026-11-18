Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057527;
	b=5AalwMO2WIIAE8VX6RkoKDTP9l6qFKA+GPH9aoq0/etXVGu9GmTrUEZOAkB6D08H1FPM
	 HvoKpWGUvopSSCmXP6l4VVl0B12MdmBiFEX2Kpc/30Gpztl3JGTXpZ6By1rzS0lfVZ8ux
	 0cyr3meK+JUFIEwbwbC4gAjvIhSG+aQBYriyEPd4VsP7gab8qpo0UWYxax4P0e2rP1lWt
	 LzZFjYyzSjut+O9uSTQxaWf7S9RaKu29DDcRKHEduWVGVAKaofNQiXXcLzFr4UhMYsgyN
	 p12sX1DQzS70imNrHLSkLWuF4EfJFEWa0kaxFTU5hbbZkvmiYkFrbh3L7fnZIEsWYqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+fE4w0O6HnOuvtiqlzj3VjVNnzjel2tYdC60bAfcojY=;
	b=D5zQTmcQQf/CRMHIT8diix+fwt+huIFghOa7ehGzZx5rSyuLNuhi3qUyAVwZorzGH33Z
	 6ALxaNUkieeWsCUIB/6AutW3ywcu+FRqBHAxXRt+UHSyWrAOn1N3S6YKebotNEtA6QFEC
	 hZ0AeiaQXgDraMOmlm3Syv2C5Xi4njQTO6vXmzwJLLwA+LjueJ/Nn79tS83IdshdX/igw
	 HGIHgoza+CwM7tnFRfXIGx49fPql3QlUaRmgnMGgs88mpS+p9jPh8Z1rwl5AUHonqu90A
	 7GA8KQOsKsQ54qRDSttCat21n9uB4CTCahcrpFHa1NEPorpZAYXcacOPkhbWyaK6B9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVINzSx6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103D4606A330;
	Thu, 19 Nov 2026 03:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LVINzSx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7121F000C4;
	Thu, 19 Nov 2026 03:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057526;
	bh=+fE4w0O6HnOuvtiqlzj3VjVNnzjel2tYdC60bAfcojY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LVINzSx6DcOkM0LcBGL3J5paK2TO14HlU5OYu90PB8rUJ9+gw5tjP1ta10OZFqHbF
	 pNoV+wTeCDLHR1i2TnW/Uu1z4PYbXJ596sJPNKHIU6jnbhvLb/VeSeqKfNNPTeUaWF
	 2DghQa0VFFWpCwQGf2aiMsoJfo3A1ViFiSipNPrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0161/1848] Bluetooth: hci_bcsp: validate received packet lengths
Date: Wed, 18 Nov 2026 15:36:39 +0100
Message-ID: <20261118145918.343053119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit ceea75ad8925425ee6520ead964b55888fe871ec ]

The BCSP transmit path reads an HCI command header when an extension
packet has only been tested for a nonzero length. Its LE configuration
packet handler also indexes bytes through offset seven without a length
check.

Validate the complete command and LE configuration packet headers
before accessing their fields.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_bcsp.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/bluetooth/hci_bcsp.c b/drivers/bluetooth/hci_bcsp.c
index 8ff69111ceede..205a644545912 100644
--- a/drivers/bluetooth/hci_bcsp.c
+++ b/drivers/bluetooth/hci_bcsp.c
@@ -194,7 +194,7 @@ static struct sk_buff *bcsp_prepare_pkt(struct bcsp_struct *bcsp, u8 *data,
 		return NULL;
 	}
 
-	if (hciextn && chan == 5) {
+	if (hciextn && chan == 5 && len > HCI_COMMAND_HDR_SIZE) {
 		__le16 opcode = ((struct hci_command_hdr *)data)->opcode;
 
 		/* Vendor specific commands */
@@ -402,6 +402,9 @@ static void bcsp_handle_le_pkt(struct hci_uart *hu)
 	u8 sync_pkt[4]     = { 0xda, 0xdc, 0xed, 0xed };
 
 	/* spot "conf" pkts and reply with a "conf rsp" pkt */
+	if (bcsp->rx_skb->len < 8)
+		return;
+
 	if (bcsp->rx_skb->data[1] >> 4 == 4 && bcsp->rx_skb->data[2] == 0 &&
 	    !memcmp(&bcsp->rx_skb->data[4], conf_pkt, 4)) {
 		struct sk_buff *nskb = alloc_skb(4, GFP_ATOMIC);
-- 
2.53.0



