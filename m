Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048694;
	b=C1AJAv7ImXkmc+F+vBmBmRSg6WLnz84UpJUrp9jJWCmA+QPyGoqmmNGEqPVuijxqVOJt
	 Ol2J0ltdT03Ze1fYWWNwVatgaVGWLgVSph1v4fjhrJRZjgOZv/KbzeTYBFjiazbzOLWPu
	 UuKaxnvXF72PhlYdKr54htAnUXmiWhYEPIRioKzcD5wD8C8drkTdaNuvlMS5ND79ZmBSN
	 X6Raq2lfTe8iitcuArWjCWHSfW3klm93xhlb4ZruzdIW1FoACM/M3i6/YOzvRdbh8LSBU
	 mMfktCKTVbUiLPC0rF93zZ9K6IAPVhfpNrE5jX6GGiA7rWpj84amu+4oYgiYQazqTSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4PiyvjEP4aIRwORUZzQ9H0d7yqYaVxTOxuZFIaGaKd0=;
	b=IXwzugkCvrHoL/qrEE5AVdBI3CpPJMsrUE2kykxRzqI5i6FUdN0Te3qu5GzGmLTgV1E6
	 06zBJZI4JPu02x8GTEIl9Eft4WwM44TaZSDy/w6l3d1aN6PqZ5/LU2pGGf5BKdPKv6iys
	 XrLC0z727IABjb4ufpMZHasp3Z9AR5UYetFDf7fhAFPqp3eQ4VmJrsuc7jGMgFCGC+dFS
	 IZAaZBIO0WDi7+ES1nEEGuQSkFx+dwY8B5pSfHOekQytYRT6rSrph1wbslzEvCieGTu4I
	 5+AQVo+gryhJ8T4WQLSe6J+v8KEmYwvJiQPqN3JE6Cj1FrZX6Z3ANBE5x9CPZbvuFEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUQ5icWo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E93606A31C;
	Thu, 19 Nov 2026 00:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bUQ5icWo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96EE11F000C7;
	Thu, 19 Nov 2026 00:38:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048694;
	bh=4PiyvjEP4aIRwORUZzQ9H0d7yqYaVxTOxuZFIaGaKd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bUQ5icWoQgC01yfjM2yg74TVttOKe67R12wkIX1WJ492/yd8KmrJ8WJq5NKlZQ7f4
	 lrSa2B301uLSva2RXW0hRRX/XXDuNsI7uLv8hp1/izSEAuXZ2DyjccslYu9fNvM0As
	 Ko3X3cRqkcjIilcdmMq02CMPOPsTEVMxvWXCrT9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2087/2857] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Wed, 18 Nov 2026 15:52:01 +0100
Message-ID: <20261118150316.550846723@linuxfoundation.org>
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
index ea3540fe04a53..37cedcdc63360 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1573,6 +1573,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	if (qp->rq.wqe_cnt) {
 		rq->base.container_mibqp = qp;
+		rq->base.mqp.event = mlx5_ib_qp_event;
 
 		if (qp->flags & IB_QP_CREATE_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
-- 
2.53.0



