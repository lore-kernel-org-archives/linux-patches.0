Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620089;
	b=CGwuCIufX7JN2S4fFzxMn40875Tc/KyxsA3J6zuK4+J7FNrNYXzV/jl81MibRa28qFI+
	 wbIazP6yRT62Juuo94++tRVu2kGvf29JG9a81VygpVRR67IpKcvbPjfHVR0EoTMyY297t
	 9bxImvAAsMLa0S6DcomMJaCj9Txb+uPwPjSf13SzhxiuvpGs4iaVzO97XPEsmdqviPGAt
	 /REYkWi2MRvWn9rsMBcODWS2pHvisf6iajwELaxZcw10DEezu3cFTKqkMxmF2gwmhQj7y
	 SL2Vu24vWyOZIYszNuY10l0QR81hxqMfCL5bK1QYVbEEdzh8oH2ZyVJCEm+lRSJoYTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620089;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RV9h6GC9GCpZ9MYdAxuh1XpTPerBSXri6+QpqSjGpDY=;
	b=GcfI5AK58et0ugKPhsaJqbB7fOAYgvurJGteS5uTe66q/FX1C9vjDoaiI9pk5KzEfqW/
	 taw11aUzFFQgLyUHnL8wJif+ueF+ymZouu6m8l6KRUE/X39jxa0YvxfOlUAkSDzAZi+1F
	 rWIAB0QlwqOiN1bzWgNmWoUNpj/zZYw7qwlqvCRXuZEyI3viVQqoT4QDUPvqBy/CBUzSk
	 ULIufqq3Ocz+BN6aTm71QMxkW+iaY+aZl/HPXt4a1UCr40MGEaYdIZYeqvlrtN24TmPa0
	 qr8EpliR4rtE0szACELS1yQMPcEjt4OJVTXjsqhcSmQjS+OjNOqZa1jbWYi5lvAQ67g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt4ra3Mj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2005606A321;
	Wed, 25 Nov 2026 15:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qt4ra3Mj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D501F000C0;
	Wed, 25 Nov 2026 15:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620089;
	bh=RV9h6GC9GCpZ9MYdAxuh1XpTPerBSXri6+QpqSjGpDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qt4ra3MjSAx6dyFkywPBfYq8qC+YV2OhHjtE7wojAuOe/g3MBdOrE2jb24DDhvfGD
	 77DaB24mkBG4kcMscq4BSmC5RI2yg0Afz4xDLUlItfaAX1cpBsFEQml99iU70CNKii
	 D5WNOsGdZzM90ofjrcFBTwJ3HU1Dp67jy/FFGNvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0806/1005] wifi: mac80211: bound pending IBSS station allocations
Date: Wed, 25 Nov 2026 15:35:44 +0100
Message-ID: <20261125143840.611908989@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
@@ -684,6 +684,7 @@ static void ieee80211_ibss_disconnect(st
 		spin_unlock_bh(&ifibss->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
@@ -1177,9 +1178,18 @@ void ieee80211_ibss_rx_no_sta(struct iee
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
@@ -1636,6 +1646,7 @@ void ieee80211_ibss_work(struct ieee8021
 			ieee80211_ibss_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifibss->incomplete_sta_count);
 		spin_lock_bh(&ifibss->incomplete_lock);
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -682,6 +682,7 @@ struct ieee80211_if_ibss {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	enum {
 		IEEE80211_IBSS_MLME_SEARCH,


