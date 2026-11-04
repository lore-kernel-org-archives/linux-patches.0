Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830848;
	b=XPIELg2cdN09RdpsE1gnhxKZrLkle/7X1HMwk01bzVPl8VaEUoUxpCFTTs4B7+9w3V4t
	 CmVB8kXNHj80N3ebrWfyJ9Tdf/RgaI+m/NjV3Lzr0pneLp7o2vpC8pCYcd6SYGzLYQeDT
	 Jmfx8Ui7fpbo7L4pDUUb0WH6PCSnrNbJhPoOM/kvZ8zhTwKyoZohYfs4d/SrUmCwNOLXw
	 nmO/I75HvktPBl5NMV3qQAzYDuIrrmuN2YsIUZu/4+mxLiJH4rCANGaLfiCUR7aoA4uAT
	 tAeMPD06X+SeUywsmRtRGU6jVo1SIbXn32B3bvcrzVjlrLk0YSJUR+lm71cnBuz9Mzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830848;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dw2I+tChsLI87iW51ErMM6QNCkRe3z+YQCujaXVuwa0=;
	b=dX/J8dnWgkrs72kdp4VxvZKGLeXqML257BMpCQsM2iATAl09Waoh6OMyHNPW/p9V74JF
	 ASb0++D8HzZbZ/2xWdUuhDC/ly8cVtGkDuxsgvovPvbWR4F+rxQWRliE0ghjGdbAhmdXf
	 gQ8eE5baASCE3Jea5l3PbekiL3YLtmd8/dOA5JLJfKWV0F4+CEQDqno6RMuy23D3KiTNk
	 1wLceisFErvy4SOHVW2kbiQYtWQLYJ+VEwFS7UGIfuuG1w6vNOGJJK6ScxO9GKO8h9/kP
	 Dw15o3257hSuRSNsUqhERTOXcaF9pkeJ0He1PQPCn1B/k23RMFcQBgQJkmavkVduSmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="l2KV/2zr";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CC9606B2D8;
	Wed,  4 Nov 2026 22:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l2KV/2zr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5871F000C1;
	Wed,  4 Nov 2026 22:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830848;
	bh=dw2I+tChsLI87iW51ErMM6QNCkRe3z+YQCujaXVuwa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l2KV/2zr8HJ+9VtEK8gM5yBCaPqN9jwD+4b+j+JdeHlsWwgAbIPiPHvNivFFMCJAL
	 JtH4TpklL5J7f+L14Jfe1szAHiL8ML8oheh6zAOxFCBxoWULONOAkOch4xzP7X+Ihc
	 iDuzJopjMpaOXtetpG5A9ydmLi2GOi7JT/vp3wew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0358/1005] Bluetooth: hci_bcsp: validate received packet lengths
Date: Wed,  4 Nov 2026 16:01:31 -0500
Message-ID: <20261104211054.111246145@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 591abe6d63ddb..6461492cf653b 100644
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



