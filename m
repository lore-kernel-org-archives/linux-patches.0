Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213229;
	b=GvHJqvuF7ggGkbbgXWTgAAzO2RjnktS8OM4y4rQeOgE6zJW+EVdFYCbh5dyJSjd4L7s+
	 pTzwl9chHjYCx+TFRH1PMe+t8S0C6UgOqds4PB3kjE3TNNR9nGPcDDOLIfhSZPDcCekuB
	 2PCA2C+EobreA+qmbXZCg+oULa6f0U87/nL+yl2FHTfPBdvp6K/yXhONb0N2cJ9EOqbPu
	 iZL6UKbQs5GHOClssdqxGqmrbiZXxwdmE9C8RGs7vWgmtJUmIuu+WQuCMQyWo7FzH2b/Q
	 G1zcezDKhcgPSu+oT4vcNeKCXhP7wwGX622aH7wmejLO4Y+Q0ovFgq6Lx48XPK233Pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N6alm3d/Ut8FryBbKDV3oce+j0HILng//SD4KcDYK68=;
	b=El3W7fFua00WQXGfpQ7XVRSnOlieVyVAwNuphTrmzLn8OpAm3QwlfmcWOJFF6XCRA86K
	 Ag7yGUSb0YSMfs5OeMbdvjF0OklKfJsrrNkO3fglTjL1J3RliikX4CbUMEpKs/QUyoijy
	 5E4bYoZDb7mXHLcfA7qCEI7YwUcv0F0IKduJMTx4j+uiZdPHzqoghuR/e6cMz5dJJcnIG
	 uzPRdfA6jsFpsnRjbLRfF5NnhnGlxJyfh1H1EPUTKlBhjjeGLRBGf6RrMMLIDG5gLfofm
	 vVzd8UTpiT5dUuJJs82sGtuLXl3zkkJegqE3KexSS4VVjal5xy5Ejs+zoH6pwYVlpSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZbbw3P2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121B9606A31C;
	Wed, 28 Oct 2026 18:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gZbbw3P2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6357A1F01825;
	Wed, 28 Oct 2026 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213228;
	bh=N6alm3d/Ut8FryBbKDV3oce+j0HILng//SD4KcDYK68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gZbbw3P2ej6srSSNgE9yb5pRQ+auaNIOJV+xZ/jhdbCq4UHW99SaFjrAxhUQsn+Xg
	 2HDBGRUajdF5KRFjRtOArYUwjlJlSwkSXqm07zPRs06k4SqpBSh2z+Bk5fiJ7BWMYF
	 ySfOtrjxjEnuOsW+7tJRZzgK23yB3JJrfmj0zBM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0430/1887] ipv4: stop PMTU walk when nexthop group shrinks
Date: Wed, 28 Oct 2026 17:42:06 +0100
Message-ID: <20261028170509.017977910@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit 6619e01855e65ef35723685a557e3eb106f4ecf5 upstream.

Commit 7d3f3b4367f3 ("net: ipv4: Cache pmtu for all packet paths if
multipath enabled") made __ip_rt_update_pmtu() update every path.

For nexthop objects, fib_info_num_path() and fib_info_nhc()
independently load nh->nh_grp.  RCU protects each group's lifetime but
does not make the loads observe the same group.  If replacement shrinks
the group after the loop accepts an index, fib_info_nhc() returns NULL
and update_or_create_fnhe() dereferences it.

A deterministic probe only widened the existing window between the real
operations.  On v7.2, an RTM_NEWNEXTHOP replacement published a
one-member group after the PMTU reader accepted index 1 from a two-member
group, producing:

  KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
  RIP: update_or_create_fnhe+0x45/0x15b0

Stop when the indexed path is absent.  Groups are dense, so no later
index exists in that snapshot.  The same real-writer window completed
114,423 PMTU iterations without an oops with this check.  A reproducer
is available on request.

Replacement requires CAP_NET_ADMIN in the network namespace.  Where
unprivileged user namespaces are permitted, a local user can obtain it
in a new user and network namespace.

Fixes: 7d3f3b4367f3 ("net: ipv4: Cache pmtu for all packet paths if multipath enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/4fb87ed994dfc067178fc845cdd8bc9b5446b039.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/route.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -1089,6 +1089,8 @@ static void __ip_rt_update_pmtu(struct r
 
 			for (nhsel = 0; nhsel < fib_info_num_path(res.fi); nhsel++) {
 				nhc = fib_info_nhc(res.fi, nhsel);
+				if (!nhc)
+					break;
 				update_or_create_fnhe(nhc, fl4->daddr, 0, mtu, lock,
 						      jiffies + net->ipv4.ip_rt_mtu_expires);
 			}


