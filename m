Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211490;
	b=UrkvLeMvMCu1/ByvVAOBa+wC+SfjzhTeG4QrCWJah1WzHPMElBWQ9LnW8WmdMBHZ6X3j
	 n6eQULpp63SFw6vAnUtl5b+RKn/n6xaWdiMNH4w/6lZCSuBQE/oXN/PX4kB1fZT1buJuO
	 yFAk8XQHrjaRtzD9hU/9i5XO/N+1yzrrNuGrrQa6jO1n5emoBE+KLKSkqDltax7bBF7qJ
	 R5YbR4RlSTuhuGwzqPH55J/l0vXtCdrRYdMqfjJcaNQTKYWa6jQFL94wodTCqg9dSTWID
	 W4ei4l00cEkab6dU8mDYmV6tjfsG7SBAoRQHWzA6YfbGxCnFNmKxq8gJm/d4NxEKf4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xazEXj5iQM+/hq2NpKPY1Sg0Az/9xlV1CuKZQTFq4nM=;
	b=KlSSJs/L2Niub3544Wu9QWCqLtFOc6HAj99G8rF+D3g0axfWDQ6JdVCrwB2YsSG/9Y8B
	 2c96cwbyPrMcYxV+VPNcXliqL6PyoXeXJFgsDDBycUY8A9R/kdkX9erTpMze+yjDhKxiv
	 EmbGVuYjY0iSrYfGAU2p0cnRDUMk1/MfzRrhTi4KBzV6zbbX89k2S/B3NhJDPdSzWB0Jz
	 x0+9NB9HNqoO17SHsXgeoVxNE4CqSbTH//WwiN4CbW6aacNWyDrMbtkuRZnzET4e6fo7h
	 xKKY02ftneCY5tvvWwIbowZs0koPF8sBOyPZIQ1O0RqQ748Fr9CIpA5SISnsYe3rQ+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSzQ2Z3S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47909606A31A;
	Wed, 28 Oct 2026 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FSzQ2Z3S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940851F01825;
	Wed, 28 Oct 2026 18:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211490;
	bh=xazEXj5iQM+/hq2NpKPY1Sg0Az/9xlV1CuKZQTFq4nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FSzQ2Z3S8yjeP3G6GzJa94aOoMRFndk8ZzQ7HzIxNVh1tpfmUwCy6WhCOaoLwPa8b
	 1f+wOnBQHdRGSYvCHiTANbrpm5hiRXnCzUiKcBwDWLLkVoW4ktS/wJHVeLJgo4qYa5
	 8A6STdPsHW10QPJdh99Ub8BVmVLumXiuaXS8+l2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 395/571] cxgb4/ch_ktls: disable softirqs around tid_list erases
Date: Wed, 28 Oct 2026 17:59:02 +0100
Message-ID: <20261028170017.386211008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sang-Hoon Choi <csh0052@gmail.com>

[ Upstream commit 4c9dc0faca98084922caeb689579d338cf3e1c29 ]

chcr_ktls_cpl_act_open_rpl() inserts into tid_list from the receive path
using xa_insert_bh().  The array is shared by the adapter's connections
and initialized with XA_FLAGS_LOCK_BH.  However, chcr_ktls_dev_del() and
the chcr_ktls_dev_add() error path use xa_erase(), which takes the XArray
lock without disabling softirqs.

When cleanup runs with softirqs enabled, a receive softirq for another
connection on the same CPU can interrupt the erase and spin on the lock
held by the interrupted task.  Use xa_erase_bh() at both sites to match
the insertion path.

Fixes: 65e302a9bd57 ("cxgb4/ch_ktls: Clear resources when pf4 device is removed")
Reported-by: Changyul Lee <lcy8047@gmail.com>
Assisted-by: LLM
Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
Reviewed-by: Ayush Sawal <ayush.sawal@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 59683f79959ce..1bf0079f909b2 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -390,7 +390,7 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 
-		xa_erase(&u_ctx->tid_list, tx_info->tid);
+		xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 	}
 
 	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -581,7 +581,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 			 tx_info->tid, tx_info->ip_family);
 
-	xa_erase(&u_ctx->tid_list, tx_info->tid);
+	xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 
 put_module:
 	/* release module refcount */
-- 
2.53.0



