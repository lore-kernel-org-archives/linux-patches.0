Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209128;
	b=Jflzsi+vCWEor5mMMjTycYj2BjjMiFLe5YEDsPryokTr7728z15d9+HeTpIPs0p7okKZ
	 Mp3FPlXKQMCh5KqRKqOWlYQMpvL4uNo38QB5wvfteHabKWeuuE7dgg7w94Vlu9rLgBvyk
	 nw3yuEAT91IK7fo+HE8tGXIZBQ0iMhn8/l2XVupWW5XBYacl2szinscWyX4DTtCeo8UoF
	 fwrwE75HJgmFWvwHQfMMLMYl3IbuXSao7Zh0b0yxcZ6jTaX4bAb5jKW+WKuBHJ+cH3WS4
	 Y4PtvWw7qX1tFeiFTEp2SEaBpefoegqc0UIEejvE+hSH8SOwDxVD0q+r6Y9qmrkM1bg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=T5dkEc97T8251P0Obz3mXc8MIrATqhDj2x1YkAZw30Y=;
	b=vKRCxgRQPiqSQKNR66MVDHUr3NiSxZj+aY0grE22kVo1qyk94G4fRk621cDG8M7EgJbT
	 U/wU/r8Jx1kYjBcBuvaOueTVXZ4CBAKi4pfKVHdbiYC3p7cpJAgizASENHP4yXVvfz1Aw
	 3vI2o/TrlEnMF1/LPZiChcTJVesO653HFXC0be+XiSe3NQzg6C9rtX32kcL3rCDfVkRJx
	 QrvCK+7Vy6MWhN8n5/WQ3BU0zwCtxFy8BvFxHwlSuA6NMxvlo/qpEB+/mppOsbGeqvj20
	 QncAigrNmJvEkr+T9cL5sz2QujAd4I2RnkFQBzWeLZoZHN/7vZQS/buavIL9wCvONkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CML3Yfhh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147CD606A31F;
	Wed, 28 Oct 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CML3Yfhh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F6A1F01825;
	Wed, 28 Oct 2026 17:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209127;
	bh=T5dkEc97T8251P0Obz3mXc8MIrATqhDj2x1YkAZw30Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CML3YfhhdICs/mYKwf0GcueHrOXn7jygLcwe+P+4GyrUWuzHU8jBCG9yYg9ampO2V
	 X0OzXwEqe6lmVN/Rlp09Ex8l0+hRLfMpOSpZOaB1ofQQj8DqsgNwCC2IXTBvUYLqzY
	 e0lDx1HJ4QxDFsgZzaFZpIdvLaeyZC82o8dvLjws=
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
Subject: [PATCH 5.10 361/516] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Wed, 28 Oct 2026 17:58:33 +0100
Message-ID: <20261028170012.037641614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b8637547800f9..64b552b5df89f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -705,10 +705,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
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



