Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060862;
	b=uecHIo5sisQbS2QnxRerhmeTIAtvo0nevBZqebWvxer+Lx++QJ3Ouh1qXN9VkDri2beY
	 /O1Mux6vAd7+U8MOG2sekqSmqIEECeIVnWSTk1Y1gJnm8T/pSUqksCqtYcz+p+31/JRGf
	 UD4xrLqe//i8pZaI8BThRJCxQkOam0lcEo5RiC8yQy0M5BOzb5rRPpbAyYvq8NyQpH+rG
	 ye9PTJpMs2EwTTL4p0/L+di0dKI4jT5Gxw8JtUq9Q7/5F9Ltjn8SgLBVxWXxkXdMpAuRL
	 t6QSdkrYiw5/phhjzWJEIIz9VDytsVAHImbiQBsgWAFaAqdezWzVEhtMuPQd5spfPkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AVj1H0xqke5detJijRK9rko9BlM4gMQu2oN6L2CAS+4=;
	b=qoAkTJ3LPjkZkA3wY40tyvmp9UsciPu14L1gni/Lcx/ZAr5LZdDDrHhzkDbptORcALiM
	 UYPdP9IrJD4XPsD3Nn4iDnle/69Se2SxUvQWXK7VkLrF9VVLjk4nqP5+PovXcAWw1cD7J
	 9AckDi2ddFrRopcwEw2Lw1lCFf66BywhmeszalOwElosCDHVesI5cug7STFS/uEp9GMQd
	 cENEfcw3BW5UZCX0PnzORK2hM15oyRo6st3dZHDhv/IHgcOWjbcfawJO9cpPGorIACNsk
	 5DuC48ZhNO1K5jatqsoclUCSB/m0s3N1afi6rnqr4P7z/hUOvN+PcxEhLWWDSfVAxcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AObOXNg+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B85C606EE80;
	Sat,  7 Nov 2026 14:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AObOXNg+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1961F008A1;
	Sat,  7 Nov 2026 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060861;
	bh=AVj1H0xqke5detJijRK9rko9BlM4gMQu2oN6L2CAS+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AObOXNg+8bAuiim2NmYlU8sZTQBoUj5zNJ/44SFLZTN300epl/cA9NKFqiXLGHPYB
	 xyZOfm1xHxh4zRnN0yk+fJqDCgGn9iUKh6FbAhAU/tZ2oj936qoXMp6MFXYVqjFcpB
	 WZLxVkJK8fVM3dYP4orvVv665cxZqTJNiyoPaFiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0244/1536] wifi: mt76: mt7915: configure noise floor reporting on reset
Date: Sat,  7 Nov 2026 08:37:40 -0500
Message-ID: <20261107135004.535134104@linuxfoundation.org>
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

From: David Bauer <mail@david-bauer.net>

[ Upstream commit a92cd5dd792a63a5d8a72142835382d4edbe9933 ]

When performing a full system recovery of the MCU on a dual-phy
platform, band 0 (usually 2.4GHz) stops reading correct noise floor
data.

This is due to noise floor reporting only being configured correctly
for the second device PHY.

Configure the respective registers correctly after restarting the MCU
firmware to fix reported noise-floor values.

Signed-off-by: David Bauer <mail@david-bauer.net>
Link: https://patch.msgid.link/20260516144944.2574053-1-mail@david-bauer.net
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index 147c0fbfbeb84..175a9a44ae643 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1309,6 +1309,7 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	struct mt7915_phy *phy2;
 	struct mt76_phy *ext_phy;
 	struct mt76_dev *mdev = &dev->mt76;
+	bool run_main, run_ext;
 	int i, ret;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
@@ -1399,13 +1400,17 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	mt7915_init_txpower(phy2);
 	ret = mt7915_txbf_init(dev);
 
-	if (test_bit(MT76_STATE_RUNNING, &dev->mphy.state)) {
+	run_main = test_and_clear_bit(MT76_STATE_RUNNING, &dev->mphy.state);
+	run_ext = ext_phy &&
+		  test_and_clear_bit(MT76_STATE_RUNNING, &ext_phy->state);
+
+	if (run_main) {
 		ret = mt7915_run(dev->mphy.hw);
 		if (ret)
 			goto out;
 	}
 
-	if (ext_phy && test_bit(MT76_STATE_RUNNING, &ext_phy->state)) {
+	if (run_ext) {
 		ret = mt7915_run(ext_phy->hw);
 		if (ret)
 			goto out;
-- 
2.53.0



