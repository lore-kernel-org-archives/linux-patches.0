Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044061;
	b=YABExIYWeAKHHfdc6qz54zONhg7hj0XR3MZeQ6rfORJnnQoVuFArDSgIrDe5EMA72rh4
	 fK68yNWgQLUvd+4y95oIX0KA3zRhdEzxzCwQsAPJxyv6aWW7g6l/JCTavMDJWidDM+gTN
	 mxK1zO6hoBmvhcgCsqHpufZnWIPLrOsWYg1NBU5+nfgTnbtZMyrV4etJIjp96Zf81TWQ/
	 b/VFEGJYYURkJ9A8m6dPuZ1WIaa/Apq21KaeRR4EQIpRhdbPu/mc2D0zMzctAdZ8MNpPr
	 om0Ok5gBFUzdtW3m1Ei7N5Zl/CQkZziUdZRRuvyK+KSi6uuWXEBxmvsJuGKomvwv+7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cgfYjYVIBBcLUZR15YAS+ra6mXaDuJfRAYpo3dbM6Qg=;
	b=GW3MAI7lz9bGIX16ytupN1dB+tPMJEy8NkyMDoYAPfb5P4i87hwHpBfcHRqxoCFyIEk1
	 4AYUVTZXILox+Cw4GEaydg3Dld7IY2+K9Ld9tojuLvzhFPfeSbLI92JXAOqNqpW6Ugcsj
	 dDJXygX+7gY13CH58cM1l7KiXExrDwj27lvs/KadTfPmvC+TRaZ9n1InB8vmUNjx3GddF
	 AvDg/B0Xnfw+72qiX58bVYePjyZYy6nLSrcFCtuY3xqnYRguSmMWrT2bFrQmki2YdXhme
	 AwgiLXUy8T6Zb8zy+LC9CYg2uBdyS8XzsEV550ZgMoJi8xJ3s+wbgg2hZ+gnEvL7bfw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI8FdneF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7577F606A31C;
	Wed, 18 Nov 2026 23:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SI8FdneF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71711F000C4;
	Wed, 18 Nov 2026 23:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044061;
	bh=cgfYjYVIBBcLUZR15YAS+ra6mXaDuJfRAYpo3dbM6Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SI8FdneFx2VRvjsElZRLQk5QTdUEYORYO93fMEF2gSI6vDThXHWE4xXEjrBn8CAhF
	 gAyWstvOT3H0wD//cENXtOaYp6a+3NpkAwfi1/CznHcpInyxZx7CcAbOQRU83V4ACg
	 22dNoQzUBUKU/5UZEdlGiEPiuGTqBmvmYOap822k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0433/2857] wifi: mac80211: refuse to make a monitor active when it has no queue
Date: Wed, 18 Nov 2026 15:24:27 +0100
Message-ID: <20261118150216.972520479@linuxfoundation.org>
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

From: Devin Wittmayer <lucid_duck@justthetip.ca>

[ Upstream commit 2b04d6556964ae9f89819b86a0a7801e39c3aae5 ]

A monitor interface only gets a TXQ if it's created active, and one can't
be added later. Setting the flag on a down interface is still allowed, so
the driver is handed a monitor with no queue. ath9k dereferences it:

  BUG: kernel NULL pointer dereference, address: 0000000000000066
  RIP: 0010:ath_tx_node_init+0x49/0x170 [ath9k]
   ath9k_add_interface+0x10c/0x140 [ath9k]
   drv_add_interface+0x54/0x250 [mac80211]
   ieee80211_do_open+0x32f/0x800 [mac80211]

Reached with CAP_NET_ADMIN by "iw dev X set monitor active" followed by
"ip link set X up". RTNL is held, so netlink operations block behind it.

Refuse the flag when there is no queue to give.

Fixes: 79af1f866193 ("mac80211: avoid allocating TXQs that won't be used")
Cc: stable@vger.kernel.org
Signed-off-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Link: https://patch.msgid.link/20260904200338.10829-1-lucid_duck@justthetip.ca
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: Added a local->ops->wake_tx_queue && check to the condition, since drivers here may lack that op and never get a TXQ, and adjusted the context to match the surrounding MU-MIMO code. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0274aac7fb9ed..10df0b81a878d 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -104,6 +104,11 @@ static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
 			return -EBUSY;
 	}
 
+	/* TXQs are reserved in ieee80211_if_add() and cannot be added later */
+	if ((params->flags & MONITOR_FLAG_ACTIVE) &&
+	    local->ops->wake_tx_queue && !sdata->vif.txq)
+		return -EOPNOTSUPP;
+
 	/* also validate MU-MIMO change */
 	monitor_sdata = wiphy_dereference(local->hw.wiphy,
 					  local->monitor_sdata);
-- 
2.53.0



