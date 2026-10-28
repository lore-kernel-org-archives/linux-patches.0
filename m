Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217114;
	b=bMViOkU/jmu/iUkgSShiuLm0ITGAIhU+w/rKStWpe2Yq/ea5+KVZAgMUwgnCpCBM0hfX
	 MH8JlmiDgN/iQgmEHBDzDr/tHY0uGwte/zbpRRs+yR9z+g1MmCaWLxlSymJWi8cj+j+Q2
	 OLNih7AMCvPXfoSzFr1aF6b0UJjbDiVSDu6DQltWUfwsAZ4TpF68Co4KOU46B71JnOlOU
	 J5BVIxYArRHQOnGynjF0u+ro9WUpoyezv+p9c9Y14QoRZ0Np7KspY8J/fewqxLvyJWeXW
	 NW3RwFXvYDLZO9nJRW0IwK0h/FNSj3Q6Vcd1tAjV5wPYpqQ05+7VYkfFghDAgwZVVsw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPEfIMS6TRICaKjHFKnNDwh1rkNZGMDpWP9nbQh4Y+c=;
	b=Zh36/7AHQcnA3DtDUoIhdW2b0lUow9Q70v2UjrxOHc/tm5f2Utq6xWo05CJda/WdZPbV
	 23Z+b/PCpw45ehApJ20gmJ5YBexnZs/ury6MLO5xn91hSc3WW5nW35zumCX4FNGdZJJ6S
	 cIQCb9OKir6xATcuA4WW/P5nyVe0BqBdfbgWkOD7Lg1QPOHXjUCs0jcceAcnZdAg4O+w4
	 YgOw8r+2R/JJ1Y+Ozvru532mi7LyiphY8neYY33exg06bjz5GBMdKSdRnO4P+GuaAhHzY
	 AQ0860kB1o9bkBP7K/MUrDoeRev020/xHD7cmIJy26rFTiccME/Dbg0ti9xlaf5RUAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcgNFmOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C87606A31F;
	Wed, 28 Oct 2026 19:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TcgNFmOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9471F01825;
	Wed, 28 Oct 2026 19:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217113;
	bh=hPEfIMS6TRICaKjHFKnNDwh1rkNZGMDpWP9nbQh4Y+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TcgNFmOnRD+VlHFWse4neJKWrUk1BF+P9uaEDM/8qJ7IxqyqYMz+T8Wlrs7o9cYF7
	 vvrLS+9n4ficKgX1k0n4EUlpJkIY3WOvROw594VwGX2zlvUW3xn09HC4CV5rIPAkaF
	 cmY5X5qPbrryRI5uxShei/6bEulCi26IO6o/ns6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1794/1887] bonding: do not set usable_slaves for broadcast mode
Date: Wed, 28 Oct 2026 18:04:50 +0100
Message-ID: <20261028170540.272260129@linuxfoundation.org>
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
index 0764bff68d97c..cd148bd014fae 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -5173,13 +5173,18 @@ static void bond_set_slave_arr(struct bonding *bond,
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



