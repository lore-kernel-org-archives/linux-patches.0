Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209114;
	b=4clHv+MMBsdWdxCg0BaPyUxGDyfq3mdC8zC0YyXvtTYxfWWotnDPq0/RRCw7wKlpmrVT
	 yyX6I2323ulygInQmNL9p/3sCfVpgc6SP9hgJQrdhAXgS+RtV2XDlzKY1Vyz8G8POdUB8
	 NkScRa8S0DGzhfvMckGjeXHV+xOaIrYCPd2e6Mpf+Z6BGQio92amnlcYUjzg+XboFXjGq
	 9bC6fIf0hoUpxfh3eUrOS/lger8fq/obgZgMcN9WD86b4sKOqpULFYAEmZG0yCj3TyWbo
	 eePsvD+gGuRtR2NQLiMuT7loLP05didhzUB5OT9x2lb9cZGU9zl09m7jX7i7eOgk4mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209114;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xOr9zD+I5CAdub9i4LiY/t4p9cQshUvGM2P90+Yp3hg=;
	b=3+xbfYgTRMZVWZzKmhoMYsfg1nyFuZRJKIN7jH64X1Q0UoaJVk3vSuE0LTK4HLs3QNAd
	 7azmHBaCDVY/282daKjZFBllSUlDGuXbnzpyDqvw0IGk8KsFXAkqq/sMngmqC5gMQJTcA
	 Sc148urQIbGKWRwfdlU17K/UH0lfIQJyeF+UvqbQjpmRU9UWjklnC0Qe+j2WkCp8XYQ3S
	 CwGUJM4wDEMtAJYK7yzJ+cYEhO5m2nrNNrPI5qjYs175vvZRGu3T4oTMizmOB+qFs/HEa
	 dw3ZrgblVQAnDIHcZriMPtjnCPWWIBtK54XPc1W7lnlJyHy184cFa9RswgroTsCOyZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wb1skH0U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ED5606A31C;
	Wed, 28 Oct 2026 17:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Wb1skH0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDB41F01825;
	Wed, 28 Oct 2026 17:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209113;
	bh=xOr9zD+I5CAdub9i4LiY/t4p9cQshUvGM2P90+Yp3hg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wb1skH0URxvYhQIcyEPIAAQwe8glmhAfqQEq7M5DztKWgpL4ltcLTciW1ZZtDRm7z
	 F3OJtOl4ckmT3HjQ/VXn8vt5EDoCdxExdBgW6UvAJwxqdPCU+zGLTe8vPUgspe5Q2E
	 TwbGUEDt55GTpUZX+ZNa3I+4la0oD5qCDrfpTF58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 356/516] cxgb4/ch_ktls: disable softirqs around tid_list erases
Date: Wed, 28 Oct 2026 17:58:28 +0100
Message-ID: <20261028170011.921486929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f9353826b2455..bc98388ed28ea 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -396,7 +396,7 @@ static void chcr_ktls_dev_del(struct net_device *netdev,
 		cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 				 tx_info->tid, tx_info->ip_family);
 
-		xa_erase(&u_ctx->tid_list, tx_info->tid);
+		xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 	}
 
 	port_stats = &tx_info->adap->ch_ktls_stats.ktls_port[tx_info->port_id];
@@ -587,7 +587,7 @@ static int chcr_ktls_dev_add(struct net_device *netdev, struct sock *sk,
 	cxgb4_remove_tid(&tx_info->adap->tids, tx_info->tx_chan,
 			 tx_info->tid, tx_info->ip_family);
 
-	xa_erase(&u_ctx->tid_list, tx_info->tid);
+	xa_erase_bh(&u_ctx->tid_list, tx_info->tid);
 
 put_module:
 	/* release module refcount */
-- 
2.53.0



