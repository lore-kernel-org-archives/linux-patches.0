Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213164;
	b=ZU2XHUIngW8o8j5KcUFfC3Ot3J8cYZZKz7qeZFyBL5EDfbO6gRQdD8KJ0eRL4kXMReIa
	 5orCYmWtA0SuHBqpHBi/G4VERRhuTGi0/T8czDKkz1kfS34QvtjfTfucOjsvIHfJQCq7s
	 U4eTNZb1Uiv7EC4bvBoSjzjxOVHle3p5g4JEoBF2q411qR/mUQmciHQCq4xm7+JQcyzTS
	 VjDRz35U6AzSkCPX+so93DNSdmO7mlanZGcQMiupdilajyc9gXVlXWjRK9zGe2gYLDqFV
	 YQV57xTr4VajA3O+drHF9QeN80QZkWRWZZyOotu2pe2F0v+d4dkApJOnjJsCQrjnCzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RJ5yZJb80Q7gppx+QAMlB3yY6+1TcncBswTQ2mnBKfg=;
	b=blLBfyjdK7v0S21jUP19hnZuKxqJzK+oIxCH3l/tlQhr2UNwC5nqrISYBnXxTWUUGrPU
	 kBpXAF4FIzwowLt0GH5uu88gq2o6wmHcY91sK8brJkHFcNbUSrcznfaD7vouf8j6LOqq9
	 FWkEuEr6A4D7DigYuDo+VnmYGHBQ52wSQY2kV7FcJn4vPEHlMpb4LyFXVKFkIo7Z11wF5
	 d/6rTBubRPcH0/lGTG5CYHQAHLWB1TN0vll9WMwr00mJKWYQqT0s5LMA4LdnhzDfI1vI2
	 f0rILDvIR+t9oYrjDDz3BVEefOJuR2hgvMMHE5Exc3YBKCYcXDwdsgs6F5MXdp3EsOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teCdz88n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3515606A31C;
	Wed, 28 Oct 2026 18:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teCdz88n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EA11F01825;
	Wed, 28 Oct 2026 18:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213163;
	bh=RJ5yZJb80Q7gppx+QAMlB3yY6+1TcncBswTQ2mnBKfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teCdz88n1Yi8qt3b7I3/1RfyZTSz9X3FL66jSuZFe6/Erung4iAYIv3vJmjw/LUfE
	 CbjqF/GK6IV7WxZik8OABpVDlSll1Bma2kyOmIDsvukoaUJKS0w5Y0wv3czQgplgr9
	 BVBSIpGX8NSSP0MLE7Xt8pNUF49xzYQt+NAep/aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0409/1887] wifi: mac80211: set info->band for 802.3 encap offload frames
Date: Wed, 28 Oct 2026 17:41:45 +0100
Message-ID: <20261028170508.541470523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
[ sashal: Adapted helper usage to direct valid_links checks and single-packet kfree_skb() cleanup. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 00e8eda67f130..51cf8c4e0e90a 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4545,6 +4545,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_tx_info *info;
 	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_chanctx_conf *chanctx_conf;
 	struct tid_ampdu_tx *tid_tx;
 	u8 tid;
 
@@ -4602,6 +4603,16 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 		sdata = container_of(sdata->bss,
 				     struct ieee80211_sub_if_data, u.ap);
 
+	/* MLD transmissions must not rely on the band */
+	if (!sdata->vif.valid_links) {
+		chanctx_conf = rcu_dereference(sdata->vif.bss_conf.chanctx_conf);
+		if (unlikely(!chanctx_conf)) {
+			kfree_skb(skb);
+			return;
+		}
+		info->band = chanctx_conf->def.chan->band;
+	}
+
 	info->flags |= IEEE80211_TX_CTL_HW_80211_ENCAP;
 	info->control.vif = &sdata->vif;
 
-- 
2.53.0



