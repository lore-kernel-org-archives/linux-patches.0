Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208559;
	b=idfUhpI0aPVUTdM7ZbQ8dgZbtcEOEDparrM4cFFxBPkRWxBIsf3cavyF5yft78/Mghh3
	 ULJCo+bas/NN1+NTeJ/LJEeZTPR9/a+hsfW5+cdRm0GLkokjGLKCj6syKCu3JbxTh140o
	 QRsX6h5G23atjk9TQV8b9UjvEW2n77d2Kvqgrvis5lMp4sc84RpEl74Jqrc/mL4pABy89
	 VQj/9rYSJYVg6nW2g+yHyRC+NHBSJe1e2lLVViQpjWBKuDwqMFNb22EFx9qnoFLMz5FmG
	 Mt9YL4WbYIU77xHmDRa+Ptifu00QYNU3ymR1f3L/lWkTV1ZgQQPMUYk4FoGdifhkQ6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208559;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rUA8O4jMee0UaV02h3GAO9u1SiSQeIBrKwW+a+uwSTg=;
	b=aoTG075zsQyxyUlt3bY/lgv6VFQK3hX2g9i6TT2tGMkfdiBaf4alNXWJ+LZy/2JQTQEg
	 M5w3OZDfKYTkVgFmZ7b4dsoRhne7bD8mSC8nxegxxDOX+pfsO9JKxXmVauW8NKYoMcP0O
	 /9PBeVS7vvSzhGst2l3DQBGg+2kLK2ksXKyESvtPV1xcl+oHZ3vx1vbBJ2P9Dm5FZfu2S
	 37kXYeMg08kQS5PFeF2aD86SvZsiND7NYDiHX5s4e/sFNeBZBpR00TTWAyyq5X5RNVpOB
	 w6eYhDQDpteZLangubvSFh26bvJpPv/GuZoDpEYGLiIj0J10oPBeKlpedh4BS80NMyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aV5QX4FP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E31F606A31A;
	Wed, 28 Oct 2026 17:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aV5QX4FP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA011F01825;
	Wed, 28 Oct 2026 17:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208559;
	bh=rUA8O4jMee0UaV02h3GAO9u1SiSQeIBrKwW+a+uwSTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aV5QX4FPn1VWOhrF02Ae9NHNdYe17QI2VAvgBR4HB6zP0c5ZpSzBRR+vImeeKl8CU
	 SHty9Ep7wuf/O3AHv7tBUxWoO5m0MzSNrQZ+RwUJbbLyE2ARzLXE6S5Jhbf0NIjYjx
	 RgsQ5HBpXxVxbMLnnXjAMDU1RU9853swfCQMscHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 162/516] wifi: cfg80211: preserve hidden-group beacon IE ownership
Date: Wed, 28 Oct 2026 17:55:14 +0100
Message-ID: <20261028170007.343524864@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit cc45f313d85533d647ce619326302aad6f797c14 ]

A hidden-group probe-response entry borrows its beacon IEs from the
group's beacon entry. cfg80211_update_assoc_bss_entry() can pass such
an entry to cfg80211_update_known_bss() when merging scan entries
after a channel switch.

Copying the borrowed beacon_ies into the associated entry gives the
same allocation two owners. Releasing the group's beacon entry can
then leave the associated entry pointing to freed IEs, which are
freed again when that entry is released.

Skip beacon IE replacement when the source entry belongs to a hidden
group. Preserve probe-response processing, the subsequent metadata
updates, and the existing rejection path for conflicting hidden
beacon updates.

Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Reported-by: Yilin Zhang <yilinzhang@moonshot.ai>
Closes: https://lore.kernel.org/linux-wireless/20260901080427.1983015-1-yilinzhang@moonshot.ai/
Assisted-by: Codex:gpt-6-astra
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 7e6e72ae6d5a9..c798991714d8a 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1765,20 +1765,22 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
 			return false;
 		}
 
-		old = rcu_access_pointer(known->pub.beacon_ies);
+		if (!new->pub.hidden_beacon_bss) {
+			old = rcu_access_pointer(known->pub.beacon_ies);
 
-		rcu_assign_pointer(known->pub.beacon_ies, new->pub.beacon_ies);
+			rcu_assign_pointer(known->pub.beacon_ies, new->pub.beacon_ies);
 
-		/* Override IEs if they were from a beacon before */
-		if (old == rcu_access_pointer(known->pub.ies))
-			rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
+			/* Override IEs if they were from a beacon before */
+			if (old == rcu_access_pointer(known->pub.ies))
+				rcu_assign_pointer(known->pub.ies, new->pub.beacon_ies);
 
-		cfg80211_update_hidden_bsses(known,
-					     rcu_access_pointer(new->pub.beacon_ies),
-					     old);
+			cfg80211_update_hidden_bsses(known,
+						     rcu_access_pointer(new->pub.beacon_ies),
+						     old);
 
-		if (old)
-			kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+			if (old)
+				kfree_rcu((struct cfg80211_bss_ies *)old, rcu_head);
+		}
 	}
 
 	known->pub.beacon_interval = new->pub.beacon_interval;
-- 
2.53.0



