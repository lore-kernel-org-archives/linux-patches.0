Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059785;
	b=g6/Z0IkEWzA+jbNcfRWZGb2txPp9fnYYjVHoGNkPgNtWvAGfOH3I9pdG33Y3mACayfVx
	 giqbc/z7cWQU+ISpTxBu+io+cZWk8Kbmq30sISJ2FiRZMUeJ4MsVM99VFJzmUgD0vlybC
	 7ZSfH0gvPqWbHZGUr5NMGWelTkbpUE2raCRv2SdU2/1u8sonVw/7MFCcTWj/sOf8TNqno
	 indVFIyrqb9dpiUKAj4rwoF8bJiub9sM1zU6aHxq/Xkvs95MbkSnKHX/BHG7AYrWo4ScA
	 xcK+ezg/zpWKVdM3kPrVY5YVd4bma1eJgtUQsz0Q3SyPkPwJopKf+e4Z/Y5YndywWJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WOxv79PJ3Q5t5tcM9U9FOXxRH4PgmTvMcW/0YHYFy2U=;
	b=paWQ/rCr/QtCeh1/bhTO7DQvOI3pPTLdsPw8t0CCs2l/GlomB9uukEMTUyZf2RF+TUCh
	 1paxQxrGUCBe+gdY1H6lv81HKp+tab95OQc/OJ6JkpM9YKiD9eWzC/Gh5rvesF2rdOeOI
	 tORsZJyg3MnidQqIFdax56ZgUAWcC7IdrqZtp/PuiCsfILlGoNxQh8DuMDHcfMmd3Cp2D
	 EMo9hq6NMLcUTPOO99oc+godIiP7TiGWj7OuNvFyU9/p/2vOvSgkoARAGZ5vbhdsbWiTx
	 iwKdRD70eqvkJB3WBfblTZY/fL1Ar1YHuwd2lDUUfYe2qjbq6s3y4xLkIim19yJkXtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juFm1Oxs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE7D606A320;
	Thu, 19 Nov 2026 03:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=juFm1Oxs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 104001F000C5;
	Thu, 19 Nov 2026 03:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059785;
	bh=WOxv79PJ3Q5t5tcM9U9FOXxRH4PgmTvMcW/0YHYFy2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juFm1OxsEguETLs0PtnQC4Pci2m5eOGDUmPvBL0NIamXmafLwMucv6eFdwQ5DTkJZ
	 DQTjJ96OmIbPhwqE/HKtWhPQadNx7apHIwDX4CLj9C/Uk03MOlrtxyUgDJ9LYqfR0U
	 TbHf29CLQ0l6ZOvz7Py4Oo25zd47Wltzh9xozsgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0965/1848] ip6mr: ip6mr_sk_done() can exit early in common cases
Date: Wed, 18 Nov 2026 15:50:03 +0100
Message-ID: <20261118145957.357059737@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f2f2325ec79970807012dfc9e716cdbb02d9b574 ]

In many cases, ip6mr_sk_done() is called while no ipmr socket
has been registered.

This removes 4 rtnl acquisitions per netns dismantle,
with following callers:

igmp6_net_exit(), tcpv6_net_exit(), ndisc_net_exit()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 6ace56ed7b13 ("ipv6: remove ifaddr from hash during ifdown list cleanup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6mr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index d5d027d77f2fa..555f806b10cb0 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -1581,6 +1581,9 @@ int ip6mr_sk_done(struct sock *sk)
 	    inet_sk(sk)->inet_num != IPPROTO_ICMPV6)
 		return err;
 
+	if (!atomic_read(&net->ipv6.devconf_all->mc_forwarding))
+		return err;
+
 	rtnl_lock();
 	ip6mr_for_each_table(mrt, net) {
 		if (sk == rtnl_dereference(mrt->mroute_sk)) {
-- 
2.53.0



