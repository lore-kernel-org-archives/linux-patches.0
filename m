Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061072;
	b=3/9TDbYD1/KQGPKDwiJfbXDdhs13ADgVmWXgtCTsD2izt+D0Cfo9PSLIOfie1oIRtQF6
	 RyGZRyK6nmiBKG7FUB7BrlWQAAwcH96dkjTeQ16xgTrAXrHBOpawyB19pt/nH94rVZrIE
	 5QQeyaCMp1Izs/FX+8f/sUxRFrR0WhNZhzuE6Dvl9H4oRDlC6l9AtUr9jO4syoPIrg6u8
	 8XNikIOIC+ZXpy5KxQ/ljWuSqS8F/hnO+l2BxnklALdfatqIqfN8/dZ0qfEO9yhUFWGoY
	 Lxz/Cpo0lYW8kVA0XOZV5qJw1WrhRicGDn5O5+Ef3NzY5YOgtxrsyWrkWHKPNwxiMuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061072;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tGCGgNyS4TKHenaoPIJDbTSk+QJWT4Rt6WbTq+bEdhw=;
	b=zGDKf9wpW6HeluURLLUc5XXLpf46zp2yItd0lf9scKeidITpL+QIIcA3TSG33fWDd8pL
	 xxxbyEycJEVN1gLuCnBEIFenjXc3z67w7fgKL10Ri6eFKl1JJCc1vLtzoEQKU4FhJew0s
	 Ad40NLdIzwM4BRcF9rbhN27EvWqUlcbzYdZjik0dURfflAuAHxqubmGE5TVI/6mO7AdcD
	 7yDIzWN4c8vY7Iak9arfs/uuUHmT6H0rjkkFOGBMXTD80tZPOof+HMawMZ9Pi7I9N/bm8
	 ZPT8I4l8ekdEeQ0wuwXVL6MT7Zaaos0Qf7tarGMcoWgGzPui0Jsn1bqUAgxk9UTJqOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RhFv49Bv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9CF606A325;
	Thu, 19 Nov 2026 04:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RhFv49Bv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8DF31F000C5;
	Thu, 19 Nov 2026 04:04:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061072;
	bh=tGCGgNyS4TKHenaoPIJDbTSk+QJWT4Rt6WbTq+bEdhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhFv49BvStCUqDBLHnf8B3WuxvStO+F3yGjhEU4d6g/Amguc8ezSoaQABOTJUU/iG
	 BDCB89m1gX28Yh/qwTT9IouF1Fi8v0UZ5N4RXTwjs5wwr3KGori9EP4rIfbKBwmcq4
	 t0fasolgOAYkbqS0CpaEGo2wlJrcvc1ttAzCvyp4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1381/1848] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Wed, 18 Nov 2026 15:56:59 +0100
Message-ID: <20261118150017.305163630@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit a4fa6497002c80b55ebe597242a1bba2ff268886 ]

create_raw_packet_qp() creates a separate firmware RQ object but never
assigned rq->base.mqp.event. Any firmware event on this resource (e.g.
WQ_CATAS_ERROR, WQ_ACCESS_ERROR) calls through a NULL pointer.

Set the event pointer before the RQ is inserted into the resource table.

Fixes: 0fb2ed66a14c ("IB/mlx5: Add create and destroy functionality for Raw Packet QP")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-13-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index c51432d91d74f..1c3bafde63df5 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1470,6 +1470,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	if (qp->rq.wqe_cnt) {
 		rq->base.container_mibqp = qp;
+		rq->base.mqp.event = mlx5_ib_qp_event;
 
 		if (qp->flags & IB_QP_CREATE_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
-- 
2.53.0



