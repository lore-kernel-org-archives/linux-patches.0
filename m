Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041924;
	b=x6z7PrQ1lio5K712vJh3agijE/sGS/T7t2HE0qV20dn9JWwMTrIVPZiGPq/TSKrX1jQo
	 R1RCBwn5jhDLcAhyA90slEHxbm/sOAE4SYt+MjmSMXWFFIuYagAQzqM+AN52n6VAc4vjt
	 aquItfKDV1GQvwnjT8VefUSTRGi39wstfE6V9rKSkPpbAXIc9pT9YigfRV9IVnoTt6wX0
	 yEff2KQksvkxdoFYmjUxGprrRW3AuenN/+M2/3zCo71LqjQ0mLRpyCxZlzaEVatS2aI93
	 OjcbN6HpXdaJjmZnXN3PRpuwvNEvdYNnDcgtQGBziBlg4d32afvsLsCGqHf3g3tFPfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=U6nvtB5QdmQur9Y+j8XvhBb+ljk7Ln0bhUFWxJHcclg=;
	b=vZFfv2u0n7ju0ucww394Fy/vFYjt1CQ6crroJvoVDFHb5cwCTRKCXyxPJ1NAkrUmou1f
	 HfwltlY2mrrA+UdfQd3K0LFqFVd3Qr98DeiMma6vGSwUIC7kTcLSTakw6LS49MwO5mSVr
	 CMAA+oj+jRIjeOXV8CVPjQb5lenOzVrPIvOORUtKqvFIJUPxHkG3n8f/7bbyu+OGIRXSC
	 o0vmuPl4b7XdJZrkdR4cTm8PH7e0WHTm9/pHqQS8OMDYPNWZjMnyhcoRbzGgcJipOozNd
	 Cr8+pzbjP3qXsUQnctku2rjmFPmLfByiCwXNsNn3z1JnpX7h4mvI4AjT0U6krQDrUlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpmfjM9W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98351606A31C;
	Wed, 18 Nov 2026 22:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YpmfjM9W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6E61F000C4;
	Wed, 18 Nov 2026 22:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041924;
	bh=U6nvtB5QdmQur9Y+j8XvhBb+ljk7Ln0bhUFWxJHcclg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpmfjM9WJHayy+xoApHBTr7l9HcZVwNyUNAhvvCBTfOTmmSIwQz2AaVWrapHEvTrz
	 IqypYeQ8HwM19OelHUo8LXlu2rJEVsJz/MlnmfOOzNkZBgN+kYwiDIJNb+95LG4/ja
	 c8Wr6eRkbWzy3Fg3M3Vy+IMq+ZRZxeuEgUa8HtWk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2980/3318] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 16:00:02 +0100
Message-ID: <20261118150449.675613481@linuxfoundation.org>
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
index 6e3082cb90dab..185f2b82dab99 100644
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



