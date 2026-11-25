Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617599;
	b=rzwF6ZX1J8eQj5mFSGbfci9XcikXM98HnHZ52+m7aGIiAIiTfUIPMiZaSpnIF59YjTey
	 kEEm/edEDYbtYDPH8in50307upaMPM0jlKEciVSsxgfd7dzNCJ0v5iV218c/EnReREqVa
	 nXMRApcdjFQ81vO0yYhPUa08+iepIxb+s7pPPscpEOMmpkn0tj+HqLoPTk3sAM/qTwS83
	 EXtueZUxyT5hYjroCWHvAR5dY6tLB6MXWz6yR1GaDX+3yzv1mEZtRh7lTnOqote4eovyJ
	 RaXKGlelomRwELAli7IVBvT5d0P9mnTNR6X3HixUNWLX+/yJVKNbC7ykPvvCM4ixe9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617599;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9a0+ZhM1c8c+OpU6BL9yfrcjzW5ZrzxBmJpNIuWLlCg=;
	b=q0mWC0Zq6PgQ/sJQ1Z4DrDTumjPqmhP99lSeNul6y0BG3KVvqYUQZC6MugDZSE5ZFA/q
	 gyXfzpFJLHscrdYKLcrDJ+fqaZassQBLrfQQ2YE81AcGAxqTpZjd1GRNG0dIFk3Xi30R5
	 7gLp/cbQKvjn7n/8j6fEVU9204SLNs1iUX1aRbWfEc3izsDKI1jsEzV6hDWltYzbS5zsG
	 80dsF3OhykZ3aTTtp4ihtRDPGb+AOBX1dNQu8Fc20AAvZe9xioH8S1ZHeXNsH5BkvSO3A
	 sVc25omWsMFvHUY6MICuGAOfaKInkM7FeeRp5Nu3Be9+Hps+s3vYgScjeMhYMJL1BAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjzJauxo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6579E606A31E;
	Wed, 25 Nov 2026 14:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LjzJauxo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF991F000C0;
	Wed, 25 Nov 2026 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617598;
	bh=9a0+ZhM1c8c+OpU6BL9yfrcjzW5ZrzxBmJpNIuWLlCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LjzJauxo1y5lRf9NKsO5OabWbFcrZ8GH0SrCfja2xWpNgcFZSKOmZ1Y/vM3uImLnB
	 F658AHmCIMGVCQSicsj7YYZuuuAEzcaeBSu9aY/zcvt2dSMEAjIEBbJn4VyYPVYXt6
	 FLpXAofB4GKHD+gLK+laz78PJzDBGYzfVswA1+pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0017/1005] io_uring/rw: fail soft links on IOPOLL short or error IO
Date: Wed, 25 Nov 2026 15:22:35 +0100
Message-ID: <20261125143822.140457503@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

Commit 4d3db66c5363dcf42c3d43ebaea330ac2d1888bb upstream.

io_complete_rw_iopoll() updates cqe.res when the transfer does not
match the requested length, but it does not call req_set_fail().
Soft linked requests then still run after a short or failed IOPOLL
read or write.

Fixes: b66ceaf324b3 ("io_uring: move iopoll reissue into regular IO path")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114072246.741950-3-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index b21daa3cfa5c2..0426c27f3c4c9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -603,8 +603,10 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 
 	if (res == -EAGAIN && io_rw_should_reissue(req))
 		req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-	else if (unlikely(final_res != req->cqe.res))
+	else if (unlikely(final_res != req->cqe.res)) {
+		req_set_fail(req);
 		req->cqe.res = final_res;
+	}
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);
-- 
2.53.0



