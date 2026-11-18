Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015662;
	b=3mBuzNQ2LvtZe4TPGkT5/hJri0o2XLdAXta2SzIk06VV51yHDClKdrsNfWWgWAnMSbRr
	 ZT3nJaqPyApKyZnk449j2tZQ7F2K6CKT4FD7jJneMisSR7t4KpbQlEfjVM/aGDTo7Jn+d
	 GHoIQwJOQ2/tpzDvRRUCK/AvU5gx+fhgM1oRtt9NpG4sEjH2hk2qGjTtaLkTcBowwnyhJ
	 gTt61/N0RpJbIZdLp989O5LhZjid2qC9pn/miLjDeTUvX1ZmADC9ZaoklbTN0Hm0E0vCd
	 fppXtW5CveAGW0VdrRfkZiNQrUdzl1PzFdDrOfvjM6Itz8H7WPYnwO+CcqldMRi+ATA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RpWFVbAM7nkgTbgYUlyY7Lkgv5WnGwSO3bLCM/IGt1c=;
	b=5kydUDyp/BpibjBD2NugvonTvU8yNCvYwobnuxmZdQupAqjdSoqwyDU3jPn32f8+Ali+
	 tCKo+AG+3n0sXo3kynnzgifP0TNkMqsjTZ1p8rSctG/lFc8tQbtqUNIpu+vjTlDn5mYdB
	 3xsuatoU2eKfPwKkNIjyysLopYCq7rdRrQv7bdqbde24Ya8RYVQPltR/r99l67cXrKOj7
	 zTn4fS0K5LMz997hKdt1MyF/bqQBviWn5//rDMaFWXJx6oO3XELYSto0nJy9QcsVXEbBs
	 /VxanT+6uZWOJzbqnjVQZB5+ueFCEyvamijzJAu3RnwYDlCxkYvu9hSUhQcD7zd/ABg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWx5yhg4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286E060A2612;
	Wed, 18 Nov 2026 15:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uWx5yhg4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B3EF1F000C6;
	Wed, 18 Nov 2026 15:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015661;
	bh=RpWFVbAM7nkgTbgYUlyY7Lkgv5WnGwSO3bLCM/IGt1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uWx5yhg4fvbdubxCS35sXDPdl1VgiPY2Mq4ZGAXWESqWofQej457/GXwMP6JWTdsE
	 DNggiQI4y02Se7AAoGSdav8cPbakWrGnzXQ8zJar/UjHB5jCsgJhNuFSEmim5xL4o6
	 bBR1oVHh467OMFIUODdvyXx9UH9n7ia1M31AMyiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0212/2651] wifi: mac80211: fix IEEE80211_TX_CTL_REQ_TX_STATUS mixup
Date: Wed, 18 Nov 2026 15:24:12 +0100
Message-ID: <20261118150255.507790236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e035900ffe9e8978f7c0d7b61811b6b578751697 ]

In ieee80211_build_hdr(), IEEE80211_TX_CTL_REQ_TX_STATUS is checked
in ctrl_flags, which is wrong - IEEE80211_TX_CTL_REQ_TX_STATUS is in
info->flags, so the check is for IEEE80211_TX_CTRL_PORT_CTRL_PROTO
instead. This works out OK because the only place setting _that_ at
a point before this gets called is in fact ieee80211_tx_control_port()
which was intended here. This is actually needed for correctness, if
jt were checking info->flags instead, TDLS would fill/leak the status
frames created here.

However, we can just fix it by using the cookie instead, that'll be
set for PREAUTH frames via ieee80211_tx_control_port() as well, and
no other frames.

Additionally, the code also erroneously set it, but that just caused
preauth frames to get it set, since storing the ACK SKB will also set
the correct flag. Drop this assignment entirely.

Fixes: a7528198add8 ("mac80211: support control port TX status reporting")
Link: https://patch.msgid.link/20260803141309.292711-10-johannes@sipsolutions.net
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 45167a2592615..951e2c678fc5f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3023,8 +3023,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (unlikely(!multicast &&
-		     (sk_requests_wifi_status(skb->sk) ||
-		      ctrl_flags & IEEE80211_TX_CTL_REQ_TX_STATUS)))
+		     (sk_requests_wifi_status(skb->sk) || cookie)))
 		info_id = ieee80211_store_ack_skb(local, skb, &info_flags,
 						  cookie);
 
@@ -6662,9 +6661,6 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	if (unencrypted)
 		flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
-	if (cookie)
-		ctrl_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
-
 	flags |= IEEE80211_TX_INTFL_NL80211_FRAME_TX;
 
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom +
-- 
2.53.0



