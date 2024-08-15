Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0958663C;
	Thu, 15 Aug 2024 14:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732150; cv=none; b=Xhy/EmLkaqBNfCqhM7SVHsXqxtrEez8ivCgiOcejhcG0TIidwGpNP43iH5MgyVE8Ur32p6PmZhfpFuqVFEItzrRgO+p5nhDgGcuEw77XBSZ+O2lXoibTpkciamfFsH9O13x2XXMs+3HU61hCBOb0iYFwTPo47/ZNMP1PFctfJmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732150; c=relaxed/simple;
	bh=vdaeN55AAtSDuums/DF0XxD0xfzMk88dE+72nQQnpTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rpmu1rDgU06efm1j4sO3sI/YEHpDCRDXv1Kqq8k5a9mn+N3DqR3OwzGU/1QtTBpLILYC2gr8mB+x5bOzOUB750N7bOK8NslL90TWEtT7LDt+0DQ8yCqoH/KvhH7SEempTzGLcTT2BxlC5McuQvCLo5SKN8U8hORnC4I3w6q6Xyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HEvMvixy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HEvMvixy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F791C32786;
	Thu, 15 Aug 2024 14:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732149;
	bh=vdaeN55AAtSDuums/DF0XxD0xfzMk88dE+72nQQnpTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HEvMvixy8oeDu+sCyTEmzKulzgVGf3WRoIkiyT/+GzhD117KPOIla59g3LBgZcCNj
	 4HaaeU0LyI4IWBa24pHl1FTiWSRVb01Q3bMKJrzbjFMWA6DU6YOjatSRB4HVe+tgBI
	 e+b/ctZojaKyL4aPoFtPFQVtNMurzdafe9G1+xpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/352] xprtrdma: Rename frwr_release_mr()
Date: Thu, 15 Aug 2024 15:22:36 +0200
Message-ID: <20240815131922.738577782@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f912af77e2c1ba25bd40534668b10da5b20f686a ]

Clean up: To be consistent with other functions in this source file,
follow the naming convention of putting the object being acted upon
before the action itself.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Stable-dep-of: acd9f2dd23c6 ("xprtrdma: Fix rpcrdma_reqs_reset()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/frwr_ops.c  | 6 +++---
 net/sunrpc/xprtrdma/verbs.c     | 4 ++--
 net/sunrpc/xprtrdma/xprt_rdma.h | 2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index bf3627dce5529..177099f6ae182 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -50,11 +50,11 @@
 #endif
 
 /**
- * frwr_release_mr - Destroy one MR
+ * frwr_mr_release - Destroy one MR
  * @mr: MR allocated by frwr_mr_init
  *
  */
-void frwr_release_mr(struct rpcrdma_mr *mr)
+void frwr_mr_release(struct rpcrdma_mr *mr)
 {
 	int rc;
 
@@ -83,7 +83,7 @@ static void frwr_mr_recycle(struct rpcrdma_mr *mr)
 	r_xprt->rx_stats.mrs_recycled++;
 	spin_unlock(&r_xprt->rx_buf.rb_lock);
 
-	frwr_release_mr(mr);
+	frwr_mr_release(mr);
 }
 
 /* frwr_reset - Place MRs back on the free list
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 9e9df38b29f74..167f0d99b8580 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -1100,7 +1100,7 @@ void rpcrdma_req_destroy(struct rpcrdma_req *req)
 		list_del(&mr->mr_all);
 		spin_unlock(&buf->rb_lock);
 
-		frwr_release_mr(mr);
+		frwr_mr_release(mr);
 	}
 
 	rpcrdma_regbuf_free(req->rl_recvbuf);
@@ -1131,7 +1131,7 @@ static void rpcrdma_mrs_destroy(struct rpcrdma_xprt *r_xprt)
 		list_del(&mr->mr_all);
 		spin_unlock(&buf->rb_lock);
 
-		frwr_release_mr(mr);
+		frwr_mr_release(mr);
 
 		spin_lock(&buf->rb_lock);
 	}
diff --git a/net/sunrpc/xprtrdma/xprt_rdma.h b/net/sunrpc/xprtrdma/xprt_rdma.h
index 702f0344523cc..73c8ab89456b0 100644
--- a/net/sunrpc/xprtrdma/xprt_rdma.h
+++ b/net/sunrpc/xprtrdma/xprt_rdma.h
@@ -520,7 +520,7 @@ rpcrdma_data_dir(bool writing)
 void frwr_reset(struct rpcrdma_req *req);
 int frwr_query_device(struct rpcrdma_ep *ep, const struct ib_device *device);
 int frwr_mr_init(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr *mr);
-void frwr_release_mr(struct rpcrdma_mr *mr);
+void frwr_mr_release(struct rpcrdma_mr *mr);
 struct rpcrdma_mr_seg *frwr_map(struct rpcrdma_xprt *r_xprt,
 				struct rpcrdma_mr_seg *seg,
 				int nsegs, bool writing, __be32 xid,
-- 
2.43.0



