Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591025;
	b=Sof3VJFCxYSXsmlNSRJJzZ8yMABVBWR9t3bJykgg8taKkxMk7e3TmTgooRSoK8hTZgwk
	 PIeUSsKE8DYWTxaDd7Ml4B2DP3y93rL0Jxe1PCgeqUzlC/ncynvv5N/IhZR9z/6fJ4zKT
	 DmokmBFHoldkw9hVUeRpBOpyEvR1L0pQU1mO2vMFzgflseIFPSrVCFw7w1A0Wcd42F44I
	 U7JvrCGx1B80hlLfOKI452mf4JI20CgdlEAxk56ebQvztMpNkFS8hklZkpwnMWcS/PIzM
	 5EYyXL0OSO2NomHZbfqAyDMjtNQh8vxEBgCqyaUoZlwiSAuW9x7XwwtLO/feDmhfXDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d2U0r3TVgKC4CVxrCQlSdBFv4BQtCgwirgomyv9vj7s=;
	b=0U9oSYPL+H3wrfc+R4MtLLwlC3Ypodwv6GbzmHOTTJIyBoI8Geq5a2D1Dhf3q/aE/nyK
	 YiIvx0b8Y37j4Z8XICA61Ym1p/mGNfjz4ADQnckp5ZfOroDFk+lWFC7f+87d7GyoKX6fR
	 5dAtHk6f0lyLSB7a3P08PO+tAFIGKvu3w1bWiK3gaMf8i0rZVETr5AwohybpCoEOFByKo
	 SrAkqiDkpeO4N/+cfZ+5hrqsuidyCpcBV4+xKL342HnNY8//a6bRJv+JJH+9iSD1aPJES
	 k3hYXr+1PxMQ2UlaELFmVxV+XRlH88EeuAHFJXqfgyRSCZpjjWL/yohqISkSFe+vIgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjDeJGyM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7986070F26;
	Fri, 13 Nov 2026 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cjDeJGyM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9879C1F000C4;
	Fri, 13 Nov 2026 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591024;
	bh=d2U0r3TVgKC4CVxrCQlSdBFv4BQtCgwirgomyv9vj7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjDeJGyM720a2rcxDk3SbmJK+GJluwo+rt3TYvn5E90ZTheZ6mCyIOBVWrn71pazk
	 i9gzT5lND3FzTZvGOLVflJLgWAtT79XNPcWZTXGaWu0lckqe/HW8kdjvjEHoeRaGkL
	 Po68RFmpOkB7hIBKrgvX9xvfokS4V7U4u/cOHo+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Severson <eseverson@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/670] wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()
Date: Fri, 13 Nov 2026 10:45:54 -0500
Message-ID: <20261113153818.448548787@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3b01934a6e800..fff9ea0dba079 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1128,6 +1128,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
 		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
@@ -1159,6 +1160,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		if (!tid_tx) {
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
 			reset_agg_timer = true;
 		} else {
 			queued = true;
-- 
2.53.0



