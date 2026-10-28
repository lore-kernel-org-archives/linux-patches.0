Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208977;
	b=1V9auVHAfJbMSBtsaeJtBn0zmL6WHilLiOy/42nQSbHESd17GU7/FM9K3tx8m0rxsaWe
	 RPIhnesprzkXMaNq92tFMI6Ibiq6LEa5f0cens6JsVWZI8GVVh4Kdcjr6yg+jc5UEflVZ
	 wsXvj2dPXCcb8t2+VfWgeVXFeFra8t3Bz5hMK4f5wnLsfFpBKIMy9U+z5mxSFk0lGCnZ6
	 orsB/J1mWOQtB6nKvMM3brRohPnDREEZ24Vl6vetqON1pMXBleuGwvw20gWTF7Afqsvex
	 ax1QB6pjBXPTT4EE806GvkJMZU3yB3OGbK8EKSHr1af0VzlMiE07DA/bzMz2hPehgRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FhiBphn4iMZMMUpfYC6mLTnIb1SQLxT2bTeD6CTxZtg=;
	b=pqAFtbpBoMc+U5S2HSJv4FLCVtlM/Sf0uRznFxqyu8WAV79jPr2ilYENdnNe5XociSFR
	 HGVkSqHVYI1eBR5RXhiaA+YL4yJzHEdC91U+x2EsUA9UKKI4IciT3s97xOcWjYOiC1wI9
	 Sw94tG/zqauQV1iHp0kwSvYji8ZQ/26jMF3lAKMtC/3drgJsmmnjvtLsPcmzWBXnr4VyN
	 w+l/0lF27g+VOX84pCdZb4ivNDKKwic/cO1FpHhhG0l+KIg59tFC9x6xfxI8191e8HUfN
	 ZsHRB12dpE3WBtV0UkAA2RbIlbg+jXAGG1WPScBYez0PAZ9aa9oBAFjYZcgB3pnl6Gw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9HvLQve;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D27606A31A;
	Wed, 28 Oct 2026 17:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J9HvLQve
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352E51F01825;
	Wed, 28 Oct 2026 17:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208976;
	bh=FhiBphn4iMZMMUpfYC6mLTnIb1SQLxT2bTeD6CTxZtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9HvLQverQGQSVBze8Ica+caivLn9vK9u39jwhnlq3wNjQSVFjma+tf9KlpDOCge0
	 f8jHqrQw7RW8xzNhF6qk3M8U1bANC4BBDdJ8PslzQcKIwuu0LmGD9cpXBs+4FOMZdW
	 L5vjC2IhoL0x8g7wcZZGeHr3H8z5NYLjXzIrhk2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 309/516] wifi: mac80211: set info->band for 802.3 encap offload frames
Date: Wed, 28 Oct 2026 17:57:41 +0100
Message-ID: <20261028170010.811143254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
[ sashal: adapted MLD-aware channel-context handling to unconditional vif.chanctx_conf access with out_free cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 87fc109595959..73b79a9611011 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4272,6 +4272,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx;
 	u8 tid;
 
@@ -4317,6 +4318,11 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
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



