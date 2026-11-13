Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590197;
	b=GZ+eE2B2u4Q/bGWzykfwqNv1Xw35iszpeool0kZ76cXOCZG6SdF0xn1hiz2HWDnRLQ+e
	 w2TbvXcotz8fa+7+vB0k0fSBgs4OL3BgdO23nIjvt4i4QgIEqfgu/vjCpTwmUF6U5lmhb
	 ug7Eb7EkJkdIMLYUOVnVkNDFpzQGWfqodBck3Rf0pD8a7e2cw+djXcAZWy0AhTqXkkV3D
	 chq9OMuOw2EVqacX1ick5Jy2NeVmkRoFtdos/j6ee5P/IBwnPEazOzcGGVJVaMmhkRhI0
	 /6BJbfdEWWuNLbMNyO6JDdnQOfOHTHgobLbB17a1kyjjit/15B0FU/IK8S88WSk4r2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590197;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gwilmxvscCnshGTK8WSabgVC6hNp8swBWeLJJApHTvs=;
	b=K29LoyUMxMfBZnpey1CbYr0D87JkgVCAPrjD849qAHDcNEKzDMnrlJJzLQnfnd0SSw3H
	 3e5QEqVafP+60lZeSMWMfHI0SHQPrQuq7lAlLVBX8Oo85hphaDmdBpqnIJLM2HwMNPJ2x
	 71WQ2DYA54Pf/Er2Rx6nKUm50h1pgCa35zcu1hu7d/V950/qr7rLIln5/0fRmxzaMvYRo
	 2IF/XNvoHASh5SIym0zkjhSuXTh4Zq1OhMlb9yaxjDUrNgc7KE+xUGEkvqYv/Gia2vSAz
	 Ey2p6eh9uwI0wzTa+Pz2NHgv93H2b7BfG2nZGpdBUB34zIYggqlOmPHKv/TLFd4lwPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12z7NRu9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515B0606B36D;
	Fri, 13 Nov 2026 17:16:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=12z7NRu9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F18D21F000C4;
	Fri, 13 Nov 2026 17:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590197;
	bh=gwilmxvscCnshGTK8WSabgVC6hNp8swBWeLJJApHTvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=12z7NRu9ExbATFYFNAQvPxO1WyY6HkYftKhzIF3ysTMlNQtC5xXDZXrWW3tBs0kx7
	 CvYA6y1yWdf3TNRc+rHh/j+f8xxcYy92xjXEDErmvzbhk0EdoiOXkVpXfdA5+tilqz
	 5hPZGy/6SA5QqWWxrEFfU5zqmp6G9WREYluibyJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Severson <eseverson@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 203/686] wifi: mac80211: reinstate IEEE80211_TX_CTL_AMPDU flag in ieee80211_tx_prep_agg()
Date: Fri, 13 Nov 2026 10:45:36 -0500
Message-ID: <20261113153827.923598688@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b012451f45253..85c90f7c24d8e 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1124,6 +1124,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 	struct sk_buff *purge_skb = NULL;
 
 	if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+		info->flags |= IEEE80211_TX_CTL_AMPDU;
 		reset_agg_timer = true;
 	} else if (test_bit(HT_AGG_STATE_WANT_START, &tid_tx->state)) {
 		/*
@@ -1155,6 +1156,7 @@ static bool ieee80211_tx_prep_agg(struct ieee80211_tx_data *tx,
 		if (!tid_tx) {
 			/* do nothing, let packet pass through */
 		} else if (test_bit(HT_AGG_STATE_OPERATIONAL, &tid_tx->state)) {
+			info->flags |= IEEE80211_TX_CTL_AMPDU;
 			reset_agg_timer = true;
 		} else {
 			queued = true;
-- 
2.53.0



