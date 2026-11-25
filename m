Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623031;
	b=uJjxdalta82SXb8w7XMCN5EfSJ+b3+3d2turRBZw5PZTuXa69ky5r5NzJei9gqstSVAZ
	 bzK4X+3BKAftj7WeQn6Z4We5YYPj8MjhJVtzHQiK9is1HPUHLgw/e6lO3nPL8D+XT7whL
	 giAtvyZmq0jxPEGEWR76aatISCMZMSzgEYIdoy+hIXbCuGjUiOOlF9zNDPRdlgmPNVYV8
	 nS/Hzrtxy8ctEUWkTYsP8rkHuiyDxNtTidpeRy7MJ74v5BD1Smaq4eArxP9ZU2uBnEYXq
	 7Q4OeVSo5vGvXNCyqcefluigsP2bKVj88OfsMF6WjwR+YXc5snn2+GgXLdFQpkQsEDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kMRFvREO+gYGJA+1bxWnHdn39RJKz6Y81nqhb99Dc48=;
	b=3Psmz0PVYj9FrfEHXmgPXtR2APN8gZF6y1zWxK4v+HGD+eqRGaIWVV8HGRmpFs2e22r4
	 AxYMbKSzbWp6G7cuLjONO0XhgFuW4Hc37dftUu6WWxd2CICIOoUV67sZbHXnuXjeCo7kQ
	 0MVeDOReLgV7jSiVGLntZ8Cq2MJMx3dHpTPFs2jihknBgtBc2NTlhewI9eOWzNkUtlo4I
	 hextFX2BDC3tSOd2BAhKsCar60ppSV3idV1R71RG2MIU18Gt1C93tNkwR2YzTDjNvyQit
	 91K8uDbMvWcIl6YosGtAbtyJxt3tMaVul55Lu6OP6kqJjp0T0bRmtXmd65Gud1JXNaA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZYh8fyX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E7C606A323;
	Wed, 25 Nov 2026 16:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YZYh8fyX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43E61F000C0;
	Wed, 25 Nov 2026 16:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623031;
	bh=kMRFvREO+gYGJA+1bxWnHdn39RJKz6Y81nqhb99Dc48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YZYh8fyX9rkhgCUyfgZoi0ldYu4TZthTALr0O6ZKhOJNf/MtIkdBVWpq/Edb2iA3/
	 XIJ9o6ziZ+Trvxac1VMR2+DewsS2JCENQjs1e5So87PhA00xZJr0oASxR/T/wjf9Ic
	 dbh5dWkKvoi13CJMSyw08ay/oOzhGbkYjNgUoOHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 726/990] netfilter: flowtable: extend ct timeout of offloaded GRE flows
Date: Wed, 25 Nov 2026 15:34:53 +0100
Message-ID: <20261125143839.080077701@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michail Andreas Michalopoulos <mike.michalo@gmail.com>

commit 46ecda278f6eedffb2898d41e3e56757c996a41f upstream.

Since commit 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn
timeout extension logic"), the flowtable gc worker extends the timeout
of an offloaded conntrack entry from nf_flow_table_extend_ct_timeout()
once it falls below 5 minutes. That function only knows about TCP and
UDP and hits WARN_ON_ONCE() for any other layer 4 protocol. However,
GRE flows can be offloaded too, both via nft_flow_offload and act_ct,
since commit 4e8d9584d154 ("netfilter: flowtable: Support GRE").

The timeout of an offloaded GRE entry drops below that threshold as soon
as a packet of the flow still goes through conntrack. With ip6gre
tunnels using the default encapsulation limit this is ordinary traffic:
the flowtable does not parse the Destination Options header in front of
GRE, so every packet of the flow takes the classic forwarding path. It
also happens for a packet with ttl <= 1, which the flowtable fast path
passes up to the classic forwarding path. nf_conntrack_gre_packet() then
refreshes ct->timeout to the GRE stream timeout (180 seconds by default),
and the next gc run triggers, as reported by syzbot:

  WARNING: net/netfilter/nf_flow_table_core.c:553 at nf_flow_table_extend_ct_timeout+0x1ee/0x2f0
  Workqueue: events_power_efficient nf_flow_offload_work_gc
  Call Trace:
   nf_flow_offload_gc_step+0x545/0x7b0
   nf_flow_table_iterate+0x13c/0x1f0
   nf_flow_offload_work_gc+0x22/0x70
   process_scheduled_works+0xc3d/0x1630
   worker_thread+0xa47/0xfb0
   kthread+0x38b/0x480

Besides the splat, which panics the machine with panic_on_warn, the
default branch sets the new timeout to 1 jiffy, so the conntrack entry
expires right away and the offloaded flow is torn down.

Handle GRE like UDP and extend the timeout to NF_CT_DAY. GRE conntrack
has no protocol state to take into account, and NF_CT_DAY is also what
flow_offload_add() already sets for every offloaded entry, GRE included.
This also restores the behaviour from before commit 03428ca5cee9, when
the conntrack gc worker extended offloaded entries of any protocol to
NF_CT_DAY.

Fixes: 03428ca5cee9 ("netfilter: conntrack: rework offload nf_conn timeout extension logic")
Reported-by: syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=521f7e7e2b974abde99a
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Michail Andreas Michalopoulos <mike.michalo@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_flow_table_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -537,6 +537,7 @@ static void nf_flow_table_extend_ct_time
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
+		case IPPROTO_GRE:
 			new_timeout = NF_CT_DAY;
 			break;
 		case IPPROTO_TCP:


