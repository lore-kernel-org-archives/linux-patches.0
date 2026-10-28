Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214399;
	b=i1Tfpqco8H+RQ39LUM3K7W+kGbEBzgxZtaypnICwe13ldzMyR08PE6vVltTroN8BdtQq
	 jXM1aGpD67RIYwAvMdMMlvmzl2xmYmRKUFSgTV/l8ln2bIENllrITKmB4u3E5ue5h3gzg
	 kYmGap6HXJ73N/k//6DiVWv1nWpZ0/UFp/zyQ8psS+yBldbozf93CvQPh0qqH/YkpVTdK
	 8few7dOgT9nAym9PbEuOHLVnpHY3o2Zzao5z8JnDBuFXARE6U57eV+IibsujMpuL/hBAk
	 leQRRCUbPGTU7PW6KZUdKwJhnPc7+UxIkTZN3TtzG1SpVpkc5l4V7plPfPXALrx/4Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214399;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bl0FKPSUeUXa9TfVtHgVOZN3gMgfFD7vIfLEQKxYPCQ=;
	b=yyFQRFYG+5GKpeWb0zwyyNedRDVqm2yY0d5Fnd4VB6VJL/oOQfDY/88pmW+5BPbiyJ02
	 DovMjxQUmJ9hFffRhEKCqRAQcJ+AFegF73T58lYRJM7Okp/Ss1lGgZST70U/UwXr/cu7Z
	 ODEriXkbKccs9IlGQ2ZCttrmMBvczwW6o4YcdeTzTw60i+KLyto/A9ngbN9DavtSWqrNQ
	 /mghBxxZXqOiKnyB7VNLEPBtoNkqeQauhLJE+q3Q18dlCitPfryBtaxcK5pVNKvGksdrE
	 prezHDQcB7FboXaBsDE2t4C4PNjxI7DcvR716gZAoBxQtxTXAMnIU9K0G12PXlZoeEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fD+5UgXo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843A0606BF8B;
	Wed, 28 Oct 2026 19:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fD+5UgXo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97CA1F01825;
	Wed, 28 Oct 2026 19:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214399;
	bh=Bl0FKPSUeUXa9TfVtHgVOZN3gMgfFD7vIfLEQKxYPCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fD+5UgXoDL/aOdMmwefkzXkNdCkj1mt615Y/QGnGYVtLIHhmkNMBc+5ochNLv7x8b
	 zBFKajhahMq819N2+6TO5Tw4jaRD+vnim0xbovJq7IlW1naK21SrCAGYvLkdDvN4Yj
	 GwQh7mMHP74Q+6ytGMggS1xdA/wRdrQSFnIIViUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marlin Cremers <mcremers@cloudbear.nl>,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0844/1887] vxlan: Fix NPD when refreshing an FDB entry with a nexthop object
Date: Wed, 28 Oct 2026 17:49:00 +0100
Message-ID: <20261028170518.634127943@linuxfoundation.org>
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 6ead38147ebb813f08be6ea8ef547a0e4c09559a ]

VXLAN FDB entries can point to either a remote destination or an FDB
nexthop group. The latter is usually used in EVPN deployments where
learning is disabled.

However, when learning is enabled, an incoming packet might try to
refresh an FDB entry that points to an FDB nexthop group and therefore
does not have a remote. Such packets should be dropped, but they are
only dropped after dereferencing the non-existent remote, resulting in a
NPD [1] which can be reproduced using [2].

Fix by dropping such packets earlier. Remove the misleading comment from
first_remote_rcu().

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
CPU: 13 UID: 0 PID: 361 Comm: mausezahn Not tainted 6.17.0-rc1-virtme-g9f6b606b6b37 #1 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
RIP: 0010:vxlan_snoop+0x98/0x1e0
[...]
Call Trace:
 <TASK>
 vxlan_encap_bypass+0x209/0x240
 encap_bypass_if_local+0xb1/0x100
 vxlan_xmit_one+0x1375/0x17e0
 vxlan_xmit+0x6b4/0x15f0
 dev_hard_start_xmit+0x5d/0x1c0
 __dev_queue_xmit+0x246/0xfd0
 packet_sendmsg+0x113a/0x1850
 __sock_sendmsg+0x38/0x70
 __sys_sendto+0x126/0x180
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x4b/0x53

[2]
 #!/bin/bash

 ip address add 192.0.2.1/32 dev lo
 ip address add 192.0.2.2/32 dev lo

 ip nexthop add id 1 via 192.0.2.3 fdb
 ip nexthop add id 10 group 1 fdb

 ip link add name vx0 up type vxlan id 10010 local 192.0.2.1 dstport 12345 localbypass
 ip link add name vx1 up type vxlan id 10020 local 192.0.2.2 dstport 54321 learning

 bridge fdb add 00:11:22:33:44:55 dev vx0 self static dst 192.0.2.2 port 54321 vni 10020
 bridge fdb add 00:aa:bb:cc:dd:ee dev vx1 self static nhid 10

 mausezahn vx0 -a 00:aa:bb:cc:dd:ee -b 00:11:22:33:44:55 -c 1 -q

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Reported-by: Marlin Cremers <mcremers@cloudbear.nl>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250901065035.159644-2-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c    | 8 ++++----
 drivers/net/vxlan/vxlan_private.h | 4 +---
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 216f67d011f08..536c8384d635a 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1522,6 +1522,10 @@ static bool vxlan_snoop(struct net_device *dev,
 	if (likely(f)) {
 		struct vxlan_rdst *rdst = first_remote_rcu(f);
 
+		/* Don't override an fdb with nexthop with a learnt entry */
+		if (rcu_access_pointer(f->nh))
+			return true;
+
 		if (likely(vxlan_addr_equal(&rdst->remote_ip, src_ip) &&
 			   rdst->remote_ifindex == ifindex))
 			return false;
@@ -1530,10 +1534,6 @@ static bool vxlan_snoop(struct net_device *dev,
 		if (f->state & (NUD_PERMANENT | NUD_NOARP))
 			return true;
 
-		/* Don't override an fdb with nexthop with a learnt entry */
-		if (rcu_access_pointer(f->nh))
-			return true;
-
 		if (net_ratelimit())
 			netdev_info(dev,
 				    "%pM migrated from %pIS to %pIS\n",
diff --git a/drivers/net/vxlan/vxlan_private.h b/drivers/net/vxlan/vxlan_private.h
index b0e8c6d290579..9e1cc18ca81ab 100644
--- a/drivers/net/vxlan/vxlan_private.h
+++ b/drivers/net/vxlan/vxlan_private.h
@@ -56,9 +56,7 @@ static inline struct hlist_head *vs_head(struct net *net, __be16 port)
 	return &vn->sock_list[hash_32(ntohs(port), PORT_HASH_BITS)];
 }
 
-/* First remote destination for a forwarding entry.
- * Guaranteed to be non-NULL because remotes are never deleted.
- */
+/* First remote destination for a forwarding entry. */
 static inline struct vxlan_rdst *first_remote_rcu(struct vxlan_fdb *fdb)
 {
 	if (rcu_access_pointer(fdb->nh))
-- 
2.53.0



