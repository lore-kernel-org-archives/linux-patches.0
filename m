Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617592;
	b=r30Z8vZ4hedlup46mlFmrYe7QJuLrO4+VnnTVAWrZldKdBi0LpKYY9iXolKIZxcM1wLU
	 WnSAc+DPR8W5AAGECR2US3WyZ/gu52qQymX1w09PNL5a8yi6oghqGc7jpe64qhLw2Nln/
	 RCxI01BOZqXKbMYSr4qEq14Wvec5P9KbZxICmu7ebTRYxGu8JC2rhSYWvJzfYCh3jmFfk
	 YWs4G036SkRE+vbpDVbjcftqawMu7P4J9n0uByOSSxPRXBHIf24diLDNzJH2gPBHnnIYI
	 KmMPoSucWkZ8sJ2bMuHe6viQjQPEamdJDYvks2YGhAyFi928qAIIYkNwX/0Sf/JqI/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TZicrDgNkC0R14z1B2VfTEsRuUDHoG771fy5b8CjARk=;
	b=RbzdnEqMWJ4rGyGDgH3CiaIvH1nZln5dUzdRKdx+xvvKKWPA902bjf+JxstrkGVPGwrk
	 K+aIu24rKLn4mM6DDdhYX7Aek2yZQ0OH3V06AUPfqMuuruJYY3RXST3cJlvW7ZWOTgWh4
	 Db+DRmyw9zbgYFOCO8zq1PnmR2aIXAs/xACY4/JGZg2vt6Mz4mBaAnBHj8/VaQr28wREI
	 aJ5KM4WgyfZJLZR2B1aKLW1QNdtaOhC/8bsoh3QG7AFHkRAmpfpfokLcG5DEBwa4qRul9
	 f+z898WX2HsKBH9F3PteLKsAn0pvGxp50/axm/NjALooZWGOQVLC/UKN8S0DyYt9Pxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HGc+KbmN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE38D606A31E;
	Wed, 25 Nov 2026 14:39:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HGc+KbmN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903251F000C6;
	Wed, 25 Nov 2026 14:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617592;
	bh=TZicrDgNkC0R14z1B2VfTEsRuUDHoG771fy5b8CjARk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HGc+KbmNl5FLv+6yn6cthTtiGyC29VyOOOKrJi8VvrWXDBIHQbOblFztt+KXVvPiF
	 /7mZP3m+mDl9KGKH3Wqw2WIWPLdghoaV5it20+vVFBBDTbG0qFXV7o5ApIxZAFjoxw
	 T5AQEk7LZeL1+lXA5ZlkgC9nkOgjbfxStyUb2gv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0015/1005] io_uring: fail soft links on negative IOU_COMPLETE results
Date: Wed, 25 Nov 2026 15:22:33 +0100
Message-ID: <20261125143822.092173759@linuxfoundation.org>
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

Commit 9ed19503a7b34e1ffb2b81236843204c473b0ae0 upstream.

Handlers such as fsync return IOU_COMPLETE with a negative cqe.res.
The old io_req_complete() path called req_set_fail() for res < 0.
After completions moved into the core, that check was dropped,
so IOSQE_IO_LINK dependents kept running after the head failed.

Fixes: 97b388d70b53 ("io_uring: handle completions in the core")
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Link: https://patch.msgid.link/20261114041123.109163-1-yangxiuwei@kylinos.cn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 41a03979cb8bb..c6bd17cca45f2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1498,9 +1498,11 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	ret = __io_issue_sqe(req, issue_flags, def);
 
 	if (ret == IOU_COMPLETE) {
-		/* not all handlers take care of the internal restart codes */
-		if (unlikely(req->cqe.res <= -ERESTARTSYS))
-			req->cqe.res = io_fixup_restart_res(req->cqe.res);
+		if (unlikely(req->cqe.res < 0)) {
+			if (req->cqe.res <= -ERESTARTSYS)
+				req->cqe.res = io_fixup_restart_res(req->cqe.res);
+			req_set_fail(req);
+		}
 		if (issue_flags & IO_URING_F_COMPLETE_DEFER)
 			io_req_complete_defer(req);
 		else
-- 
2.53.0



