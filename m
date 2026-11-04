Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826851;
	b=r6EjN/b5XlZRR2A3hiGr7wOv/QrW4KmLzhnkEPfUlvQMQVXa+qfEWsZJ84/17Vb5wLSL
	 6jrFOmyEov4So+PA3epMYwfpdiG6QZn6Xyj3r2LUIJPyC6kBo3Wf8OPEysY+C4yb1RZdx
	 NDkDoyHHMnxuAmJWLaIrnyAh03JdQJA5pRHg6+lg+msZWB8RA04D33ckYKZcqgRGGkFCu
	 f+vhuAX8ohZAlrCiyEQJ1YUZqgFPwADgAsy6Q/IKpfkHB7TGqVAoCRUcShwWSWzyb/qkJ
	 WmJ4KX82lPo9bmlYcobqFtN0dO/pR/cqsqoyKfG76hiSF0t+xRsl3ab5WVbV6H4fTHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aay0jqgN97vqGFWWKHq2zZlUxJKJTE9Jo14FHPPpMfQ=;
	b=zbmkSGnFB5BvjlPTkGyaJiHDGaKEIay1ag4bTSBGF1CS7KIBwigRmfNVlZducH9qd79m
	 KpI6H4DRFxLkZE/ZA+J6SBaW7123ssYp/hLU9BKeJVCg7XIf7qxXFhIt2Oa2FO2R4j+AW
	 fna59buBIbGJyFJDypwVoYmsXKFGCUgabNndjADRmzJq9rkDW08RhKLPrTC4fbAyPsxyV
	 qO/ETGvzEV0zuCzKuCvL21ej/tdJ1mrE75vBA3cudSLHvXcuMgmVigFj+epK0l90zgJqO
	 JCNiAcZIn7m1DZqh2VgnOQoAH2gD9esSg2qLTNo2lPsFoa9AcDFdugiWv73u+ahD5sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK0UguZI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831C2607E120;
	Wed,  4 Nov 2026 21:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EK0UguZI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8131F0093A;
	Wed,  4 Nov 2026 21:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826851;
	bh=aay0jqgN97vqGFWWKHq2zZlUxJKJTE9Jo14FHPPpMfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EK0UguZI3hOAwkTGAbQUZJLoLA4EUCRTCdn56FVoY2mZ/OOrZS58DGN1p49HsQda6
	 KrdYxsHC8DVO0ZsPwna4HBNUxCU8U33RpSFRouWCG3e3mPjPNIKe9V7yB2VvLuQWyD
	 vJnDqZVwB0tk+ncFH+lHCy/BwBrbdgUKD+zgxKYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 7.3 044/547] io_uring/fdinfo: fix CQE dump of CQE32 rings
Date: Wed,  4 Nov 2026 16:03:48 -0500
Message-ID: <20261104211039.571329523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

Commit e4507a62c247081fffe299622c04c6f7c3d98e92 upstream.

Since the CQ ring dump was changed to deal with IORING_SETUP_CQE_MIXED, a
32b CQE is taken to occupy two entries of the ring. That is how it works
for mixed rings. With IORING_SETUP_CQE32 each entry has twice the size:
head and tail count 32b CQEs, and entry n is found at cqes[n << 1].

For such rings the dump reads cqes[n], and skips every other entry. It
shows half of the pending CQEs at best, and what it shows is taken from
the wrong place unless the head happens to be at the start of the ring.
The extra data of the last entry isn't shown at all, as the check that
keeps the dump of a mixed ring from reading beyond the array is applied to
these rings as well.

[ 7.2: without the last-slot check, which 7.2 does not have ]
Fixes: 82ceb7fcc5ff ("io_uring/fdinfo: handle mixed sized CQEs")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-28-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/fdinfo.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 3ae4804765b94..30027fd460455 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -154,11 +154,17 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
 	for (i = 0; i < cq_entries; i++) {
 		struct io_uring_cqe *cqe;
-		bool cqe32 = false;
+		bool cqe32 = false, two_entries = false;
 
-		cqe = &r->cqes[(cq_head & cq_mask)];
-		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
+		if (ctx->flags & IORING_SETUP_CQE32) {
+			/* all entries have twice the size */
+			cqe = &r->cqes[(cq_head & cq_mask) << 1];
 			cqe32 = true;
+		} else {
+			cqe = &r->cqes[(cq_head & cq_mask)];
+			two_entries = cqe->flags & IORING_CQE_F_32;
+			cqe32 = two_entries;
+		}
 		seq_printf(m, "%5u: user_data:%llu, res:%d, flags:%x",
 			   cq_head & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
@@ -167,7 +173,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
 		cq_head++;
-		if (cqe32) {
+		if (two_entries) {
 			cq_head++;
 			i++;
 		}
-- 
2.53.0



