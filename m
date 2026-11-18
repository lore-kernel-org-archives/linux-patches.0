Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027149;
	b=d0R0IScVyRR875gL9Ngy1FdGK0TVnFwtXRrZ+1g0DjeZZXzJNR4zoEycUDEWpC3FFZRN
	 5qbbEGNmrudbulFEhvJck6qEsyP55g5y9vgggledB5c8D8HTjGguX0WkJJwFHMI2sDwWo
	 YcI7JGkJQ4NAysCpwAnG6XZcP9ckqnErDYvjFsvbjif89Fxfi0RSIPFVi1z9vceiECXfA
	 yEKnbC9It1dh1o/+wugH++UwVqHeUjCw8DlyHLZzkFhvO1HCLADfjo++AGDVaxwrc4HZ6
	 xdEi2h8q38ucYS+hbk5bG39jpRxqNl/cAquhIUT6uWFubAcfPfx0SZxSSiuK7ooJlVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/cXXw6MwsuNRlynoaDuNIk6I5+jALTV9vacq4rRMu5s=;
	b=gltoXLRb4oHmbtBBv78spLVa9x3a8d5RbNDT+SuaGNYFcfX9NQyhChIK2S4b8kDFNE1o
	 E3Zgrxl4CYMvlSYEWM5LXRRMUNkPpJoy7sNkcAl/8mcMJsXetmDiaeMmRd7gRM0QEmAUa
	 aakJs8QcvK+vqW6Etq9wUYuBJn9RQlwRAWLblEu81SQmY0XL895fratuTnwMfjJalqavH
	 xK6aJHBEM7Omh75wVy4pXXuC6LI7+gUTmZotH6cqSqACiovaGMnlvT9dLQCnB3cchFx9V
	 N0sa5XCuydSrbm9QeR6wX0GyI8XEoSHuYenb54+DpvlIn2fNXO/uLCSOgRA9yjqwHxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEECBrFK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E39606A31C;
	Wed, 18 Nov 2026 18:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aEECBrFK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F671F000C4;
	Wed, 18 Nov 2026 18:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027148;
	bh=/cXXw6MwsuNRlynoaDuNIk6I5+jALTV9vacq4rRMu5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aEECBrFK12+kpIk+PMTIZkQXhUq7JXdxbdu/oWl0cwThmZL8M2wnyrBr5PJL/QkmA
	 fXTSUFsQ3Y6A1KqHA6a6KiSrCkP3Q6bhCJgLQXMUZN6LPO0jwtsb6tGZ/je6GQ0oce
	 go4t69lhDP7wWJbIg0J/OhYWt+6JGp/FhevbrbmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1685/2151] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 15:57:00 +0100
Message-ID: <20261118150223.212502872@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7b7d6e8a60f5f..6df4d84bff842 100644
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
@@ -2827,6 +2828,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.53.0



