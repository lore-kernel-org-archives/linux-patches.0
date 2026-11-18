Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048691;
	b=4eD/raLZKZA8+ZsqKi7eoC+g0TPxNMfVuh64LQCsKXMpXy5/c1iTs4wJdT9kye44/q8m
	 EWR3b0Iqnxtork5/GFgG9ivPKq/kUMP5hPwzhTS6cQIV2aAcFsawoGw9oCiFEWvADFBxB
	 +bDqM4xzHm9h9yoRlfvp+Ei3YHBrf3pnJs+sVhhurntSLHWJF9151C/YX7vU9oSxu6BjY
	 ZLDJnezQJS/RBIIN1Y88DMNm49n5K+VI4t5LizkpNg9JpDRDp4ZaEJTaUC3Hmj3Vlz3yP
	 CD2elS4jUVZo5oEv99AQitBHmSx5Q5gqm57bpM5KcRTKq8mQe+0YgyIOYTCIEiY0HSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048691;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xyyoLS4HPY6sWE7HHGh3GJK62Ouy5N/Ev1PdaHmaU18=;
	b=C2mG4SsTxpsqFIAAuKIMMTOpvCMUcUbOUvcFJFGLj/M+j0EaU5zpj3CDKXBE62OlyyYf
	 Wyepj1kijFqbwDdWot7/SxtE3O/qRRSWrln+HMnt1IWZPqffBl02JPMxGUZt9BF4XgtQK
	 VbkdTzEqc1xegar1FvSfrckGGdMborqfGx096VZ6Mi6+6SwUfZBqkr0rwUBsOQAA3bJ0E
	 SFR9LhpBNVBuZoCTee5YY6Hj7Ran3JUieJHOJJlg7si81/3/QiIptK3JBge61sp9fcLPa
	 sUMrjrjM91KTc/Xnj/PFurjfhcW2ZbuuYAOGBxPSL7jrE2pKSP92eMBlsIyX1IGZU5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xr9QKDPC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26C606A325;
	Thu, 19 Nov 2026 00:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xr9QKDPC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD64B1F000C4;
	Thu, 19 Nov 2026 00:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048691;
	bh=xyyoLS4HPY6sWE7HHGh3GJK62Ouy5N/Ev1PdaHmaU18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xr9QKDPCI1+QDvqhtjMtvJ/VEU2PP2b4NC4ZsmTVsaL9iSru6fG9omqoSV5/B0Cgk
	 c+Fx7UutWwDHyJFR/WmqkGlfTnu66UVdV6mgRid0iohrKobn+XhPbz4ntdGUbG9g4A
	 MXcS6j8whmhGtVvRGAKwbq24fr2pwm3I+w7lsulc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2086/2857] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:52:00 +0100
Message-ID: <20261118150316.516267573@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit d2aa15620e98dc4c6516944397ebea03b7a62b90 ]

mlx5_cmd_create_srq() stores the SRQ into the xarray before
srq->msrq.event was assigned. A firmware SRQ event arriving in that
window calls through a NULL pointer.

Move the assignment before mlx5_cmd_create_srq().

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260915140933.40580-12-yishaih@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 731e6721a82bc..1d8345627a293 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -280,6 +280,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -288,8 +289,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.53.0



