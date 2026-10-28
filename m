Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214085;
	b=Qf/i3FsjUFvtnjYhgK41S63sNgmdkQqzB20O0wZXaUf0xGcJQgnl2MA38x8ltkPmG8Kd
	 5XdGD9XShQr1NdWhxWe7h1EGB7PnnCbBLlH10NdyM8Q/Nm2fU71THZewnymvwU36i4gQS
	 pNga6JYzmFZ3xFPTUL/kRee8PFqdF3Yy/BYDv8nwpuB0qJStwSq14XHhBJo6A817ugYO8
	 S6e7txua5qb0CiyfKVkHDvZbYteB4pPbU8r3Mpf71jVkvTh4bnq35oc3YTX5YBRpJA2Hz
	 b/wWMaiwtTzxErmOufCHJRTcYr7wWqU/LDk1QxTQfre6vwq5UqqJwXRkANGXJVzikNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O7XQ9nAW0LQfC0GnURnaUnQhSpr+55TDLeWRH+ziiv8=;
	b=IqWdTSvHqmHQl6QSbn+s29ts+/qmuI9yLADgYXieUuKbL+9DIAp+AjQ3fy+Sy8BB6tzq
	 PU2ntVXem1G419KpQnbDK25apaZzsk3QDYTqfUi98NkeDg+RGFuwHDSHzC9LtcEqStTXk
	 2MOVpuFdWKKMoy+lR3BiY7CxubKPs1apfL0rf2wDNO33IXXumoMVn4TlLABmBGlpdQEgo
	 eyI3b9/B+AuXbY96GrKO4APrxFHI2+yXTMtJCfyWQ92BF3t039HL9jcjjI0eQ196/HXoL
	 IkoVggc3pDqwlBpBBMXTBdNIk5LAaIvAbXulglxEtEZghc4NHKp6xuTm677uW7wCiHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhzaw9qs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3167D606A31D;
	Wed, 28 Oct 2026 19:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mhzaw9qs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848D11F01825;
	Wed, 28 Oct 2026 19:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214085;
	bh=O7XQ9nAW0LQfC0GnURnaUnQhSpr+55TDLeWRH+ziiv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhzaw9qsxFKi5loeU3mwUeQBctN0tybZcdKsyPUYt/xY5ukCmEUnjBLtSPIPyS7zQ
	 zZC8ZUwC9k9Q9TFPA3k9g1OuNj6Blzo9o/hYUacb/lvwyw0/wKIKV6e4yzOAwF0Ue6
	 soErHkIuUsW7OxKfeDR5gCv2cUId5xjkPucLQXQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wen Gu <guwen@linux.alibaba.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>,
	Alexandra Winter <wintera@linux.ibm.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0717/1887] net/smc: initialize close_work early to avoid warning
Date: Wed, 28 Oct 2026 17:46:53 +0100
Message-ID: <20261028170515.751556315@linuxfoundation.org>
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

From: Wen Gu <guwen@linux.alibaba.com>

[ Upstream commit 0541db8ee32c09463a72d0987382b3a3336b0043 ]

We encountered a warning that close_work was canceled before
initialization.

  WARNING: CPU: 7 PID: 111103 at kernel/workqueue.c:3047 __flush_work+0x19e/0x1b0
  Workqueue: events smc_lgr_terminate_work [smc]
  RIP: 0010:__flush_work+0x19e/0x1b0
  Call Trace:
   ? __wake_up_common+0x7a/0x190
   ? work_busy+0x80/0x80
   __cancel_work_timer+0xe3/0x160
   smc_close_cancel_work+0x1a/0x70 [smc]
   smc_close_active_abort+0x207/0x360 [smc]
   __smc_lgr_terminate.part.38+0xc8/0x180 [smc]
   process_one_work+0x19e/0x340
   worker_thread+0x30/0x370
   ? process_one_work+0x340/0x340
   kthread+0x117/0x130
   ? __kthread_cancel_work+0x50/0x50
   ret_from_fork+0x22/0x30

This is because when smc_close_cancel_work is triggered, e.g. the RDMA
driver is rmmod and the LGR is terminated, the conn->close_work is
flushed before initialization, resulting in WARN_ON(!work->func).

__smc_lgr_terminate             | smc_connect_{rdma|ism}
-------------------------------------------------------------
                                | smc_conn_create
				| \- smc_lgr_register_conn
for conn in lgr->conns_all      |
\- smc_conn_kill                |
   \- smc_close_active_abort    |
      \- smc_close_cancel_work  |
         \- cancel_work_sync    |
            \- __flush_work     |
	         (close_work)   |
	                        | smc_close_init
	                        | \- INIT_WORK(&close_work)

So fix this by initializing close_work before establishing the
connection.

Fixes: 46c28dbd4c23 ("net/smc: no socket state changes in tasklet context")
Fixes: 413498440e30 ("net/smc: add SMC-D support in af_smc")
Signed-off-by: Wen Gu <guwen@linux.alibaba.com>
Reviewed-by: Wenjia Zhang <wenjia@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/smc/af_smc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 35cf30486916e..71ceaab9b6dd3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -406,6 +406,7 @@ static struct sock *smc_sock_alloc(struct net *net, struct socket *sock,
 	sk_refcnt_debug_inc(sk);
 	mutex_init(&smc->clcsock_release_lock);
 	smc_init_saved_callbacks(smc);
+	smc_close_init(smc);
 
 	return sk;
 }
@@ -1277,7 +1278,6 @@ static int smc_connect_rdma(struct smc_sock *smc,
 		goto connect_abort;
 	}
 
-	smc_close_init(smc);
 	smc_rx_init(smc);
 
 	if (ini->first_contact_local) {
@@ -1397,7 +1397,6 @@ static int smc_connect_ism(struct smc_sock *smc,
 	}
 
 	smc_conn_save_peer_info(smc, aclc);
-	smc_close_init(smc);
 	smc_rx_init(smc);
 	smc_tx_init(smc);
 
@@ -2430,7 +2429,6 @@ static void smc_listen_work(struct work_struct *work)
 		goto out_decl;
 
 	mutex_lock(&smc_server_lgr_pending);
-	smc_close_init(new_smc);
 	smc_rx_init(new_smc);
 	smc_tx_init(new_smc);
 
-- 
2.53.0



