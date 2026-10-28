Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214958;
	b=2ZPYRWt50L44gBtoD+9+L3qQvcHhVvyLVstogfhqBD/e/XHjQiY4haP2oLyCsxPip/Lg
	 UQwqDjnAEvD2EQSyeeC3hyYwSk+JoPz9HszBrhUH0rlBk7bDqPf5i3UsXw+9cjnfIfh41
	 NYOmDicUA8f8lxTv3VvM5PRFk8iPMuf6bn9S/fR6oKsBnNT7iunIgCOvdOsjl6744MHpI
	 SLhLibOJ123YfmjHNlxzEEqFpwSi5W7l+uQTs8Ohn+fFSKhXh32+9e5MYAD01AWrCuaVS
	 G3wxwx2HhTS6QKM15e6IysKo3QWRUFZtBIlwi1YiDpeP3loGpmydqKraUqvRsLZGaCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214958;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JU6DzKCVfPw1qd8fi9oqIGQHxSOmuARCTMhSNJIUJDM=;
	b=TkChexVacs2RhTM/M2wBeC2b5pfENBT7oXGVSnkqKHPb/g3r0qpqzzPbomYeEXvXjg9S
	 1vw8mwYVqaAo/RCkg124YGllW6j7zvHJDuajcPb/6Css2vCYQEMV2Q5DP34jm5BSO2udZ
	 rcMrZfO5JZurN+pkkbyFrn2s0HimWfwawjbJFuSXIJB9MXsYZdoTogxi6A4oUr+gmO8W3
	 GGCvQwu0CW79vRExgJLB98mWZ6Ec6p9DViwgaPFL2u+qd2XX4FV0HOcZdB0rKR6E1hnlq
	 DEqsGcs+U7fFwWjjdfud7hhb/FqXGZ9UklfT1FRNwIjQpwfRoC1zwJOPDxPsp84BAwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNsTfS79;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30522606A31C;
	Wed, 28 Oct 2026 19:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNsTfS79
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395531F01825;
	Wed, 28 Oct 2026 19:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214957;
	bh=JU6DzKCVfPw1qd8fi9oqIGQHxSOmuARCTMhSNJIUJDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNsTfS79741xuzGabQaEQhB3Ofn74xRlEOQ7TxP01oPv5+PqiWWzESYUY/oHbD57Y
	 gV9B61zR+CqQ9Pqykm+OYNCxc4qO9bykkXYZC1q6gcXwfvmf6zJtrKctA53YavSo8Y
	 Rt45nEy19lZvzS/wvQgNaHV3ciLyRxcEl+LUHgss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0999/1887] vhost: move vdpa group bound check to vhost_vdpa
Date: Wed, 28 Oct 2026 17:51:35 +0100
Message-ID: <20261028170522.148226144@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugenio Pérez <eperezma@redhat.com>

[ Upstream commit cd025c1e876b4e262e71398236a1550486a73ede ]

Remove duplication by consolidating these here.  This reduces the
posibility of a parent driver missing them.

While we're at it, fix a bug in vdpa_sim where a valid ASID can be
assigned to a group equal to ngroups, causing an out of bound write.

Cc: stable@vger.kernel.org
Fixes: bda324fd037a ("vdpasim: control virtqueue support")
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Eugenio Pérez <eperezma@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <20260119143306.1818855-2-eperezma@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 3 ---
 drivers/vdpa/vdpa_sim/vdpa_sim.c  | 6 ------
 drivers/vhost/vdpa.c              | 2 +-
 3 files changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index a599259af8632..fd4a62101a3d0 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -2845,9 +2845,6 @@ static int mlx5_set_group_asid(struct vdpa_device *vdev, u32 group,
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 
-	if (group >= MLX5_VDPA_NUMVQ_GROUPS)
-		return -EINVAL;
-
 	mvdev->group2asid[group] = asid;
 	return 0;
 }
diff --git a/drivers/vdpa/vdpa_sim/vdpa_sim.c b/drivers/vdpa/vdpa_sim/vdpa_sim.c
index e7fc25bfdd237..74d8de5f1e8ba 100644
--- a/drivers/vdpa/vdpa_sim/vdpa_sim.c
+++ b/drivers/vdpa/vdpa_sim/vdpa_sim.c
@@ -599,12 +599,6 @@ static int vdpasim_set_group_asid(struct vdpa_device *vdpa, unsigned int group,
 	struct vhost_iotlb *iommu;
 	int i;
 
-	if (group > vdpasim->dev_attr.ngroups)
-		return -EINVAL;
-
-	if (asid >= vdpasim->dev_attr.nas)
-		return -EINVAL;
-
 	iommu = &vdpasim->iommu[asid];
 
 	spin_lock(&vdpasim->lock);
diff --git a/drivers/vhost/vdpa.c b/drivers/vhost/vdpa.c
index 40c43e0611ca2..27a7a168e5bd9 100644
--- a/drivers/vhost/vdpa.c
+++ b/drivers/vhost/vdpa.c
@@ -546,7 +546,7 @@ static long vhost_vdpa_vring_ioctl(struct vhost_vdpa *v, unsigned int cmd,
 	case VHOST_VDPA_SET_GROUP_ASID:
 		if (copy_from_user(&s, argp, sizeof(s)))
 			return -EFAULT;
-		if (s.num >= vdpa->nas)
+		if (idx >= vdpa->ngroups || s.num >= vdpa->nas)
 			return -EINVAL;
 		if (!ops->set_group_asid)
 			return -EOPNOTSUPP;
-- 
2.53.0



