Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040427;
	b=vFsy0WgdvBl+WOObhSPVcrd8fWDScMqj8GjhWjhxnbyEI13116/UAzUKohlj+z5XfO3Q
	 Ew7ng7dgSNnypeX5Wc8Df0dZ53R6GE6bP3sQ9VD4yZfJfOPderOnuANXD520T4YMnzReN
	 4Wu0g6ymXcJc1jAC2aprMYUiwPFdBYZHkuKLAfsA1zhjZB/y+Tw7qvNtV/0Nj9NsO4JDI
	 sj8Iyk7tIGLPcnptf/uANQIR3vJ6i5FygogLmzfKdmmrw+Sxsngd8YthnghP4UHDVftwx
	 fn1vN+15Tc8f26dy8y1ubBQfL6+1ZAzn633Za6zLzu9Ri8QqO6SzI4wYe2x6csbWgsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JYNTKxx2ZFfIaGU6+Hyb7PnpWQJFwxJRhDBVpeTNeTk=;
	b=aGGeji7oC7T44DNr6BTKvJCE41isgFg8DrA22rYQDjvHQU8BbA0pnKEA/fkyW78AK+Ju
	 6BV4BT0v1v/Z9UMndF7K34MJJsq0cFjqEkckccD0ZMnikN8/iNt15+3h+9bGODFMLn2Gb
	 vnyTTM43vLyYVFRSvAJwiv/2EhodXUEKvKH+ACsEw3Y3RdHvy7tQGEsEvxP7NUuWoSmNu
	 jAMdOwC9WOcd5Le1iYJgJdnfiJ5cKr2vgqyexQMAXEE3ndymYWDn7vE63apkXAva/U6lX
	 cI7J9u+ji4Wt9DtXCMOLQ6rTum9q9YLjcn8RkGrtHmLvphtedPuGiyBwiqw50Kar7XQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BblKAEcR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C0606A325;
	Wed, 18 Nov 2026 22:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BblKAEcR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2C71F000C4;
	Wed, 18 Nov 2026 22:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040427;
	bh=JYNTKxx2ZFfIaGU6+Hyb7PnpWQJFwxJRhDBVpeTNeTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BblKAEcRNDqK7QtMwXU66urCk5m9gRevFXAdDS0F3Lojj1uL3HJXy4uswAwp/YQ4E
	 JmwFD+mZw2Mv9cH+698je44VNSARX7zkY3Pfp0jqz3tm8VXu5v3N5AZbS8KrHBn+aY
	 T5X2sm3MSQktZfeT/lsGWDZP4so6CJltSbMyE/aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2402/3318] RDMA/mlx5: Set SRQ event handler before xarray insertion
Date: Wed, 18 Nov 2026 15:50:24 +0100
Message-ID: <20261118150433.567202586@linuxfoundation.org>
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
index bcb6b324af506..38def085ee267 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -284,6 +284,7 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 
 	in.pd = to_mpd(ib_srq->pd)->pdn;
 	in.db_record = srq->db.dma;
+	srq->msrq.event = mlx5_ib_srq_event;
 	err = mlx5_cmd_create_srq(dev, &srq->msrq, &in);
 	kvfree(in.pas);
 	if (err) {
@@ -292,8 +293,6 @@ int mlx5_ib_create_srq(struct ib_srq *ib_srq,
 	}
 
 	mlx5_ib_dbg(dev, "create SRQ with srqn 0x%x\n", srq->msrq.srqn);
-
-	srq->msrq.event = mlx5_ib_srq_event;
 	srq->ibsrq.ext.xrc.srq_num = srq->msrq.srqn;
 
 	if (udata) {
-- 
2.53.0



