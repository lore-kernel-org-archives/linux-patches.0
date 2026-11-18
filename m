Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020717;
	b=RsbqUPXzwrTo2hZL5g3ruOGzUQLLkIwzVVxdY3YFgdxM1E1xaQKhmB5tlfREZZOtZf7B
	 4jBuQJSxRtecREjSmEUwHbykVZXQigxW3Gpi4aSlb/yaq1GLkel7ksO3z/HgYbbISPJ4p
	 8J1Ch0Q273TeK8h0Oee7B2/x+ulMD1uHnhhRRBJ9bLz1Qpm2KFERdPv1LbjsTIk459wQt
	 Jqd7OTh/U9SSEX1M7YGb1coidDITHW0HOG3Yuh5Sktg4iJfrSJpND5EQF5n1X9oeXuIlD
	 odvbkqmIKzR1UdCIlP40mcQ8dPilhS7toeiCZj1JhpX8tUeuxwgvwJ62T/+UyBGQdTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=shDNbX1xLfCk6LYTbtCHSprT3fFVaAB0qMZqCQTtbmo=;
	b=dzyjZe31Xs67uC9xrL5NLr69ch57BJscjX6wZo33+7v5hVcP7jm118v54IQ3xlAjj3hK
	 /TTEKGx65bNnRYY1eI4MnQPs433qWX1AHG9ELIvPzdrN4ukX4xIX7gEGG+wMi8Q8sN0JK
	 h51Eukt7USDAMz9VaS44yHhP1s0erxw7TnUioI2JwW1rso9ggxGMGB4rMyy3xS8ajCMk6
	 kkgziU/XND5z8g+W2aEqAiSWV+QeH19OEbG5mjBJjNJXvvny91iAZexeiqfI+og9h5it4
	 4+HIVsyqHnPtxT8LvckQeNOylvOMIVxHW+5fzGQfU90XMZJ5d48XvE2O98MQJmdvhbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBSDWpqn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E13360A380F;
	Wed, 18 Nov 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kBSDWpqn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7AF1F000C7;
	Wed, 18 Nov 2026 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020717;
	bh=shDNbX1xLfCk6LYTbtCHSprT3fFVaAB0qMZqCQTtbmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kBSDWpqn417WDeZRDMsCc6glWOOxvrJvUmstIpgWXT8XbE63ZfIRJWSNF9OGRTuDe
	 OQEVR2bLn5i7VFdntusJ6o3HVaELWlt5QrPqrBJOLTRVG2b7ammvh+ZGBMub90wQsj
	 GVAOHEbnuxo7MHQeJIvK1Fe7QNV7E7gSHNNjjuMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2049/2651] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150359.844145154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 1ff7ffd7a5258..d6fe74adf62f7 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2589,6 +2589,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2860,6 +2861,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.53.0



