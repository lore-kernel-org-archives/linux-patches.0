Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829716;
	b=WU3btP4InUZmpRdWT2hgRkyZLJ974tpLsdeEhQ3Y76BfImw6e+g2X3hdUeT3F9ERIEFE
	 u2mo/Bf1+IBtEBmsnT0ifYRoixJyMSGrDPyyJaeIRI6ywoc5gQfig4oWFqt0SWE9jI2l9
	 zOF1BHRQp5AY9eHLAmWudk+07GW1ThZ89YxD33U5gUHgEu/PsNZYXGOvb7jDYld95b9Ap
	 QNapiWvYFX0Lk7AWzMi//TQUxbL6UTJvCeSR7EiXOfaDMK6JxjiAPFEcPttQESjVCrpiI
	 BkVSm8AigJYoPqMgD6PfPc+IiTiPyKJfdISkcpxW75WdchF2v6k6xBTi6tSZqopxwCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AtRXeIOZh/8q1E1lqPRsROwIP8D6H7YVl4UIqNCrKg0=;
	b=Q3zuhCYhNwlcYJ4Jb2kN3zCoCJW8iN6ms2OiJqrfdbs+DWcIPpUns6GEc5sFGL09lHeD
	 ApsFUZZCrhgnmldZpLqlIS2tSBtS8DDJqMey28qKJ61ZlOr97PozHNOWxcg2TV4yuKY1k
	 CYEUPjwW6LLB67BiHU54Xvoi2/8hD+QWH2y/zNIc9ozd1Qp56UV+YYrCOosWNajhcLvA2
	 9HPUhnXBlwE7CFwm0LScuuXz+IIhyTHG10lpvWuYlfg0tA5no1OBf4mDOXIsAurj9cfXp
	 zkTxTLMB80aDqcvEWyAvJV3VlLQzCTsySBMJQhLN13BwH7805pyMflA7SmMAvsxfPWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owvQi7EW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2D6606B2DE;
	Wed,  4 Nov 2026 22:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=owvQi7EW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9711D1F0093A;
	Wed,  4 Nov 2026 22:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829715;
	bh=AtRXeIOZh/8q1E1lqPRsROwIP8D6H7YVl4UIqNCrKg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=owvQi7EWehbZE+HqFnI5oVwmT61M+NcPGNRP8Sz3VDn+kv2glJ80vHQpKkiNQaPMN
	 0ykMECVhtHGCVaQhMcEfeJLGQfwrpKoLy/I0IIPDaGExMtPEzNSh/qbSZPrD8onDQR
	 WZjfkXaMJ6aC62H1uAiz0plOoLZhr1w9vE25hqHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Bauer <mail@david-bauer.net>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0297/1005] wifi: mt76: mt7915: configure noise floor reporting on reset
Date: Wed,  4 Nov 2026 16:00:30 -0500
Message-ID: <20261104211052.231577238@linuxfoundation.org>
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
index dda4e7d179536..55d2553addb13 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -1292,6 +1292,7 @@ mt7915_mac_restart(struct mt7915_dev *dev)
 	struct mt7915_phy *phy2;
 	struct mt76_phy *ext_phy;
 	struct mt76_dev *mdev = &dev->mt76;
+	bool run_main, run_ext;
 	int i, ret;
 
 	ext_phy = dev->mt76.phys[MT_BAND1];
@@ -1387,13 +1388,17 @@ mt7915_mac_restart(struct mt7915_dev *dev)
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



