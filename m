Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213609;
	b=HzHEKbCDKzAAZuDcZJi9HnLKKVGXtD0Yll/bMW+4ziFg28UWoYEDoJg8oJcvE0FkTtQA
	 f975Neqfzf4EyRfr8jcHY98Ng1uTJLbmjEP3W+shoCbQKv1ygJx6+jIHWUTEqahLmJWKj
	 x3eOv155KBcMZNTgqRukUdniNBRrlPHRBybgY0Or0VCf/hbRojpVcxOMvo/6eri0uwDEK
	 bsZC7irBYWEHT9QjJhsBIiK9lWzcsgOsxvlXrYsnEbF0RCiCsC7r8z3qIDc7kDbemP+yJ
	 voXoNjupf5qxfQMgA0rvaysXWsQjhg+EfrzPyYOgdtmKslVmkLK201PECVnU8eeySjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213609;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADGgYIB35CcNHrqC7KyfyhEcKDIIbgyGYpnNy4TTjos=;
	b=dH40RdV9rTWZNEbteoarO7EBKfQASAy0AYZLNHU+GSeIyuKBv3wIwCd/ye0dctJZ7z4x
	 lf+mG+cAJIviH6UTyywtlm8pj7qdu2GBTBCtbdEMK8wOhQFnESxrRZ4+yonVu1FsdN84+
	 5/7ywTF25WkqCjrrF7123xKDs8HfytGOqI9JhwnIIRZ6gHYtGdOGKqilyaYwsSsVM0Le2
	 K9cWz8MZ91d0yxvobKwzxS8+Y22sINYsB3hMWcroG7q24gIvDkxFFZDMc620987gQB9l+
	 oBBTenCN46EbZRDYs02SNiFEKwB8MWDrsgFum2pCMjfM5zieeSbYrg9mn4o+52RkxGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHZ3fodK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECBB606A31D;
	Wed, 28 Oct 2026 18:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OHZ3fodK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAFB1F01825;
	Wed, 28 Oct 2026 18:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213608;
	bh=ADGgYIB35CcNHrqC7KyfyhEcKDIIbgyGYpnNy4TTjos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OHZ3fodKBAgkdjVKTSGY/q+RPXOBggkiSxzlj2+93w52NwtLn9uyGee3Qba8DvAJ0
	 HXuOKrp9bldneSe8AJOFm6o7akX+mcaB7CdwTGRMbV0PqP4CPnhLfmz6V7316m/f3c
	 ZBiwebPBenmRoJ1hhsBq97b9W4P/VOJiaNzOqduo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kal Cutter Conley <kal.conley@dectris.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0565/1887] net/mlx5e: xsk: Fix crash on regular rq reactivation
Date: Wed, 28 Oct 2026 17:44:21 +0100
Message-ID: <20261028170512.252034693@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit 39646d9bcd1a65d2396328026626859a1dab59d7 ]

When the regular rq is reactivated after the XSK socket is closed
it could be reading stale cqes which eventually corrupts the rq.
This leads to no more traffic being received on the regular rq and a
crash on the next close or deactivation of the rq.

Kal Cuttler Conely reported this issue as a crash on the release
path when the xdpsock sample program is stopped (killed) and restarted
in sequence while traffic is running.

This patch flushes all cqes when during the rq flush. The cqe flushing
is done in the reset state of the rq. mlx5e_rq_to_ready code is moved
into the flush function to allow for this.

Fixes: 082a9edf12fe ("net/mlx5e: xsk: Flush RQ on XSK activation to save memory")
Reported-by: Kal Cutter Conley <kal.conley@dectris.com>
Closes: https://lore.kernel.org/xdp-newbies/CAHApi-nUAs4TeFWUDV915CZJo07XVg2Vp63-no7UDfj6wur9nQ@mail.gmail.com
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index d26c36479ee91..f05fe8074b755 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -989,9 +989,11 @@ static int mlx5e_modify_rq_state(struct mlx5e_rq *rq, int curr_state, int next_s
 	return err;
 }
 
-static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
+int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
 {
+	struct mlx5_cqwq *cqwq = &rq->cq.wq;
 	struct net_device *dev = rq->netdev;
+	struct mlx5_cqe64 *cqe;
 	int err;
 
 	err = mlx5e_modify_rq_state(rq, curr_state, MLX5_RQC_STATE_RST);
@@ -999,6 +1001,14 @@ static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 		netdev_err(dev, "Failed to move rq 0x%x to reset\n", rq->rqn);
 		return err;
 	}
+
+	mlx5e_free_rx_descs(rq);
+
+	while ((cqe = mlx5_cqwq_get_cqe(cqwq)))
+		mlx5_cqwq_pop(cqwq);
+
+	mlx5_cqwq_update_db_record(cqwq);
+
 	err = mlx5e_modify_rq_state(rq, MLX5_RQC_STATE_RST, MLX5_RQC_STATE_RDY);
 	if (err) {
 		netdev_err(dev, "Failed to move rq 0x%x to ready\n", rq->rqn);
@@ -1008,13 +1018,6 @@ static int mlx5e_rq_to_ready(struct mlx5e_rq *rq, int curr_state)
 	return 0;
 }
 
-int mlx5e_flush_rq(struct mlx5e_rq *rq, int curr_state)
-{
-	mlx5e_free_rx_descs(rq);
-
-	return mlx5e_rq_to_ready(rq, curr_state);
-}
-
 static int mlx5e_modify_rq_vsd(struct mlx5e_rq *rq, bool vsd)
 {
 	struct mlx5_core_dev *mdev = rq->mdev;
-- 
2.53.0



