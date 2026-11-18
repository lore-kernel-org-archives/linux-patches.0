Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034750;
	b=uztOsdwruKQUyD7c5OCAn+MYn1JRTx+5PldIYSR0Zs7JolyJ5NnoP5ynh0dooPbhNKwX
	 kGJftI3Clyo6+TgBEwpuXnC04p7Wo2A4cCNuZeiAttFVLBc4eTgXeS2E3EvAZB4F9EePN
	 cj5Sy6ZN3lyDMPZkC7Lg9ZrbIijtcwNZVb5S5hpd2g/q5yn/D+4sB6Q7cvooOjRh3N6jE
	 OnOIH0OPoXjF9YHMxXONUbknz2kUs4OOyvzRwNDWxNfAVwuBU0fxjmSWOb6QVjGNKAIP2
	 X9c0p/pYMK3J3upAEBsnSmo+iIo3R8khbz767gdBRM96NC4B/CAxxjdz2JraqYNdUhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=462c41CGoOf190gJfllhXUMPLa67zrofv0kPHlyUm3U=;
	b=bwRekLbPo0m1710CvoPI0Ok2oLEVkFeuq5nKdNMgzXqFyPC/tsFKFOXXCfgEKblyynWC
	 rUJdJpbVpFiMNuoXrwb0UQi6wNSeGo0fN88lBK+1Xgz7Abml/InckBq/LObYUc/6aojno
	 BmmryXoMN0NNcW+jT/MnILxTwz8gmoYfxuKNucKF7xxmfZzdRIA4l/HlnqttJv3rUHstU
	 HAAxSWm7rNvqnr2zYGujFV2xfbu/msEJWcnnMRuYH2yRpZCPubjb5KWdGjimJYa/vrFnv
	 caHQ0PzF2BZ1feerb7Glqs7Y+JQgbzRY8NyXeLNtNsLBig8zoPN8hYZvhfCb4E7d/ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xsl63Spm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40BFC606A31C;
	Wed, 18 Nov 2026 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xsl63Spm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8771F000C4;
	Wed, 18 Nov 2026 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034750;
	bh=462c41CGoOf190gJfllhXUMPLa67zrofv0kPHlyUm3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xsl63SpmsveyuNIIQruZm7uiCDihVKzrE9hnkLLs3KhVeMGVra1pWl7QcRwVVXCZY
	 T/XJb+GlhqJFf2BBBhhUuOTyy9iduBuA50Xd6nR5cn1yK9hc2R2qcqhzaJ76l7m6Tf
	 /R0r67Rjiq/5QbisUxYnVZ7IH/aEtFaAMsUxS2JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devin Wittmayer <lucid_duck@justthetip.ca>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0478/3318] wifi: mac80211: refuse to make a monitor active when it has no queue
Date: Wed, 18 Nov 2026 15:18:20 +0100
Message-ID: <20261118150331.283814174@linuxfoundation.org>
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
[ sashal: Adjusted context lines around the inserted check, since this tree has the older MU-MIMO validation code (monitor_sdata lookup) instead of the reworked virtual-monitor condition. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/cfg.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2ae07248a4564..12b57df5d9f50 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -104,6 +104,10 @@ static int ieee80211_set_mon_options(struct ieee80211_sub_if_data *sdata,
 			return -EBUSY;
 	}
 
+	/* TXQs are reserved in ieee80211_if_add() and cannot be added later */
+	if ((params->flags & MONITOR_FLAG_ACTIVE) && !sdata->vif.txq)
+		return -EOPNOTSUPP;
+
 	/* also validate MU-MIMO change */
 	monitor_sdata = wiphy_dereference(local->hw.wiphy,
 					  local->monitor_sdata);
-- 
2.53.0



