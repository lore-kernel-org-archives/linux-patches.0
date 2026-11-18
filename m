Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055446;
	b=vFZfxe9qzGQOWln/6mOzAp0BQ7LLVed+Dhnpysn6/OyVY/BzxSy6+jBua8siSme3iIC/
	 MIcRMS6iiUafefZ9kvI0XkqZ3sqYMOgk0Owr6zHDwyO/PvFj3K/4H+CCKwk6f7h71jwiy
	 r5j6fk6oewH5swRp7ZzBK7e+ay5q4kpTHNybmKhZ/5E8euuX25Qu0ZehSQkpK6Jwg8p6b
	 TbjEhUe1iwq7UDOS6SaHNEhFPOFUONpjQDA9xCk0ok/l2oWtaoXADEK30FbZTaKp/BLmv
	 tLg9tCNpHuK0gU+bwmFGJiADF1OcEPp0jUcMaVat4816jsqFRNrjVPPKGeC51UkXpfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055446;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eXYi0DDul3mrbbFm3mVRejuxSNNKyuXo+KgrFR5cbRw=;
	b=Ro0+tj+e8LuA23/bOrhIZEvZ8B5ShoVpXWMwD/6oMPxsq/jpYs6cjam4XqjVXrv4AUvb
	 YA7nOCvQQzA8Bv6Rbn5fTmqVhDGJyN9fnys8a8H+MuE2FDoo71JrvqXuQYYED3NCY9bNB
	 anGGC1qoogRr/7GxXm5JTiNipp4Flh1uNhTCe+j5LthdQaxZOD2rvVXJ0qOwz0H1vdh9u
	 CiX4ovvDeDHVtIbsaoMEUXHG42mHSPGSjXJPvAtHvhIACuQF5rQUvZFnDG2kX1EIo0bVX
	 YiBCY/RbsGGsvxJrELcODtrJrzmq5fvFDjVM1Q9ww62BJNforIRrOFBuDcsFqgDkg8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N96rl0Eb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E8606A332;
	Thu, 19 Nov 2026 02:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N96rl0Eb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5596E1F000C5;
	Thu, 19 Nov 2026 02:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055445;
	bh=eXYi0DDul3mrbbFm3mVRejuxSNNKyuXo+KgrFR5cbRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N96rl0EbfKXkBeOkwJ4l7ZnhWoB2BCc+Hy96ZVRTXo+h6iqlCZ0CVz8asUZC1tagh
	 gY2x/V3ZjQ6VB+N5k7azQRjDKWnOiZdXsVf5Zs2/Dvr87Jqppx7xZeamysyEEuuB+Q
	 1BlLTWrkR8zTJ+vUR6Nr6T4wJthCQvPgyXjZ+Oo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1632/2214] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:55:08 +0100
Message-ID: <20261118150117.239391399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 8caded8c3b324..015fe382dd649 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5411,6 +5411,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5434,7 +5435,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



