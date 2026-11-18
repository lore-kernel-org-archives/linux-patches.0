Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043454;
	b=4xpt8mutmqCiZMT8GMIW/r4a+fICZtuoDXepvSjFOZsAYLpBX/kBvMfFjyGkOChULCmY
	 b7CuwB5FhVrNo5ji7KsiEQ0RnczVD19SQVDStV/ImkWerSNgO+SJZXqdz6k/oQKObm68T
	 I90qXuTsgc7Fnk1G/AmkB1gdAjdeyJ9VdwTxYA6JXTqOoQSe7mPenC8ACH+ZVt8IDypKo
	 KfZ+8HejeQpE1W/r/RQBJgSaw+DuKsxhjcAyMXPEcrs8XkNizT38z8HSnRp5ZMfnKZ0FD
	 wL2GboNT08vq9IAnqGfRCFfouPMcOOhnHVAilCej+VSeant5rzgGVZlsTyYB2ERMFDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gssm05DTBxkzvVqbDrYpGu3mKTX8o0CpvNNzMP+fLFA=;
	b=ahZTY60SB46xLfq/x/hTaMhrpU/REU/y8TqLWc4Z+w6+hjJTcFYFck76wULjcK5AezR7
	 QGgXBcSc+yLDn/EKUZ9+7teHh7lqXjw6zV1I5rPm+ioWiwBg9F9GTV6ZDvcA+HGWhGe6n
	 kglFx0+0OpSTU1rTMyRhEWJ5Aa5YmlbreEEcx24euc/vtUAEsICwHbOy9NmPfJScr3aQr
	 4tdZ4ywKupDeP3weekx6hFhCOpPr3lzxHsJQzcMisVQigDWk8/iG8jjImeNQMrxoJ/e2r
	 JKVGFGxvheD2hxTlhSGFnvM0AMk0zr1yTJwvv7i81iIhSsnTc3fFqmFWQV9E2lFaj7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lWwWdm9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3000606A335;
	Wed, 18 Nov 2026 23:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0lWwWdm9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 344201F000C4;
	Wed, 18 Nov 2026 23:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043454;
	bh=Gssm05DTBxkzvVqbDrYpGu3mKTX8o0CpvNNzMP+fLFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0lWwWdm93dJ5/6dvwblvUUSs/CA9IKWCqD7hMGLWBjkwYBoXWVMwReg4C8SVa9byW
	 q5bOtxJR7tEKgpiQ1RD3oM4BBIW26dgz9MSNqzEFjeitBN07+RigaQK7szNvB81gZs
	 EeyZ3cPG4OoUvN/KLNklktblWzSNsbFQsfP6oSgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0216/2857] Bluetooth: hci_bcsp: validate received packet lengths
Date: Wed, 18 Nov 2026 15:20:50 +0100
Message-ID: <20261118150209.240174391@linuxfoundation.org>
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



