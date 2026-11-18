Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032987;
	b=M4nlV9U+QyjGgjT/2HeRl8GddI6ifXYBbGVXHp8kM5SS0zB8ZQpM9HvPOVqEEY0RqrIO
	 P/A1gbf4U46OmrdnT707g/FQLODeCKpjXMzRxnqxEhUx3pxhzLS5Z1hCWlOphIAux0wF4
	 y4Majv13B5MdE4zRla7SaCO0jRDfEq8si0AU3LJbDxj8/PyJr+Tg0YEKh9HY0bKsVrsRU
	 w/7es30WjmwzduG/DdU0g06JfxAnPc+e9o4nsPzCAYxdYUjfBFSIDddwbox5qV4j0ryh3
	 BWqfsxZ2zJRYoP/HCEPc0vIgZ5lzPLpge4m4V/aUlDvE6fr6+XzSznz6fKpcO8jWrSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032987;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LafwD/1tyRBra42PJBgPJ38mtoBFVa7YnM/g3agfqn0=;
	b=qNcKxR/hh4uvNoWk0UPxDKL9WqEitdbkt8t/GyFsNuafClMEzW8LAO4apttzO2G+S3JM
	 se3bUAkF1GnX7AA0nLCizUohBQNg8gJZjdZicW69275+zo21eGzb5n03hXS2aduAtO+gW
	 xlZzaLFvJt5D2nw8CeWZumowSjxzCg0eieJcoqTJ1EZoaWnDsVfF7jO+7J485zulnKoSg
	 RtXvKnU9WAN8eBYWui/3ddU+742N0kl1uBQRImlJt2ekBw55xzLBLedkLMwaYe1U0SPWA
	 /NyzrQTk3qYaPWOX+ZNtUAnKaIwY6jD6ChT7tiXzTCaSnlQpY2qoVeB+EXhKpuOdvhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+B25sZE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDBD606A320;
	Wed, 18 Nov 2026 20:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L+B25sZE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DBC1F000C4;
	Wed, 18 Nov 2026 20:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032987;
	bh=LafwD/1tyRBra42PJBgPJ38mtoBFVa7YnM/g3agfqn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L+B25sZEQU8D9eNNvetl2RAP0P2keIAQVw0b2wMH6x46Fj5WpaxkUemefIrewKAqV
	 XKXcRxyGdht5dB/EBrtdHePyitx/2MS0yVZRwn0S+o/ZGleJp+Xqpp8qXzIlGGBa1r
	 AGzkg2IEWWVzKj4lw44IrgJcJgX6xBGK9j9xB9Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <yi1.lai@intel.com>,
	Joel Granados <joel.granados@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1600/1756] net/rds: do not fail init when CONFIG_SYSCTL=n
Date: Wed, 18 Nov 2026 16:02:07 +0100
Message-ID: <20261118150113.597486842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Allison Henderson <achender@kernel.org>

[ Upstream commit fbea154a86641d2543a871aa19f7c77a366de542 ]

With CONFIG_SYSCTL=n, register_net_sysctl() and register_net_sysctl_sz()
are inline stubs that return NULL.  rds_sysctl_init(),
rds_ib_sysctl_init() and rds_tcp_init_net() all treat that NULL as
-ENOMEM, so RDS refuses to initialize at all even though every tunable
has a sane compiled-in default.

When RDS is built in, that is worse than a missing feature: the failed
rds_init() destroys rds_wq, but the rds_rdma initcall still runs, and
when rds_ib_sysctl_init() fails the same way, the error path in
rds_ib_init() flushes the already freed workqueue:

  BUG: KASAN: slab-use-after-free in touch_wq_lockdep_map
  ...
   __flush_workqueue
   rds_ib_init
   rds_rdma_init
  ...
  Allocated by task 1:
   alloc_workqueue_noprof
   rds_threads_init
   rds_init
  ...
  Freed by task 0:
   kfree
   rcu_do_batch

Only treat the NULL return as a failure when sysctl support is actually
compiled in.  The exit paths need no change: unregister_net_sysctl_table()
is an empty stub with CONFIG_SYSCTL=n and already tolerates a NULL header
otherwise.

The underlying problem of built-in transports initializing after
rds_init() has failed is independent of sysctl and is addressed
separately.

Reported-by: kernel test robot <yi1.lai@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202610190310.9737b2e3-lkp@intel.com
Fixes: 3e5048495c85 ("RDS: sysctls")
Fixes: e6babe4cc4ce ("RDS/IB: Stats and sysctls")
Fixes: c6a58ffed536 ("RDS: TCP: Add sysctl tunables for sndbuf/rcvbuf on rds-tcp socket")
Suggested-by: Joel Granados <joel.granados@kernel.org>
Signed-off-by: Allison Henderson <achender@kernel.org>
Reviewed-by: Joel Granados <joel.granados@kernel.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Link: https://patch.msgid.link/20261021195837.142802-2-achender@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_sysctl.c | 2 +-
 net/rds/sysctl.c    | 2 +-
 net/rds/tcp.c       | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_sysctl.c b/net/rds/ib_sysctl.c
index 2af678e71e3c6..bc97a3eecad69 100644
--- a/net/rds/ib_sysctl.c
+++ b/net/rds/ib_sysctl.c
@@ -114,7 +114,7 @@ void rds_ib_sysctl_exit(void)
 int rds_ib_sysctl_init(void)
 {
 	rds_ib_sysctl_hdr = register_net_sysctl(&init_net, "net/rds/ib", rds_ib_sysctl_table);
-	if (!rds_ib_sysctl_hdr)
+	if (!rds_ib_sysctl_hdr && IS_ENABLED(CONFIG_SYSCTL))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/rds/sysctl.c b/net/rds/sysctl.c
index 025f518a43495..968d6279bbd36 100644
--- a/net/rds/sysctl.c
+++ b/net/rds/sysctl.c
@@ -103,7 +103,7 @@ int rds_sysctl_init(void)
 
 	rds_sysctl_reg_table =
 		register_net_sysctl(&init_net, "net/rds", rds_sysctl_rds_table);
-	if (!rds_sysctl_reg_table)
+	if (!rds_sysctl_reg_table && IS_ENABLED(CONFIG_SYSCTL))
 		return -ENOMEM;
 	return 0;
 }
diff --git a/net/rds/tcp.c b/net/rds/tcp.c
index eab960d10ab08..7fae00350b404 100644
--- a/net/rds/tcp.c
+++ b/net/rds/tcp.c
@@ -643,7 +643,7 @@ static __net_init int rds_tcp_init_net(struct net *net)
 	tbl[RDS_TCP_RCVBUF].data = &rtn->rcvbuf_size;
 	rtn->rds_tcp_sysctl = register_net_sysctl_sz(net, "net/rds/tcp", tbl,
 						     ARRAY_SIZE(rds_tcp_sysctl_table));
-	if (!rtn->rds_tcp_sysctl) {
+	if (!rtn->rds_tcp_sysctl && IS_ENABLED(CONFIG_SYSCTL)) {
 		pr_warn("could not register sysctl\n");
 		err = -ENOMEM;
 		goto fail;
-- 
2.53.0



