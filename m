Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031170;
	b=x6SkEkxdgzrJqAb9EVujiCbpZiBq9FIMPB/JrxMSqAFt8hrqGaqgHY4AJaQ4ALX1LaeL
	 KN4CSA9HuD3+N+geKKGWvdVq3jY1zqQNMVuoxA22iqPMfIpJxXh33ErA1GDhxqWSK01LS
	 fgH8yky3dgXKWvemmfaebgPMw4PsgR7zMDFGUm9VRDZJuHWz7Fe2A23A2b/yeuzhKfzRt
	 Bp8io5NMejT/h/ludCZuyAC9zowfFwCDy5A3LFYtVChJOSQ8iYky0GXdJJzqKaZMyYQj2
	 8tqlT0fJGFps6OTqdgUPxemGgVPdi/N4kj3IETawnWxJ5vX7cR06WWaFgzMxLRJMUHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=udL9Vjb8AS/t5A2+V6RYlriyKy9PF/K6R9VnbeyVQbU=;
	b=JQHAcAsGmwZe0HBUGax/6pC0ubnzyQSG7aYsoaHjfo0L1OgvPrHzfgpX8CdrhVhSkGJh
	 1OYO53fg0nCH54cUZdGzF4kb1Leo81yg3sRwudyQiA3FBflrSt+20pmh1SNMOk9XrNglm
	 /1XzqNwlDHjOHA9T9CbVe4fBOd+h+u/8rqGhCkv/uutyupSZ31n5fMt0p/Qn9Z7EwAYFs
	 8e/prPtCsT6ub5BCo0W9E8pM/rKUp3NTRFEJZCKbJ1tpEBbndA95EVBCkPfLEjobS4IZX
	 eUs9Vl1AVEYPJNwPKabJcnA23iUpc/pJ0J6YlC6yK0IcZr7L0KQ02sQwtcUbTuxKP9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tcflczxl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8290606A320;
	Wed, 18 Nov 2026 19:46:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Tcflczxl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411871F000C6;
	Wed, 18 Nov 2026 19:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031170;
	bh=udL9Vjb8AS/t5A2+V6RYlriyKy9PF/K6R9VnbeyVQbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcflczxlufqoXw+3Pd6/+lq9nJuMPj79xuJm9tBi9EWGHeiBlaUAykprJ5T4nEeQd
	 KtwJG5Mc2iOlQir5wPPn+cCyRXrwNRK8TrC+QR9FcdbmSLXDcZiDIBxBQFCFLz3IpC
	 MorCg/jLxzrvHGukwvcPfvsmwvs5lNdRn1/4nV88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryan Leung <untilscour@protonmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0962/1756] wifi: mt76: fix unlocked wcid check in mt76_tx_status_skb_add()
Date: Wed, 18 Nov 2026 15:51:29 +0100
Message-ID: <20261118150048.381698775@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Ryan Leung <untilscour@protonmail.com>

[ Upstream commit cfb05250ded4d6de09dfd273c2a72092f48b55a3 ]

mt76_tx_status_skb_add() checks rcu_access_pointer(dev->wcid[wcid->idx])
before taking dev->status_lock, then allocates a pktid afterwards. A
concurrent mt76_wcid_cleanup() can run between the check and the lock,
letting a stale wcid be re-added to dev->wcid_list after teardown.
Worse, the check only tests for a non-NULL slot, so it also passes if a
different wcid has since been published at the same idx.

Move the check under status_lock, alongside idr_alloc(), and compare
identity (rcu_access_pointer(dev->wcid[wcid->idx]) != wcid) instead of
just testing for non-NULL, so that a reused index is correctly rejected.

Fixes: fcfe1b5e162b ("mt76: fix tx status related use-after-free race on station removal")
Signed-off-by: Ryan Leung <untilscour@protonmail.com>
Link: https://patch.msgid.link/20260821-mt76-stale-wcid-race-v2-1-8f41ee96fb73@protonmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index ed1615192d644..edb1de6582fac 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -129,7 +129,7 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	memset(cb, 0, sizeof(*cb));
 
-	if (!wcid || !rcu_access_pointer(dev->wcid[wcid->idx]))
+	if (!wcid)
 		return MT_PACKET_ID_NO_ACK;
 
 	if (info->flags & IEEE80211_TX_CTL_NO_ACK)
@@ -147,6 +147,11 @@ mt76_tx_status_skb_add(struct mt76_dev *dev, struct mt76_wcid *wcid,
 
 	spin_lock_bh(&dev->status_lock);
 
+	if (rcu_access_pointer(dev->wcid[wcid->idx]) != wcid) {
+		pid = MT_PACKET_ID_NO_ACK;
+		goto out;
+	}
+
 	pid = idr_alloc(&wcid->pktid, skb, MT_PACKET_ID_FIRST,
 			MT_PACKET_ID_MASK, GFP_ATOMIC);
 	if (pid < 0) {
-- 
2.53.0



