Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211319;
	b=WXocFbfBPJCKhR61EMqqywVTDEMxIomnlr1uSOJNlW92uuxfXbIuKPOmKr5u3vFcS43e
	 O0+6XPen/JRNlT7Qx/DGWCnxBDHuFmeGqAMuAgvGj71SZdaovXuB4QhVRt2Y/L1t7dI4H
	 BpW5MbicV4jR0yURik0NyiPlkl0Tc3gTiwDwz/pMKPs5aH4gY8/WqkMwucq5WcosAG2QN
	 ATF6DI/9mwd78B96LI8lwwXZ9pwvw2wi8sXF1gAjh/Nb2twI5F4K8CuMSMaHkn58THWfZ
	 aCKo88U4NeQBgNqM5//fccl/WTlXTBacPike5A2+zdUMZEntAQuf/G9BQ1urSdyTPsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=S2djrZGxPe9qy+cdNI7gSxhKiHPIfKbWE2qXAfS2O2g=;
	b=uCn5uFwhfWQjQiH5dwStUpQVFR5cMNQSU+EcFP2dtX19fG5eoyV+w+zl5lXn4xZGTZpq
	 a3EU2+8siNGhn7zFRVMCI8Typ/ur8ITIuU+NGusfHVTvWrsy3yvB1gV5yfIXm/+PuNujf
	 1h+JVbfvJiR1TcjYSn0e6iuAr97meQcVokskQa4+Xy5e2cxfQoI8MYSUhCEKLiIw2Y6hz
	 3GM2g3zQJnYRsCKmO0OcgjNbnAP2QfiGMBTwfWD9Ml8o4oy3RLLqBgmKq0pNguUyxxUF1
	 PcYk9VK/Dz/kC86B3cFoUWo0P7++79mBs31oPrEvcLZ+fzjw7IixbE30KtaziHDpYsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueBs34E4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B6E606A32E;
	Wed, 28 Oct 2026 18:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ueBs34E4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE971F01825;
	Wed, 28 Oct 2026 18:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211319;
	bh=S2djrZGxPe9qy+cdNI7gSxhKiHPIfKbWE2qXAfS2O2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ueBs34E4aUK0iZDoNrJfTz26HErOwwyZTU0SUX6+pROHTdVs9tsCn15rblq1k6Tpw
	 /VTzKxsf3WWcBPJ0S7fYHlmHM1s9amPXpN0/1kJnSGThjlEEOKfFpqCaBKL/VYtScr
	 lqghY/BurB3V38SfFTxKY4t5QOhT295LbIHjHQ9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 336/571] wifi: mac80211: set info->band for 802.3 encap offload frames
Date: Wed, 28 Oct 2026 17:58:03 +0100
Message-ID: <20261028170015.985072168@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 4febc02cd02f021f2b6d0768332be643ef14a12d ]

Unlike the 802.11 TX paths, ieee80211_8023_xmit() does not set
info->band from the channel context on non-MLD interfaces. It stays at
0, so ieee80211_get_tx_rates() uses the wrong band for these frames.

Set it the same way as ieee80211_build_hdr(): drop the frame if there is
no channel context, and leave the band at 0 on MLD interfaces.

Reported-by: Andrea Pesaresi <andreapesaresi82@gmail.com>
Fixes: 50ff477a8639 ("mac80211: add 802.11 encapsulation offloading support")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://patch.msgid.link/20260926120216.4054712-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: Changed vif.bss_conf.chanctx_conf access to vif.chanctx_conf. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index b7865f3b97879..a919d585b6b1b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4467,6 +4467,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx;
 	u8 tid;
 
@@ -4514,6 +4515,11 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
 
+	chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
+	if (unlikely(!chanctx_conf))
+		goto out_free;
+	info->band = chanctx_conf->def.chan->band;
+
 	info->flags |= IEEE80211_TX_CTL_HW_80211_ENCAP;
 	info->control.vif = &sdata->vif;
 
-- 
2.53.0



