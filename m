Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041020;
	b=bg2Y9gXLBMmRXDT8MJJHQIhx80Jjrv2bc55ABFAR0SgT4sPkSmWRJHdRJazUZvUN3jaH
	 Qwd4Fuv6SrO41czeLASIWhcu/zpUbO9icoqBHQfqia/7JxLmeqDxCYP85ETTCWxziz5SX
	 G54afMGScV+iW3Eex9zKUbNaaOTx2bHHx/3jARitBLztDbPBlp/9IxPks0K9Mu+GXlTak
	 mauk0XPZAyxKGDS7jXYkMRoBvTU0LPlLIzvr0Xdxf+ZDYGL4wjAaRZlXzPj5Yy6BORC5v
	 V5XDt1PY9LkJFRnlh5v0Z/HNnwKpwYgNZlByyl2Q79Z57zHUkgTjO2Y6uFKXGJPlSKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041020;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0mmX1n8EL5mxJvKIaXZc5UNk1ttuBF4sgISFiFyYuwI=;
	b=rAdOD1VlgKjwUAnZWLgN97XiBDjGy8z0pY0ZKVlqJ2Xp8r9GQ45EeNM18q8J/uJMxd6/
	 Xja87Rh8rajvnD4ku8MUDCputX5cAR4Ct/0DnlCj+oCGvNQeAmfpxC09vs8jz0rQNXM0i
	 9SQD6WqrB52vNArbdqJpMeZLtJE4SUGYqrirIV9NOLoAi2MEIZ3aCwiooTs4fu3WmkDrh
	 WvBIMSMSoSlEk//DniCTfzjuzkaoa/Lf8sb5d8Wtr9HhixuhGapohi6C5If1pW8LVR/2C
	 O4/CC7MWL/gnKVobRXsG8oI00whXgDMYkZp6S95s4hFpYSCMTbTIyW2VBz4FQGfkwsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ndDFdv/V";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EB63606A32C;
	Wed, 18 Nov 2026 22:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ndDFdv/V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 424971F000C4;
	Wed, 18 Nov 2026 22:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041019;
	bh=0mmX1n8EL5mxJvKIaXZc5UNk1ttuBF4sgISFiFyYuwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndDFdv/VAs7ZHvqQtkkHC8aIa+L60kd1432KuI8ixsvRrv6bZsKaj5j6xGQv/ORsY
	 U1wfjhctEfvLgf4cTQRbkzo9QFXuFzVoBk6xVwanSzmw4mhNdukWDKSRoi1l4dqriB
	 +WMMLB4+Cd/342hY6LI4nZc2BJ4sJC4mYIm6qZBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	moosager <moosager90@gmail.com>,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2663/3318] wifi: mt76: mt7921: check drv_pmctrl return in the PCIe reset path
Date: Wed, 18 Nov 2026 15:54:45 +0100
Message-ID: <20261118150440.911177919@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 75673ab3c0e4186628e0a76b94443cddfbeca255 ]

mt7921e_mac_reset() ignores the return value of
mt792xe_mcu_drv_pmctrl(). When the driver-own handshake fails,
__mt792xe_mcu_drv_pmctrl() returns -EIO without reinitialising WPDMA or
clearing MT76_STATE_PM, and the reset carries on: it writes the
interrupt enable registers, cycles NAPI, resets WPDMA and downloads
firmware to a chip the driver does not own.

Return the error instead. The call is the first statement in the
function, before any teardown, so nothing needs unwinding.

Reported-by: moosager <moosager90@gmail.com>
Link: https://lore.kernel.org/linux-wireless/anG46qbvCqCHGF-f@fedora.fritz.box/
Fixes: dfc7743de1eb ("mt76: mt7921: refactor mcu.c to be bus independent")
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Tested-by: moosager <moosager90@gmail.com>
Link: https://patch.msgid.link/20260809012309.43657-1-lucid_duck@justthetip.ca
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
index 031ba9aaa4e2f..13a6e788edc53 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/pci_mac.c
@@ -57,7 +57,9 @@ int mt7921e_mac_reset(struct mt792x_dev *dev)
 {
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	err = mt792xe_mcu_drv_pmctrl(dev);
+	if (err)
+		return err;
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.53.0



