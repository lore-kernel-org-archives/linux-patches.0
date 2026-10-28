Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215997;
	b=ca9tP8MIilNU1cAODPn9kxA2MzhLbDhkVqdLQXAAhWRi9W9K4dhqvfaoJkfwe2f6LQPh
	 cYiKJvVE7qi4d0BcxyHgzfYI1PEF74h7Rg/sJetJs/yMsWGCtQGnAV9dQ9sdIbrcSHgZo
	 znPxysZvW2cfVfAs0UtfbwUZrpyQvB0BwcOLn6orUS2203RJerwIVkOtDX+rhcscA94Ru
	 qz3V8ATJ8aO7hFl/nnF9/dAE+pwLqVyZqKJAW54xYjxITTNtHA+D2eMM68crqkvXQewJg
	 LvzKvj2gpo28FsbpPSZ2zgXHNgS7L3qnks9eIT7Ek7eCVbwTXpNcWOdl3Km83Ne7mBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HklBHxlLeMs9C40nIjOKBSA8qnVu+zVhnUfv9Do0UYY=;
	b=uDP7rYgH7a75amYgEL5fmVhfia7nvYLbkaQrQkZnLF0a7byDbXqx/OLEqn3+U5LnQ8dN
	 U9fAa+mjgdtJXgkPmGEhtMYQ9sn0V5qiFuIO1f27QCWF0MNzr/2d3Favj8frRG3+XHUNF
	 I1KouxBzdfzdUye3rRg5tggla9iynOyEmjr/XInp1U8bB7wzDdQVPamRRX7QgGMALYl7k
	 cdZRbDWTvXzBwIKQj3O3oQFdNrD3N49iLF7JffwmzEuARA5aaGME90N1pJLRSAmVNLl9S
	 B6ZjdPDrmnnTgMiGnNxelGbNQh0Fyvewsw7mv9Fw/FpLljTSJUINy59zUDwlyUbaRTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCYrx9Qx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D32606A31A;
	Wed, 28 Oct 2026 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HCYrx9Qx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8801F01825;
	Wed, 28 Oct 2026 19:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215996;
	bh=HklBHxlLeMs9C40nIjOKBSA8qnVu+zVhnUfv9Do0UYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HCYrx9Qx/0Zg46cii2ZMuq5X+MK4FIS5c7p+Sf362vqGYUfN/fBW/IABB1PT+pNnH
	 B4D+Gs8fnw8CI4MXKcAduc3gNtmrnfRbdt9tDfO9zHaPXllI3IHHsD9VB2KEEnt8+5
	 TeyUYZ/+VmuHNKW5sdW2evNeiuqTfuqBdEV2YqP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1368/1887] wifi: mt76: mt7915: bound the device EEPROM address before the EFUSE copy
Date: Wed, 28 Oct 2026 17:57:44 +0100
Message-ID: <20261028170530.579543648@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 44b5adfe49499f53002737f5fe81d608c08122fc ]

mt7915_mcu_get_eeprom() copies a fixed EFUSE block into the driver's
dev->mt76.eeprom.data buffer at the offset reported by the MCU response
(res->addr, a device-controlled __le32) without checking it against the
buffer size. A malicious or malfunctioning device can report an arbitrary
address and drive a 16-byte out-of-bounds write past eeprom.data.

Reject a response whose address would place the copy outside eeprom.data
before deriving the destination pointer. Devices that echo the requested
in-bounds offset are unaffected.

Fixes: e57b7901469f ("mt76: add mac80211 driver for MT7915 PCIe-based chipsets")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Link: https://patch.msgid.link/20260625-b4-disp-16f99062-v1-1-aee52ecf61b9@proton.me
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index 9074ebae752d5..6cea8b2791bba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2769,8 +2769,15 @@ int mt7915_mcu_get_eeprom(struct mt7915_dev *dev, u32 offset, u8 *read_buf)
 		return ret;
 
 	res = (struct mt7915_mcu_eeprom_info *)skb->data;
-	if (!buf)
-		buf = dev->mt76.eeprom.data + le32_to_cpu(res->addr);
+	if (!buf) {
+		u32 addr = le32_to_cpu(res->addr);
+
+		if (addr > dev->mt76.eeprom.size - MT7915_EEPROM_BLOCK_SIZE) {
+			dev_kfree_skb(skb);
+			return -EINVAL;
+		}
+		buf = dev->mt76.eeprom.data + addr;
+	}
 	memcpy(buf, res->data, MT7915_EEPROM_BLOCK_SIZE);
 
 	dev_kfree_skb(skb);
-- 
2.53.0



