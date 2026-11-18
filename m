Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030216;
	b=w7raMlcq0IPIMv+S6K4vGugV57qsvg0pwitXgfMicc+zv82XvRbHksADxZ3a054di2UD
	 JoON/PFKZkhcYP/EPJEj61CSBnb/gfG0B+jdu/wR00WZ8HkGZukMgYnmY7JfL2M/WbH18
	 FUSocznTT90HD32H+ucsiq47vRCGBmt7LKARQKHy68CWXgUutaCiM3PUkVGq5p1k1bsqJ
	 jLYlTuzJlltf+kdlsN4JhK8SWeXzWb2/iMNU9izey5nkPXXr3mRXKhtujiptqwgh5KV+Q
	 QPJWBsc+gzzlYcf1p+cDWPeyiIKGt9JQPBLUqiFWXqD/qhd2QJSdxHmaMdFHPASob6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ILbZTfHx5kLC52SdLFy5RRqeEhvJaKSzsH/VlnP9p+g=;
	b=AkZrefl2n+UIehPSo/W1Q1zYDKwFfeuHFNq7fHG2tBVBjhPksjWIvBCSrHkpiZL9ixaw
	 TDYootW4tGHIQQcHXz33tZGHcMDxFjbZlHlWqaGj3nLwtFGRj9OfaUizfgsZ3HvPRGgAO
	 QiJ1ELY9pMa4ktCYBbVEe+yjNn2ieFeady/f2FqBPMYVv57J7QozuqZRb2NA1OWENjbPd
	 TUBeuocN2PWFt0zzWs70U0Kst4PeRN9chk3UdW/m4y8MQn+OqsBcMzJUFvy5R5EmH+KIX
	 j0T6JGJN7IVn6tFoSH2oQwbch/Hxg+0CILoMcVlygb+9HoM5yP+XGk+SlhtDivon0Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l41NB4uK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA35606D377;
	Wed, 18 Nov 2026 19:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l41NB4uK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2D11F000C4;
	Wed, 18 Nov 2026 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030216;
	bh=ILbZTfHx5kLC52SdLFy5RRqeEhvJaKSzsH/VlnP9p+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l41NB4uKQ2WCb9ccbdO0WihkCchM0kUBFCag2xFTv8d2qkbddAMHqgOHXTI8dcQAt
	 avUt7Uz+qPcixSs8skDcSa4x/CAKqmwI1aROWcvUQGWT1lKpK3uLn1WqbxAzp9cIYB
	 mJDdjBbkWMPxUHJgeF/uHJSut0N5GRGzxym3IbRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0626/1756] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:45:53 +0100
Message-ID: <20261118150033.808074649@linuxfoundation.org>
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
index 6259eeb6f9776..44c16bbe3cc17 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5461,6 +5461,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5484,7 +5485,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



