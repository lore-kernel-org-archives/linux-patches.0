Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055451;
	b=S2y+425X1568logYXkaXNODfZHxfoHMIxiZ/ZvMew07QZxWYmPHRLpMHM2CeCN9V1Mzx
	 ZKg9MpA0VyD2tLfd6NkXG/E+rU0GYevXQDqaFxYtrWLLG7pbV+IQ4jr+blINt83yFjP7G
	 eJ6NRF+mSL8bFTMh9msrvmN9dzbYOgKGseiXmk43IMT6OosLs7X/o5008ddU5ObEtFHKi
	 9CvE82gAeyg2h8Cku40QRnzXuJnNkGyZRMWByzSbj2V400e0ab9ZOFuZndroLuddQud8y
	 pZxKcB1DGQryltRVxIrJoH6ONT1qdNC3xJhoPSLj9pNK3Qkl7cp12JtzUhFyNJ9r/CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UFVIziuDfgCtCzQlHXiKEReLmU1QHzh2qLRIrHB/TG8=;
	b=Woycw3UXTQ/i8JJBnauGDsZpLVIBQaI4MAqShaccBjeGoPyDZcE8MPA7GiCigC4pujoC
	 83M2ASG5YDH0G47swhkfqlp8AxC9mL14J87OZ+iDEdvNZHzLGrupQd2nDOBInTWZLVy1H
	 msZ+OsYN2pQx0LdNgFSEiw8jO/FR8Fzw2ffvDqJRD/TnqHRY1omf7IKMgbSToUYRCfvdd
	 +M0XLQIfaleubU3MKZHI8FdLi+/ZwEnX/DEpNPdHoIZQBmJEomC4AFG0UB4agxr76IJDQ
	 23WAnJ9IzIEaNpGM/0jxQ4b9Uycux0sunUgh0KYrLVSS6WHVkIn0/6Aqyb2kRxkuuow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZSVAB7Ym;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3765606A32A;
	Thu, 19 Nov 2026 02:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZSVAB7Ym
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFCBA1F000C5;
	Thu, 19 Nov 2026 02:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055451;
	bh=UFVIziuDfgCtCzQlHXiKEReLmU1QHzh2qLRIrHB/TG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZSVAB7YmGhGL58nGshLXCKVIotCp+XTZqT2uAI9E4qFApRrBTYu2c95MLthWssK1D
	 N9DiJ5wQvf2wpFaamD1NdwYNTspFgAWd6tsa+Q/OZdTUaUlTM3m8R1t7xly0VyLdHO
	 KiGCcWEC1i+5VR9K6ZMy14MFlp3UgV6iJ3/+0tIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1634/2214] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Wed, 18 Nov 2026 15:55:10 +0100
Message-ID: <20261118150117.312481416@linuxfoundation.org>
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

[ Upstream commit a4fa6497002c80b55ebe597242a1bba2ff268886 ]

create_raw_packet_qp() creates a separate firmware RQ object but never
assigned rq->base.mqp.event. Any firmware event on this resource (e.g.
WQ_CATAS_ERROR, WQ_ACCESS_ERROR) calls through a NULL pointer.

Set the event pointer before the RQ is inserted into the resource table.

Fixes: 0fb2ed66a14c ("IB/mlx5: Add create and destroy functionality for Raw Packet QP")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-13-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 015fe382dd649..73c954982f41f 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1568,6 +1568,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	if (qp->rq.wqe_cnt) {
 		rq->base.container_mibqp = qp;
+		rq->base.mqp.event = mlx5_ib_qp_event;
 
 		if (qp->flags & IB_QP_CREATE_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
-- 
2.53.0



