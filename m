Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212641;
	b=baH/J93+t4ML+BsbQ9YrPxgbeKuZx8jBaYAtWJXx79/AhPtGbtagOd8S6pKBYeMWRA0y
	 PATDltnkQ0vrFc/yTO8grMas6UdqMgcF9kx/hq72OM8jZjjRbAvibusk5/tI4vd/LX30m
	 j9QwgnYVRgelbyFgtDl8lzhdwFNOvSMIPw/XBvvQLp5uxwMtdKNwOxc6RSPJBtg3fyrca
	 sTIxxPhGRpawtoXknAW4FchzqK285yGWPaN8+P8lBmZ0XNWlzAgJxh0scMeZRPuNFTRGM
	 KdyaxcWh8CAE6UiyR4D8r/QPyGq8Pw+bLWjgDfnXpEuyl8QFHteI2AXg+zCIf20Njzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RBuIkpIzjC4KbS4LCJEADHpLfBy4mTzDh9z2+FGvJJE=;
	b=mPvgEkLlWIxEfLDxsBNwiCo5ge6wJKc3HWUb3QObjQUSSB8ByEySfujO5BPtiI9IP5in
	 NS0iX1f85Sy0GnvQZBvIz4kVAIUD5TeYLKtES3IEzTQaDQDpTuofRcVKs6AW+EP0KqJf9
	 2hHKElVjPFkUaJLUT1brqc5X7Qp13Z91+u3ToiMlDSSGG4QHF5qpFEzD91Ker6eULP0om
	 2hcWO74kfT0q3YgQT/1K3aq1lq0G1Oyduhu3ZS3+FqXQo2JGnyihRI+e09uD4tu4qkJRJ
	 b5Rc1LGJW+FXlarTnP2m2a0Ew5/Kai1vy9CkaoeLStYeIA6KW7DLTPa4bFiyAZcY8xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSv2DGQS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FCF606A31A;
	Wed, 28 Oct 2026 18:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YSv2DGQS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B6C1F01825;
	Wed, 28 Oct 2026 18:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212640;
	bh=RBuIkpIzjC4KbS4LCJEADHpLfBy4mTzDh9z2+FGvJJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YSv2DGQStl1qqoh5sCAWom7i1G7AlejtQGdoFPscSxsuJOsN6DX+u2tY16BqrECu7
	 A9/4qlBT7/W9e2dNwDlp8BRHMkdL26VFTt4/C1EDi3wl0G4icb19IcpWlHvmv8x2Kz
	 jMlIRb6b2PhEYD1j1qeLJp5RQfMP2Ng4YQ/pqodg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0225/1887] wifi: cfg80211: preserve hidden-group beacon IE ownership
Date: Wed, 28 Oct 2026 17:38:41 +0100
Message-ID: <20261028170504.353063342@linuxfoundation.org>
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
index a8901e07e96d6..d6bd95857abf2 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1784,20 +1784,22 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
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



