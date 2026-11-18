Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048688;
	b=pqzzUjkO2GaUSWvcG1144Yq8KOb+lSYCYfNWX2b1sBOKL3fuNn2wliFqtw+WnldDbJ27
	 ipH81G7qTs7MFlsVj9BNyg/WhnMYtYEj38fe9GnQl9XZZRQMCJvXLjgQ9P/LPXbnmNkyE
	 mjFH+RDDoVpRt28kckw7zNMQsd6+pXq2h2gQF5VbziU8HLVeaJGhKFFQNc4rFDZvn5hK9
	 iHyAdJdkPQn4e35ijXcgNEmuEkDH8vlwFLbqZex9Y+W9vflxweQ/EeCbLiEyp03toif/M
	 RhlbeSTvDSWL1zBNZLTwQCPRofByWMzXPUhFyMIce4pXzqOdvDJv04+EO6KUeuqBV4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kKalksv5KlzntumoelqCxyhOSW70s0DPMADtV40gZhA=;
	b=VReUToRgt7PDHB0cokN2plXKHjYwxvuQdm9PVVMql8ilzvWnzG51UDfxJA5wgacnfE1g
	 dTvDbxVsPJsQt1rOm7tJLycO9Po8jkiu+qbAsnoR3dhFLL+mGZXl0JJUB2vNV53zo4B3/
	 CesRRq8so86jkccWhjY65oU6S1cRKszz2tSUP8lAs7UcQJpj0OQWK81rxhEg90k+op6Wa
	 mI47o+Y/pmQ9Cw2a2mEDgLo5A0ERY+PsQGjrDG0BIVVgBRyg+cAeuqDIOEdnOT9SwlKKj
	 j0n+IDUhzj8V/TlYHnxBUdRLmRDSY3wLO7S2REkVcTmJKSpEHj2J9Ny6KJ5ooj8W/nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MPPvhm2i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A71C2606A33E;
	Thu, 19 Nov 2026 00:38:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MPPvhm2i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064CE1F000C5;
	Thu, 19 Nov 2026 00:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048688;
	bh=kKalksv5KlzntumoelqCxyhOSW70s0DPMADtV40gZhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MPPvhm2iZLkmyc5LRtQi/IHf+zjNv8XFLtYABxg4Ks25ZO6OCuXsQ/RQhHLDVvF9K
	 Ih1WFKHdCOe+sNSdj2FmI6H4wCaZT7UshrEeydgqtQgXeH2TuknzBK7HhJXFGBFIDs
	 PRhyWKqMkQR+du43b2OVyOHg1yCzx8j8nJ1gvZJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2085/2857] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:51:59 +0100
Message-ID: <20261118150316.480489548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 28c559d1e25de46bb6dd39e6fa1e93ea6abdf1f6 ]

create_rq() inserts the RQ into dev->qp_table.tree, making it visible to
rsc_event_notifier() before rwq->core_qp.event was assigned. A firmware
WQ_CATAS_ERROR event in that window finds a NULL event pointer.

Move the assignment before create_rq().

Fixes: 350d0e4c7e4b ("IB/mlx5: Track asynchronous events on a receive work queue")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-11-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 24fcfdf30c602..ea3540fe04a53 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5417,6 +5417,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5440,7 +5441,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



