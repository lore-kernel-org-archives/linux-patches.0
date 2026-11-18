Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024646;
	b=fTrVaPechFY8f4vgR5I5kiD1K+8WmvK2T0ueu7sw4ODtm5FyfSOZJKcwxAjdZMru8wJy
	 IwMDaCCOmMIRW16EqJewPiHEUtq0tbKSFOKWAWhrlGEXuOGOYRI1EwGX1nHaXKnWex8J3
	 i0bXRsSpXbjOK7ZgLBJV8mDhAxg938Et6MKmSoPs0PvnPksLJrQ7SsI+I1RsVoDxiJQjE
	 n/W8BeV5DhnJ/pFHFAXrjd4xrspczY6Bx30FdzXc7Wp1XEplRSQe97SmcoEvpWzZ7kSCN
	 OgJydVs7ED4iflIMG8ui1AyIpiopDuUL8mSzCy+bHpIa05XatGrVFrUxQUiWM6pcrxQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024646;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=34MScFbkG6em45r91rrI7cgmEFRWAOFQM8uI+Fop/mE=;
	b=A6w6N88Xexs2pRNF56zfQ64qQU0QQzkZqJsJ3QZePzf/hCuB/Fhqif9OmAH8PqRtxfYF
	 EA7rbQiMtdhwkyLZ+xyySDkWRlU4KYQEWWR7TOeZ5BirkGAJys3aCmLnZZd5uTO8KHUeF
	 OHVelWVM8Ycmz1Tekl4MZRP7VMecOWMX5t0JB0q4sQKQESWBa8cGl/E95AMP1tjk1e7MS
	 71ZUQ5PbsCGFbCmmXoqY7SJ2jtlTCeD0yc3ZwZO/zBpxdfkeDlY6Fmj0kgC+07V6Pr5lX
	 Lq5hEwFRu4d//YZocG78rfFUpi+QBJdabZEUtb4RUYqRivFOH4uYbhOxi+oskkzc7uQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUfL7wIX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BF8606A31C;
	Wed, 18 Nov 2026 17:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OUfL7wIX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AFB51F000C5;
	Wed, 18 Nov 2026 17:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024645;
	bh=34MScFbkG6em45r91rrI7cgmEFRWAOFQM8uI+Fop/mE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OUfL7wIXiP2XCloSApaLUFteIaZJ9RWGD0aSQ1eFM0lLW6xSG9AHKfzPqaH+vgEgL
	 WZqueLidRRC6pDmBwL8WvNnYBh8S5f7scks1NR1kccVmAr7OHN9MvliZcyswdUOVZQ
	 btkwIeNtF0/GsUE5Y8/vmySkPwIle0VoqHAFViAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0799/2151] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:42:14 +0100
Message-ID: <20261118150151.180840524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 3168d70315c78..1084bf154e0eb 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5502,6 +5502,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5525,7 +5526,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



