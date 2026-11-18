Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017586;
	b=JIuaUucAEza1TrC/GzEm7MRjX2seN5TwzlQ5zO/qQD0DtMqTlE7iciHk+3NsgR83oU4f
	 Z4HPGMJMI5xkm+7Afgdi4GenDAU7y1Bf5PegX9Hwe85EJ3HfSy273NFlXcgncXU7zsOeP
	 8whcj5NYwmfpeW/n82LfMwfUyl8fPpJLkRVwdEkM1x2F5o/Dsa/nr56wcDWaZzthcDpG3
	 uJ++BE/ZjZuQy9mYrN3X79Jag/VcuKKL+D0zbogVKo8GN5Ivla9Idqg67t04O3GFp1++V
	 U/0LmXgTYHKnPujxAwglOBr3LSEDGC8CLgQM21WO7soozLDrlRDHge1LKXV+4TenQjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rh6wS3CLoORgkLy04azG8xCHgTTw/ypTEf4aQVHUg6E=;
	b=skOvzsCLlrJT394j5S31P+9wgxxHiGsNrjcfhCJyP3rexXVAR5ZKbYVoxyDcKcjwn+6w
	 fsMLxeFrOYg4y0FhKQtnanPC3vGj4CiBLfsRuoecGq6WwFIwmVCy8XMo/SsU0Q2Cr2V+n
	 R34MwILeceyFIn1v885n62KGhArkmWie15TSH8g/94L+Xd6qnXqntG2FNz/B/svdBGq99
	 UL4ijwSdUogYgVQrEJTyDEqOIxTY88OkzbxIyrA5f9xpZ41tGkl0BCavGMCRYCzakUfEC
	 99os3UxDK7tI0wNzO4GNIaHby8lCNwVED9TFa0iGcUP3Wmgm08FgLvzeb76Dhk49BiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+qRnQ0T;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FB36606A320;
	Wed, 18 Nov 2026 15:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F+qRnQ0T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B9511F000C5;
	Wed, 18 Nov 2026 15:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017585;
	bh=rh6wS3CLoORgkLy04azG8xCHgTTw/ypTEf4aQVHUg6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F+qRnQ0TP6cVsJKHFb9ACrXTmBmZ/jLCrEUv1oveDkTg8hEHUE0vMuhB6WMu5m7AX
	 wP4VzGMHYTCZjXjKPVxT/QphdH3SaybQpl2A8YAxc/wqt0KR+Ux8f1ie4lWnJ1jpXk
	 CSp86BMpuHPFL+hTG4/5aT83k5zAcaYfIlGHvq3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0937/2651] RDMA/mlx5: Fix mlx5_ib_dev_res_init() failure when XRC cap is absent
Date: Wed, 18 Nov 2026 15:36:17 +0100
Message-ID: <20261118150321.615958310@linuxfoundation.org>
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
index a457647edacde..4a0b4dcf2830c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3370,7 +3370,7 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 {
 	struct mlx5_ib_resources *devr = &dev->devr;
 	struct ib_srq_init_attr attr;
-	struct ib_srq *s0, *s1;
+	struct ib_srq *s0 = NULL, *s1;
 	int ret = 0;
 
 	/*
@@ -3388,19 +3388,27 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
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
@@ -3414,7 +3422,8 @@ int mlx5_ib_dev_res_srq_init(struct mlx5_ib_dev *dev)
 		mlx5_ib_err(dev,
 			    "Couldn't create SRQ 1 for res init, err=%pe\n",
 			    s1);
-		ib_destroy_srq(s0);
+		if (s0)
+			ib_destroy_srq(s0);
 		goto unlock;
 	}
 
@@ -3431,8 +3440,11 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
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
@@ -3444,9 +3456,6 @@ static int mlx5_ib_dev_res_init(struct mlx5_ib_dev *dev)
 		return ret;
 	}
 
-	mutex_init(&devr->cq_lock);
-	mutex_init(&devr->srq_lock);
-
 	return 0;
 }
 
@@ -3457,10 +3466,13 @@ static void mlx5_ib_dev_res_cleanup(struct mlx5_ib_dev *dev)
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



