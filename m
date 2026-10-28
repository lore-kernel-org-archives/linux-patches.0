Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210216;
	b=MWR5pP5kLbiCs7yzAciR36mdTSosxTAzS7R+KxtpHO8i0jkxFC/4AumOBJ1Bvt1iTDsG
	 3HNS4HZvJooWopKxREKkmKUX6RTMx1mH8fpHrPuXMFXJFyI3USc7SJYkB8BkFNpzTswvu
	 4lxvgxuIkqpDHNFlg4CJ8Xx5Ex+O2YS82ScY9Qtg8h/38fOp7a8kEvTq79HpqaaGFRBwO
	 OYKwKbbkk0PbS8F4zZHEVWy7dS651TE6Nf0KBzKTbD1xu3PDLRZcW8TU7hiCXVh6yWq/r
	 cgbq5uSOijHeHsfh+EF3qdWhTCDfZbtYAWAzUb1c3hpBDoc+eWYl/OiR77Jv+Q1Gsvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X4vrTPy2mE4eIJlzQXpbe9SJscsumlnInZUPWA8x+do=;
	b=lWglvozVwS6lDpQBmHhzrpktGkSmA5sE0N9N67ihlcqs1kCeIsqRqaBqqXi+qexdAjaJ
	 xTYE+QXsHost5URPGFn7biL+MGVd8EVS0JQK2LEGQfU/mMnMzXYDT2htXPpQzcYVV5z5L
	 m76JPP00Ad7uRO1Z4Ok5QYiQKLXNiuKGb2hO0UzQucZ19OMuuO2q4j5cPzc9sWmUeBmVT
	 0ChZvZb/aOi30ausePHkn2VJSr5nnwXjolFVNbuIEheHYso6vinzz86kA4gYGZ1cRa1XS
	 ZD3r7l6NnnJO0Xi8wRJ30kb52LrWVmav/DGGfZ3Qto0PylPn/ckh/Z2GbyG2XJ79Mqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uL++MHg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E6B606A332;
	Wed, 28 Oct 2026 17:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uL++MHg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FDDA1F01825;
	Wed, 28 Oct 2026 17:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210215;
	bh=X4vrTPy2mE4eIJlzQXpbe9SJscsumlnInZUPWA8x+do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uL++MHg31yLkgmDKw4vL785MTFfj4af1bykY/zjC3Hhk/shVRpFfBYGOgMjcDVQKL
	 hu33N0I6ajj+11s2kcjG0D6alFkXBCZCFmcrDzRkj1NKjsJ2LPiMEZ4QoAtlA+9msp
	 XD7F8YGtnM7tYu7MLA3cWiTXboZ13Tzln02x6VXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/168] bonding: do not set usable_slaves for broadcast mode
Date: Wed, 28 Oct 2026 18:00:53 +0100
Message-ID: <20261028165945.857606116@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit 45fc134bcfadde456639c1b1e206e6918d69a553 ]

After commit e0caeb24f538 ("net: bonding: update the slave array for broadcast mode"),
broadcast mode will also set all_slaves and usable_slaves during
bond_enslave(). But if we also set updelay, during enslave, the
slave init state will be BOND_LINK_BACK. And later
bond_update_slave_arr() will alloc usable_slaves but add nothing.
This will cause bond_miimon_inspect() to have ignore_updelay
always true. So the updelay will be always ignored. e.g.

[    6.498368] bond0: (slave veth2): link status definitely down, disabling slave
[    7.536371] bond0: (slave veth2): link status up, enabling it in 0 ms
[    7.536402] bond0: (slave veth2): link status definitely up, 10000 Mbps full duplex

To fix it, we can either always call bond_update_slave_arr() on every
place when link changes. Or, let's just not set usable_slaves for
broadcast mode.

Fixes: e0caeb24f538 ("net: bonding: update the slave array for broadcast mode")
Reported-by: Liang Li <liali@redhat.com>
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20260304-b4-bond_updelay-v1-1-f72eb2e454d0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 69cf5b970a114..e480c692513f0 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5112,13 +5112,18 @@ static void bond_set_slave_arr(struct bonding *bond,
 {
 	struct bond_up_slave *usable, *all;
 
-	usable = rtnl_dereference(bond->usable_slaves);
-	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
-	kfree_rcu(usable, rcu);
-
 	all = rtnl_dereference(bond->all_slaves);
 	rcu_assign_pointer(bond->all_slaves, all_slaves);
 	kfree_rcu(all, rcu);
+
+	if (BOND_MODE(bond) == BOND_MODE_BROADCAST) {
+		kfree_rcu(usable_slaves, rcu);
+		return;
+	}
+
+	usable = rtnl_dereference(bond->usable_slaves);
+	rcu_assign_pointer(bond->usable_slaves, usable_slaves);
+	kfree_rcu(usable, rcu);
 }
 
 static void bond_reset_slave_arr(struct bonding *bond)
-- 
2.53.0



