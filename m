Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213408;
	b=h3D6pZDCFWEwsuobVaRi7iYSAUhQvJnOKUdltxT2nYDiqpW8FP4TOi9ANP3EAn8ZCQ2G
	 /0dYONrSV1Ul3w/aK+HAnkp1WQnqZPa6CNO1EScQHJAVUCxL+59pGIl6UoT20zagWdjGO
	 QwPKzM2kFsHj7s3zZSQwr05O0+gjXtjiN7EPALQu9qURUE73E9wGuJenSC6ZLHhAtKRcE
	 37900ndD5md3xWbBxhqLoEVeJNMP9aKAEaxbSZZDNbst/aLksNI/mSuRfh57UjgwSt1cx
	 YVIVm80E+nG7xnChKQWYN8xlJBN4w3U1obxHxb4H11uCx4EgreScfoTEG13A0uivVCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qu4pNdYcTP83vjH5UStBlFr1N7NzGnN82k/EB1klILA=;
	b=F9098kOynzScMCo5FNEK8pQU/zq67vL4leIs7IzG/k/ueRdoul2DvCeOofjtPBArbAdc
	 UVrAY29d+m6X1qYHkft0/wDoSXwLxy6ob/PcYQ+41YbfTlYb6Bu3/xQebuFoGuPbWilWQ
	 nRF8hmsSr7/7ZJypxjf66naIsBgLD8lZsfVrZkpC86PiffDTqswX8yPFHZYvhuYqDCzV5
	 XQowsLX55qZ+s7uV1dnbtTHEBGrv7vCd5ENvRiYRA2xTREcajuKByOTK3lJT16UQ9qk4a
	 9iOdoPJPtU3H2BOljZCwOCfHtR1hYMJuZ/0ASGmS8+6FIzNz68odwTB7TqCCE6v4LsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ul1eWqaB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33AE7606A31A;
	Wed, 28 Oct 2026 18:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ul1eWqaB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884851F031E0;
	Wed, 28 Oct 2026 18:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213408;
	bh=qu4pNdYcTP83vjH5UStBlFr1N7NzGnN82k/EB1klILA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ul1eWqaBm8O/l1tBfFtirGRwrc8b6BZXxNFeY31cypd3oUna3W7kLpCcVpBnHbnW/
	 /nbMfAGTAE5yKVi4tDY2WAOxOIESEdyG4MvAfXpbU5zoK0TIrRBorncISex8JGbQbZ
	 UrKU8Vg6jx9sBQ9jYiBPTi973jwkfKnHxLin63Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0496/1887] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Wed, 28 Oct 2026 17:43:12 +0100
Message-ID: <20261028170510.572142627@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit b056ca4d3742d0769f91137bb1ce3215428398f7 ]

mlx5e_poll_ico_cq() requires sq->cc to be updated only after
mlx5_cqwq_update_db_record(), otherwise a CQ overrun may occur.

The current implementation updates sq->cc before the CQ doorbell
record, violating this ordering requirement.

Update the CQ doorbell record first and use dma_wmb() before updating
sq->cc. This ensures that the CQ space is released to the device
before the corresponding ICOSQ consumer index is updated by software.

Fixes: fd9b4be8002c ("net/mlx5e: RX, Support multiple outstanding UMR posts")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261006105820.257208-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 75934d0f144cc..346db86c59483 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -931,10 +931,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
 		} while (!last_wqe);
 	} while ((++i < MLX5E_TX_CQ_POLL_BUDGET) && (cqe = mlx5_cqwq_get_cqe(&cq->wq)));
 
-	sq->cc = sqcc;
-
 	mlx5_cqwq_update_db_record(&cq->wq);
 
+	/* ensure cq space is freed before enabling more cqes */
+	dma_wmb();
+
+	sq->cc = sqcc;
 	return i;
 }
 
-- 
2.53.0



