Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049411;
	b=12rnFXteYe77lPr5uzJtP0qNuONXHQ0PyWm9bJmpJLvDLgngVH+aID6V6zXC3TS86F+v
	 0x5rvBMrZ7fgbPzB4q04tHQTs3rxXaav9DCidT5VEfqb73KYHNmng/W/xxhEh5JzirFno
	 hBv8Wa3ppNukTSrnI4uNrMDvUgYTD/ZfCqnMmKAXB+SdkMUJs1xlEP1trCRTLBxEm7fls
	 gZaSivzFfVb0lg2iyej1iZblJJ+uBXI4fsLO8A3h2V2goe/Pti3jBUu8/m3+bRWc4TsXk
	 Kf62qkk1OAmtIWPJ46tncgoY97BxWMepH4gYrxYuR6QaVS6SgLBY9XD+PItQLPj+YyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049411;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QCzC+Rnr27giLxfOA5KXGNzC0pupnn+ju+87OswN8Ho=;
	b=r0fwDSXBY9YUqotQp9mxCVJ5UureOUpXCPycTtY9mrGiVRkiglcMgKMfilUB5pAoND9l
	 Ob1zHn4zrug9FczfxuGU6OSB4T8PJIP/F3K7dRJ9hx/uSHdmOsLamGGHMKUvvBuAxx7NV
	 ld2RyBCqzGVwJm9x4Z6/VVELP/sy5wOM6Z2U0pvOB5SDMGmhg8qfq7Vasdt0GUV0rF18h
	 MClyiX3gJEqoQl2SppdgoQVOfZrWBb64VFCZNz6dgL+A+VPqI9J+W0VAgEvJ88gyMR1Pd
	 HGrqHU97YdcLgZuaTwAEx7vEU3FvSoZ2TpRNMjDHbu16WyGWvSohZET1eWOjp3zZsLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ja3XHQFn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F04606A31C;
	Thu, 19 Nov 2026 00:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ja3XHQFn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0321F000C5;
	Thu, 19 Nov 2026 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049411;
	bh=QCzC+Rnr27giLxfOA5KXGNzC0pupnn+ju+87OswN8Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ja3XHQFnLuqD8bNuW6kM1sWJMixp1sH3vR5m4NtFBjA8yrnWaXwYVBPJnn+/zc3Sb
	 jHPcePTZsT72MQf4IKrYcFkClTV6spsB7FeXgCIrrMZi9cWkNOIotTrA7iO3DGPbt4
	 v+QnWc2qko4Yw4SeaQfcgV2RTQEdXGIrnAyO2QCk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2342/2857] wifi: mac80211: mesh: use hlist_add_head_rcu()
Date: Wed, 18 Nov 2026 15:56:16 +0100
Message-ID: <20261118150325.858327283@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 2ce8b78102e91c9d6536630cdef96491121c84d3 ]

The mesh paths walk list used under RCU, so we must use
hlist_add_head_rcu() to publish an entry. Fix one place
that didn't do that.

Assisted-by: LLM
Fixes: b4c3fbe63601 ("mac80211: Use linked list instead of rhashtable walk for mesh tables")
Link: https://patch.msgid.link/20261005224950.e0db543145e1.Ieaf30d3546e8ff63ccf400f6fb26e027c218721f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mesh_pathtbl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_pathtbl.c b/net/mac80211/mesh_pathtbl.c
index a5ea7bc2065b9..bdbe2f9b83b7b 100644
--- a/net/mac80211/mesh_pathtbl.c
+++ b/net/mac80211/mesh_pathtbl.c
@@ -419,7 +419,7 @@ struct mesh_path *mesh_path_add(struct ieee80211_sub_if_data *sdata,
 						  &new_mpath->rhash,
 						  mesh_rht_params);
 	if (!mpath)
-		hlist_add_head(&new_mpath->walk_list, &tbl->walk_head);
+		hlist_add_head_rcu(&new_mpath->walk_list, &tbl->walk_head);
 	spin_unlock_bh(&tbl->walk_lock);
 
 	if (mpath) {
-- 
2.53.0



