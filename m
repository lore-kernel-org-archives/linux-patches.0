Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046206;
	b=CU9oHTBNxnEUWds3Ibbo7Tfo3DcKkroDqiD4qevyM6Gh+opWpv0k5GK/kaTy4GLAgCdt
	 oVG1dKCts4K1ACHtnIH96952y5oZU51pvbeY4E/OI+ROJwYkQBru/VcPjD4kJeAYtR83q
	 in7e+VNXQvR4vWYq7nmEoWMqPM+hDAC8m3yO3IJVsadoWIc9oIquj1d9R2C9Z7BP8mFF7
	 XproXZEE1CoFKWCmDvHdy/ABMBvsyzAvz/e5B/SSOg6IGbyNDA5w/ZNU6N5P40jODiPkk
	 bc5DeAGcohl4jNnbUZYefvY9y3SwqjpDkfN7n7R9mpwiaFKt8tCWIUlzbk0WaccwvCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=oM/PVCiE0SOa/UeUa0ZqC08upbeYD8905YSouqWjgdQ=;
	b=sZFWGpXHOivaKZtd/s546kBRrg0SH6GEZ6bfoV5yu8+/fB4MdiJyWprZkd8pUG17trma
	 51C22ljC7wAysaXJAJ/n3W4tjrcoK3UmYBSbyKh7kwKF1h/DEI0QprrLYEH1zJQ6aJGUj
	 peBQtTsc3vbyjv/+EFZoCed+ooxkk16Mszx9GzLvQJBzb7PxCv/0czh/NhAbUQPJwaQRL
	 JJtEFHzZ3QNksK8+pZM/CY43OjL4jRmUNVMkf9k+5tQ0Xhh50KB6QcqsiKIcH5IRITK+X
	 aFw4foLN1/FyWjfRqfbgXeSz8gAwBppQBkKXPZp2ZydW8ZX/+qvQx6lezeiDHPhSLdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3N20bwu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63A86606A32A;
	Wed, 18 Nov 2026 23:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=i3N20bwu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B411C1F000C7;
	Wed, 18 Nov 2026 23:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046206;
	bh=oM/PVCiE0SOa/UeUa0ZqC08upbeYD8905YSouqWjgdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i3N20bwu0SLZwZY148sgOXKoePBgLkXjsi3lMO623cbwJCPUZT5ciX3tbOvhbqScq
	 eidv6GNoOREc/5MSAZJM3PUoC5AX9WRhxeokPqKWKGe8mTeeytwrR1cla7sL2xZCVv
	 +RnTwrhrUs5e2ZO/VDTNAlJbZlPqhvQK7KKG3Pvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weigang He <geoffreyhe2@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1197/2857] wifi: mac80211: reload TDLS header pointer after skb_linearize()
Date: Wed, 18 Nov 2026 15:37:11 +0100
Message-ID: <20261118150244.717067665@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b25aed68dc8a8..071cbed5f3b06 100644
--- a/net/mac80211/tdls.c
+++ b/net/mac80211/tdls.c
@@ -1976,7 +1976,7 @@ void
 ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 				      struct sk_buff *skb)
 {
-	struct ieee80211_tdls_data *tf = (void *)skb->data;
+	struct ieee80211_tdls_data *tf;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
 
 	lockdep_assert_wiphy(wiphy);
@@ -1992,6 +1992,7 @@ ieee80211_process_tdls_channel_switch(struct ieee80211_sub_if_data *sdata,
 	 * The packet/size was already validated by mac80211 Rx path, only look
 	 * at the action type.
 	 */
+	tf = (void *)skb->data;
 	switch (tf->action_code) {
 	case WLAN_TDLS_CHANNEL_SWITCH_REQUEST:
 		ieee80211_process_tdls_channel_switch_req(sdata, skb);
-- 
2.53.0



