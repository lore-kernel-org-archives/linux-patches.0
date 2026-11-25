Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624692;
	b=fGoJcm6/4UEugyUw9y9+ZlDMyJQ36DhRXYvl7ConR4CPYY4QI4RjO+vk8VR0Wlv0M8aj
	 MqFRg4X3RNVbl8ZXvXV0xKuD4HRr8HgJ5XQwJv63CpIz6Qq6/7Ful/dh7eXPdK9VppyUa
	 rCtIBKs/vQrDFOGyhMz7v+hvOXLbIGN50tVMo2WatuKjMOE+8UiNKNjloxlEdS0vgYxTi
	 ZISjcorWwPsreJeg8iT1+ZQ+g1T1Gwuw+Ov60gw24bzCpNpZxa4LMC+0H+VZY+RVreyoF
	 47uYVBa8FvOTCTkx9LSpnghbYKDs59w+yjECTC5sb3+WwsgjX5ZhdirIgK9CuSAqMVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ysSwtAp4Egsm0YqhJPGdxPfITTEvmgTw5MBlXzIQM6E=;
	b=VTWsxtTCTU1dzRt0yEgpIxOtzv/AgOjAoKcQxwiwDgSryv6NAN3Pn6/sov4IldW734ZB
	 P7zmwfuLuoqAyZNLiQ1NP4PNqzIloTtLTs9Bzt8oo9M1hbF+mQEWvBXiItl+Luh/AwgRq
	 FFnMRZE2VjJHGxplQojX5nXkxpTJsOgkuqjAy1v29D1HqELi5Wn99YtO86LUH746Nb80k
	 1mGL+WDezg45QdZTcY8/hdBwJV1X/Ml9N2jQ5L1Xq2k5xMl89YIPb0VlGReYpBpYfxCXA
	 mQsrfY/JGINyPO/13EdqIB7MyOU9KL/O/imGJ0DIGBQ+L5Vp4AhJfsdHNdQxI7uu5pQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1q9xxXxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679FD606A33A;
	Wed, 25 Nov 2026 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1q9xxXxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA1941F000C4;
	Wed, 25 Nov 2026 16:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624692;
	bh=ysSwtAp4Egsm0YqhJPGdxPfITTEvmgTw5MBlXzIQM6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1q9xxXxygds2C8gcjHNbwwgXiA8IKxDNJK/sopIS6SSOSL8hTZOMS4S9Fp/wRM1PN
	 yB+hMY5YWFDot6pLN1C8uOz0HYbMdFIMJhcDNtiES3/oTOvwAIKeWyj0PxC8H7t79m
	 NwkReg/zJMgxZpx2KpRZwb/42nsf1jvoCSnDH1RQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Cheng Yongkang <teel4res@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 231/816] net: bridge: disable MRP ports before the FDB flush in del_nbp()
Date: Wed, 25 Nov 2026 15:29:39 +0100
Message-ID: <20261125143854.556042303@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Cheng Yongkang <teel4res@gmail.com>

[ Upstream commit 37dfd0efbfffc20a57e41c2eb349ac49b1ca1ff8 ]

del_nbp() flushes the port's FDB entries before it unregisters the RX
handler. For a normal port, br_stp_disable_port() moves the port to
BR_STATE_DISABLED before this cleanup.

That does not hold for an MRP ring port. br_set_state() ignores state
changes while BR_MRP_AWARE_BIT is set, so br_stp_disable_port() leaves
the port state alone. br_mrp_port_del() then restores forwarding when
the bridge is up before clearing the bit. A frame received between
br_fdb_cleanup_by_dst() and netdev_rx_handler_unregister() can therefore
create a new FDB entry referencing the dying port. Nothing removes that
entry before destroy_nbp_rcu() frees the port, so a later frame to the
learned MAC can be forwarded through the freed port.

Remove the MRP and CFM instances before disabling the port, so that
br_stp_disable_port() actually transitions it to BR_STATE_DISABLED.
With CONFIG_BRIDGE_VLAN_FILTERING=y, synchronize_net() in
nbp_vlan_group_unpublish() also drains receive paths that could still
learn with the old state before the final FDB cleanup.

Found through an LLM-assisted source code analysis workflow and
reproduced on net with KASAN and CONFIG_BRIDGE_VLAN_FILTERING=y in QEMU.
A diagnostic switchdev module accepts MRP objects and delays the
NETDEV_CHANGEUPPER callback for 1.5 s, holding del_nbp() after the FDB
cleanup and before RX handler removal. The reproducer floods the MRP
port with rotating source MACs, waits for the port's RCU callback
through the module's rcu_barrier(), then sends frames to those MACs
from another port. The unpatched kernel reports:

  BUG: KASAN: slab-use-after-free in br_forward+0xb1/0x820
  Call Trace:
   <IRQ>
   br_forward+0xb1/0x820
   br_handle_frame_finish+0x148b/0x1e50
   br_handle_frame+0x90a/0x15c0

With this patch, three runs of six cycles each reach the delay without
a KASAN report.

Fixes: 6536993371fa ("bridge: mrp: Integrate MRP into the bridge")
Suggested-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/netdev/20261012123051.GA714215@shredder/
Closes: https://lore.kernel.org/netdev/20261022090431.3641707-1-teel4res@gmail.com/
Signed-off-by: Cheng Yongkang <teel4res@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261101044840.1595584-1-1020691186@qq.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index eee6ceb7cddab..82447f7071312 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -339,13 +339,13 @@ static void del_nbp(struct net_bridge_port *p)
 
 	nbp_delete_promisc(p);
 
+	br_mrp_port_del(br, p);
+	br_cfm_port_del(br, p);
+
 	spin_lock_bh(&br->lock);
 	br_stp_disable_port(p);
 	spin_unlock_bh(&br->lock);
 
-	br_mrp_port_del(br, p);
-	br_cfm_port_del(br, p);
-
 	br_ifinfo_notify(RTM_DELLINK, NULL, p);
 
 	list_del_rcu(&p->list);
-- 
2.53.0



