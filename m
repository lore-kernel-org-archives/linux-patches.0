Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017588;
	b=dYzAOkADOV6SrvMclJGuPbezcesk+lZ1LD4IvWzc5qQ2tFEZlrIBSICxTSw0ShGVZGap
	 +F9q23KOl6Lzari2aPtGy/Ht6jA8QNerPQhzN8QyVWNFkQuCvYidjjTIQtKF3cTeRVAlD
	 YE329Z/fnJffv7H0jDlLhCVlvIcBXjgAL7jPhWgKGaC5XfuMyOTPHjhASvopDavQ3mMps
	 G3pB0B6HwGpyWfRNPjO8gA+ihLqjeLp3Z0ec0bk48671/GyXppb8O1xZ2bR0zQKab29/Y
	 TuzlArksnsTJstXIWiSAafuYj/hNaQJorP4NpCrm9Y2XuXdsJS9ayiL1fo9VTXP0fwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BSVkXlP8rzx3wMyMJciAOZs1jy5mb5HpXZP2nbJm7Ek=;
	b=AujjurhLSGJ8g3typWP/8Iw2dM7ldqFCxzFA1wwCBHNrNQy0IV6/XApvO0y/c/GRug8u
	 Ixa1u1bFo5thMipGWd2ofhWy6O/OdBG5377bgUYEPdlPJlGp/KxM8ae9I2KTDilqDoCF8
	 DKBHZh4Evv9eEsKmenEi8ImcPOoPyOpu+XJ6GUyIip/2t81MI/BUdfv2M6SvZ3jZy+w3s
	 kM36/q1GQTdMQLNXBStU48PYkFGyrdJMbMoi6lPaqq2PXsMTzR29vzoBaAVFAYPRkZleN
	 7FezvInXqj0MY+GxcbtziBM0JAsC+xeCAuKbk31krVUMa4Nn2j6L+lLMbB/UpQkCHTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT14hXeM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33B4606A325;
	Wed, 18 Nov 2026 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mT14hXeM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 308131F000C4;
	Wed, 18 Nov 2026 15:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017588;
	bh=BSVkXlP8rzx3wMyMJciAOZs1jy5mb5HpXZP2nbJm7Ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT14hXeMGu+KBL8g+VUZ3naQfxJqeYwdrxOA82VqZ1pSQ4fTfyOl2WmZuJM5PBmyM
	 NKh0G56xOhwJqphjUxPJTfZxaMUwxjgWgXHHxHd/fKqddkJvdTa135TDRWevg5cPWD
	 I1XKHRGGJV4Xi4KtiO5em+4N6I4WtvjYFnyMQOq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0938/2651] RDMA/mlx5: Set WQ event handler before firmware RQ insertion
Date: Wed, 18 Nov 2026 15:36:18 +0100
Message-ID: <20261118150321.653448274@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index fdc33fe589fdb..a19572bfaf8af 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5619,6 +5619,7 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 		rwq = kzalloc_obj(*rwq);
 		if (!rwq)
 			return ERR_PTR(-ENOMEM);
+		rwq->core_qp.event = mlx5_ib_wq_event;
 		err = prepare_user_rq(pd, init_attr, udata, rwq);
 		if (err)
 			goto err;
@@ -5642,7 +5643,6 @@ struct ib_wq *mlx5_ib_create_wq(struct ib_pd *pd,
 			goto err_copy;
 	}
 
-	rwq->core_qp.event = mlx5_ib_wq_event;
 	rwq->ibwq.event_handler = init_attr->event_handler;
 	return &rwq->ibwq;
 
-- 
2.53.0



