Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019332;
	b=ZN5Q1KgmznnzaPi/G/FFRHykg9TJyz5lP1JKs46nyznYNXzyBNNfGcDD1qn0MNXpIYGk
	 4LHy2v8nkrnTRWhZLMhK32XQsfwDrUVUweepKuO/W5ibt9wmCYpRsYNNs7zsWWZIOszeg
	 IFlttbpc1agV+Xxr2NQfILhkflTvrLlDYlsY4T6vRMKiz0YPaJxOaVrv2r9OuLrKzZ1nF
	 Wy0csnMDe6OcdhuvBGbNRmwaFlJMGiZlG5nEKlC20HgqiMBlJ+rPvCLzpY7GtNgLerskz
	 1Zgi7FJbmJP1LyzXImMH5Celo5H0rS94iLITseSArz1+d8KDO6XRAOYQINeE5Ab2F/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019332;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2ChfF+NdTWf9pSt8s4eoBUohcaIdwDqVChsq15niqSY=;
	b=nHIZB9ogqVgajQA/BP4j067C/dTPfSV8OtLT/mCDnEFJMQZUVXg0tFCPuek9fkMIfxTF
	 1Gas6Gn+z3vymPZVc4qZ3oFMyNh8F/KjndhRTxOa0PBayZcEOZYcIk1vAwGv23ugTA46E
	 MagoqupC84/FKy26Z+OPJE/gqBsZO1iOtTNraADWQj3Jd5vZSTp+DHgIuW/tiYqQEGpTI
	 koYur2I8ZaHpqPStx8xtZR+OHr9Pe2Wt1DoYnf6toU0mtp5mRoO1ftGiwzEw6WjcbdOOI
	 pPWwk3wQSkcVRJUreoLVnYKp9muo8QtfLn0vVU9TqzjciNcGKTgRgkYNygCHOGceHZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AOFlgh3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC2E60A262A;
	Wed, 18 Nov 2026 16:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AOFlgh3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 092A81F000C9;
	Wed, 18 Nov 2026 16:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019332;
	bh=2ChfF+NdTWf9pSt8s4eoBUohcaIdwDqVChsq15niqSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AOFlgh3//r8WW13jV6BRgcB0LolUA5wMMtE6wAPca/UONlxe8hfU8Qvun4mPf4AZU
	 JxFunUeMeFFlhLaSJEL9BlTdeQaRznS6it7g9LqzIggr1r9glPS0FUqhHFAteFphq8
	 7gu3VCiPA/rOogJh6VYxNHYyLsFcNBZg4WFHmljY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1557/2651] wifi: nl80211: reject zero RNR/MBSSID elements
Date: Wed, 18 Nov 2026 15:46:37 +0100
Message-ID: <20261118150344.004961852@linuxfoundation.org>
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

[ Upstream commit c767e1173aeab7825a8dfb197041d3996db84e39 ]

That's a nonsensical configuration, and we get errors
reported further down in mac80211 for it; hostapd has
code that only adds the nested element if it'll not be
an empty list.

Remove an unnecessary NULL check while at it.

Fixes: dbbb27e183b1 ("cfg80211: support RNR for EMA AP")
Assisted-by: LLM
Link: https://patch.msgid.link/20261005224950.97db49d9d104.I5765a3310528b3d1cb1673dc90ad5ab5fc3ea571@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/nl80211.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7acab4fd2860b..d6c43083f8e39 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6538,6 +6538,9 @@ nl80211_parse_mbssid_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc_flex(*elems, elem, num_elems);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -6573,6 +6576,9 @@ nl80211_parse_rnr_elems(struct wiphy *wiphy, struct nlattr *attrs,
 		num_elems++;
 	}
 
+	if (!num_elems)
+		return ERR_PTR(-EINVAL);
+
 	elems = kzalloc_flex(*elems, elem, num_elems);
 	if (!elems)
 		return ERR_PTR(-ENOMEM);
@@ -6816,7 +6822,8 @@ static int nl80211_parse_beacon(struct cfg80211_registered_device *rdev,
 			if (IS_ERR(rnr))
 				return PTR_ERR(rnr);
 
-			if (rnr && rnr->cnt < bcn->mbssid_ies->cnt) {
+			/* RNR elements are only used with MBSSID elements */
+			if (rnr->cnt < bcn->mbssid_ies->cnt) {
 				kfree(rnr);
 				return -EINVAL;
 			}
-- 
2.53.0



