Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051388;
	b=VXobILDma4R7ARXT3cZxb7TR7XlY1BkGz9J3fZLm95Ynk0a0knLz9Ll7b+hgF0whgfQ4
	 QUg+avh4LfZ3+SFmK72DQqB3s8B7adiTGLE3QNYcmC9JArfpDmlxZJj5GO7GVFIPIL11e
	 b1EH3UjU1QbBolt65ZPPckX4gCStI8Z6E3588Fnfjpbi2He74bPlTMrT+83fk8jpxQLmk
	 jo2K0qs9EUKZTXmZTlz63lLrZtcTGV3kbyw3kU9l09mMLRNTdx+rn0wZSkOENUvT14ESW
	 ak00TZU5xY+jX2yBhxOkrOjVkR0ZcR8ql1tnaxBdAOBmK7lcHpObNPfYLwxyQ+Is/oA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QA0Mlsn3EgVeJx7Dq4m2/5/X2KK0s9M8i67szEy11Eo=;
	b=CKhCtWoTexYNmPzAU3jWy7F+B4dOAzsAnFdPUczhSahZDiNx6tkDyjDxndiAzkEaOX1y
	 yvy/hIqgnkjX87SxqaAJ00OTYPmiKF22xxXfzuXfnT8ihV4dlToFEIGJErLCKalwwCke9
	 4icTRVE7aYjSZXqQ34MMLgybu2DCKe6gUVIQcPaKw5eSUPbDgYyINKpxYEoZ1mIzGtTiq
	 fWXcRCE7BbzVpaPNTwfU4i9WWgDWIKjTbqdZino0D5XEewyj5NHMyZaco3Sm2DhV2c9tt
	 AGjCSF1mBAmBbS5iRbSZy7tP4Iqm+6OjJv39Uyif7y+fvTJIbBXFUH6eOsHPBb1PO5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzD8fY93;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6641606A332;
	Thu, 19 Nov 2026 01:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IzD8fY93
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4270C1F000C4;
	Thu, 19 Nov 2026 01:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051387;
	bh=QA0Mlsn3EgVeJx7Dq4m2/5/X2KK0s9M8i67szEy11Eo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IzD8fY93+YknEdadAPnlzEpCo2mJyH3mdrUMSa3W3SPLLultdMUTZ+PCq93+MimKm
	 RW7kyj50uOsMOz79rXGlPnpa13wpD83qg6p+eSfyy75fFd1CwUUvleJv2doctIw13v
	 YdZPU+MCKIDZda3PYVh429xjKVqNU6rh4iMrhn1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0190/2214] Bluetooth: hci_bcsp: validate received packet lengths
Date: Wed, 18 Nov 2026 15:31:06 +0100
Message-ID: <20261118150017.755500965@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



