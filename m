Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831795;
	b=dZ6Nyy48clz2EUYuhv7byIPkL3pATSGAa9TFl38wY5WZ6aRwQGitzNQULqjirW7lJb9J
	 lrEhAqQ2i4xtfnRADg8LS5DDVyFafUpMavhrxrkFUZthNRDR6d/MLqnFn6FYQramm5T2l
	 XDkSkjQNyhPe+gZcaNJNkOfBQzTOxKUnp6R7dBrY1iUAuVqRefOjz57AARYemQHtFn5gO
	 eOcNcypDfLK4cujHWouJBsB+RdiyQVQif5xqwQiXIUL/X54WMiUl7vMR7A4/i9JdhiD8f
	 swrkkQHJamWYgGz2MMllkLUtCtUgEfleT/ZgrHqb2KGtK/qQZ00r8iJuW5VnXLFaLug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831795;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ciJgLqZaNzOG3LRO8J4rl31tP3V0mL9vRoZkfzUP7pg=;
	b=cEw/i+fZ1WIhL/z9FnhZjYunbgNgyR4OcQvUCBQEeVh+IxpWlsgt556r/v1Pwjy9FrQD
	 QkjLqoHokltHhT/5YbhOgcuqK4FXVc45ULRal/FyiYC34JiFOOKZ5AV+z4PJd7hznvrSd
	 2PXBLOIhPnjIdcj844Ae7M+59lU2L1Pq2zMxqkzPsw10nJ+VJ6tc+DmDcfaotZglR5b80
	 ewA7Kc+CIcKF4wNkz/YbJY0lehX+SNu7c1rv6F7wZmCcL77fbF976Bp97UOyaiTGyPwGM
	 qH7oZdV4qMZRmmAOQMwehFBPyX+NNoR7JCrddRWCOQhgxxafJuJoTHHG5R5uifTbs3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sOopkRjz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B10B606AC37;
	Wed,  4 Nov 2026 22:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sOopkRjz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCE01F000C1;
	Wed,  4 Nov 2026 22:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831794;
	bh=ciJgLqZaNzOG3LRO8J4rl31tP3V0mL9vRoZkfzUP7pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOopkRjzfUB4KXcMrQqMsy8PkFy0nSRCC7ngEqcjrSNF4DY/mGAutn2Azowzfa246
	 dKhjLeWF7J9FrxpnGt5Bio2L3UKOTBEBDa+FVIVAxKtEA0AECMFGdU//Rw1cINzhll
	 iqCOUrPyskoXJScWU2sRkVGmoIw7+ioJcuGU97eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.18 0916/1005] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Wed,  4 Nov 2026 16:10:49 -0500
Message-ID: <20261104211108.815195737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
@@ -537,6 +537,13 @@ static int unix_gid_parse(struct cache_d
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


