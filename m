Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057930;
	b=Env4W+rZCZj1M1z2LlHkgYnZvbA29XPuVyZ+bXgGEMq/vGmdelx7ENBlOM8eA9O+98ky
	 3GgvSpnQUw2oL8zHmwZJCh9F+0sCSIBV7i9B3b14RLC5kjUdUW1SWiYPHkYX/TV1V/XXj
	 FH6uWY0yQY6TFsTTq+IsiPYiTHE1rarFG3MfnIQIgNEjH2JaBjiQvS/TJOKnhFCq6jzyI
	 VPAI7ruIaYBH/OUT68OcGMTLHzS4P18z+tS3lCj0ABypuNFJ6I9tCIpBxdNh4A3nXDhjU
	 tucFZm6V8fZIUAMszCvC6jSNl3/dpeWxTfLsj469VlCdSTMHAmUnhxobri2+tTo5ynw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yhHLDUCzTSMubxnxkD2CLMnywnpXjMeB2z9vC7dY65c=;
	b=x7hbo2B8IGBoPqUVXeuysCUIVlkx6xbfPLdi/KbN773MVSLmfOOhd2SO2TwW18R/m1rB
	 21F5P87rtf8Kw4LBPIxt8aUxXau/T2Q4+31QrmlwdvLDmxkIfULToPe77wfEbYs/ViR8b
	 cZNk6c+MlEPtbl6D+RhCjspQDVBIDskVjByxziKlZuu/i4PCAc33hk1QE0/hWoSiUTAov
	 JtgWLrEuuuMrWiFTnxU9wgrRMsr/ZfZJ5DMrLGarWMswknLH+0d3qOFckd7Fq1y0i4oK/
	 EliSLp2IdZOtEs5Ph+iYNtkF7na15f8S/i1uq1rQpR8ZyK/MpJQ38inbK01MKy3OVtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WT+M3JEr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42C8606A32A;
	Thu, 19 Nov 2026 03:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WT+M3JEr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E841F000C4;
	Thu, 19 Nov 2026 03:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057930;
	bh=yhHLDUCzTSMubxnxkD2CLMnywnpXjMeB2z9vC7dY65c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WT+M3JEr5Nf/8vab+Lct0ze/5bI0tIx9v8bAWa3hiWpzs7URL8FR/gPuNnUKq3mdO
	 5adjTDR5ifoR5MjsJoCnL6Y7j41lqDCKtsRNtZMa7PGmwX9IrEMT50PshD7ZwsCRS7
	 aqxEfvYx0N33wAe7mq2mbxmitMjJZDETamEDcmGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 5.10 0303/1848] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Wed, 18 Nov 2026 15:39:01 +0100
Message-ID: <20261118145924.849345230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Ameer Hamza <ameer.hamza@truenas.com>

commit a12cc0930235b86b934ade7c077a1935c2ac333d upstream.

When rpc.mountd cannot resolve a uid (getpwuid() or getgrouplist()
failure, e.g. while winbind or sssd is briefly unreachable), it
answers the auth.unix.gid upcall with zero groups. unix_gid_parse()
installs that as a valid positive entry, and svcauth_unix_set_client()
then replaces the credential's group list with the empty one on
every request, RPCSEC_GSS included via svcauth_gss_set_client().
One failed lookup strips that uid of all supplementary groups on
every export for up to mountd's configured TTL (30 minutes by
default), long after the NSS backend has recovered.

mountd cannot send an empty list for a successful lookup, since
getgrouplist(3) always includes at least the user's primary group,
so a zero-group reply can only mean the lookup failed. Record it as
a negative entry: unix_gid_find() then returns -ENOENT and
svcauth_unix_set_client() keeps the groups the RPC credential
already carries. This is the fallback that
commit 3fc605a2aa38 ("[PATCH] knfsd: allow the server to provide a
gid list when using AUTH_UNIX authentication") promised when no
answer is available, and the same state try_to_negate_entry()
already creates when no listener holds the channel open.

Fixes: 3fc605a2aa38 ("[PATCH] knfsd: allow the server to provide a gid list when using AUTH_UNIX authentication")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-fable-5
Signed-off-by: Ameer Hamza <ameer.hamza@truenas.com>
Link: https://patch.msgid.link/20260814221953.108837-2-ameer.hamza@truenas.com
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcauth_unix.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -544,6 +544,13 @@ static int unix_gid_parse(struct cache_d
 	if (ugp) {
 		struct cache_head *ch;
 		ug.h.flags = 0;
+		/*
+		 * mountd sends at least the user's primary group on
+		 * success, so an empty list can only mean the lookup
+		 * failed. Keep the credential's own groups instead.
+		 */
+		if (gids == 0)
+			set_bit(CACHE_NEGATIVE, &ug.h.flags);
 		ug.h.expiry_time = expiry;
 		ch = sunrpc_cache_update(cd,
 					 &ug.h, &ugp->h,


