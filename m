Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362BA1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:18:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7A7C433D2;
	Wed, 28 Dec 2022 15:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240687;
	bh=QHXZepQeQqbgC7owBkZgnQXTcfrrAMohQMNozT4c7es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B87Rf3F/rh+07SDuO4qfdBRmHU7+QEN9E/a7Z/Ha0QjYAIea1KJj3Hm5NBv6ybjyg
	 ictQkeYHBnMl0UBP/NM8+o7HejeUgASGY+x7WODZpxFBJZD/UgCnL0zPfso3E55WLe
	 KVbGrg+sOp3MMIJ0LzbR5fSW5YXRKV65JnTWDCZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0191/1073] wifi: mac80211: fix ifdef symbol name
Date: Wed, 28 Dec 2022 15:29:39 +0100
Message-Id: <20221228144333.201826619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9d13aff91ecd3f077b432df35291c945bde585be ]

This should of course be CONFIG_, not CPTCFG_, which is an
artifact from working with backports.

Fixes: 9dd1953846c7 ("wifi: nl80211/mac80211: clarify link ID in control port TX")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index d2c4f9226f94..dafd3a480f02 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2934,7 +2934,7 @@ static struct sk_buff *ieee80211_build_hdr(struct ieee80211_sub_if_data *sdata,
 
 		if (pre_conf_link_id != link_id &&
 		    link_id != IEEE80211_LINK_UNSPECIFIED) {
-#ifdef CPTCFG_MAC80211_VERBOSE_DEBUG
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 			net_info_ratelimited("%s: dropped frame to %pM with bad link ID request (%d vs. %d)\n",
 					     sdata->name, hdr.addr1,
 					     pre_conf_link_id, link_id);
-- 
2.35.1



