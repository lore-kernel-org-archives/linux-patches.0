Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585402;
	b=l8BscamhSRy4Hujxot8dJ7qavvVFNKmTQB1iELBrjAHZXweLgpaV0lTb9Ro3x6JZElfa
	 L8k2fSUM6uEQw1i7mZXB4pYUwglyPzivWS1wHR2lB4hApedI6yqpVam3LiIcJUxajoh3Q
	 ya8cCs2uK1dL0CM4HE+Hz2FswRxnPdRHS62nSGl4ITP0qTy6iW9T3mivB51YyqudSQEsF
	 pPKsWJBBb/v1aVdPBrFM2ORaOuef48ntgxktfYN4q4SnTxruNyzFftDaQIJaaxIIWk63B
	 sxhsqbXMZlowGBA/Vv72HBFei7HK1Mmk2RLHSWz4GO8a7PophJrPNRHY5A8sqCOb74Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585402;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qedeY1F/f/Y8CUPllaZcgBbkOasw/qYTvQ4RWEnz1Qc=;
	b=5ERIhaaijGqcx2TZzr/nOJ8RmAMjOhmgBrnM/pmC4dwCV8wUX2xWaQZOnbjiwiJgmFI2
	 15x4ie9B/vmNthw8HI2YpwRrTp6PuOyht5CCJoovGShmNzhzch9CAVGjYJH1aVrF/52ZH
	 YbrveUrXaZRMGWm3FOfCzk98MY2x8l/uTMmihqyGmITDX7R3KCcFg4gfUIUnqBUWsuvGb
	 10PWIOLMHyzoyryny5AqpNwjvjT1KoA5UXX7c3mbdNqg+kyMy25vd7YtYvA3sq9vW65n0
	 /++eLnhWUwYXpiruUWBxUl5v6ga+vUodikZsSvZtu56M94kW8QShPutHSoE2Jgo6CWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKJiFaCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559086070FF4;
	Fri, 13 Nov 2026 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OKJiFaCl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 019931F000CD;
	Fri, 13 Nov 2026 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585402;
	bh=qedeY1F/f/Y8CUPllaZcgBbkOasw/qYTvQ4RWEnz1Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OKJiFaClKpYi0Uc7xZHdqq5oMvQWFeGEWszx5B/8zwc7H/Sw+TidCIrbOekUquoFB
	 dIDurYSif4CmcCF9ZRmx09tyYiprt6jGwWA9WnHKJ7zp72cjPiUHYcy34wPhe2GvBT
	 ehXaN72WzEUDvJiXePDDuZFw3zocYXf2FIH1c84Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Severson <eseverson@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 071/507] wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()
Date: Fri, 13 Nov 2026 10:46:15 -0500
Message-ID: <20261113153755.979793143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5714634c81033..27bae2a4fa86e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1130,6 +1130,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
 		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
@@ -1161,6 +1162,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		if (!tid_tx) {
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
 			reset_agg_timer = true;
 		} else {
 			queued = true;
-- 
2.53.0



