Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043347;
	b=kXe+FSNY2ytduyarKtaRowVElEqw4HZk53nr6DVqqWSZ2d56xWN7EKzwXAzdbOOxbSmS
	 42bJNCDLJRoluIH+hBRRPaVbz9LPK4y9FXdj9vSaKfXsR742Ubc5zKljPdtaNY9L+CsfT
	 SvclsBdyVq91l3q7GW3w+sPGtjQ+wAAMvFMk0DCs0n98m5UB4brN7C8XGAllOos87Gln+
	 gjLU5Y9uBwAa8ZtaLOyQ2w5Xi9OdqPGRCzHABO2FM0qsq3Aj8+zVoklntvakb+kVZUPdW
	 fgqPYcRj/CCFaLN9unmD+62aFxT9WlJyoUdOGbaVWSaZvhMsxuqBbvKOUMOjggkNLNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VEkgsrr3xOwqwVOvG+W3q4+PEMhr1VQuz3H7WvoWKhY=;
	b=n7cX8aSJmp/yHGC9etXAz5i4GPlsVRx1VXIhXG3w0rDTd82F6d6k65Pz/kQBUm+TJibR
	 vrdGZYODU6l6LI+gCfLJDh8ApJBFWVFqoIoYdEoGVJiSGBWiy2MsnbjuCNY7eoOl5Tpu0
	 TKRePXHWvpSeJNYiWs9RzjF7Mgk7xqkoILG26h/QVd/6QfrTKbHs7rmOQXB0s5ABhIgmU
	 9xCiGLOGzO3vmhYL3VWfPAXQBjHbGR2MiSxWI3QNPlW7JvGXKIUClXhiapUvk2Ccsb2eN
	 p6NBZjO7ktfzmyELIe2FY/f0Cbi61t6V+4uhb+y7UZGzkX/g11XNrATaAk9R+2Pud+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVz1shPN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 346BE606A31C;
	Wed, 18 Nov 2026 23:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dVz1shPN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B99D1F000C4;
	Wed, 18 Nov 2026 23:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043347;
	bh=VEkgsrr3xOwqwVOvG+W3q4+PEMhr1VQuz3H7WvoWKhY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dVz1shPNy4ivQSheYQ55WG6cQZEjmpI/+XmsTHTS5B/wa9CTX4k8l8iqwwGdpnQnk
	 1aHjQSlDVcpcPg8Z4TkOcTurT5+qHO+lbBSinRUWS0NFx3RXiLTblHnankk5IWbNSn
	 w1hvQzmdnR2XPcHBl6wCupNE41reTqc0UlkrQ7/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prashant Rahul <prashantrahul23@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0177/2857] wifi: mt76: mt7921: fix memory leak when skb_linearize fails in mcu rx event
Date: Wed, 18 Nov 2026 15:20:11 +0100
Message-ID: <20261118150207.725457688@linuxfoundation.org>
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

From: Prashant Rahul <prashantrahul23@gmail.com>

[ Upstream commit 4361f1660101270611eb5dc39799f620b35f2e4d ]

The ownership of sk_buff skb is passed to mt7921_queue_rx_skb, each
path inside it under the switch case handles cleaning of skb and it
is true for mt7921_mcu_rx_event as well.

mt7921_mcu_rx_event, on a success path, either queues skb via
mt76_mcu_rx_event or cleans it immediately inside
mt7921_mcu_uni_rx_unsolicited_event.

However inside mt7921_mcu_rx_event, if skb_linearize fails, the function
returns immediately and never bothers cleaning skb which leaks skb.

Since skb is fully owned at this point, it is safe to call
dev_kfree_skb which fixes the leak.

Granted, the skb_linearize failure is rare as it can only fail under
heavy memory usage, but at the same time, leaking memory under heavy
memory usage can worsen the OOM condition.

Signed-off-by: Prashant Rahul <prashantrahul23@gmail.com>
Link: https://patch.msgid.link/20260716-mt7921-mem-leak-v1-1-6e9c0ea19f63@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 991298475844f..d0e93707b9787 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -286,8 +286,10 @@ void mt7921_mcu_rx_event(struct mt7921_dev *dev, struct sk_buff *skb)
 {
 	struct mt76_connac2_mcu_rxd *rxd;
 
-	if (skb_linearize(skb))
+	if (skb_linearize(skb)) {
+		dev_kfree_skb(skb);
 		return;
+	}
 
 	rxd = (struct mt76_connac2_mcu_rxd *)skb->data;
 
-- 
2.53.0



