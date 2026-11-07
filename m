Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061033;
	b=1PkLIk6yqXrNo0DkhcJ/t3kHPtvYDs3cls355csW702uMR7IqbB3QsbTsfRaYHsOqn7l
	 M/O9k+MJIixB5/6qHYQYoFvGk/vqnKC+5gr6CAOE1LMU6cVeXjfIYunaHs6RgPN9+VwRR
	 dhtMzTUHOsrCQjXZ23I5mJtss8R4Sf+hJ6fXqqVMbPjgYochRrK55yHXI4foj3OuZnLpI
	 ConyKssf4nPM+NngB2IAN11PZcSqpIbhORrl6xZah5337NB6/GXPvWVgEwC8aCWrUNsTS
	 r8uPwmaFNW9qf8NWCPDZG7+I8Bl+eoWpodiVrYYu022vAnD8P/AMR0//b8+cFM2VO1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gGAQT2ByzXE6V9IW5vTX+WGF5ugHcGiicUfqC9D6Hkc=;
	b=LkM3ATRwfuhSAaxm4/ZolBPn6pDjCt0W3jT+A2tIcCPJdpUxf1I8uPybFPC6vDmJqjfF
	 VX7YLcjXIBpC5UlnJngl3kLlz1Rsua3xN4bJ5IcGjdhxANb2xTyK1Ih9MXISnJJO3DLCq
	 WJnySF9cXgfsUihLHG+HT9mgE1F7GZX0O7n4UMYCrs3lx1hxZj+grUHKFNypKiLrUVdb5
	 geEobA5CPivrozAUUGJPvIOsOWeNBZ2S33QAEvBk3MjGvYkDzCaID1Z6XwhOHcUCfJBVT
	 BqqyxCKXHyRdE3cFWar92VRm9GyYfPupA2/HqWhczI6tRe/G5JpU6+LibqOIzMnR7fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LrVvWw/8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E5D36082BFB;
	Sat,  7 Nov 2026 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LrVvWw/8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEAE1F0089F;
	Sat,  7 Nov 2026 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061033;
	bh=gGAQT2ByzXE6V9IW5vTX+WGF5ugHcGiicUfqC9D6Hkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrVvWw/8rLo0X9H3QFbMtDk4cIbULRkBr20OMrz1rUhUl14Bo+s/gTcb9Yq5PVOVJ
	 ZVVO8cEmjrIJLG5S/beXGl5R2jkyaUsRNg3E2TqIv25A0ZiPe3CZh5KRl+jJTzvOMN
	 jDHKXT9pe++DDvnOxHN3p68og5Tscsd0OJ8eGTN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weimin Xiong <xiongwm2026@163.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0367/1536] vdpa/mlx5: roll back MR update after VQ setup failure
Date: Sat,  7 Nov 2026 08:39:43 -0500
Message-ID: <20261107135007.960874642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Weimin Xiong <xiongwm2026@163.com>

[ Upstream commit 11f79e2780043ad94424a8db02a7a9022ba93252 ]

mlx5_vdpa_change_map() must install the new MR before rebuilding or
resuming virtqueues, because both paths read the MR keys from
mvdev->mres.mr[].

If rebuilding the virtqueue resources fails, the new MR must not remain
installed after its reference is released. Keep an extra reference to
the old MR before replacing it. On setup failure, restore the old MR;
the saved reference then becomes the map reference, while replacing the
new MR drops its map reference.

Make mlx5_vdpa_change_map() consume new_mr on all error paths so that
set_map_data() does not release an MR already released during rollback.

v2:
- Keep the new MR installed while virtqueues are rebuilt.
- Restore the old MR only after setup_vq_resources() fails.

Signed-off-by: Weimin Xiong <xiongwm2026@163.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Message-ID: <20260716054353.155805-1-xiongwm2026@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vdpa/mlx5/net/mlx5_vnet.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index ac4aa2e29fcc0..66d5231f03c22 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -3044,18 +3044,24 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 				unsigned int asid)
 {
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+	struct mlx5_vdpa_mr *old_mr;
 	bool teardown = !is_resumable(ndev);
 	int err;
 
 	suspend_vqs(ndev, 0, ndev->cur_num_vqs);
 	if (teardown) {
 		err = save_channels_info(ndev);
-		if (err)
+		if (err) {
+			mlx5_vdpa_put_mr(mvdev, new_mr);
 			return err;
+		}
 
 		teardown_vq_resources(ndev);
 	}
 
+	/* Keep the old MR alive in case rebuilding the VQs fails. */
+	old_mr = mvdev->mres.mr[asid];
+	mlx5_vdpa_get_mr(mvdev, old_mr);
 	mlx5_vdpa_update_mr(mvdev, new_mr, asid);
 
 	for (int i = 0; i < mvdev->max_vqs; i++)
@@ -3063,17 +3069,22 @@ static int mlx5_vdpa_change_map(struct mlx5_vdpa_dev *mvdev,
 						MLX5_VIRTQ_MODIFY_MASK_DESC_GROUP_MKEY;
 
 	if (!(mvdev->status & VIRTIO_CONFIG_S_DRIVER_OK) || mvdev->suspended)
-		return 0;
+		goto out;
 
 	if (teardown) {
 		restore_channels_info(ndev);
 		err = setup_vq_resources(ndev, true);
-		if (err)
+		if (err) {
+			/* The saved reference becomes the restored map reference. */
+			mlx5_vdpa_update_mr(mvdev, old_mr, asid);
 			return err;
+		}
 	}
 
 	resume_vqs(ndev, 0, ndev->cur_num_vqs);
 
+out:
+	mlx5_vdpa_put_mr(mvdev, old_mr);
 	return 0;
 }
 
@@ -3357,15 +3368,11 @@ static int set_map_data(struct mlx5_vdpa_dev *mvdev, struct vhost_iotlb *iotlb,
 		err = mlx5_vdpa_change_map(mvdev, new_mr, asid);
 		if (err) {
 			mlx5_vdpa_err(mvdev, "change map failed(%d)\n", err);
-			goto out_err;
+			return err;
 		}
 	}
 
 	return mlx5_vdpa_update_cvq_iotlb(mvdev, iotlb, asid);
-
-out_err:
-	mlx5_vdpa_put_mr(mvdev, new_mr);
-	return err;
 }
 
 static int mlx5_vdpa_set_map(struct vdpa_device *vdev, unsigned int asid,
-- 
2.53.0



