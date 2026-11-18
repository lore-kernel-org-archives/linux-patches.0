Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019335;
	b=eOlNtMEjzB3mjhMnDiYOCDEjJ1wIwlA/yjquuDQJE7qBxWgi8VFy9rOiPesb5iM0llqY
	 5v7/V+H8UJqKUIbdyX6PxDacwsmSsTnQv9qMfTwd8gftFMGbCARlWC0rZufkOhkKnYjuT
	 VUD5Lf6Il+5mpjsgRHehXoQdF+KcCUOxkQJb+hFK7mNPgK68/8nfiZoxnZRoaiTMGFxdC
	 0X3Apm0tVOM+U80JVqy1FK9P+mvtwG59x6I1KO91p1DWuo5cTmlmkvzsm75uu/uSEw22A
	 SiVPe8Rf9taOZVQ/P0ZoMwqh1QYN62Rqv1FP4IlyH6kSyGkzjhC9vsRZHS6PSczabYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019335;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=olOLmtNSu08srMzYfytS7ZGyfSvW8B2T/Jya0oKZAK8=;
	b=gT48QpHrebhfpscQruMl0+vKBJtXG7amIKIv5Qi91y5xzWMgZheNbvmZ2FHN+G2gR/Bo
	 r3lAqNVOx/p3KVwLn8UiyTkdmBCY6HrgIS7camVhhIWakUroY4qQ7i8rkYzLjW4aNNiY5
	 xS1u5DwYnVEIqndFkh5HHYPutTEzR5QD8Z2wnuVlV4/I0tSAUFrGnJifhnOxWL1ykXfYH
	 aMf/jDkpVmZ+9AIWHQ/ZVRCNqc+cBko4ByoMVPiDBWiLBom/khzZ8latWFfkllXUJDd6A
	 7kjko4aBunLtmRt+kFOCsLpJnQ7swSTNw4epSdSm4DkhKYjX6x7jBu0/neCvxFwr/Ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsC4Utfj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB39C60A2604;
	Wed, 18 Nov 2026 16:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsC4Utfj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81791F000C4;
	Wed, 18 Nov 2026 16:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019335;
	bh=olOLmtNSu08srMzYfytS7ZGyfSvW8B2T/Jya0oKZAK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsC4UtfjsHosZCwrl38BmQkTIqLnEVoIqlWDhd14n0EsklVdne9FvNLcltiZpLW+M
	 aDtGjLxdhaNbYMWp61wnNquipyBq2P5WL+vMenTa+jSTOkW+4q2xHel8XvcvWJ4391
	 bYPujGOVNSfvLm5dNLkCKLw2JkWc6I7LI5e01T38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1558/2651] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:46:38 +0100
Message-ID: <20261118150344.038440442@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e3cf8da7e0c560db67ac5ee8c9197514bb298ea7 ]

The radiotap iterator initialization will already parse
the presence bitmaps, so it accesses a good part of the
header. This might not be present in the linear part of
the SKB, we haven't checked it at this point. Check the
lengths first.

Assisted-by: LLM
Fixes: cb17ed29a7a5 ("mac80211: parse radiotap header when selecting Tx queue")
Link: https://patch.msgid.link/20261005224950.b5c2c31790d2.I091422db411b595bde4dba2de69334cd2aeb33b0@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index dcc8e84ea1a93..c826bfb92b7a2 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2183,8 +2183,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2193,11 +2191,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	u8 mcs_known, mcs_flags, mcs_bw;
 	u16 vht_known;
 	u8 vht_mcs = 0, vht_nss = 0;
-	int i;
+	int ret, i;
 
 	if (!ieee80211_validate_radiotap_len(skb))
 		return false;
 
+	ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
+					       NULL);
+
 	info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT |
 		       IEEE80211_TX_CTL_DONTFRAG;
 
-- 
2.53.0



