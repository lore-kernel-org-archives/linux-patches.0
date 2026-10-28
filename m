Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213512;
	b=5Y1nrVNQHCRQzOnrJaLuHg37ddhudnPl3UeqYncKdHTQV4nmgMpB/bRMOo9ypITg2eW+
	 vn6oFpLzbtdrpqWE1m0mxUA4QZBYJ8AYxogAHBnm6bvbzEm1jRgkPDkMPs62ym+Ne+nGw
	 TdU7AkUPC07tP7RUOdJjfM44TyjZep01yijIskNGGijaM5wdu0FD8Uv/DUiDr4f861gFe
	 noe+wUhW/oQC7pG+kDzVjoNhYSvRXPZw7U3QDkhTNTB8YUv//kZV8fexH5u0BPlO/g4S0
	 GpVdYbA2L6ZUwrEv55qUcqibIH57Cs9MWy32zn/GHH3kPhesZ/m6PIKnzgeyuB0A4lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213512;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sWyd+GXvGSbf+NF2oelY3xMQn12K1kvez4bsE25wxjk=;
	b=hSfb6zbE7uYH2R+ZPJOUjXEG99iHdiJBQYfDiiPVR0lP3h5s7hBpS+Vh8jKBvsBDR+zM
	 FW76l0JbtqVaGfpNGUm+1EAggLG3DcTzUFMpK0hX6E0eO4LG44B6kUmE56IL1P9Mmsclq
	 jzqg/779VFdYrcByZuMTwYCe0NtkyDj07/bJtM47iyA4oOpoyW8BviShsX355i7p5Xnbh
	 izxjmR2UjmahkAYhOx9RhwQFrHucgiY/9YaEe55UClu+woent6wepwDhWvZAH8VWjDARd
	 yKkaIbpy0fQ6WsREF+tXVamSu2dTB/9yY1/hYsI2VnLgAWTb7PYKUVmjQdHnmqwoqXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7ZnJPCS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795F2606A31C;
	Wed, 28 Oct 2026 18:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O7ZnJPCS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C816A1F01825;
	Wed, 28 Oct 2026 18:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213512;
	bh=sWyd+GXvGSbf+NF2oelY3xMQn12K1kvez4bsE25wxjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O7ZnJPCSrQzOvnuz1K694/MuGPUZhPSZ3H/EgnQmdZGm9FqfjipOZNFuBz0e9z6Vi
	 6JlE71l2XzQnIgHqJF5tED5SJzRiWgDEhCSay/6qi51env/UMrsg24tdbLF39iRmJC
	 Rlk3huJB3M9HB0/ggLxfHKjpYnu03//k5Ss82loA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changyul Lee <lcy8047@gmail.com>,
	Sang-Hoon Choi <csh0052@gmail.com>,
	Ayush Sawal <ayush.sawal@chelsio.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0489/1887] cxgb4/ch_ktls: disable softirqs around tid_list erases
Date: Wed, 28 Oct 2026 17:43:05 +0100
Message-ID: <20261028170510.399150388@linuxfoundation.org>
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
index da9973b711f49..b2adb15812368 100644
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



