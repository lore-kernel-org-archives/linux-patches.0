Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061066;
	b=wKE/n8E/8/CQzcKBsKXExFgfDTbH2vixXsInaoB09i+BnNeY+KZWPo8rMFhIIh9u5kYE
	 GyMtVVZCT+g5kFM19xTPS2Ge5izI7hM4HX6NPAyo5HD+QztYk/gIbgfr1644KF4uNwtUO
	 RUKEvFs3ZeqW9dlH1G6T6asjS81rONkOxTugF8tlLJDjuTEuwVGrBxFOSP4Do9zAwynC1
	 4wmMHXrb0GbZMVl2mY/QqQrxjTI8n5unafhHS6AvdutwLoVSZa8C45L+pmEzyya3qz7eF
	 ZaY1JYOQb1LJad1Ins+AiH5s/yh5Kxw+Z0KlTdM8HHQ4fO1e3BSiM6DMKYOILOJmmZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0sxaU2KsSOlLsyqCBEpr1BGht8jvxC1ZKJOBUt7oD7I=;
	b=ssK4meDZQhUv2eB5Y5eB1VXzGT1Se28s9uLZ5d3BhWdro04lSjS8j3q+L4Hb3s7xnw0i
	 4WhlfGaxQaJHlKDEE9D37nSavNAopGhIWUJb9nfFU2KQ2YK8W6tQI9bPRXOTjFPof11wL
	 sAH0x3nWyRKA93Nb2cRu74n22YaNm3aPTr5pvQramk28oUcEH05pykGdnXUg4ZeEl8Vco
	 yZOgHscKc6R6Sfpo9SKJ8dDuD6I9YqkOCc0bjyumNyDrALNjkKHXz6PGn1kv/JqLQPOkl
	 N2MBEMOYfVS9wE6a2dSzAb23blFsFVhoM/ha+JsqqPIMJl8/Qiu8OJYtRYZVgFtLt0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oo+JErSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7669606A325;
	Thu, 19 Nov 2026 04:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oo+JErSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB381F000C5;
	Thu, 19 Nov 2026 04:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061066;
	bh=0sxaU2KsSOlLsyqCBEpr1BGht8jvxC1ZKJOBUt7oD7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oo+JErSErxON4smuPcyaOpmu8+7apDxMu7v1Z9O4lKNHX8c7x15yq3m8RftUtldMx
	 90i84+uHw5l+SIpRJJTdSUOg26fQSiB01IJhxsnvPx624uiqF2hIt+bKVZVnUAoiDp
	 Ss6+S3gx7zEfuazQPtGfoTc2KTp1VMdspq43/s+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1379/1848] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:56:57 +0100
Message-ID: <20261118150017.228935480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
index 0eee841596049..c51432d91d74f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5131,6 +5131,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc(sizeof(*rwq), GFP_KERNEL);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5154,7 +5155,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



