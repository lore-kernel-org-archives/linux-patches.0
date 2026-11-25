Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625911;
	b=gx/vLaEfdDacOadCTKg8Gh5BQy8G1Mc7hU5+nx/dg7Yee/9/OKTjWWwDJ/NuBkDoAr1c
	 VRsSou1YIfCcjx4nv1jeav8YnSnqeVfNMHAW8bO7rmavQgjqSvv4gVi3MDDa7q2DA6Xio
	 z97NQUQUamYS2BJHca/y5JK4f/KcbFlyphCN/FnKpuwfyfBZ3Mqe3dEGB2TUfToBbDzIV
	 a9nn9eRXkt8rr6ZSuEBAtHtaJLyFZ1hzNCkDVfjNyw2nUAGDMRB0iOmw0n2T/XFS1WPfv
	 ztEI41SPMYZYv41tNS7EJ2KvuyEEnYu4DDEmRw68oKeCsNn4hBsnOAyCjGqPEIoljOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BNoNIuspslgTS0GgjbS9OxC1R2PCjS+EPmTMGNuaaHk=;
	b=aY3ORv9AbafRO5QuaTFPHSAT9JAStYRzKhPHgUsdAK37ZZZbW8aWbQAJuSYtTa7C2vJU
	 0FPUoHKUZFWUt2X64+4ljh/8ZvqUfeiXALE6RL//hs9gDLCSMGNNghUCxbpcafH3QT7HG
	 5hiaq6jl4Gox8IZNEcW4V+N/UdFpRtI6sE4oAX0GCsCO/7lzdz2fMBv4PZoR4OyMR5C3c
	 377RPIyrL52Vl8b4mCsX8T+SWyKpRHUV3PQKZ3eE+pJRFDyQDu/jFbUbz9fzUe4yJBLTq
	 jeu5pYBESJvxw8m6fIk68e3RDuZFpNO6HUyJYiDECAhnXjvXNUHdyspG8XLKDMNid2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oA6K73nf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43377606A321;
	Wed, 25 Nov 2026 16:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oA6K73nf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2B31F000C6;
	Wed, 25 Nov 2026 16:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625910;
	bh=BNoNIuspslgTS0GgjbS9OxC1R2PCjS+EPmTMGNuaaHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oA6K73nfykvOtmD5UuVxJjysiOEKUDy36w+LFCpwlT7ZH+072E9m7pljXCft0Q+PY
	 b8ZprVNF7jQZMeEbUAp/rzDsIZxyaqkMv9XqR12NtvTAMHb6oL6NGr7jAPvWhgxhfU
	 clHwgn6HGx6w9Dky+J0TKmBM2+asdS74YRJqwsS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 671/816] wifi: mac80211: bound pending OCB station allocations
Date: Wed, 25 Nov 2026 15:36:59 +0100
Message-ID: <20261125143904.710482113@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit ee1a5e92dba0a98cabe476c780e3af4f0ab88b27 upstream.

Delaying the OCB station worker while frames arrive from new peers can
retain an unbounded number of station allocations.

The receive-side limit counts installed stations, while new allocations
wait on incomplete_stations until process context inserts them. The list
lock does not cover the interval between allocation and list insertion.

Reserve one of 128 pending slots per interface before allocation. Release
the reservation on allocation failure, after the worker inserts or frees
the station, and when leave frees the pending list.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142302.16634-3-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ieee80211_i.h |    2 ++
 net/mac80211/ocb.c         |   13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -649,6 +649,7 @@ struct ieee80211_if_ibss {
  * @wrkq_flags: OCB deferred task action
  * @incomplete_lock: delayed STA insertion lock
  * @incomplete_stations: list of STAs waiting for delayed insertion
+ * @incomplete_sta_count: pending entries and reserved allocations
  * @joined: indication if the interface is connected to an OCB network
  */
 struct ieee80211_if_ocb {
@@ -657,6 +658,7 @@ struct ieee80211_if_ocb {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	bool joined;
 };
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -70,9 +70,18 @@ void ieee80211_ocb_rx_no_sta(struct ieee
 	band = chanctx_conf->def.chan->band;
 	rcu_read_unlock();
 
+	if (!atomic_add_unless(&ifocb->incomplete_sta_count, 1,
+			       IEEE80211_OCB_MAX_STA_ENTRIES)) {
+		net_info_ratelimited("%s: No room for a new OCB STA entry %pM\n",
+				     sdata->name, addr);
+		return;
+	}
+
 	sta = sta_info_alloc(sdata, addr, GFP_ATOMIC);
-	if (!sta)
+	if (!sta) {
+		atomic_dec(&ifocb->incomplete_sta_count);
 		return;
+	}
 
 	/* Add only mandatory rates for now */
 	sband = local->hw.wiphy->bands[band];
@@ -142,6 +151,7 @@ void ieee80211_ocb_work(struct ieee80211
 			ieee80211_ocb_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
@@ -225,6 +235,7 @@ int ieee80211_ocb_leave(struct ieee80211
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


