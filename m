Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060976;
	b=fkZKQTGtSZapXUIbxJbaIah7ySNgmQBSdXsdMQfyMIFjm+MGbMHbTUL9xuRQzeVTEreU
	 mSEt9oAEbLyK546TCSpgDT/LQwqMafF4gOx7QakPwCX6OvkcNqz8iSm3vyE5F3+6TZSET
	 2HO1BdTpeElDDkZuxsalv73eub2Uf7fYlomucgF82/Q5U5fF7SVo7REJit9RPmBYaKDWt
	 EIfmfe7gI0E1SrnbqGwLMVT6o1dbpHqLiHuyV3fMS46zZT2OhVC1lzKav6RZAntN1mkE9
	 bORPVZR4rGpxSywgbez04rKa8l4Eh/mtSxbVQqOga4MRlWn6eHVIeIjwxVFjFTCJzfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FInDh7UqMhoB2vyEAoUZbsWsD6tZ3x608Y27RNqVZP8=;
	b=YMoPtkW2DANxeXDfnze5ldcUwGhZB/lAeMWzC9j7T4fOx4sgI+BfjPS0/Xhe1uIfzW6p
	 mYwQ9Umvai9v6MkxVoKCnftzN/SzouU50XA9cnc05jZ9Wgm7RgyZ4NfWhEja1oA/A/rnw
	 6uxvJM1bXtlcT7VLgzJEEtRDMJkFYbZxhoVIKPDqzS1RNAwv2i1kQc37Mcy9sNAvxvlCj
	 JT7br/W5pFIZsLB8mlvbQAvQ0zlOnsLstyGIaN1JxBatwXs+n6A9CXJRqHMuY0F+Cz2qc
	 pzOmiV4eP3j+DzAztygBus+ZSzxi+16MPtrJs2tSLgVu5o23HFPyiHQVYLNK0jOeQLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJBg0a8s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D70606EE80;
	Sat,  7 Nov 2026 14:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJBg0a8s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A731F0089F;
	Sat,  7 Nov 2026 14:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060975;
	bh=FInDh7UqMhoB2vyEAoUZbsWsD6tZ3x608Y27RNqVZP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJBg0a8sqtjAjXq/t7/KO6mZ2g7GPfy9ljspsPlvw1hs7yPfQYUKbIPUtnQ5QWjTs
	 ImSEaeJucwn3xOU493H2zIFbYWPKkZJyYv7fZFf2UWD77GZR+fCPPI2fQ3a70CKI65
	 Z7yz8P+5vyvtDWn1nVG3fHd3/18u6GrwnZbRmwI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0294/1536] Bluetooth: hci_bcsp: validate received packet lengths
Date: Sat,  7 Nov 2026 08:38:30 -0500
Message-ID: <20261107135005.988389623@linuxfoundation.org>
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
index 6cb904b7b643c..3231919676e06 100644
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



