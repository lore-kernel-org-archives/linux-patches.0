Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590188;
	b=NASL7Y9vQdjOFScd5JACsRv8788VgaAmZ7Qy3TRXNZ06jOXpWcS5dY4jD89PxAP0qui3
	 hQk7pjj1FftYMUaTPZFJdExc5lbPBjFyAJeJkno17f6dncPPoz78zzYQUXxiOmz9Lsc/r
	 RZOnZhtKVFJ1XSDNdZzLIvl1V8Npw9DxzdNC1+52TpbRw59cC2oyfICpHfHVRAzo8rDYK
	 Y+G4kUpGwpLjkNX8vJQpQ+V7XC5JqM85Ivm0ZZNj/vEXP6nW0wL6yschVVvQYVS7TK3ej
	 1FsJqpR2F/Sptb0yHI7iugtr+AUrV7Z5OmfOMP7dzFi8ZXClQyq3hG/ar8tHhSyqgxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590188;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EMfFbDhloTBmpBOMm7gaedBBfKgONHBtZa7z1WetGPo=;
	b=PVB4gok6scMaBjH9DSN9No04U76KRnKSWW2qNi/ip4MKxSwEAXKy8aFDbZlSFFOhzR9r
	 df1qYKVjPuG7Tr+AtnrT4WgZOYyncZ7IsUxd7sMuWIiSSre9Ks2asN2Kt++iYwLRvPmSU
	 vaFo/hrexasSwuKzBfP5ozuboWg2QPvcG6WHt0UNljIv1syzlJuOgKJtS2aP+xeKyIOu8
	 0v5kbA2ToYXUOCVYyF7wKwVX23eBA39MZka36uAGDL/I3jFKtPuzG0ZZ1kF+sjucL8Vn8
	 JQio7UyPUtkseRdYEx6vrkj3c/O/DAKlEYmm1sUUC2l7uRf1xZQGQTeUw+Mqb7ii9xQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBMIdP11;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8996074B0E;
	Fri, 13 Nov 2026 17:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iBMIdP11
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3DE1F000C4;
	Fri, 13 Nov 2026 17:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590188;
	bh=EMfFbDhloTBmpBOMm7gaedBBfKgONHBtZa7z1WetGPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iBMIdP11jVmXLKhhFrRYVcciBs3QDioILMsHhiqKK+2utl/BooNCvjCcx/R3iCS0p
	 X+pDpXU807sb2zwpdoiQUyEmAkiMXPtCGXTANf41VZx173bkCsKURCW9UAWq+X9N/R
	 zAJHDt3qS2d8Q/AgzsEoDdmnBBN0JtJ1f1RJnxD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 197/686] wifi: mac80211: reload TDLS header pointer after skb_linearize()
Date: Fri, 13 Nov 2026 10:45:30 -0500
Message-ID: <20261113153827.711335374@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weigang He <geoffreyhe2@gmail.com>

[ Upstream commit 35c5a5ea4418571997a7e7af3e7e8922b136f6e6 ]

ieee80211_process_tdls_channel_switch() sets tf = skb->data before it
calls skb_linearize(), and reads tf->action_code afterwards.

ieee80211_rx_h_data() queues TDLS channel switch requests and
responses to the interface after pulling only
offsetof(struct ieee80211_tdls_data, u) bytes, so the skb can still be
non-linear when the interface work handles it. Drivers that build
paged RX skbs do this for every frame that does not fit into the skb
head, e.g. iwlwifi (mvm), which is also the only mac80211 driver
that sets NL80211_FEATURE_TDLS_CHANNEL_SWITCH. If the remaining data
does not fit into the tailroom, skb_linearize() moves the data to a
new head and frees the old one, and the action code is then read from
freed memory. Depending on what that memory holds by then, the frame
is handled as before or ends in the WARN_ON_ONCE() of the default
case.

The frame only has to be a data frame with the TDLS ethertype from an
authorized peer, e.g. relayed by the AP from another station in the
BSS; the read happens before the sender is checked to be a TDLS peer.

Load tf after skb_linearize(), as the request and response handlers
already do.

Found by static analysis tool CodeQL.

Fixes: 8a4d32f30d11 ("mac80211: add TDLS channel-switch Rx flow")
Cc: stable@vger.kernel.org
Assisted-by: LLM codeql
Signed-off-by: Weigang He <geoffreyhe2@gmail.com>
Link: https://patch.msgid.link/20261021145807.3018338-1-geoffreyhe2@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tdls.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
index 1dde37ad8bb20..83ebd9ab2e9b3 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -2017,7 +2017,7 @@ void
 ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
-	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_tdls_data *tf;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	lockdep_assert_wiphy(wiphy);
@@ -2033,6 +2033,7 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 	 * The packet/size was already validated by mac80211 Rx path, only look
 	 * at the action type.
 	 */
+	tf = (void *)skb->data;
 	switch (tf->action_code) {
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ieee80211_process_tdls_channel_switch_req(sdata, skb);
-- 
2.53.0



