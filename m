Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035446;
	b=EPwsx2puZg8i7ig2fSSO7D22DDoYYuzA1cRzdS90MTIxLFG7fmJmcg9Ka8WofWh7BkXb
	 pfG43WT04C6gANgj750IXApCFG7WSShF8z+snMSqPm/+gyHK9pQs1UzaRnUghH6elr11E
	 mUDAAf2tvNLj89UT1iuhaACxvbsIcVABtoGRHDBMlLuL6wSiNnHWWAB98eSr9jQ/JlRZK
	 oG8EANI4+5ciFbJYKUUIjoHCSiHHnKZYtmi6D0BtMiyClYvE6iFE7f1ytvm7/FZOcfUHM
	 GSDWrDkNVJ0XuZxAhE/La/C25gSRNGDScqt1YbKvyZ1ejG7hhrNXli8Rge5ZPD5+yWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4r8XKS95Z5FNLQnj0OHTJ57A94RwnCJm/+3CBFt2MoA=;
	b=VjoDu1Hrj4qbZumRUO4awhkWk2XMBF9CQVdx0BB9OzZbDlkKGjWuIKlIRYZxaI/A3uit
	 2/zFrSUC8LJxxyM00wIVVQN7ajDFTrNgpAQIeGi+nzJWWN7GxQzIX707Mh3qb7sHwcehk
	 lslP/rJQg20IFFZyw42mut+GxBNmFy6btE6NA8qdmRpeUG7n/V6KrhzWqg4mPx5i0nFk+
	 H4PBynmUsoXuM0mCyPd8eo93tlScASDISD/7NW7RqBrRLlh6N01B3xs3MyyVWp9khDDpo
	 gPyVSEqjMP+MVnOgwisV1Qigc09kv66U+zgQ34sGgx6EJ7EiM/xoEekWCdCMHWPc2HQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIAqQXqA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312A0606A31C;
	Wed, 18 Nov 2026 20:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIAqQXqA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834A21F000C4;
	Wed, 18 Nov 2026 20:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035446;
	bh=4r8XKS95Z5FNLQnj0OHTJ57A94RwnCJm/+3CBFt2MoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIAqQXqAWJHR4JSdZXwWXLGfTY0EkRjVgZp9dLB5T9PJb0bSn3R71fGLtc7Pgh53s
	 JmyH3DH3gvkTP37BAMoir4O1pTvA8rt95/i3IU1n9n8Dv7zlpkFowgA9aKRZ2MKKlM
	 pHhJiGhes+lKdZIxghtIezvTzZWRcj1Bz3TJ6ak8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ameer Hamza <ameer.hamza@truenas.com>,
	Chuck Lever <cel@kernel.org>
Subject: [PATCH 6.6 0708/3318] sunrpc: treat empty auth.unix.gid replies as negative entries
Date: Wed, 18 Nov 2026 15:22:10 +0100
Message-ID: <20261118150339.652568345@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


