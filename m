Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7185920E034;
	Thu, 12 Dec 2024 15:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734015828; cv=none; b=TZIEAW4Ft+WXmso14F8DCcUy4IfejC0onMsC4Gz8paby2bZv5mNLXUdKnqjjO3jKWGm6q0fxoMEUPegEhPsbGLOdDfFfgZ68VMF0d3iIEl/9+YJvNM8rQ7EzQcef0o4kyXHNZ7jhtR8KjuVcjQ8D6HVxlyUwOdjmw3HXXngkI7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734015828; c=relaxed/simple;
	bh=4vPVZbifg9X0Phr8fQk+UG26Bp26xK0WIVUBPex5kes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPxNKICG02AbuuJIlpmXpEd77tssg8aNWeqe3OPimqc7DxGejQ9rGdrArQer2nNnX1bEzuIYMnPMjPoFJzILLNKpSLoI9s628YSWlpGCqhaFOCSteafZ6NKVzTQ9xabDTZopJR0ldr1eno5c8NeHK5HTQrSxFh7SiIyGXe8hIlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yS3+Stml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yS3+Stml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69127C4CECE;
	Thu, 12 Dec 2024 15:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734015827;
	bh=4vPVZbifg9X0Phr8fQk+UG26Bp26xK0WIVUBPex5kes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yS3+StmlL4HMkHDVaYiJN9iFVaB6iXHQzL/A9EBaUoUZhGHuj+30LR2M2a3kfayhG
	 oMki2IVnIkcvQgk9hk6g2NV44F617/HRWFs7rZDxBs+saCVlqDK5biJzXov2bipMS2
	 I32CsNvtQO04/dXFVWOsCaMbonMTNtr352A24/HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 055/466] net/mlx5: HWS: Properly set bwc queue locks lock classes
Date: Thu, 12 Dec 2024 15:53:44 +0100
Message-ID: <20241212144308.993113809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit 10e0f0c018d5ce5ba4f349875c67f99c3253b5c3 ]

The mentioned "Fixes" patch forgot to do that.

Fixes: 9addffa34359 ("net/mlx5: HWS, use lock classes for bwc locks")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241203204920.232744-3-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c  | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c
index 6d443e6ee8d9e..08be034bd1e16 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/mlx5hws_send.c
@@ -990,6 +990,7 @@ static int hws_bwc_send_queues_init(struct mlx5hws_context *ctx)
 	for (i = 0; i < bwc_queues; i++) {
 		mutex_init(&ctx->bwc_send_queue_locks[i]);
 		lockdep_register_key(ctx->bwc_lock_class_keys + i);
+		lockdep_set_class(ctx->bwc_send_queue_locks + i, ctx->bwc_lock_class_keys + i);
 	}
 
 	return 0;
-- 
2.43.0



