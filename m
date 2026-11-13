Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590828;
	b=VFfyRt4TQsezL4Gj5GNbV4PMUrqZtdKKzf/WsRDWlJe35R24qe8X6HV3m+9Z/1+QOt+d
	 aZJNwabep1Y7+9pU7mzvW47nOT2Aef8ODnAEe3BDqKriItzW2UP2IWHjo2PNKvKpRDkvO
	 64CcKpcFmXpW/Cgp7YZUeucGfRUc0TrXPQFm3SGQJGRvDYXCZrUZPoN/Vxefze5x1S30V
	 A1UVLuvCkG3EJalTmmDU1MO2/d2Gb4sZ+OzDrCwyu/6fx28TLNFCoRgqQRpAu4SNNqEsP
	 BEEgmaTLkeOFDLS3NZ4jx/DJWkVOgyza6o+/JIoDgmtbrThd0jFufklN4HEO37/NdgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TQbMVO3zHvzeTevDy2rlXIjRjvpbtdyLaVKEFCbWiww=;
	b=ZSdLIAmTxrg6iQlN6zJ9WpN9kQJfkoa8z4yHaYkyMK+3u66Zgvif/U+8xfp2ykmlSD5G
	 XUDfkUaP+GmI/oPnkg2vYEP0VE5QDz4GT2EeEhcjSf4ccHZPFReI6M4W395SlUJFS6eq3
	 s/3WtFZpqng0CZqPSuHQvE4JY1G0IV1qFyo8mMu4eZNOcWtCGaeRXIGttdR9MvNbIBk0B
	 /dculPoL81ErgBHbbMWPFUlPkeVNQ6Rtbvn25XqUPHA5sxmnllfoRlC9XnFnMPLJrcU48
	 lZovIx+SSUJifXbynX3DxQeaTJO0mNmed2tAwBJbeJxVyDmE050ZZfDhTEbCDIiuflw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0jlFfO8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782A2607E06D;
	Fri, 13 Nov 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A0jlFfO8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 246D41F000C5;
	Fri, 13 Nov 2026 17:27:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590828;
	bh=TQbMVO3zHvzeTevDy2rlXIjRjvpbtdyLaVKEFCbWiww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0jlFfO8EUiSvWxSCbctqrJjcfFFBw7vIYls5q7Tl9e+0uAbYYCLiCW0aJsCBF9RH
	 F3xdUJ0Q45sQ24ByfvrYmfPtSrkCFStjnWvrDPwgVB9YPFI+2De0yagFIdA7mrV/Ip
	 RN95S+aqEUqEUNOc7gxWv+1/mff8u5IA3dhIQRDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/670] NFSD: Send a meaningful CB_RECALL_ANY keep count
Date: Fri, 13 Nov 2026 10:43:17 -0500
Message-ID: <20261113153812.280588408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 9af39c0773ef956039e1ebe9c235532fe6ee1e50 ]

deleg_reaper() sets craa_objects_to_keep to zero on every
CB_RECALL_ANY. RFC 8881 Section 20.6.3 defines that field as the
number of objects the client may keep, leaving the client to choose
which of the excess to return, because the server cannot read lack
of recent use as lack of usefulness. Zero asks for every delegation
the client holds, including the ones backing files an application
still has open.

There is also no reason NFSD has to reclaim the entire delegation
working set on the first sign of memory pressure.

Derive the keep count from cl_deleg_count so that each callback
asks for one delegation. Both the shrinker and the laundromat re-arm
while their condition lasts, so a client with more to give is asked
again on the next pass.

The Linux client ignores craa_objects_to_keep and returns unused
delegations selected from the type mask alone, so the count changes
nothing for it.

Fixes: 44df6f439a17 ("NFSD: add delegation reaper to react to low memory condition")
Cc: stable@vger.kernel.org
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260817-recall-any-keep-count-v5-4-3b2cffce701e@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 43755bce08f95..c79b7ad28f3c4 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -7006,6 +7006,7 @@ deleg_reaper(struct nfsd_net *nn)
 {
 	struct list_head *pos, *next;
 	struct nfs4_client *clp;
+	unsigned int count;
 
 	spin_lock(&nn->client_lock);
 	list_for_each_safe(pos, next, &nn->client_lru) {
@@ -7015,21 +7016,33 @@ deleg_reaper(struct nfsd_net *nn)
 			continue;
 		if (clp->cl_state != NFSD4_ACTIVE)
 			continue;
-		if (list_empty(&clp->cl_delegations))
-			continue;
 		if (atomic_read(&clp->cl_delegs_in_recall))
 			continue;
 		if (ktime_get_boottime_seconds() - clp->cl_ra_time < 5)
 			continue;
 		if (clp->cl_cb_state != NFSD4_CB_UP)
 			continue;
+		/*
+		 * This read races with hash_delegation_locked() and
+		 * unhash_delegation_locked() on other CPUs. A stale
+		 * count only skews the keep value; the next
+		 * laundromat pass sees a more current one.
+		 */
+		count = data_race(READ_ONCE(clp->cl_deleg_count));
+		if (!count)
+			continue;
 		if (test_and_set_bit(NFSD4_CALLBACK_RUNNING, &clp->cl_ra->ra_cb.cb_flags))
 			continue;
 
 		/* release in nfsd4_cb_recall_any_release */
 		kref_get(&clp->cl_nfsdfs.cl_ref);
 		clp->cl_ra_time = ktime_get_boottime_seconds();
-		clp->cl_ra->ra_keep = 0;
+		/*
+		 * Ask for a single delegation. Recalling one before it
+		 * is needed costs the client an OPEN when it next
+		 * touches the file.
+		 */
+		clp->cl_ra->ra_keep = count - 1;
 		clp->cl_ra->ra_bmval[0] = BIT(RCA4_TYPE_MASK_RDATA_DLG) |
 						BIT(RCA4_TYPE_MASK_WDATA_DLG);
 		trace_nfsd_cb_recall_any(clp->cl_ra);
-- 
2.53.0



