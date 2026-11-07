Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061797;
	b=a7f1ug6Rullwa4n8pVr6vIYqmPpZusaCGLIxUVjf+40wMRy1JkrDdCMbqxnpHwMeZek4
	 L49F8cZlb4yyv4BZjv2oMMGO6PD0a/u1NHsqB1k5hxQkozHjf2lTvCZgXY1GEpgefNWLY
	 4KTR6/l/9iVAJVz1s1FXOAjku8xChFjOZjY2G4rfWs76V/VKkBo6NnIEOVuZ7X52B6jRZ
	 4OlqZY/5UIQaG1cemO8vm1TxTHmxb2tjaazJgbbQ7nGu1NSBFd8e+OaWk8brm82ZLjw1l
	 AH720lqfQbj1VUoFYn+NuoZSUCYRx1qtNsOzRoZpIsLJtlabveDeJ0NDq/Sb/f66/HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KUa7puAtYviN+BgpEQpPYZ4lTKnzFIO4wwV4toTegIo=;
	b=d+JdCTwpmdUDzrO8y0Y5WVBD42caMjw33RlUNKJfRlAMmHhB83paMwXLgFh05GyY+hLy
	 j7vj1GziU8eT+6cjSLcpB8R+RI8A3HneAsGD39pq0O6TzilcXs0cI3zg5mF0zKAeO3Mrn
	 /e37YEbur4jm3jPtq40iuBF4yJZh658fAGdeys7bJIhw8EICUFmPub4Un4PElpDUUe6kO
	 /T166YCI2Ix8fay4E+5kyC+4PwWL7tfUaK9SfqKJawrNl+65Mnh8oMyBsGfYE0F/jAjW7
	 60Nhoza7gAf7jYeBMIFtHB7mvmpprW5e0e4hVGrrYY4jo0grphYvJzGjVP+hjJsjxUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SydqczD/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AF1606A332;
	Sat,  7 Nov 2026 14:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SydqczD/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A5A1F0089F;
	Sat,  7 Nov 2026 14:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061797;
	bh=KUa7puAtYviN+BgpEQpPYZ4lTKnzFIO4wwV4toTegIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SydqczD/bYYG35ESdpHuMy3noRWFzbWqKhF5r5pSnkiP6PGC9+dftO2EB39teZ663
	 EoDzrxoUZ8NdaQ5DiP3k3wCwJ2rE0p8+Xq1ZS5b9ijeDUR41wxN6EuGkdBonc05H64
	 OfN4RYoxrhEPZ08GShAtSm1QNQnSgjeKqipEsiso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.12 0788/1536] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Sat,  7 Nov 2026 08:46:44 -0500
Message-ID: <20261107135019.672426009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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


