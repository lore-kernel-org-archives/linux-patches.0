Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043341;
	b=zpUdZSeSeo23iFOcJ7iDNwhZXQO/iHRinBziA6sQuUcc0lJjCaYhlbouD5VShsL+t4QO
	 1IwQe62XMzhLbsdGbILuh8fSatbE8LFGqdfgUXRrMV9NeEj5NE+H+lK6mhkdjJUywxVAL
	 mZqi2Leg/S0e7HgDjewf6od2uunLDfhVrduf49CYKoSa6qBYS/81c8JnWAFvVviW47dzw
	 No8dXJmtbH93ywjoHG7Tcht6qg38ZDzr/zBikcFHI8gEDjIqP1Tl4kietUscsrwuxQvVH
	 juE6GUe+LnLPPw9QnYbBMbcceLvwcFdieIW7IuenguIR+r9yhycAI+C2Eqgt7NDIzYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRX/LyPiAUDTXfXFBrHhJQJiXDpzQcELd75dORWWwEs=;
	b=4thyNnZeH3iNUVCTpA9rwLk81aYL0Gozp3ctcH/vcE7eXcZyrv1GQGJIoxVB0sRfxsse
	 kxAvZ8/QLkBYQbgKMQGZqoeyeYO2raUUFAdbTuSfUttqzetoJXaHxschgWIQb9StswffD
	 Aks/QyJY91/f4WfolM8h5OnLXM3805euHZurRkbQMSwPjPKMPJMkkBC4/ASncF4PbsoSG
	 FVEqu2hzUZzJDkGvCi/XQKruINWrMnu7rQlFlog8a60s9vqxw46IDHPr4OjRK+8PXdeyR
	 QHN5ElCaoSgSPe5DTPCYeaETb9o0cG1vXfjtZ7Ge9UCT7vJLlzDoDgraxrA6fNyOTYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsTPMEuL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48CD606A331;
	Wed, 18 Nov 2026 23:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsTPMEuL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04F871F000C4;
	Wed, 18 Nov 2026 23:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043341;
	bh=iRX/LyPiAUDTXfXFBrHhJQJiXDpzQcELd75dORWWwEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsTPMEuLSPUpJ84Zy8mfXwx2/O8DBRPhFLlvgLKcL6i17QjsDaHfcdKtH4zgwHscc
	 lsou3/dY5VsdVf5V+BOR03UGMa+g9c8BtGze8O+sG6RklEaVfT3Vv7pEYKG/OFlj3w
	 i9kyctVhjkWy64DrSSkt+q5kur6LM5qXUL1o1lqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0176/2857] wifi: mt76: mt7915: configure noise floor reporting on reset
Date: Wed, 18 Nov 2026 15:20:10 +0100
Message-ID: <20261118150207.689809036@linuxfoundation.org>
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
index 035e0b9c1fa9a..c4d7126e05c89 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1322,6 +1322,7 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	struct mt7915_phy *phy2;
 	struct mt76_phy *ext_phy;
 	struct mt76_dev *mdev = &dev->mt76;
+	bool run_main, run_ext;
 	int i, ret;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
@@ -1404,13 +1405,17 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	mt7915_init_txpower(dev, &dev->mphy.sband_5g.sband);
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



