Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623329;
	b=m2TDnl6BS+dCY32y3j1vc11Fqf07L0K8y+eSkzMaG6kGf0jtebSpOf9odTvOKgV4SkaN
	 54dw9+lxOjrgF1c72/G5uAdyBL2io2bHtuofWUZq00NEBpBl93UH8v0s8smxBVdkp8/nm
	 yoNfpTAn0mkpPJWyT2ztjimSRwF7icsZbqIJ1eKuN0Y9V1x+0hdo1S1RomWVjx+Th42q5
	 bB9Ur4tfKfibCQlLsLjV5dRTKqDAA9D9Ug+3+OMsQZ4UzP8ycRy1LxUuwn0SanbSPk8cC
	 e6uyr0vbjztFwgDhMghLAc3fdNeLYmZJZ0RHRq0H6abqPjbYXOovdTTK/YJAkorZr1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tOFjByPAcQxnFZJfB+P11QGYBjFARYv5hZQLHgaqMwc=;
	b=KS24qAOpf+dKo3ecKYqwZ6kK94B/alzo88P24O3Jt+rtVMX5yINKlKDEkXSy1Q4Njx2y
	 0sOU5Ut1ABl0Vlqwa2wjzD49dybv4YGUMplB+oY2Hktx6qvZQMyvnqlHvNc7u5uSzvu8J
	 vdhbCQyDuNFDtTGXPwDcTUzYKJgHHLP8/fZvFIxPAlypfzowp0FKzFqnFpFMi2y/bKX0c
	 N/5P51amM4kTT0CiO0joNtiZAPzMg8ik8tcLj/cfHvDWSFl0VqEmFNc7pCmLI+uSe5YJL
	 LyithhP7LIgrqOG6kX3P1gEwoPn6w9wTq0+RpzzcD84qRDQbdGoYCDECtRxHkFQxxEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fb2taaAT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDD1606A321;
	Wed, 25 Nov 2026 16:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fb2taaAT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C9691F000C6;
	Wed, 25 Nov 2026 16:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623328;
	bh=tOFjByPAcQxnFZJfB+P11QGYBjFARYv5hZQLHgaqMwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fb2taaATFryKf6Yamh2Ea2l8Y0E8OIamxgKnhq+orfubWflR58vae4XDpmsniE7Ec
	 P4/pN6NGC0Hmd7Gn3gSDl7UywQCe+xp57AB1nOmfdhZl2txBV97SOWa8Rul3kUMGD6
	 fFtIa6rvu0AwFy6Iqy23Ravj+3V+QRyFF0XWlSkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 822/990] wifi: mac80211: bound pending IBSS station allocations
Date: Wed, 25 Nov 2026 15:36:29 +0100
Message-ID: <20261125143841.292658626@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit 3029ca2112d7bee4d3e3eadd02decdb3eddb9485 upstream.

Delaying the IBSS station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when disconnect frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 8bf11d8d0811 ("mac80211: delay IBSS station insertion")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142235.15428-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ibss.c        |   13 ++++++++++++-
 net/mac80211/ieee80211_i.h |    1 +
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -691,6 +691,7 @@ static void ieee80211_ibss_disconnect(st
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
@@ -1207,9 +1208,18 @@ void ieee80211_ibss_rx_no_sta(struct iee
 	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifibss->incomplete_sta_count, 1,
+			       IEEE80211_IBSS_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new IBSS STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifibss->incomplete_sta_count);
 		return;
+	}
 
 	/* make sure mandatory rates are always added */
 	sband = local->hw.wiphy->bands[band];
@@ -1662,6 +1672,7 @@ void ieee80211_ibss_work(struct ieee8021
 			ieee80211_ibss_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -668,6 +668,7 @@ struct ieee80211_if_ibss {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,


