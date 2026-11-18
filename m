Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058978;
	b=wNofSpn4jpFYHoJBGuIB+eYwW1MzXhKFocxElyxveMQ6T7wUm3nfvc53nGGCW0H1zp5v
	 /u4MhJvj0YA4VEywLInv85UdlwYFG9SN6jiPSlbEL+GLrB6yZTSHRCgRyaOjQqfgmcFSk
	 MJpxmSaz5RVnsJCOU1zLfzro+QFnZEHBDc8zYzpGHkiFybxYd3h9G6mMl3RDvZdzp2ucN
	 u4qYzUyCI0YHloniN4lFzlKGjKjp3t3FSzYXVxZJs08m1fLhPDyUd5hXQdkVS6o2TTve8
	 3pl+1UYcXF+jZtnU3irEnQ8Kv3V5uYO9zVT8SwgiRhR493JOiMydL6BjqQjgtm9xIrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058978;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jnnGao4tJlStf2IK5y3goYw3xUcfDR9g96Ti7U1z4eQ=;
	b=pXX5IwpnTb9Z8HqOpplFzpG7tyPuPYb01jC+BGD+w8SAVh/cnp/qXQIgVXJLHnlkk2gQ
	 Njjg8HK6ih/D2eDBSQRlrXTeIzXuPSGaKZCYuIUltfQcuMrIWhrasHgBd0K2NKispNRRW
	 eWWMnsY2YHhs9lIjaISOZx5lijETKNC29+pe4cW92JxLnTQIwk9T6NUSRpuNMIfdudA40
	 TUXRU4eJ++w9i+ImPnZORIYCzrpgrjHR33dNzJzqfwdf3grKO2SkJ+GOPk+jqi5wIGOxz
	 Lq/JkAd1jxZt1yTUtyLO6Hx4jlWPct1hukES2MKeAnVqCRfTxcg3lIDVnLNG0UA4hXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOQIIjBd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147E9606A334;
	Thu, 19 Nov 2026 03:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LOQIIjBd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699191F000C5;
	Thu, 19 Nov 2026 03:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058977;
	bh=jnnGao4tJlStf2IK5y3goYw3xUcfDR9g96Ti7U1z4eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LOQIIjBd1RLODXydBl++B+ttVzBnB6n5BLSLgWIjFz0DaOBXt9Kf4oFVNLzNhSb2P
	 xhjzCC2i5n4lWNueK3Fd1VulNps8vNe2QboNZwnCJl9Op9/rO1bvmBegjOfcQUpio6
	 5eQ4/nyOlncZx0f0uUGGoIwrGO+e4UQIwIpyR7eM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0679/1848] wifi: mac80211: reload TDLS header pointer after skb_linearize()
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118145944.353186888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 66e32f1d0a989..5605903ae7d18 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1924,7 +1924,7 @@ static void
 ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
-	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_tdls_data *tf;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	ASSERT_RTNL();
@@ -1940,6 +1940,7 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 	 * The packet/size was already validated by mac80211 Rx path, only look
 	 * at the action type.
 	 */
+	tf = (void *)skb->data;
 	switch (tf->action_code) {
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ieee80211_process_tdls_channel_switch_req(sdata, skb);
-- 
2.53.0



