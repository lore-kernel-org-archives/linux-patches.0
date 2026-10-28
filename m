Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210851;
	b=Qaa3W6SN+/s3GFsFXQJ862Jam+dR8ngKFUlug24xjnq70o9gmKy+ZmOKsJcDBYPkfnQu
	 zEbFo0i7U2Cm/oc4fasnzi/EnqUxv0Fw7LUwIVPozNsWmWFvNgl5EmFo7etdn+HH3n1rL
	 2+Q9TGWIa6MNsMbCHE4dAr3aSL/H1ArOh8f4G6w30o6Nx+iw/m+GDU7UyZl2N2sAZhb3c
	 kBIusa+U9BesYxguUVgxY20DfLGxaTwI8Q9Obj+zMrl4OS/7I06qqE0kz0NJyAGbelFCs
	 J3GZDRLO3Y18VlOtrVW6xJ861QaINNRKXvYoTxuEcw+LhpHPr9ZbOItRTIuUQfUWt4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ymB4UGulYugbK84ExpBkWDTO7By9FmhuQPk9pkUiRlE=;
	b=c8Zy3FPIk8bB6ojoYuIq0p8LKBsPZJPVwK5djatUIhY4h+iEHgc8EQQSlmzI7d0uao0G
	 2Lz6+/2hmIrxBjt8LS0Wqs8to8csMljBfd3w9qIsfE888swSWwove74x7QzC+nQTKc0ee
	 OgteVsoLVHUCuxcicy1RdUlZWitENwEUo08lhbFzS5JNH2yh+PH8JmyNC3BNS954mEgnj
	 QgI9F1LAitz4+NTOjzCTh1HYnP6s/seXyO3BrQYmybfDrwhC47mCmQ1HimrJJtyuTaHp3
	 fTKVT+ni7+VBnkRmJOnzarFcIW9gfCOzXC5HPDzp422D362Y/fwIcaecKkDv12fLB1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEGvAFnW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430CB606A324;
	Wed, 28 Oct 2026 18:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WEGvAFnW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947D41F01825;
	Wed, 28 Oct 2026 18:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210851;
	bh=ymB4UGulYugbK84ExpBkWDTO7By9FmhuQPk9pkUiRlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WEGvAFnWf0WiFSGOj0QNf3YDAvaFmzoPIzh0mI1TqN8RDXpibig0IzQhUaEM2zhLr
	 VAxdNPk59lD3KUInmpYuBwVvEGBhud91f49zaBhMdYgsxvidW2rsP0tsYgbBh+wor9
	 X2PQ/8Q7nwvDqoXzIFPRrWXObl1smqRHsguwqCK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 169/571] wifi: cfg80211: preserve hidden-group beacon IE ownership
Date: Wed, 28 Oct 2026 17:55:16 +0100
Message-ID: <20261028170012.024366066@linuxfoundation.org>
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
index 375ffdbae1d8b..bd1f702edadaa 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -1767,20 +1767,22 @@ cfg80211_update_known_bss(struct cfg80211_registered_device *rdev,
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



