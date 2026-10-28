Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214638;
	b=Nwc1yaZsosmkn4YNorXlvindj6wkSf7JPdv76zMAugEHRSDaTquRxs6CPB84vVBD5a7V
	 fVvOXQAO1KfwrE/E6fa1Rqhm7kPtwrDlD8+PKQFdGLfpbvGYImUGGyOahynaV1IgiqrS5
	 06acWFER4b2bcNNjn7+Ais7z5YQueY4J33QmupXGAWwCm4qZQMQSZ3oOQMKo0XAJImPsL
	 dNC2M0fzLQFsYe19Zy+E8ZRfFW2xo0yFglfNPqlDpO5cusYoS00a8tnPTSugNWCMWeyO/
	 HpPx+zy805LwIRv5tZ5fNzFi+s4DrtN8CczO4A1MWCD/v4EV9sqSt7iLNtJ0bfs517g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214638;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sOxufywgApVPGrFaFIoj8uGrZHV3OdFmbaP6/3BZV4M=;
	b=qjtC2GGjs49NQqWBZC8Y4qayw4y3OXfd2eef1aZAtFhxLDSf1s5ZO086+pR/RzI/ZGI6
	 S6W5Jpa9gCB97KJNx6uCgOKEZtG9vk8VexwrIWSC6FDxsFFE2n0UZFuk9JAVTq9hW/OYD
	 03Vncg2eEtSs5/yIACQb7Afi//BP4qT3wVkCl/+35c3o0dIrtMwnsmVDEcltmy2UbGPqo
	 oZqadBGS/JbVMJP5k+ijZfULo/JLQfW6G8MBsKz3Fku4nRj7HXBGpQH1vBZ9qYTyQ1Exm
	 MkYwYpihcXEEq7FwozeCA4LHrUmywdNxGfl+AH0ZahbIQE5+8vkyziqlvi05ELLPCTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFmyAYQA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F042606AB1D;
	Wed, 28 Oct 2026 19:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qFmyAYQA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7123E1F01825;
	Wed, 28 Oct 2026 19:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214638;
	bh=sOxufywgApVPGrFaFIoj8uGrZHV3OdFmbaP6/3BZV4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFmyAYQAyKfJAtf4ohQv1v+Dz15196+Q3CIv+2BAqJigpQvpS8IyBujSfjUHbF57R
	 y1zv76idnIdpeZONTd8r5nCAvrwwTQ/vIhlUi/Ekm/5PBYviSBe01kqS6oH+1L0XkH
	 uQjpMBFQSMwk6BzJg6RWAgUjgS+opp4aarW1PK2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Rogers <linux@joshua.hu>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0902/1887] svcrdma: bound check rq_pages index in inline path
Date: Wed, 28 Oct 2026 17:49:58 +0100
Message-ID: <20261028170519.943637676@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Joshua Rogers <linux@joshua.hu>

[ Upstream commit d1bea0ce35b6095544ee82bb54156fc62c067e58 ]

svc_rdma_copy_inline_range indexed rqstp->rq_pages[rc_curpage] without
verifying rc_curpage stays within the allocated page array. Add guards
before the first use and after advancing to a new page.

Fixes: d7cc73972661 ("svcrdma: support multiple Read chunks per RPC")
Cc: stable@vger.kernel.org
Signed-off-by: Joshua Rogers <linux@joshua.hu>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 1bc9dfa1e5bbc..e455f16440334 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -811,6 +811,9 @@ static int svc_rdma_copy_inline_range(struct svc_rdma_read_info *info,
 	for (page_no = 0; page_no < numpages; page_no++) {
 		unsigned int page_len;
 
+		if (&rqstp->rq_pages[info->ri_pageno] >= rqstp->rq_page_end)
+			return -EINVAL;
+
 		page_len = min_t(unsigned int, remaining,
 				 PAGE_SIZE - info->ri_pageoff);
 
-- 
2.53.0



