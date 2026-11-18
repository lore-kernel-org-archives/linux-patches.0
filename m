Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061069;
	b=WmPVEf+rUcB8yRw6FQkOJwfLwmQolz9Y5PkRuVPjviTQpAJuOp1K9NFsHTC9M7vxMlY0
	 IS/wkJnzqhzffJEvYg90OBHu557jllendxUQ+8F9LzZ1gEgWHkDtdYo1fM0S5CP0+0qQq
	 nRU+c9UX1xaaGSuuNZGpb4vK06o4F4wT9fTgJWRF5EjoYAc4D04woDVtQhfgm7l6ARANB
	 rq3oIEwJq4Mge0PNpPMg5FwYOut/MGyIh5vVaB7m3Zc1437SAtdERIC/2aSk9mhd0g7fu
	 NVLAzNlfWuhTQjHVoG5qGb4GTFLNxsln+XA2TqZSqgFyqahItoXMjz3Sww665ygTfpA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061069;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DBF8E7dSGNHVG93LnTjIl2s7J1hcpLJd0J/EhUC2q3M=;
	b=0wuKGFfNgEN5IKIGoxKgaIEhN1/WGc16MM8qDKCIInD27Xb1hxfcpNC2vEI2QnEnn+uc
	 Yi7sHcyfZUsLLIUDTTAwhuDcLctbXcNa/JEjZtb/xuJC6BUAMBjiihWtw4+ayqbgXHzM0
	 84gyHEcxWUF666A5DLIFuDuRMx/NeWhSJb2weMWDCxCyDoqHB/nWv5d9oit/gZwwTzFXJ
	 L3WIvuPaXXwM5y+pDxBD4ZTFUuzz0mwwhY1Q3xPnUtrW2x9xhTHIhnxiwrYz5jfsK4KUo
	 h4dG3qV2830oEXpWGCFaE4v/J16A6WTb/KqiDkkt9TLuusynFKyNlP1rcRqEWxepGzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7PGIWkz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97FE8606A325;
	Thu, 19 Nov 2026 04:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H7PGIWkz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4801F000C5;
	Thu, 19 Nov 2026 04:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061069;
	bh=DBF8E7dSGNHVG93LnTjIl2s7J1hcpLJd0J/EhUC2q3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H7PGIWkz21beCH+uLb4/ANBOLcKdFTiZFeAbbJclwegSW8/evLZjv33MbQN6DswPy
	 ijdorC5SsTbVswVo0P56xrotn+o61SO4TVm3xPHn/I34lBFL03AgbY6eJx7EkvPYW8
	 TLIyBZTtW9zg2w7VwOO2U7QJUUXoD884Jr/XszwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1380/1848] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:56:58 +0100
Message-ID: <20261118150017.269058619@linuxfoundation.org>
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
index 56ce0fea00e92..d52578003f2a7 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -301,6 +301,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -309,8 +310,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.53.0



