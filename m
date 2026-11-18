Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056496;
	b=4IVWB+bjZvilV/biIcYGIwRhr2n65QUplAI+b3smQVP9wi7arhXRvpFI8fdIOVIyBQlP
	 hTDcQTXv4EvdtTk7Pj5cYxxJ1jCpILM73MBQwKFkbCfdcJT/3TRevCL/NUcWfqIC0xuCS
	 p8ULlndG/p2+e+7yB0F3b3tUJ6s37X0rfWMOIpcvVK8dDwMzwVp1aB8jdpJZEb/TAewKD
	 QTQ/IUVjGz5IVA6f6zV7BQzlWDC39MuMtsMQIyWcTRo9sdzPZKwyGGeN/lY4+F48ds7qG
	 D3JLMdMz6hgcuFi8VBoZMwVWgA+SO6nwV0bae23HYNZllsXW6egoY212IjGT0ehMUyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VrHaCKsZ6VqEbF4zzkjcvUcMuLn7B6Y1COg8l/1JJHI=;
	b=WfnJKS+QB0ZTWS1RFNCDNoEJMRlHs7Bodsl5PA6jZjnB2hCHARbU3pUTW0njxlpuA/oO
	 RnTRC5RynQReWVsLh/44zC56vQt1HDkGL5/rU7B62UtNHBEUUXi2NqHfYVOWADgRHg6sq
	 YKeDSI7DsH+L5IIKHc5xJndKS+qYmtej3zFY51lhddVbDI5NYpEwq6N3Rwd18VCRK19x5
	 pBAxaajS3IY4mih/q2iWL8KSLGXsdZoRXupfNyuq2BJHOvWKffdldL2SWfma7PxRNkTyi
	 jQFX/C53Icd1y9xLKQpc9786fw0IKNq1zcQT1/rqle4doXBkiZBFSuvWKhvckSUP91w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZQE4ard;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6BC60A2626;
	Thu, 19 Nov 2026 02:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CZQE4ard
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89F601F000D2;
	Thu, 19 Nov 2026 02:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056496;
	bh=VrHaCKsZ6VqEbF4zzkjcvUcMuLn7B6Y1COg8l/1JJHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CZQE4ardDZ1No672f59tiVrprAFztEfm10XqzrGbOPUpcJYkuvuebg4S6WcsyKi11
	 MF2HE/wuu/Cbv6YKXgiWjNhc4IefpAUd7AaWMGA30sGVr9srPqq6CDjOIubtQ/kmlb
	 mUWAA5LPeleDxuXxK3I5h9itht/J0WbRG6ISbmXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Cui <cuitao@kylinos.cn>,
	Christoph Hellwig <hch@lst.de>,
	Tejun Heo <tj@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2009/2214] blk-iocost: account zone append completions in latency stats
Date: Wed, 18 Nov 2026 16:01:25 +0100
Message-ID: <20261118150131.118398799@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0206fc577e84a..3e486ed787de9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2581,6 +2581,7 @@ static void calc_size_vtime_cost_builtin(struct request *rq, struct ioc *ioc,
 	case REQ_OP_READ:
 		*costp = pages * ioc->params.lcoefs[LCOEF_RPAGE];
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		*costp = pages * ioc->params.lcoefs[LCOEF_WPAGE];
 		break;
@@ -2817,6 +2818,7 @@ static void ioc_rqos_done(struct rq_qos *rqos, struct request *rq)
 		pidx = QOS_RLAT;
 		rw = READ;
 		break;
+	case REQ_OP_ZONE_APPEND:
 	case REQ_OP_WRITE:
 		pidx = QOS_WLAT;
 		rw = WRITE;
-- 
2.53.0



