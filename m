Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214130;
	b=DXLdBMOJQ8YNKFNIiBgDrHxud0sx5Qit8fpQVAFGn8Pw3OgN+xkhFbMTrGDRFYn/OIfC
	 0EzAztHp+q1UDw1gZNLCS71+mriPIyDa3Fk0lRbDX9dfiPzq6WKSRj2QeYfBXBVDHB1ZL
	 uLGOPF1VbnCnxNLIyzLhf4+BaXe1BzkJazdJ/tdhqbIs4QRtx2WXmmHaCp3K5bXulBuVv
	 A2ydaihMufX42/MqWH/vTq/0PrYYcMVf2WuW356ZUZi71AEFAXmymznJwOXysKQVzE6qO
	 1SU7ixtptELR9AFbSmLfrq7/S/SLYCCh3B/AvhxiEZfrAlqeehSIpyQ00ZK7DluCKrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214130;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F+1firajgyouxX/tfKMblhKAvGCxwk5QizD5s8P4984=;
	b=k34JlOsmfby17VRPaYfpIw4sNYAkOPSYyhhC8C7MUbzTmsmO00FYUehhVLHrELEfcW7p
	 3foyGb7kW6wrjSVwGx/dxkGPdpt66l1vgo5dxt7eJOyV3Z4qqesWAh/Qqqh+nDzgCP2/m
	 +B9RkCTvf/9+SOLBkXQeSM2cayCaxSYNtt+KwNI7i6yg3Xgvhj2aiv1Cv9GKlkbl7iMu+
	 Vgo1tE3B4q2kwLfxJXMsSg/t9G2tvv/8JVvbqSx+JTY4Nhs+2w+l9V5C3xINCom0C/mkh
	 VjP93/dm7AYgPnbwUwZUw/Rdkp3V55m6pq1DDBguHbr2+GDQiQnW2MXztohhkeRMcjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYLUphCV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3DE606A31A;
	Wed, 28 Oct 2026 19:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYLUphCV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE8F1F01825;
	Wed, 28 Oct 2026 19:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214130;
	bh=F+1firajgyouxX/tfKMblhKAvGCxwk5QizD5s8P4984=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYLUphCVnZeNRhHjOPVid4W/rq0Xil6u2eUZuRYBpI6eL3AKPhPE7ot2hNqsW7/Q7
	 gh72xV341naHvdxqcfxpvKmpBn/ELDHO1p/zbjXfGJz6FKI3hCMQa169+cy+47EiWb
	 719QF31bCdF2APvBhuy1HSKheiKBwTibWBvRpu00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0749/1887] RDMA/mlx5: Implement mkeys management via LIFO queue
Date: Wed, 28 Oct 2026 17:47:25 +0100
Message-ID: <20261028170516.490717096@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit 57e7071683ef6148c9f5ea0ba84598d2ba681375 ]

Currently, mkeys are managed via xarray. This implementation leads to
a degradation in cases many MRs are unregistered in parallel, due to xarray
internal implementation, for example: deregistration 1M MRs via 64 threads
is taking ~15% more time[1].

Hence, implement mkeys management via LIFO queue, which solved the
degradation.

[1]
2.8us in kernel v5.19 compare to 3.2us in kernel v6.4

Signed-off-by: Shay Drory <shayd@nvidia.com>
Link: https://lore.kernel.org/r/fde3d4cfab0f32f0ccb231cd113298256e1502c5.1695283384.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>

Only the umr.c hunk is kept: the UMR failure warning now also prints
the mkey, which is the context the following UMR QP recovery fix
builds on. The mkey cache rework in mr.c and mlx5_ib.h is dropped as
the target fix does not depend on it.

Stable-dep-of: d97505baea64 ("RDMA/mlx5: Fix the recovery flow of the UMR QP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/umr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 219e89242d888..79557a25b55d7 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -333,8 +333,8 @@ static int mlx5r_umr_post_send_wait(struct mlx5_ib_dev *dev, u32 mkey,
 
 		WARN_ON_ONCE(1);
 		mlx5_ib_warn(dev,
-			"reg umr failed (%u). Trying to recover and resubmit the flushed WQEs\n",
-			umr_context.status);
+			"reg umr failed (%u). Trying to recover and resubmit the flushed WQEs, mkey = %u\n",
+			umr_context.status, mkey);
 		mutex_lock(&umrc->lock);
 		err = mlx5r_umr_recover(dev);
 		mutex_unlock(&umrc->lock);
-- 
2.53.0



