Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016159;
	b=Dmm/ws0it5YxHP+/6ZLcZvWEu5ncpq6EdAHWdybYmWpqShLSMs0LmL2D+Fe+OsA4/1pn
	 u7AU9hLSIQ3sDFnb1LJk4TxfoJrv3RFDMKle2SlqJAfGDLI28ZSb/74phvcXepallJKOb
	 mY/WvNwi5Bm7gD3r6fM6+Be2ZpevF3M0/R9D7jadNu4mafVYHPBmEO8yrSrehOUeyP7hR
	 12MDSETXLUmN75z3B1ORxS/YBwDLJMoVjj+gqJ+LnKi4S+yxmk13sKIPWJ5VOfaxhyXF1
	 KTgfr2X0xzVWuHhKfQ1x29fZK/HseAdxI85a3NNssKPy37OQFp9uNpJZ5ry96tRADAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016159;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v3tdc5cjGvUUhJS8sXbgGYM32x4+F8xXvaryawsjdzk=;
	b=hbsWZZ3Ck2pOuqDcdTaME6nbeKc0v8WmE5Gvv1hSU9JW7acuPnslCnX9xniQeA0j1Nwq
	 adq1+7Z4TMPSvaRcyLEix779BBoSfcqVyGgrTYovvja7b3ItaShQeyCZL/YNTQOuU0rM7
	 ugwWEb1Gwl5+KTtwuwbbFyLAIF8XLybc3eWCgrL+ChqMZr9n6hpxoZYDEm0EDQ/0R5uT7
	 qY3qQTM7bZIPxbJr/wnV5U4IVTciLd9LsMOVZxe522j47AV51upGsr89dXIwTxANu5rN4
	 E24qMe3VK1EyrG6+jAjhksGiOSCvWWvlEgVqr9vLkl5TaCLQPgNA2FnZ2V1IhM+YoPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpMZPJCr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8D1606A335;
	Wed, 18 Nov 2026 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DpMZPJCr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A321F000C4;
	Wed, 18 Nov 2026 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016159;
	bh=v3tdc5cjGvUUhJS8sXbgGYM32x4+F8xXvaryawsjdzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DpMZPJCrI5iZ7jammDCUUJ9J8oxPp59koa4qpOlvQfmyBnumTAqCEIsSoAiDjE1oh
	 /QKOdRnaCygzZVbQ4twiOW8dIQoYdA8eqC2gXjaB9vWXpznjzaezKzLWutLnhDP/Ol
	 /Jdy2gz5AusJfqtleZIPHrfpuseg7DMcO+i5JVJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0388/2651] sit: charge ip_tunnel_prl_entry allocations to memcg
Date: Wed, 18 Nov 2026 15:27:08 +0100
Message-ID: <20261118150301.801532474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 40a2b90f5190fcc7b083809fa93f2799abefeeb1 ]

ipip6_tunnel_add_prl() allocates struct ip_tunnel_prl_entry for each
potential router entry added via SIOCADDPRL.
An unprivileged user with CAP_NET_ADMIN in a user namespace can add
an unbounded number of entries, consuming uncharged kernel memory.

Commit 1b51d8271973 ("memcg: ipv6/sit: account and don't WARN on
ip_tunnel_prl structs allocation") added accounting to the temporary
buffer in ipip6_tunnel_get_prl(), but missed the entry allocations
in ipip6_tunnel_add_prl().

Use GFP_KERNEL_ACCOUNT when allocating struct ip_tunnel_prl_entry.

Fixes: 1b51d8271973 ("memcg: ipv6/sit: account and don't WARN on ip_tunnel_prl structs allocation")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Link: https://patch.msgid.link/20260907075846.2913645-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 4438b2472b287..9a2bbd76d3794 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -395,7 +395,7 @@ ipip6_tunnel_add_prl(struct ip_tunnel *t, struct ip_tunnel_prl *a, int chg)
 		goto out;
 	}
 
-	p = kzalloc_obj(struct ip_tunnel_prl_entry);
+	p = kzalloc_obj(struct ip_tunnel_prl_entry, GFP_KERNEL_ACCOUNT);
 	if (!p) {
 		err = -ENOBUFS;
 		goto out;
-- 
2.53.0



