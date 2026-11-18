Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040287;
	b=CC3H7utjLBrm59mApZ+VMG/9YbBTUEh79ExnXXhp8XXB2RGzOgdlRTuvTCza82/9HCxS
	 BAdurUMqL671tOdUCAargIF991Ubv92RX8tsm5KOpP0tn4SRa0ttTDQr0C3anaC8Ed1L1
	 rStbFHjSrcRLI03D4PQbIpA4jj2ACrJKMilqDbYIvn6r0pojUW/lSknA85mToHVQa2u/A
	 F9wS0BzafSxM7HS/jvYzaMzMIkS4/QwB7a5XerlQvab418eRvkJN2ET14+elo9psoW8+g
	 cKWtdHvcGYMRzskSuahYF2CjnIALcB3vmfM3a/cHKOyl6VUZKH09q8LVLQkZWX4zkIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=StxHXcTi6mE2OdQehm74cPmxudYsur191KqimPM+9K4=;
	b=lOMorqNXrAqHPxwuNc+L1FgUponxld7GKXtqNJTVjFkjgteyE/lQ8DmA8CBxK97mDMMA
	 VX7cfpkgAjaElS0MTH4E3+DGnZi/hhya/GgeQ0PJIg8KqBrIR2mBclXHTDtc2XiBOw5s7
	 MpxDTJKeX5JktTKlvqeYsRs+xad0G/IcvDgiN/mGg2+ZVvR4hKeRDB4cB5JI4yrzX76nC
	 QJL3R6b2Ne+5WiPSD7aCbnWwRSc5EaqdAbkJp12t4jnT/JwTcVZb35qpXgub49EdolgS1
	 Tsqr9w/P1lifqygZZM6So683pCdMwUFJHoeMtPGwRKOR/3Om0/eB/T338VSKmOHoGpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzNsmXgf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB6A9606A325;
	Wed, 18 Nov 2026 22:18:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YzNsmXgf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 374FA1F000C4;
	Wed, 18 Nov 2026 22:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040287;
	bh=StxHXcTi6mE2OdQehm74cPmxudYsur191KqimPM+9K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YzNsmXgfqAEgFeFQlPpG4e1Gcy687qeaxGkdK/r4wHQAmO+GU38DGnHeyCo8xuL8v
	 lHH9CCfOauJBxsJNu+yWVVqgBj4WA2hfAM96Xl9yoVJJufhBLr6EWZSBTDg9wnoECz
	 +5/+aw/050co2zbw9xPEOqipzGPEOFB27IZwkX5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2401/3318] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:50:23 +0100
Message-ID: <20261118150433.538997103@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6bfd1e6f26b44..b8e26e7bee1a5 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5472,6 +5472,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5495,7 +5496,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



