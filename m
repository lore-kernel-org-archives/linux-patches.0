Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053260;
	b=bnLtRTePKsCPny/dot3XOCsZHVt7/pDB5KG03RtHP8IcSFLBqUgVDX7knlmfCh4xhhdY
	 zDvk1SR2uRArgS3RKxO5ID7HQjg9HG6EtZ3eP/ficJuJM52g3fsh4AOLrd/pCL7VfBFMU
	 +JA9/3WHgUWZXTeapHPcCCzoxQkMgKIQL8IQpJl37k9REyiPAKMBRKYweO0L34CWumpEv
	 5b26JQPbQNi4z4tYIk93ZY4kkM9hq3PU5h8w84fWM7yiRipLVsr61UID4H1vacGMSfqu1
	 0ZtFzWB8vWWGIf8Sa95V3d63oHl8DP9cFdtPt24Wh7HeXqHVK8vRZweiLE+8JoCk6Bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053260;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pOs7w7JquOcGdJBpO65lNeiR37k2E9fUhLIs2nWasIs=;
	b=j3Lo9xJYHz+9rXTdY7X8ZZuweoP+jn+TGUuHWQo25eDLr2+vlc7N+CwbQq0/f2Y728G+
	 kd1PKZccbnZHiUZPrF0jrhnvUGfNs4cjaGaDa4u2xml6ls+94LLn/F8WUFsiGIClvI/ul
	 dQ4ulafdE0KDjAphjg2LClRnHCq0urbgVXVcA4x4mgkCkMgmrQDytCunpDs0gcodlveyT
	 Qg1kWVcDM4mSQqfz9IjTqM3kg1Y5NcWyA9VmwfqZNBSPy5gO5HENsX2Ln+CTjYUrk7Me8
	 nC4SFWZSstLywzWK6e5Pw4wpzJOdodiweZKqLBlzyLis7I5cbXjnVjnSYlu4yikprYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R13Vc2xh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E212606A32A;
	Thu, 19 Nov 2026 01:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R13Vc2xh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8534E1F000C4;
	Thu, 19 Nov 2026 01:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053260;
	bh=pOs7w7JquOcGdJBpO65lNeiR37k2E9fUhLIs2nWasIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R13Vc2xh62fZnJKvGGyYx10jPyOq7mbJFEhNKJ53g1VjjJYXkxGWUrQ9X7oGZdxC9
	 ZAse7xJYQQtbEbaKY5h3HhOTNGKJKAaMXX4JQC08kgmNecqtUQp2ZemhBBaRmORrYA
	 9fHfK/sX6KljejsaMzD2ldoHA8fL8bVuCMRpWF+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0839/2214] wifi: mac80211: reload TDLS header pointer after skb_linearize()
Date: Wed, 18 Nov 2026 15:41:55 +0100
Message-ID: <20261118150045.772249095@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d25dfeb347f24..b6d5ed56d67ee 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1938,7 +1938,7 @@ void
 ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
-	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_tdls_data *tf;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	lockdep_assert_wiphy(wiphy);
@@ -1954,6 +1954,7 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 	 * The packet/size was already validated by mac80211 Rx path, only look
 	 * at the action type.
 	 */
+	tf = (void *)skb->data;
 	switch (tf->action_code) {
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ieee80211_process_tdls_channel_switch_req(sdata, skb);
-- 
2.53.0



