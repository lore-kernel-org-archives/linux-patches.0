Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034199;
	b=QiW6A9qyD/jL/9K+76cKODBaYcvzkkOvRLmHizy+CEQF0yHMcTmx4K1F6WiiWPdEO4SN
	 5X++f5OmiQsDMPuqpkXzHZJ9oP+p7sCvJqBovkRxkW0EzgKZSc+UVgBpT2lXPZn/94VE5
	 2FjeFsxZXw9UahAr8BOaXDX2F5eOZ3ZgEWJ0JCwyaownCXdUAHx4H7hiNP4fY6HTOtf6b
	 bapfS+pM9WyRxVRBJTvLqcKFEulDVMTFQWpPVdjAZqvLfHH91Rxs+92zrTeTlJENgwga5
	 SlYpmexpJkEWrKNbec39RJxEhqHzQdg9DOUaFZdEFEoH7UfkYsrTWF4xp/lERKN6g7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OyjmTv65o0V5OjfJ/OsuIU2keknMxACFtNzploM9tH8=;
	b=3gDZF9IHJBIR3lJDiPpOa3+IIGe6vZpOdH/Q9+6/qIjhmuo2MYj/jsDss4gchT9n3Rwk
	 VHutamkrOo3A9KqaA/ruaEUTfmoiZMT7bMUhdg3SFC9VP/5POxs7XUbdaOj5UInIFJPY8
	 8oJuafuengKv+cqV1gtdr+8+1oULrdrPlb01zEcTRZOUu4Qce7OACrlhZ3+YbvuJ6xlQ+
	 h50bRRRf5IvMsmS2nY/4u5sQT6ahuqRy0Yl89bT9VSiFsRrbXcghflaHaXM/Zg+I/OwLO
	 QOrkRRMCVvB6gwKLOWOVikOdlYl8UHeUnlF2yAt2M9Frtdj7PaGEphmK2RwMC8i4dCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeO8qq59;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DF7606A320;
	Wed, 18 Nov 2026 20:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BeO8qq59
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816761F000C4;
	Wed, 18 Nov 2026 20:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034199;
	bh=OyjmTv65o0V5OjfJ/OsuIU2keknMxACFtNzploM9tH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BeO8qq59SxgquPfsZ+W2/Y/7FxxvvzkYBqHcSheL7B/cEO7YwKKbBzkbN2oGKFgs8
	 J6vC4NxJ0dfXY34DZQAwGY34klgIraADvwKrlmaol+7LS77Vzwe/e8l8ZlX1NKI/Kj
	 xKrmXYWyC8l+s0z/krUmKpZ/ix7Xz13lIRWWJLWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0249/3318] Bluetooth: hci_bcsp: validate received packet lengths
Date: Wed, 18 Nov 2026 15:14:31 +0100
Message-ID: <20261118150322.758488124@linuxfoundation.org>
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
index e991d9e624869..0bd50471ef869 100644
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



