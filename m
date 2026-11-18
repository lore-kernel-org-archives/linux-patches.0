Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040307;
	b=aBwFDOyd7KLaALbqXunDN87jnREQ0xSba9un7wBnwC1GS180Zh8Q6GbKSVHGVg/8MueS
	 0bw5gpInzjUByC/Z07PZNPlFRc4b6cnaUqxpfkt3ncVdxkC4c/EWyiaDzsYIL04nniL8Z
	 iwQkCUfgEUejwm00J8KcHAd7tczzPnLzltyKeaoJqbhowpxaPiK0O2L/dWrVuGozElNlg
	 +KgQo6Ax4woidKQXMtrf86nPHGpeGbnKBmAVLvpMUazGW7i9GORxQP+SkdOxjPc3smN/9
	 n4RDVrUvhvepBqRVASuNIjAIPuC8ymNbh0giB/2FCa8QBHl6g+WPLkHJeneld9sdL8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040307;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RSqVsq/3gd0Lmk7iY1nfKAZVZkxqPEIgS+JyuNLM+EQ=;
	b=Qrrdkkj+KXQdti285J5XB7rxrMjvDwUnnGF3VZko5LSM8YpFuafDhjkqXEbFnxUDuxY8
	 Tfhl2jRpF8VtwqdBfDIvhvo7ubwhugHX0W6vjF2gceIhzSdyxS8mrvgGRpglqBUkS6l7m
	 3UrScZkMYJPX7VDAYWvcIP3ClPDr9RRim8wemcWj4jagylTVFTRNWCQsuUeV/2k6FDnxI
	 1YAlTWMmx5vXU9JM+umGHK5akQ7YhK/qqNp6Rym086Okz2V0uHzk97zY33oOg5dj/VD32
	 ONTo6PTULIwuhhSoWJri0S5AFWcdfnlHMnyn4j0ETwQlIkxXLgTJuUCtNDZ1Ag5LPyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RZCg/PzG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23097606A32A;
	Wed, 18 Nov 2026 22:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZCg/PzG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79D6A1F000C4;
	Wed, 18 Nov 2026 22:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040307;
	bh=RSqVsq/3gd0Lmk7iY1nfKAZVZkxqPEIgS+JyuNLM+EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZCg/PzG/mW9BF5No24gVHyBCyhrC81OqLQiuSASKd3+UbkuTVXNudH5NWD4wfA0w
	 cLVYBIUaRw7uD2rQuOW6qhvnIzqu2VD9Hkm+mbaHjpeHIwsJuXsoFYkjY2ItOdR/ZI
	 liu2jpvCRrrv72Su8hpHADEMjqzvYWyAeyZQzm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2403/3318] RDMA/mlx5: Set RQ event handler for raw-packet QP
Date: Wed, 18 Nov 2026 15:50:25 +0100
Message-ID: <20261118150433.595516643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b8e26e7bee1a5..41807be47224c 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1619,6 +1619,7 @@ static int create_raw_packet_qp(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 
 	if (qp->rq.wqe_cnt) {
 		rq->base.container_mibqp = qp;
+		rq->base.mqp.event = mlx5_ib_qp_event;
 
 		if (qp->flags & IB_QP_CREATE_CVLAN_STRIPPING)
 			rq->flags |= MLX5_IB_RQ_CVLAN_STRIPPING;
-- 
2.53.0



