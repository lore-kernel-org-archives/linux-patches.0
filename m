Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831632;
	b=d2IvQHnSynuoHRHryQgHZn8ElzoapdoKHQI9dOIqzkKjEQ0jQa9sls2I1NNXDGp671je
	 0cTQ740U8d989BIEBfW0ZGDE6TIk0ir6ehDszmVdINMQuqZkSChBZENE0ztpKuctpKwyY
	 z++d4XitUlLFipJ3fBZ7fbDocbLBxSOEIU21lqTUGpdxDQp4SvfMt3HOOVl8PD77z5jZs
	 lcIlmdU6A4mB5YFTOxtuy++4QUQ1axWmNf+cjnVQYxlCpm7bbek1THfp8WycEk3SQCIsQ
	 HzaLbqPsHpCqt+Oq/Qac+hVdtCprpNX9IvMXtCu+9bpxHMABQAXFR69coDM7AZK/i4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n5bavh71tWxV9kS4Iw+nGfCHEE6pETm81gS+H69YMmI=;
	b=p+RYCCknqEAYg/XodjFcIdgnz8fTBAQZta3Gasa+ZviL5Pmu9j0p3SiNpQVT/MbrXFxU
	 iQ61KEvKxdaB4sCz1hSLs54hY6h6YJexiyfyaU0Vo8syzEuJr0glPOjfr0JQYO2324Zqh
	 hX8lk1IKvBCka7c/eJKVR2FPdav8834E8iibKepSsjL1NDhMWGnLvSNg3xsLspFwcZn/e
	 s4jtJOmd6SdUOKyyf2p1HCUaMBLiC7m/pkVD2Ey213s8mkOdSH2Eu1Ay+1Y+qjoL70Vdw
	 wm8k+sM8hVybMYz0mvtEFpbDvZETq8j/NiTxTtp/GPicsOFgn3J89YgEWoM3E0xwa9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVLECMPe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43417606AC2A;
	Wed,  4 Nov 2026 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVLECMPe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931C01F0093A;
	Wed,  4 Nov 2026 22:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831631;
	bh=n5bavh71tWxV9kS4Iw+nGfCHEE6pETm81gS+H69YMmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVLECMPeg1nwklvdLNWi96E/ie/52P0DkAEQ5zIY0tRf+j+VU6Lfid1n+B/7Iegdr
	 0vZntyF5UcmRsFupYMyO92nQfuZJc1pPhHpHpb5hCv2u53a7tUGJbZjJW2HciM38ww
	 UcKmE4pvsMf3S+GlZDFIlbYjmUPsANlYh0qCadnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@kernel.org>,
	Andrea Parri <parri.andrea@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	stable+noautosel@kernel.org
Subject: [PATCH 6.18 0822/1005] rtnetlink: wait for RCU readers in rtnl_link_unregister()
Date: Wed,  4 Nov 2026 16:09:15 -0500
Message-ID: <20261104211106.364793642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 3b70edea393de445255da6c706eebb823117a955 ]

rtnl_link_ops_get() finds ops on link_ops under rcu_read_lock() and only
then takes ops->srcu. rtnl_link_unregister() unlinks ops, then calls
synchronize_srcu() and cleanup_srcu_struct() without first waiting for
RCU readers. A reader that found ops before list_del_rcu() and has not yet
taken ops->srcu is not waited for.

Such a reader then locks a cleaned-up srcu_struct and keeps using ops
after the module that owns it is gone. rtnl_newlink() and
rtnl_dump_ifinfo() both look up ops without RTNL, the latter for any
user that dumps links filtered by kind.

With delays added between the lookup and srcu_read_lock() in
rtnl_link_ops_get(), and before rtnl_link_ops_put() in
rtnl_dump_ifinfo(), running "ip link show type dummy" alongside
"rmmod dummy" on a KASAN kernel gives:

  BUG: KASAN: vmalloc-out-of-bounds in __srcu_read_unlock+0x57/0x70
  Read of size 8 at addr ffffffffc02ff318 by task ip/147
  Call Trace:
   __srcu_read_unlock+0x57/0x70
   rtnl_dump_ifinfo.cold+0x30/0x3b
   rtnl_dumpit+0x7a/0x1b0
   netlink_dump+0x486/0x11b0
   __netlink_dump_start+0x661/0x910
   rtnetlink_rcv_msg+0x611/0x9e0
   netlink_rcv_skb+0x126/0x380
   netlink_unicast+0x605/0x830
   netlink_sendmsg+0x6d0/0xbb0
   __sys_sendto+0x335/0x3a0

Call synchronize_rcu() before synchronize_srcu(), as
rtnl_af_unregister() already does. This should be enough because
rtnl_link_ops_get() is the only RCU walker of link_ops, and it takes
ops->srcu before rcu_read_unlock(), so every reader that found ops is
covered by synchronize_srcu() once the RCU grace period ends. The extra
grace period only costs time at module unload.

Readers and the writer were serialized by RTNL until link_ops got its
own mutex, which is why the missing RCU wait did not matter before.

Cc: stable+noautosel@kernel.org # needs real net-admin (non-ns)
Fixes: 6b57ff21a310 ("rtnetlink: Protect link_ops by mutex.")
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261001143040.28467-1-parri.andrea@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index b0e6a6eff23ba..23f693d61d908 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -682,6 +682,10 @@ void rtnl_link_unregister(struct rtnl_link_ops *ops)
 	list_del_rcu(&ops->list);
 	mutex_unlock(&link_ops_mutex);
 
+	/* Wait for rtnl_link_ops_get() readers that found ops but have
+	 * not yet taken ops->srcu.
+	 */
+	synchronize_rcu();
 	synchronize_srcu(&ops->srcu);
 	cleanup_srcu_struct(&ops->srcu);
 
-- 
2.53.0



