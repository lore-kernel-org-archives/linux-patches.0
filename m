Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704775;
	b=D+QW1r0PpwPhfzhFGyibz9FH5HRnNNdLLRluiQr7TPWW4v0r63qay9dFLfrAO2cBHUVa
	 bTfrvZhq1B5bgasFsaMfG4qRUH8/GxN+cuUhg9oU745wUtbGgOcF0R+rMQ2uKoBRR2snm
	 g0bkUyVIjmCnSt940jcOspPaH8XEzRFcnMLeMpmvMAaZN/ANK+8HZwHNyE7n8NyGzJJWN
	 cpMB+siQSUzBJhGVz5JpLkD2wXkDSPf+QH3QjRzwJyU8DPlAqsKS9JVHfn93WSjM/W0O+
	 lOuG0iNV54qQAYhW+3GEuMBIArpCn+JLDLkN2NCy+qI3dUS27MoEqTqCeKXL1o3jdhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704775;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8CagHgH5MTXzMI/jtqbpjBDf9i2U7eD3Fv3CMJJBuI8=;
	b=iaxF5fddKbiHINl+69te/dEeDaY72GDqO5ft5nl2Cd6Dp+2snJU+afV779xA/fRFZXLV
	 5B1YOvMi0GnybWQSBopPU0r6v+5CDbywDdtX6gs4ezowyTCAeOSNafxE3hL1w3XQYxIvW
	 uZqluULzVUtl5SHPwKWmxtkGkPN/ZteLL/n2CMiGqwkIuWYIQ3RykqEa0HojcXkbYncxI
	 5RH/yn1W5wXChGiUWvtzmI6NPRJRlnsZo0hc8kIQ9sITHW2VLIIcJdGsk4YZku6Hil+kB
	 phJsRi0kOtqtbpUH14wsANFlorJH5bwiuoxrd57Nrn8nLpBXAOnbMDv3W/8KvlgaIag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTOYtX4R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C03C606A323;
	Thu, 26 Nov 2026 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YTOYtX4R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A668A1F000D4;
	Thu, 26 Nov 2026 14:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704775;
	bh=8CagHgH5MTXzMI/jtqbpjBDf9i2U7eD3Fv3CMJJBuI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTOYtX4RONrfDUSOk7eBsPFozccCTUN4cTcAy3x0vUyelcvZ/5RohNxu8iC8FWZiN
	 1DTZ98lb0wbOk5W60yPZ90lMwRvqXtvUHh/4e047QH5qG8EItp9Lle0OrVbVtjT1wI
	 IThinmQzyOp9NXr/qV59VvpFddCLwi5DdpLA6iT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 195/265] wifi: mac80211: bound pending OCB station allocations
Date: Thu, 26 Nov 2026 15:38:45 +0100
Message-ID: <20261126143618.827686674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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
@@ -607,6 +607,7 @@ struct ieee80211_if_ibss {
  * @wrkq_flags: OCB deferred task action
  * @incomplete_lock: delayed STA insertion lock
  * @incomplete_stations: list of STAs waiting for delayed insertion
+ * @incomplete_sta_count: pending entries and reserved allocations
  * @joined: indication if the interface is connected to an OCB network
  */
 struct ieee80211_if_ocb {
@@ -615,6 +616,7 @@ struct ieee80211_if_ocb {
 
 	spinlock_t incomplete_lock;
 	struct list_head incomplete_stations;
+	atomic_t incomplete_sta_count;
 
 	bool joined;
 };
--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -71,9 +71,18 @@ void ieee80211_ocb_rx_no_sta(struct ieee
 	scan_width = cfg80211_chandef_to_scan_width(&chanctx_conf->def);
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
@@ -144,6 +153,7 @@ void ieee80211_ocb_work(struct ieee80211
 			ieee80211_ocb_finish_sta(sta);
 			rcu_read_unlock();
 		}
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);
@@ -226,6 +236,7 @@ int ieee80211_ocb_leave(struct ieee80211
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
 		sta_info_free(local, sta);
+		atomic_dec(&ifocb->incomplete_sta_count);
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


