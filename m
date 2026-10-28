Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211510;
	b=xPYaREdrRKWYNkkbUmtuPJA5uTSYkWBuMOqJ6eVsJnH5jTqkBvoKIz+/WueRmKcoXiBA
	 alvxtrAv45wNaK4hDnKjAGkTndd2fow0LRsn4aXJlt24AW1Rb0hOp0BofprBMUbUU0Zxu
	 zriwSewI4SmpsvuyScudkKYIJAoRO81XHzS0mhM9VWRhdmaWhfctLUSRY1AQ3xPli7kKm
	 dMPjK+ex3ccWg6sab2z3xu7d5521dldp2eOdI61gO7By8409kGev9hPPt7lwkVAMQS38M
	 IDAK+Kj+1F+GDOiIPfbRHnULUOrjPEnvZXuFjY2yeX6HJVBsh5OJaEs7iEeURp74u+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CpB9nXVSpXE5Knn/nihweLcm9roZkaSBEjWSrEvcpO0=;
	b=uuujwJdCkswXGMXI7k2766JUimXbCTsF/d8kjM/ErxPEuhKjBPyUV4KzVaF01z1qpEMC
	 gQyZGa0zZrKaQ9INzkC39602SGC8V7dGxDqG6DOYYKdn/RtSUWqtwHYkJHZqND/eu60Eq
	 sfQTaZgiduxeWa3vSCflUJPeppxG4TXJCPQ/vsjlDovOYTO3n4qPRVF80qSUaUB5d6S6v
	 cHnZfHEWKVsjO6xOU/N4zWwRjs9jr0hNMtY0sIodqP37QMmvNLkL47lq/3ZX2kgwp3x1i
	 EFe00IcIMgSvlcOSMUgkY+n9W9z4GSaQtseyX/sBDbtJ+cAfK+b600sk+oP0wb5ltzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NSj4AP/+";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D36606A31A;
	Wed, 28 Oct 2026 18:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NSj4AP/+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EE51F01825;
	Wed, 28 Oct 2026 18:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211510;
	bh=CpB9nXVSpXE5Knn/nihweLcm9roZkaSBEjWSrEvcpO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NSj4AP/+lgMNxcfYVY+E5QUV1Ezewp2T2JW1MT9Eg0exPjY2Sz7b1MEOYzxKRSqkx
	 IgrId+LG767p2UTw5a01I1hBHAzsScBfAn6yR8fICaTgTZRB+HH1h4jyYiMCeEctoZ
	 SFqvaIOVu4kPrrJapWGomgHaXkKHwoj4GMBLHuYQ=
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
Subject: [PATCH 5.15 402/571] net/mlx5e: Order ICOSQ cc update after CQ doorbell
Date: Wed, 28 Oct 2026 17:59:09 +0100
Message-ID: <20261028170017.550798622@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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
index b4a0af5a1ef0b..129ffaa209563 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -704,10 +704,12 @@ int mlx5e_poll_ico_cq(struct mlx5e_cq *cq)
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



