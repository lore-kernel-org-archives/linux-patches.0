Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037470;
	b=gt1K5B6U37PFZVALiIw2Pa10tu+79vleZZ+7HCI5POhoDMXgUX3e25vjaUlkDojeyqTH
	 INV0qHduWbJ3I2rSjoro1rLFvcZoJQyxTvuZv83o+3ALCfnj5eJoqunTs0EhZXjyc7F5s
	 Hvmdr60JfR629piPyWY90G3rEiloissUpbBNy8aaKfSSZE4yjnpDUaRn0DlZJ+Rl4Dz/R
	 iG3OQH6XEx0us9SojqZve01SABWeYT4FqscRALehrpVDNC4ewn+T7SQO7H/cQUDp3OCCn
	 qWEbf2E/6nC+wiWJFB63PeVZDiJEuD0utQjuixFn7JjRa1sQacac/vT34+CRcC/U+Ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037470;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pNY2W9ROb3ss+DsLT0zTJbYToAEspmhdWwB62wrssYs=;
	b=Ujvn6Af2yWkhtx7g+wV80eR5K6lalgtMZlV8MPr31teBGr9OCelkXdbQi+59ADopZpvL
	 dOGCcFTFQlxg76Rw5PBsL0AH+taF9EgJhzKeK6SKoCt8mNJKg5GKFfLHGN7b5F+hPTvtC
	 OdGkFj0SVyWlVXRQK8ZAcTnHs2Z4R8Qi9x+61E7L7ce8zcpDnqcpLjbp2swt7mxnamjUA
	 d2ljEBGg5mmF+Jcnncndy2KSXBUipAndV+sMp+M4kuJlPDmnoBz+E65xtK5Fo8LYqIqYJ
	 g4HhfHeRkAUGa6aZPC9StMfXKkz5xvc9m24sqIMoqRMqYbDwm75hzoaYZz9uAut4zQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpM7JZNN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35517606A31C;
	Wed, 18 Nov 2026 21:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zpM7JZNN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 321E01F000C4;
	Wed, 18 Nov 2026 21:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037469;
	bh=pNY2W9ROb3ss+DsLT0zTJbYToAEspmhdWwB62wrssYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpM7JZNN7s93S4lpw9SkEvI2UkEojf8upZuJuNacR1pDaVZ6V4Z5CCg7J1YHGidRc
	 58X0HzvjEpuqJvIHuu1qaVbHO7ugvjpceqc3tdOYpEWYXK2THwB5mjL5bYXmCA+wdh
	 ohW2LJURB/KLsExMc75QlKPUnWNiM7RVq+O+iGcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1408/3318] wifi: mac80211: reload TDLS header pointer after skb_linearize()
Date: Wed, 18 Nov 2026 15:33:50 +0100
Message-ID: <20261118150402.883952078@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 38cbfced6ae34..7579176d9bb08 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -2060,7 +2060,7 @@ void
 ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
-	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_tdls_data *tf;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	lockdep_assert_wiphy(wiphy);
@@ -2076,6 +2076,7 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 	 * The packet/size was already validated by mac80211 Rx path, only look
 	 * at the action type.
 	 */
+	tf = (void *)skb->data;
 	switch (tf->action_code) {
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ieee80211_process_tdls_channel_switch_req(sdata, skb);
-- 
2.53.0



