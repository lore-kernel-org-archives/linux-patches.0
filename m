Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019133;
	b=XvopBxi6HXgJ/g4CJZwpo4Mck4keQLnd6agnslFbXRzaX6rzIGvX+NByqx386m+YZ+za
	 XshHBmUGKJ84PYv0DibobsJQc7aw6Ejz72ZQ+FEDldwOy+da/Sxhp+abCtS98NZCNZdov
	 Dh8er1oq8US/hOSQ/WKGs+AUq8x5cCxW8AVCq8BC9x9ydLCSP5KKfxqeiTzxl2+8XClew
	 jGTeIWN5AO6iMU7IxCXExgiy9UjlUt1yAhR8dQGYEhD7qidjO8Vfun7SSWsOVJgIjsJ9/
	 i9yLq0c8DT+v6UUqFoF8hlYqo9LWZ1jnMI+rw7LV7VBGEFEVNZHBaO+zLxA5XPuy09A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ti1YJthlWbkNwZ4JBiOJQopQ9VMSdN7b6GY1GE6nCbk=;
	b=lFP067Pq+RDplfJUBzpj63j2vWBy2DkGKJQS4u6iXxZ51/rz0VVIMgkvpEoX/rgYr9a/
	 mpOnMqzgA5srGnMiZwcSw1bqtfRyEe3aKftnscjeaaWl/Q5PqurrL8pFFbga61ikC5O3w
	 BEWWaeJ7jU5XlEAz/D+RczCb4hwtLFdUHp1ZrVZ7nqiHXZBUirACVuRdBUBsnMnocnDcQ
	 oFznB3dInyeGgFAzHxCvEBJW0FQvPuA7fK3n2er7Ons+zClBxoexrU1yaE0dkbakxQD/q
	 sNO0/Bc7KhAbIevZbdDY08twJ9lGcH0vY1jlejhf3jxWF6S8yZaSOCWWtsjTV8hmOXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ALQ2/JJA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059BA606A32C;
	Wed, 18 Nov 2026 16:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALQ2/JJA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311A51F000C4;
	Wed, 18 Nov 2026 16:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019132;
	bh=Ti1YJthlWbkNwZ4JBiOJQopQ9VMSdN7b6GY1GE6nCbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALQ2/JJAn+IVuLUYKqPf0EtRYUlOKCLP+FLGau47+bLRS0EFhdYszDDrxlWbLRbSk
	 Vsd3kgCsQOpdEA2LJ/8ik9wlSO4dLlsZVfv8LgQaMl34VH3LhawFDjoDUbWAKZHc2c
	 ZrOoyephoAloctXwj5TWjXC6Q5vn7Mq8IsdAUPgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1445/2651] wifi: mt76: connac2: fill TXD spe_idx for connac2 fixed-rate frames
Date: Wed, 18 Nov 2026 15:44:45 +0100
Message-ID: <20261118150340.067682100@linuxfoundation.org>
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

From: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>

[ Upstream commit e9fd0a209ff7f646e6ce9221a73c92c4912175c7 ]

On connac2 chipsets - MT7920, MT7921 and MT7922 - the spe_idx of
fixed-rate frames was never programmed, so every management frame -
auth and assoc req included - went out 1SS 1T on WF0 instead of 1SS 2T
duplicate, giving up ~3dB of array gain during connection setup, which
is exactly when the link budget is worst.

mt76_connac2_mac_write_txwi() takes the MT_TXD2_FIX_RATE path for any
non-data frame, but the block filling MT_TXD7_SPE_IDX was guarded by
!is_connac2(), leaving the field at 0. As spe_idx 0 also encodes "WF0"
the hardware happily transmitted on a single path. Drop the guard so
connac2 fills the index like the other generations do.

Do not set MT_TXD6_SPE_ID_IDX along with it: on connac2 that bit points
the hardware at the WTBL instead of the TXD, and the WTBL spe_idx is
still 0 while connecting, so setting it puts the frames back on WF0.
This matches connac3, where SPE_IXD_SELECT_TXD is 0 and
SPE_IXD_SELECT_BMC_WTBL is 1, and is the opposite of what the falcon
firmware macro name HAL_MAC_TX_DESC_SET_FR_SPE_IDX_SPE_BY_TXD suggests.

Guard the duplicate fallback with hweight8() as well: ant_to_spe[] maps
a single-antenna mask to 0 too, so without the check a user asking for
one antenna would still get spe_idx 24 and duplicate onto both paths.

Verified on MT7922: TXD DW7 spe_idx now reads 0x18 and the in-chip
sniffer reports spe_idx 0x18 in the TXV of auth and assoc req, where it
previously reported 0x0. MT7920 and MT7921 share the same connac2 TXD
path and are fixed by the same change.

Fixes: 5c81a4f182d9 ("wifi: mt76: connac: use is_connac2() to replace is_mt7921() checks")
Signed-off-by: Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>
Link: https://patch.msgid.link/20260930083103.1284937-1-jb.tsai@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../wireless/mediatek/mt76/mt76_connac_mac.c  | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
index 8a8d608dd56e8..8481eac8d7838 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mac.c
@@ -600,6 +600,7 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 							vif ? &vif->bss_conf : NULL,
 							beacon, multicast);
 		u32 val = MT_TXD6_FIXED_BW;
+		u8 spe_idx = mt76_connac_spe_idx(mphy->antenna_mask);
 
 		/* hardware won't add HTC for mgmt/ctrl frame */
 		txwi[2] |= cpu_to_le32(MT_TXD2_HTC_VLD);
@@ -608,13 +609,18 @@ void mt76_connac2_mac_write_txwi(struct mt76_dev *dev, __le32 *txwi,
 		txwi[6] |= cpu_to_le32(val);
 		txwi[3] |= cpu_to_le32(MT_TXD3_BA_DISABLE);
 
-		if (!is_connac2(dev)) {
-			u8 spe_idx = mt76_connac_spe_idx(mphy->antenna_mask);
-
-			if (!spe_idx)
-				spe_idx = 24 + phy_idx;
-			txwi[7] |= cpu_to_le32(FIELD_PREP(MT_TXD7_SPE_IDX, spe_idx));
-		}
+		/* Fixed-rate frames (all mgmt, so auth/assoc req too) otherwise
+		 * carry spe_idx 0 and TX 1SS 1T on WF0. Fill spe_idx like the
+		 * other connac generations do, but do NOT touch
+		 * MT_TXD6_SPE_ID_IDX: on connac2 setting it points HW at the
+		 * WTBL and the index below is ignored.
+		 *
+		 * spe_idx 0 is also a valid single-path index (WF0), so only
+		 * take the duplicate fallback when a second path exists.
+		 */
+		if (!spe_idx && hweight8(mphy->antenna_mask) > 1)
+			spe_idx = 24 + phy_idx;
+		txwi[7] |= cpu_to_le32(FIELD_PREP(MT_TXD7_SPE_IDX, spe_idx));
 
 		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
-- 
2.53.0



