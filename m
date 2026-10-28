Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213317;
	b=ZlyhK9ewCUkMIeGiT8sHuPlFy+HHWeiUb6WJWITFr9hEuSQrmeQouYPH7DcL5mfNdG3O
	 wq0CCCIXrzpOivxVeevbA9XZNqJOog5Bmc+ah8t0WqrdoiH59wF5smo/bUu6kyDZqVenv
	 Q7GlajvA9wYx0cMdU9hFmh/5NjHq+//Dk2n9amaEd9emnJ+mq2OOlqvidltFL0TVNTYP2
	 L8268bQqaA0t7Yyryq/9ROKz2COdLbcIxIRqnCT5xypKXZswipUH2g1kL3sc2B/5sW35S
	 7nxyRNENBLs6JtbWZk0KglBPtCbw1NQLT/zvmrdLl5UrgPkt1JbMQ3r8ljcovhAnYyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KO83oMl/YaQSqn/I9wSwA4BxYeFlvoZzJ/Ty9E+2IkQ=;
	b=oG2d9VHDYhJqO/ZXD1Px3FdmUIZq9zX0AAM5ylm+hbjpoHCtwCH08nUE5qBaGSqXyFHu
	 cwz6ajO4CmSCZ/lr/4YkApT5z40f6lm3jNT/8AVLLvWdE9oSyoDCp7khsL+y34dBL6+Gy
	 yWzw2w8hDAb9yoEa2hfvUg3cwKdtvl0yJopr0Fv0AT15kzeOhT5nwYOw6HkYbIpLWEERQ
	 oBFZr7W4Bq2kdGt/1sRyA7TytUQd2izFgK08o5yH3anfhJ/1tFsGxvg2TO/TW/HxABMiA
	 p1G4aWiSVatzzm/REQdPF5gSW+mcGXBCdSWii6dSpl8Fw+aavXjFmvEWNLAmtEKqJAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SE8X6lco;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B55D606A31C;
	Wed, 28 Oct 2026 18:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SE8X6lco
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC4D1F01825;
	Wed, 28 Oct 2026 18:48:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213317;
	bh=KO83oMl/YaQSqn/I9wSwA4BxYeFlvoZzJ/Ty9E+2IkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SE8X6lcoTFTDMc3/i8Zrup4BVFc35ksDQa3r8NOzK40PFv8DWnUE9tQhfFPRXWLnN
	 j0GqGxxViQK45P13n9Yxt4WL7PIy9FXMWIltKqRquua/0iL4+fAOPSmBBi9jeEc/zW
	 p5MKyDJQhdIL/7QjVVYwFFtYHDJBnVZkZJeMCeHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 0463/1887] net: bridge: avoid recursive multicast port cleanup
Date: Wed, 28 Oct 2026 17:42:39 +0100
Message-ID: <20261028170509.770752166@linuxfoundation.org>
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

From: Zixuan Chai <petalzu987@gmail.com>

commit 5158353121bae4f552cb677ce8c5c3ef52f93a0d upstream.

br_multicast_sg_del_exclude_ports() removes automatically added STAR_EXCL
port groups by calling br_multicast_del_pg(). For S,G entries, that
deletion calls back into br_multicast_sg_del_exclude_ports(), so a large
number of STAR_EXCL ports consumes one kernel stack frame per port and can
hit the stack guard page.

Keep the complete port-group deletion path for cleanup, but suppress the
S,G exclude-port cleanup while that helper is already walking the same
entry. Normal deletion callers retain the existing behavior.

Fixes: 8266a0491e92 ("net: bridge: mcast: handle port group filter modes")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -80,6 +80,10 @@ __br_multicast_add_group(struct net_brid
 			 bool blocked);
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
 static int br_mc_disabled_update(struct net_device *dev, bool value,
@@ -436,7 +440,7 @@ static void br_multicast_sg_del_exclude_
 	for (pp = &sgmp->ports;
 	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;) {
 		if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_del_pg(sgmp, p, pp);
+			__br_multicast_del_pg(sgmp, p, pp, false);
 		else
 			pp = &p->next;
 	}
@@ -675,9 +679,10 @@ static void br_multicast_destroy_port_gr
 	kfree_rcu(pg, rcu);
 }
 
-void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
-			 struct net_bridge_port_group *pg,
-			 struct net_bridge_port_group __rcu **pp)
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports)
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
@@ -692,7 +697,8 @@ void br_multicast_del_pg(struct net_brid
 	if (!br_multicast_is_star_g(&mp->addr)) {
 		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
 				       br_sg_port_rht_params);
-		br_multicast_sg_del_exclude_ports(mp);
+		if (sg_del_exclude_ports)
+			br_multicast_sg_del_exclude_ports(mp);
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
@@ -703,6 +709,13 @@ void br_multicast_del_pg(struct net_brid
 		mod_timer(&mp->timer, jiffies);
 }
 
+void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+			 struct net_bridge_port_group *pg,
+			 struct net_bridge_port_group __rcu **pp)
+{
+	__br_multicast_del_pg(mp, pg, pp, true);
+}
+
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg)
 {


