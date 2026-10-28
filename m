Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213249;
	b=H1O5IcEBZh4NCcBm+uOYhSblrI/hCB0GeGCcXEVkKApWY9Rc2NeEARytfDUz8UnPA7tu
	 hNT1rd04XBWPArVrSy5T5+ML4EMmZh74HfQgbM8X/RJziSy3y0ew5UeaRigbn/i1PkA1P
	 h/YwmWy8IPyty/I3va/J3552u/hHRxIKNWunvyaSHcDLj1Ah8dKzKat8luL7P28KOXX1g
	 711uei87kdQJvAmQHKdeJoxsu5dcDJ+Rfes7FaPOCq1YID91CF74O3Jbc+ZL0BfSbmJJj
	 SpkoipJIGpsVbAvRUvWiW3vbmtrFzjj1sXGrEg69CKFthDdT5afqPZRbpXiOA0eE/nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pZt3dwfmG38ZKw+d3jVARLqN+07HRwf/Yr0raikKfr8=;
	b=yHH2A5+xOPXp9C1dIfgJvcyzxmMwpjLgQIpQAB/kRvF53sb6IuZy0/lFKF/7Bmvd/WkC
	 +qNVK5tb+99tjPmM11HBcrhyxKVG1ogSblAXFMm+/okefjrrI4VIHsDV0j+zuxntiUCyY
	 O0Fx/wOMwtggW8z/UDOTgzjoZqErh78WhSUA1qcuSRgEfDhrKU1mKlNcpr96qcLgazEqC
	 SQCI+ZJUzv+Y/mGWR4GjEVLYQauADlHiFFNxZqI0TuQOmmtsxcYrNms7/DbBj2cagnbYB
	 u1G4+mis2EeuaHtkSitEpdEqT2xPq28eYsB/U6ssUt45omIjOBb9T8LYH85+PEDxXag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwF9Byko;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD2F606A324;
	Wed, 28 Oct 2026 18:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dwF9Byko
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3943A1F01828;
	Wed, 28 Oct 2026 18:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213248;
	bh=pZt3dwfmG38ZKw+d3jVARLqN+07HRwf/Yr0raikKfr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwF9BykokIZSoetaF/d6Hwy1i1smtMdCwCMhFEbkJYRlSeIYFp7LNyDxx1pGfRGNC
	 AghTjR5Qm+AUnuQjjaFMtFyuSVRHOJokFPKlbr92738R4+ghsvg7+7wBTug75Ups4y
	 pCOnXu3CqqB1nCjKxRbr1roBXUU3G6IlwHs9fAE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0395/1887] wifi: mac80211: keep fallback association elements alive
Date: Wed, 28 Oct 2026 17:41:31 +0100
Message-ID: <20261028170508.222953957@linuxfoundation.org>
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

[ Upstream commit a10a2f80476d166fd81c361ec0319493671b694e ]

Associating to a non-transmitted MBSSID profile reads freed memory while
determining the operating channel and applying HT capabilities.

When an association response omits WMM, HT, or VHT information,
ieee80211_assoc_config_link() parses the cached BSS IEs and copies the
missing element pointers out of that fallback parse. For a
non-transmitted MBSSID profile those pointers refer to merged-profile
storage owned by the parse object, and the fallback block frees that
object at its end. The copied pointers are used afterwards to determine
the operating channel, configure bandwidth, and apply HT capabilities.

Keep the fallback parse result alive until association setup finishes.

Fixes: 5023b14cf4df ("mac80211: support profile split between elements")
Cc: stable@kernel.org
Assisted-by: LLM sparse kasan
[reorder variable declaration]
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: adjusted context for the existing conn_flags-based VHT check ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 32f24dca40ab5..56120762c7fbf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4023,6 +4023,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
 	bool is_s1g = cbss->channel->band == NL80211_BAND_S1GHZ;
 	const struct cfg80211_bss_ies *bss_ies = NULL;
+	struct ieee802_11_elems *bss_elems = NULL;
 	struct ieee80211_supported_band *sband;
 	struct ieee802_11_elems *elems;
 	u16 capab_info;
@@ -4059,7 +4060,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	     (!(link->u.mgd.conn_flags & IEEE80211_CONN_DISABLE_VHT) &&
 	      (!elems->vht_cap_elem || !elems->vht_operation)))) {
 		const struct cfg80211_bss_ies *ies;
-		struct ieee802_11_elems *bss_elems;
 
 		rcu_read_lock();
 		ies = rcu_dereference(cbss->ies);
@@ -4115,8 +4115,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 			sdata_info(sdata,
 				   "AP bug: VHT operation missing from AssocResp\n");
 		}
-
-		kfree(bss_elems);
 	}
 
 	/*
@@ -4343,6 +4341,7 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	ret = true;
 out:
 	kfree(elems);
+	kfree(bss_elems);
 	kfree(bss_ies);
 	return ret;
 }
-- 
2.53.0



