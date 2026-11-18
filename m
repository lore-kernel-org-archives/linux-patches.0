Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037483;
	b=WcQq6grhcLH8U+zlgP17Qfg5hQsSCmouQiZjHbdonLCd/d7eGsv6Qs0qWai1oKUSy6Y5
	 YVQzFZec4sAJdUaYp0Teg1FxdPhCWjTpcVaQomW7yh5VqWD63xVrx7cpJ1Ic0wUZqqxns
	 VH8U6Kq+tM9Lco3YO0RC2zkCt7UE6JW5T6AWXuwu+9Q7OCA3fRhh5kep6Qo70W6RiZY2U
	 lEanm/FYR2Ff111W2BFoQa552RPh72DCYOngCcGY+eCtMDwXXze12bXnVx3rsoaIpHRq+
	 jlEzY0rluc63dCSCl/XKjcGxQWYTDYFqLbwxBYEVdLUvtPUTtGz+3QjVgO08jJRS8Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037483;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Wc7XfELJQvaUj3AKkLdzhf2PQnMr6ZX2I9yUQWi3lF4=;
	b=b2vRr++SuZ9mrBkjdSNUfil3rJMBNWKYQdBS2H3RXRnmwWPw8AqLAqbOwY38X1vtjI2P
	 sdYXWdMGgXSSFJ15OxXiha9ZCVFI+dVEvuEKRpN1Q5ppJzK4gLQzlthjz2zkQwx08Ru5N
	 pfVsCL/k+Bs+Acbx0RXyI1rJMY41CbZm3nbt2yCvantS0blxzQMDEqoPFiit8vulJmqyi
	 ouxrF2jZG1yHQrdmczqp98Ok3wA8512/oYW62oQg+HZuvV1TWW1+22/nokaimIVC7Qwd1
	 V6d1RBV6x6fwBolNChr6FTH2T6Xfw5OqtLdXo3x4sinjmbeYRFO7BYChdpN0WDo0wSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRWqFj9r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1A3606A31C;
	Wed, 18 Nov 2026 21:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gRWqFj9r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61AB31F000C4;
	Wed, 18 Nov 2026 21:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037483;
	bh=Wc7XfELJQvaUj3AKkLdzhf2PQnMr6ZX2I9yUQWi3lF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gRWqFj9riiaC4qLSC1s4WGMe+Cnwdln7Gn5upoCdthwJjQWjHOxbAKjtc83FrqLQr
	 XYs5SJ4sms3xGc0faHlRFEmBuwaBU3q908D6kybwN5XngWLX1pc9KyW5M224igNLYO
	 vpRmfOD0JCOx94F1O1dLpVqTE4TFW9c3wEwC3AJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Severson <eseverson@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1412/3318] wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()
Date: Wed, 18 Nov 2026 15:33:54 +0100
Message-ID: <20261118150403.021853085@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Toke Høiland-Jørgensen <toke@toke.dk>

[ Upstream commit 25e73f1d6868c759c8eb56cad4e411692c5341b4 ]

The commit 592234e941f1 ("wifi: mac80211: Fix iTXQ AMPDU fragmentation
handling") changed the way handling of the IEEE80211_TX_CTL_AMPDU flag
is done in mac80211, so the only place it is set is in
ieee80211_tx_dequeue().

This means that any frames that are sent to the driver via drv_tx() will
no longer have the flag set. In particular, this affects packets going
through ieee80211_tx_pending(). Evan reported that this can result in
the ath9k driver failing to account such packets in its block ack
window, eventually overrunning the window and stalling TX.

Fix this by reinstating the flag in ieee80211_tx_prep_agg() when inside
a valid block ack window. This should be harmless for the TXQ path, and
will reinstate the previous behaviour for drivers that use the flag as a
signal to track the packet in the window.

Fixes: 592234e941f1 ("wifi: mac80211: Fix iTXQ AMPDU fragmentation handling")
Cc: stable@vger.kernel.org
Reported-by: Evan Severson <eseverson@gmail.com>
Link: https://lore.kernel.org/all/20261014025734.2288693-1-eseverson@gmail.com/
Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
Tested-by: Evan Severson <eseverson@gmail.com>
Link: https://patch.msgid.link/20261023110052.650519-1-toke@toke.dk
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index cc7507ffaf001..cf463965b8d40 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1126,6 +1126,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
 		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
@@ -1157,6 +1158,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		if (!tid_tx) {
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
 			reset_agg_timer = true;
 		} else {
 			queued = true;
-- 
2.53.0



