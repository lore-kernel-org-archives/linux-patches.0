Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050061;
	b=OHc3oe406BE1nY7sWbwlH9vkaeR/b0DuJyjeNTQTd5QxaSCzeFTViR2JjoYKyUrHHYIE
	 jqh6iGAcwBvknaUCy4cnks1zrxjb2Ud1PdfNw5vlF1LB2kV7+2xWxTVOZrXK3d01D/G9u
	 X6LDFOO6j3VG+Jg2D9PKb17syhgiJwe0CvQ4w/llktVBlE4oYEhc5oHU/e49TU5K1Gafl
	 yeEOgcqx1vggwSUNoyy7te5EgV5Q7RZ+WKEAq3Q5buVjR7Yt8WfHbNPU52P+T1lqd2Lj4
	 5MT2+2/zmdG5TPaGWpxXzGw7KdByan9jDoNlySAjg44THUUqCiofOl2dMvx4kh2I1vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v4xqryxvh3/DH1EDPrCLfROPnwNe8rDvi2RFsA6rrHY=;
	b=XLlNnwetZyQ3I1NE1Zm647sEjMj2ktvBFdzcErQTlFdyS29r5NC++pCYxzZ8w+CL+bte
	 7gl5fFFVr70unXqdT8y9bfFA2sTYjrPqd3tJTmGIRRRNAFoDuRW/ihJRALqXXVGCtPhm3
	 5XcPxK3HatqBdGGofiWQbbbsTiSF58JUVhe/dAob0kH8vhyDui2BlsxXjCCXjekaLErD8
	 K69Zf6Lij6DLjPo+o1DWrQ53R5dl1j3zJ+f+u3lFr8UGo6lp6kvnk6+D9huy8OvcC61p9
	 1VmIgp3hKrCcaiK3ZaxkW7d1Knk+ZAb3Vkw2iDPFB1TTeO7n4wFSJmI4BsHYnTF3eFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1IdhyXc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EF12606A31C;
	Thu, 19 Nov 2026 01:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A1IdhyXc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4B41F000C4;
	Thu, 19 Nov 2026 01:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050061;
	bh=v4xqryxvh3/DH1EDPrCLfROPnwNe8rDvi2RFsA6rrHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1IdhyXcQrsLGU2ONrROSh4Zm6X+6LkPKWbRuLaOoGoLDrnYCjoGt/F4pgmhzdGJi
	 +PQjGJwKy5EI8cUhr97Bd7aUN9AY6d0FvE5uJEvdJ8yb+RU4hFlVA8l05FT9Dx7xnf
	 NZ38GurAhHjxrwaxYLBMnT+FRcMqSy4OWvdevSyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2573/2857] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 16:00:07 +0100
Message-ID: <20261118150334.133657422@linuxfoundation.org>
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
index 10c7cbea15932..e00e5961b0022 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2570,6 +2570,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2806,6 +2807,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.53.0



