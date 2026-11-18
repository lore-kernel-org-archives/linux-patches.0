Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024643;
	b=S6G4fk5rbR4TbPj48dIXEMmwRBxVSAZwj1vS/fpe87q1karY3hyOt5JSkna+AHijHpwM
	 eATOFjJaS2yIF9oqf+ImArXv+0JdLrvG9TYreDS73VPcnJxOYZ+6JT1c7AuCh6tffQeTX
	 C9VJPxc8BwtEvtlV+04wYzC44rzpaswlgRB7KHm5qkgGT3FktlfuTvmo7ijqkABpdjuIz
	 IRw/79ImsSVZ2pWLCIwllhqXLWh7+0dOwp/dCN17/+CoZQIc4jRBhwwLwV55QkOu49Tyf
	 9BM1SflxPj4EM0nwAEP63T5gkTH/kShsexsQ1tIiSPsaN4NwGANdZTPOl2FmXp6PhsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024643;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UsKotakCEAaSaYKWppGY4LsZkqFF4GRM5N+DYUkfkJs=;
	b=NDqLDMsU3Vaew0ohUm10DOui4kwy5LKqtI6RGMn2U1h/Tg/dOFScRAbT7Kje4trBWNNq
	 wCDhcxVSl49M0TsUXqniBG0qUW1wdltr3y0bhAfeTpphbdHTWaXg/WW7yq6ZCGqexTyQY
	 PHWAVVGmyAkuwEYzCH4FGcKUt27SWuvo1Gx4ReD9CAxsvg3y5lbLqWlIMpukJt3kBYEt0
	 jqSHXT0BUjVDirMh9lP/SHxl0RTGCKHe3vLKyfWfNJ0R4mMWnMOUwjnVIA8JDOqRGa4aV
	 c4UWmULg+9P8xp4Xs3EEBOG2KBWa6OIlniVxX/8cbDZOVIQkVyKa/lE/feyb/5V3LIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1vkGIux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A6DA606A325;
	Wed, 18 Nov 2026 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p1vkGIux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804EE1F000C4;
	Wed, 18 Nov 2026 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024643;
	bh=UsKotakCEAaSaYKWppGY4LsZkqFF4GRM5N+DYUkfkJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p1vkGIuxxMsu6paoD6nVwHG1V2d3n/lTVV8Ei7PeCKnc7cWGuHs8FXNAElsTyiOVR
	 yZMMIc25fZ5zHz2EZDPSSHz1lMivzSwfT/jpRyetOpBwXLjslzaYP0xMwx/6f4378L
	 M2xt1a8La7OmBhwKEsYd4RDzJxPZA1W7vtKZdhqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0798/2151] RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
Date: Wed, 18 Nov 2026 15:42:13 +0100
Message-ID: <20261118150151.151688499@linuxfoundation.org>
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

[ Upstream commit 4354ab7a85d1ddd45a8a3337227fad5b37b44902 ]

mlx5_ib_dev_res_init() returns -EOPNOTSUPP when the firmware XRC
capability is absent, failing driver probe on XRC-less devices.

Make XRC optional throughout the devr resource path: initialize cq_lock
and srq_lock unconditionally (needed for every QP creation), skip xrcd
allocation and the XRC-type placeholder SRQ (s0) when xrc=0, and guard
their cleanup paths accordingly.

Fixes: f4375443b786 ("RDMA/mlx5: Get XRCD number directly for the internal use")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-9-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 56 +++++++++++++++++++------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 3dd100cd91565..31e36ab9a1316 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3272,7 +3272,7 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	struct ib_srq_init_attr attr;
-	struct ib_srq *s0, *s1;
+	struct ib_srq *s0 = NULL, *s1;
 	int ret = 0;
 
 	/*
@@ -3290,19 +3290,27 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 	if (ret)
 		goto unlock;
 
-	memset(&attr, 0, sizeof(attr));
-	attr.attr.max_sge = 1;
-	attr.attr.max_wr = 1;
-	attr.srq_type = IB_SRQT_XRC;
-	attr.ext.cq = devr->c0;
-
-	s0 = ib_create_srq(devr->p0, &attr);
-	if (IS_ERR(s0)) {
-		ret = PTR_ERR(s0);
-		mlx5_ib_err(dev,
-			    "Couldn't create SRQ 0 for res init, err=%pe\n",
-			    s0);
-		goto unlock;
+	/*
+	 * s0 is an XRC-type placeholder SRQ used as the default XRQN for
+	 * XRC QPs.  Skip it when XRC is absent; all devr->s0 accesses in
+	 * qp.c are inside XRC QP paths that the verbs layer blocks before
+	 * reaching this driver when xrc=0, so NULL is safe.
+	 */
+	if (MLX5_CAP_GEN(dev->mdev, xrc)) {
+		memset(&attr, 0, sizeof(attr));
+		attr.attr.max_sge = 1;
+		attr.attr.max_wr = 1;
+		attr.srq_type = IB_SRQT_XRC;
+		attr.ext.cq = devr->c0;
+
+		s0 = ib_create_srq(devr->p0, &attr);
+		if (IS_ERR(s0)) {
+			ret = PTR_ERR(s0);
+			mlx5_ib_err(dev,
+				    "Couldn't create SRQ 0 for res init, err=%pe\n",
+				    s0);
+			goto unlock;
+		}
 	}
 
 	memset(&attr, 0, sizeof(attr));
@@ -3316,7 +3324,8 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 		mlx5_ib_err(dev,
 			    "Couldn't create SRQ 1 for res init, err=%pe\n",
 			    s1);
-		ib_destroy_srq(s0);
+		if (s0)
+			ib_destroy_srq(s0);
 		goto unlock;
 	}
 
@@ -3333,8 +3342,11 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 	struct mlx5_ib_resources *devr = &dev->devr;
 	int ret;
 
+	mutex_init(&devr->cq_lock);
+	mutex_init(&devr->srq_lock);
+
 	if (!MLX5_CAP_GEN(dev->mdev, xrc))
-		return -EOPNOTSUPP;
+		return 0;
 
 	ret = mlx5_cmd_xrcd_alloc(dev->mdev, &devr->xrcdn0, 0);
 	if (ret)
@@ -3346,9 +3358,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 		return ret;
 	}
 
-	mutex_init(&devr->cq_lock);
-	mutex_init(&devr->srq_lock);
-
 	return 0;
 }
 
@@ -3359,10 +3368,13 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
 	/* After s0/s1 init, they are not unset during the device lifetime. */
 	if (devr->s1) {
 		ib_destroy_srq(devr->s1);
-		ib_destroy_srq(devr->s0);
+		if (devr->s0)
+			ib_destroy_srq(devr->s0);
+	}
+	if (MLX5_CAP_GEN(dev->mdev, xrc)) {
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
+		mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
 	}
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn1, 0);
-	mlx5_cmd_xrcd_dealloc(dev->mdev, devr->xrcdn0, 0);
 	/* After p0/c0 init, they are not unset during the device lifetime. */
 	if (devr->c0) {
 		ib_destroy_cq(devr->c0);
-- 
2.53.0



