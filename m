Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625700;
	b=1GhjYaLLGlw7RHNEfk6xpgfU5RfOr+yTuULhLSj9SV+Wdm2UsWn8hJdYdYLW65JheZ5Z
	 gH7iYo+qtaiiiDK9BnLGA+NdU9hI2VbX8ZGKzZHTkN8UIc0DQON8Lx8cU70vWPKGqmVCZ
	 XlxIaWHdOAD2Q616WakBZI83qYfD/51sxGfX1QqPJZHAdhirKsn/PVlSN5gx1mWUR9DAq
	 iSvv67hSvb2wUFtWxcb/oP7/Nu2PEj6gMB1RMHB99+l1ULzsOq+gO1LXCUFrFSf/c4aQj
	 aO8mVW//I44E2QxDvaVC3ee7LVSARcm7TFRX6tH+6XAYIReVYdEnp7LudDK1mIlLnPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kD8z9PVWsIn8OAxiVKGcKjhQZbcyaBg458vrbmBTfaM=;
	b=H+Bo7+pL5XYEEdVejivcwP8Ielw33+VVL1pC10ewYuwP/GbmUs3sgy8g6CEnuy1tmYkE
	 5YYbFfgkNws8VLIeMZiW341pXIW/Vfc21FN/RU5KQp3J/mO8mCtLgvzo5aLbnMXIfU2Xf
	 rIinrwvB1M76poNu+j2Gwl7WRjOXP/oLUI9wz4+bgnW4a+4VOS2VHOzHkGR5GLi9KxyFe
	 9i+HCNiA/WuyVzzmWrv1drszy/Cc67AmN8jcUyABP5p+zaH/KSYp/1oLErj6Atw/siCLz
	 lH0SiLX5Cym2fOTze4x7s7brx9EKJg32ehBH6Kr7jYAx+0p0AQOF/ln0JaOCyorwong==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quRFaSLs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DB4606A31E;
	Wed, 25 Nov 2026 16:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=quRFaSLs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FBFB1F000CA;
	Wed, 25 Nov 2026 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625699;
	bh=kD8z9PVWsIn8OAxiVKGcKjhQZbcyaBg458vrbmBTfaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quRFaSLs8BKbLVaWKyS8FQKr+2F5v/E3fUryCugaXaKfivKc/kMHpRhGqiAZXWDT6
	 OvdGFy379955NiD6+tjvWcbVw+Pyw16yJg4zhUmzgxdWIPPH+Zuf5Jbeu9snaPWFFl
	 evqJKoot4caT+48MQufzJX9HHEpHFrX4Zyw+YonM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+521f7e7e2b974abde99a@syzkaller.appspotmail.com,
	Michail Andreas Michalopoulos <mike.michalo@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.12 601/816] netfilter: flowtable: extend ct timeout of offloaded GRE flows
Date: Wed, 25 Nov 2026 15:35:49 +0100
Message-ID: <20261125143903.089625550@linuxfoundation.org>
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
@@ -496,6 +496,7 @@ static void nf_flow_table_extend_ct_time
 
 		switch (l4proto) {
 		case IPPROTO_UDP:
+		case IPPROTO_GRE:
 			new_timeout = NF_CT_DAY;
 			break;
 		case IPPROTO_TCP:


