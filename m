Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214397;
	b=uOjGycDyBYKMBhIMUFKXuA0xQO6ZJro+PsF5TaFNjAVDOvh+kuy6eZUMNIFoXwneLYkV
	 /htYJ4RaioCKCokmlaJ7qhKHjVXs3BPldW5uF5zaLDMBT7o6tCXBs+sRFC55OWqtjaRUe
	 IXsKefGQ5dax8+cl4nIbFnJh6gEurZiAnnFGdZ0e3MnsKbLmLGf0g9feQ3X7XbTy2UPwA
	 3S3G26emmV3SK3ypOAuqhNkecPRmuZ04Fvhi06AUpA2TGFe8Pv3e+gC2bKw6MlUOnnKv6
	 U6TAjdgXrO2uu4wlRFBFwf2gJrB4DlVCazkVyFq5whNOJI6syzZDw7bRR1k/WKc67Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214397;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pRWbQf31JQHDB0QkB5+9BX5E2sEY2Agw7SV15FFqNFQ=;
	b=4NZu01uE97/L8e2UoTm4pZUO92VYeZVARi0joSgyRasJhrNaYUiNN4MH2PTKHSB41VLT
	 9AQkyiTjvRaEZnv7WowXBpaxaF3rUSGy237XIancEEtfg0RVcWv8LibEDLeRz9iZRSclp
	 EqgOJ06uZl6Xzt8He69kHw8lCWoDZbChBRJxYc0gKc4cuagTd+32HU9bNzNPgS86j9M4W
	 hf0FqMd91zhjPK+eTOSGPBLOrO98aOEV2xUQUksrk/niC0QHVBCDYJlmdPL+hYwZEcSyb
	 BMtZZio+P28wh0k4OSxiLvDjEzS/7vRTHHO4ntnff04e8lFoIYss59oW7F2jkkpmpgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="H04XSa/N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E5A606A334;
	Wed, 28 Oct 2026 19:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H04XSa/N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B0E1F01825;
	Wed, 28 Oct 2026 19:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214396;
	bh=pRWbQf31JQHDB0QkB5+9BX5E2sEY2Agw7SV15FFqNFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H04XSa/N7CnfyJWFJDXXgFDL+/iMTMh02CSDmSf3SwlopM87LaFGYYFdiplatj+Iz
	 g+eBAJqvZoJI61OFcuaG2GhATrvpvNEbzMTXKbGlhvA6qJEUiIKfAKIhXYZRV45Jcc
	 Lj/tTR1fHlLdsaRGXpCVDVrlcwBDMBdWw37fA2CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Machata <petrm@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0843/1887] vxlan: Fix NPD in {arp,neigh}_reduce() when using nexthop objects
Date: Wed, 28 Oct 2026 17:48:59 +0100
Message-ID: <20261028170518.611465578@linuxfoundation.org>
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

[ Upstream commit 1f5d2fd1ca04a23c18b1bde9a43ce2fa2ffa1bce ]

When the "proxy" option is enabled on a VXLAN device, the device will
suppress ARP requests and IPv6 Neighbor Solicitation messages if it is
able to reply on behalf of the remote host. That is, if a matching and
valid neighbor entry is configured on the VXLAN device whose MAC address
is not behind the "any" remote (0.0.0.0 / ::).

The code currently assumes that the FDB entry for the neighbor's MAC
address points to a valid remote destination, but this is incorrect if
the entry is associated with an FDB nexthop group. This can result in a
NPD [1][3] which can be reproduced using [2][4].

Fix by checking that the remote destination exists before dereferencing
it.

[1]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
CPU: 4 UID: 0 PID: 365 Comm: arping Not tainted 6.17.0-rc2-virtme-g2a89cb21162c #2 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-4.fc41 04/01/2014
RIP: 0010:vxlan_xmit+0xb58/0x15f0
[...]
Call Trace:
 <TASK>
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

 ip nexthop add id 1 via 192.0.2.2 fdb
 ip nexthop add id 10 group 1 fdb

 ip link add name vx0 up type vxlan id 10010 local 192.0.2.1 dstport 4789 proxy

 ip neigh add 192.0.2.3 lladdr 00:11:22:33:44:55 nud perm dev vx0

 bridge fdb add 00:11:22:33:44:55 dev vx0 self static nhid 10

 arping -b -c 1 -s 192.0.2.1 -I vx0 192.0.2.3

[3]
BUG: kernel NULL pointer dereference, address: 0000000000000000
[...]
CPU: 13 UID: 0 PID: 372 Comm: ndisc6 Not tainted 6.17.0-rc2-virtmne-g6ee90cb26014 #3 PREEMPT(voluntary)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1v996), BIOS 1.17.0-4.fc41 04/01/2x014
RIP: 0010:vxlan_xmit+0x803/0x1600
[...]
Call Trace:
 <TASK>
 dev_hard_start_xmit+0x5d/0x1c0
 __dev_queue_xmit+0x246/0xfd0
 ip6_finish_output2+0x210/0x6c0
 ip6_finish_output+0x1af/0x2b0
 ip6_mr_output+0x92/0x3e0
 ip6_send_skb+0x30/0x90
 rawv6_sendmsg+0xe6e/0x12e0
 __sock_sendmsg+0x38/0x70
 __sys_sendto+0x126/0x180
 __x64_sys_sendto+0x24/0x30
 do_syscall_64+0xa4/0x260
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
RIP: 0033:0x7f383422ec77

[4]
 #!/bin/bash

 ip address add 2001:db8:1::1/128 dev lo

 ip nexthop add id 1 via 2001:db8:1::1 fdb
 ip nexthop add id 10 group 1 fdb

 ip link add name vx0 up type vxlan id 10010 local 2001:db8:1::1 dstport 4789 proxy

 ip neigh add 2001:db8:1::3 lladdr 00:11:22:33:44:55 nud perm dev vx0

 bridge fdb add 00:11:22:33:44:55 dev vx0 self static nhid 10

 ndisc6 -r 1 -s 2001:db8:1::1 -w 1 2001:db8:1::3 vx0

Fixes: 1274e1cc4226 ("vxlan: ecmp support for mac fdb entries")
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20250901065035.159644-3-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index c9f02da4c8af8..216f67d011f08 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1943,6 +1943,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	n = neigh_lookup(&arp_tbl, &tip, dev);
 
 	if (n) {
+		struct vxlan_rdst *rdst = NULL;
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
 
@@ -1952,7 +1953,9 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		f = vxlan_find_mac(vxlan, n->ha, vni);
-		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
+		if (f)
+			rdst = first_remote_rcu(f);
+		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
 			/* bridge-local neighbor */
 			neigh_release(n);
 			goto out;
@@ -2111,6 +2114,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	n = neigh_lookup(ipv6_stub->nd_tbl, &msg->target, dev);
 
 	if (n) {
+		struct vxlan_rdst *rdst = NULL;
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
 
@@ -2120,7 +2124,9 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		}
 
 		f = vxlan_find_mac(vxlan, n->ha, vni);
-		if (f && vxlan_addr_any(&(first_remote_rcu(f)->remote_ip))) {
+		if (f)
+			rdst = first_remote_rcu(f);
+		if (rdst && vxlan_addr_any(&rdst->remote_ip)) {
 			/* bridge-local neighbor */
 			neigh_release(n);
 			goto out;
-- 
2.53.0



