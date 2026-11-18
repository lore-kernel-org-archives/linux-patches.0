Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048271;
	b=RiL3tTP6gMamRPoAtALzRd9BF+Y2kQU3+XffXsE+b85f1lPsms/jV+Y/ya8vVqxRM4CY
	 uQIHEitGsTJ5jDeyU/3TpEPojLR7zujbwx/GuGwtjcx8NLjn232dpz7O/CWbo5ugQvwyE
	 EjSRcFvRYZJq8T+7wE+40B+j/MZMIIov33MB+KAfgr1Xaj5RXwieud6BZPBEfBAkl5dg8
	 2LJWpZbXCS9XrDMJHxdhusOEPr5o6etDhc24N2JMr8hHsFmivzOYWyOX96udh4KZbHPJz
	 YBBrec3DVolRriUx063+hDNLFHOxQOgC1m5UcPrfZ/SyciJ2FUGGy+LbQK/3/vYlzjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048271;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=VrE/fJxzqaQDsVP8ioEt5GDeZvEPrZstorhoNb/AbBY=;
	b=xcX0ula6bHG+E9A8D32d9rFkNWtuc9AHNxPTZg+VF+yzyk27Mi3i2WzWF6eI/XNdhEv2
	 oD/PSQ+cp45uOQw+JVwCGisFZchC5hq+02+OXVy355arG4onNvxmG0yvGRcMmiSxRcvs1
	 XrUyZ6LkPa1Se9toyh7nigO5iQCxwpgTGNCi63L2di8gNmkpeCubvPxvqWmZyzyzJrmz5
	 7CeCRDrYNN6gkySerRXukGQyVRNLXaTxm6kVTJ+JzGP+K/pHuTTPZu718zTTth4is7fW3
	 pgyELdCir15Jwnn60Ou4YzgOo+KY6803NSjqYvdhqsq7ck/JjtF64cyFosgGML5Og+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQkXLAt3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF83C606A320;
	Thu, 19 Nov 2026 00:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lQkXLAt3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DC81F000C4;
	Thu, 19 Nov 2026 00:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048271;
	bh=VrE/fJxzqaQDsVP8ioEt5GDeZvEPrZstorhoNb/AbBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lQkXLAt30rnOLNl1eEslktR6iYlBvdf+nUqzc6BIOUn/Z1svDO11EpAYIUxN4JWEE
	 h01dN88RA39aLnQIEUC6Dm3U4M79+/o0mGf04426CubYogLloLq0pZJGrUm3pu0nbC
	 rHzeEipAVJQhDCMv8wvwDyEpPQFz2DSurHNEnnF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julius Bairaktaris <julius@bairaktaris.de>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1934/2857] wifi: mac80211: dont reset the TXQ scheduling round number
Date: Wed, 18 Nov 2026 15:49:28 +0100
Message-ID: <20261118150310.848899477@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Bairaktaris <julius@bairaktaris.de>

[ Upstream commit 8ea81827d3537db7cfcc82c008f052bb1bbe7567 ]

A round is ended when ieee80211_next_txq() meets a txq whose remembered
round number is the current one, meaning it has gone full circle.

When the AC exceeds the airtime limit, ieee80211_txq_schedule_start()
sets the round number to 0 to close the round. The next open round is
1. A txq from an earlier round 1 still remembers the "1", so the next
round stops on it and serves nothing.

Fix: use a separate open/closed flag and let the round number keep
counting.

Testing: ~4200 skipped selections per 20s without the fix and 20
skipped selections per 20s with the fix on ath11k (with my AQL series
applied) at BE 500/1000.

Fixes: 8e4bac067105 ("wifi: mac80211: add a per-PHY AQL limit to improve fairness")
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
Reviewed-by: Toke Høiland-Jørgensen <toke@toke.dk>
Link: https://patch.msgid.link/20260908144155.756569-1-julius@bairaktaris.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h | 1 +
 net/mac80211/tx.c          | 8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9e1c1c859cf65..db96956cf5ae0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1305,6 +1305,7 @@ struct ieee80211_local {
 	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
 	struct list_head active_txqs[IEEE80211_NUM_ACS];
 	u16 schedule_round[IEEE80211_NUM_ACS];
+	bool schedule_open[IEEE80211_NUM_ACS];
 
 	u16 airtime_flags;
 	u32 aql_txq_limit_low[IEEE80211_NUM_ACS];
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 9fd867722ef9b..3ad7a6ed5e66a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4021,7 +4021,7 @@ struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (!local->schedule_round[ac])
+	if (!local->schedule_open[ac])
 		goto out;
 
  begin:
@@ -4225,12 +4225,12 @@ void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
 
 	spin_lock_bh(&local->active_txq_lock[ac]);
 
-	if (ieee80211_txq_schedule_airtime_check(local, ac)) {
+	local->schedule_open[ac] =
+		ieee80211_txq_schedule_airtime_check(local, ac);
+	if (local->schedule_open[ac]) {
 		local->schedule_round[ac]++;
 		if (!local->schedule_round[ac])
 			local->schedule_round[ac]++;
-	} else {
-		local->schedule_round[ac] = 0;
 	}
 
 	spin_unlock_bh(&local->active_txq_lock[ac]);
-- 
2.53.0



