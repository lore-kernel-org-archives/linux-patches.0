Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061565;
	b=iGTFoO/uWiTpJYZtYCxrovRQAEZNrCEkvvz33Xu2/KvkcJr9c0BqkLO4HRgGY7aKfJOb
	 D24aCPvC3037OS7UNzSrmHnGN8id30kxEN2OK0BpsG9zMVg/AnQhYbOjY0jppHn2U2e78
	 hwwDfcMmpz0JlJ0nZ1SielK7cmTzz8giTV3bk35vj8CfNJZ/dD0MJrEifHk7nPYaZ/cKc
	 j6lRuRHSwD6mC+k5EOSx4R+69W6ZAZh7JEqvz4sBSoYpfChRjKoiCruCkdMpqbT+LLzwi
	 xMcSUAAtqCQ5yduc1I0GvlT1ts2wLnNWTvf26i/2DY12V0DsWR0GXfyNDyTX0p9mMuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061565;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9LoQMsnaE3wjxX/tww635gvkyP5iBpF1tID2hnHLBt4=;
	b=MpSnivBMIwB5EUW05g9uAg2v3FHjZD4WSfBD5hQRE21qdYPKqJOEtBcOHNF4+Yoy3071
	 PlC0Z/8QbSMYM5l/tD3qGtik4FFy9I61MhO9vfWVajpf7ydzOyOFG25gM3bloZUbHAwLt
	 m79NuwMqZ+uvarbVHSemnO9HKXTFY7orBtVLGUhm/ULusUBsvxMBGgL4UpHL2XgpRfj+W
	 yJwN4JEc73KrBB17Ujiq5Yg04Mm/YUp3JdorRJ17PTyB48URdMTrHl6Oyo+0Gixok7eZa
	 jMWDKHAvVxPDdQBqFLZV6glUpH92ykDrJ3JxHxYT68NhRj1veJAPqOa5c5I84EVInIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y82Ul2wO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1363060A2607;
	Thu, 19 Nov 2026 04:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y82Ul2wO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6F31F000C7;
	Thu, 19 Nov 2026 04:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061564;
	bh=9LoQMsnaE3wjxX/tww635gvkyP5iBpF1tID2hnHLBt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y82Ul2wOiXJUgFM+p6vxI+BMxOCcYmg2Qr4DFb6jUnWfBqZRyGx8IrDKLDQImmnIa
	 DttDU1WEtBnHxfcyjFrhrXIK85H/lCUPOIIOh5lcxYBZAsRHYkz3KU+BHWMRKTm4Wm
	 D+S2jNdwvyvSVv31BUEwfvIP1aYOwi0x9x7nKeiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1556/1848] wifi: mac80211: init radiotap iter after length checks
Date: Wed, 18 Nov 2026 15:59:54 +0100
Message-ID: <20261118150024.750513397@linuxfoundation.org>
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
index 6c9df5e2a0d64..fd2887004689f 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2077,8 +2077,6 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
 	struct ieee80211_radiotap_header *rthdr =
 		(struct ieee80211_radiotap_header *) skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	int ret = ieee80211_radiotap_iterator_init(&iterator, rthdr, skb->len,
-						   NULL);
 	u16 txflags;
 	u16 rate = 0;
 	bool rate_found = false;
@@ -2087,11 +2085,14 @@ bool ieee80211_parse_tx_radiotap(struct sk_buff *skb,
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



