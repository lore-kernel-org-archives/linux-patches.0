Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032227;
	b=uBrRzTNsFTujq/eFdCPNWlM8xO9iPvNJdu3KcscYoalBgWloIkUscimnF8Xwaf3SsYAn
	 LQPI1zsh6UCCc8oyX6xk9m18urINutFwxaZb0g7h0rVXmX6Kf2aVuCYsap7BfpOAaWpKx
	 z5ey75LVUSmNx4RIHFrtcMQg+3ZjnDhsDTSlssdkJsaJyQfB9Sd6KdkSxd6RhYRboqqoA
	 RU5CgpgeTqrTrVuT3ORuG04OC0jY5w2QffqeKc7VusektjJ6dv667ZSrsxrLeZjXSCJQJ
	 7kmY07UTN2NDy/Z1OQ/dlGXtWNrperNsVmkjGQ+dMHl07fC+4zUqk7LuvVdc5q2Jjig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032227;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H1pGwq9ZvEzNah98eYT95HM9T/zNv5XJKrbvKPx5JGE=;
	b=Z6XYXQSvFm0cl9H+axmIWd+/6uHQckoRIlHUlW82riLnhrC4aO3hjN565PRYBKQ4bkGo
	 uuxH85i1HgBsHJiQkRDIOohYvGHGdYRT3IG/3bgxqoIdBZmNBMJaUn1PKxMnkmpMTOSFV
	 lWZ3ALiyT7Osch2c6hS9a5rK7Cl28RBsvABAMS5glx9bw+r2JiPFyTX488c4Up8oeTMe+
	 m3QZIlTvgscTD/MpRw5C4UaWAdJpCbTtut6ztHlABxgDZXALCVZ6k9qemIYkCUn2obWP0
	 zdtOKJshUolIcQO+8CBp6oQwTbVsSI8zhJaDpATfUnLGFSdAAQYFdccpuPgDGI+d/Xg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1lPYbug;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BFB606A31C;
	Wed, 18 Nov 2026 20:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N1lPYbug
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA471F000C5;
	Wed, 18 Nov 2026 20:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032227;
	bh=H1pGwq9ZvEzNah98eYT95HM9T/zNv5XJKrbvKPx5JGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N1lPYbugD9RVRz7tALOG8xGQv4ZwOZ9dD2ZDYWVcE8HmgDGPUDKH9DUIrNFfCBNfh
	 S/gRJE2Z+U2PIEi3xLAoR24ar8J/A55Qn2MV4qrr/Kx/yPoi4M9wWTHwbHHkFa2zgE
	 hpnuDEIwEb5wsYjarq8m+JZjzchLd1isKm/nJpCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1338/1756] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 15:57:45 +0100
Message-ID: <20261118150102.621510214@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Cui <cuitao@kylinos.cn>

[ Upstream commit c38975c427cc3d3f6eb66a36143893be5cdf4ebd ]

ioc_rqos_done() only accounts READ and WRITE completions, so zone
append completions are excluded from the latency window: the vrate
feedback loop cannot see ZA-induced latency, leaving it unable to
respond to device saturation caused by zone appends.  Similarly,
calc_size_vtime_cost_builtin() does not classify zone append as a
write operation.

Charging (the cost model) and feedback (the latency window) are
separate mechanisms, so this is not covered by the previous patch
that prices zone appends.

Treat zone append as WRITE for both latency accounting and cost
classification.

Fixes: 0512a75b98f8 ("block: Introduce REQ_OP_ZONE_APPEND")
Signed-off-by: Tao Cui <cuitao@kylinos.cn>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://patch.msgid.link/20260922043856.2020116-4-cui.tao@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-iocost.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ce822834d5b90..2a4d246fd9922 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2592,6 +2592,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2828,6 +2829,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.53.0



