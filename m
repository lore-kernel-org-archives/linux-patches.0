Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E141346D543;
	Tue, 21 Jul 2026 15:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648921; cv=none; b=HdRktgLtmTEG31MActcgqROKieOWjihg3u/efLIJ7owj512SB9KU6nZi/5+ECAsYQrg3F3EUh6IqID0zd+hwWJ/jBB5eidLSxJfFoRgrP9rrkJT11H8XLGCer4tPDPte9siUNFHattTQ4nLh4/mRBP2uPmyQ7LU2Bv/UAQAzo2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648921; c=relaxed/simple;
	bh=g+sPFutUPj4B1ScRGskye5mnrRBvvcEDz48UPOrxj9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9LWMFv94yLK3wuDSjRNu3jW+BONEKI0BlN7oUVxAHiaR9fNrk4Q9vwG4zWrEJWK2/sjlOHg993GGCEuihHr0tE3Cwrho1BKmiTncMN0uP7MY6ociHJ3zhu/3l2uvTQ9AJbCk8/c0zhqkrk60OYDa6Vbh1VTEtLnxvsVps4NZ4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ud/Am32B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ud/Am32B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14C861F000E9;
	Tue, 21 Jul 2026 15:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648920;
	bh=HVM5ZHPxg9kiujGKmVhLC4Ofkaq1JDfn6aEpNk8fHUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ud/Am32BSx6a8PQhDe380HdNxqJaRTTN2chHdD58yftwVYhEhJBeCr+Tuy5a2qbr0
	 2hgn/5WaD7mgInR0kLYww2dg8UGYtcT6Eu3ytteVvgcwIL+2TO9Tr0YyJfIy8XtjOu
	 EN3gsCyKKOrc5zbPlNpVvwaGpF558XESQE5YPCt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0382/2077] RDMA/umem: Add ib_umem_is_contiguous() stub for !CONFIG_INFINIBAND_USER_MEM
Date: Tue, 21 Jul 2026 17:00:55 +0200
Message-ID: <20260721152601.707126595@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2cc10972f5f4f123e5a7658824db4f7b5abfc410 ]

ib_umem_is_contiguous() is defined under #ifdef
CONFIG_INFINIBAND_USER_MEM, but the #else branch lacks a stub.

Add the missing inline to fix potential broken build.

Fixes: c897c2c8b8e8 ("RDMA/core: Add umem "is_contiguous" and "start_dma_addr" helpers")
Link: https://patch.msgid.link/r/20260529134312.2836341-15-jiri@resnulli.us
Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/rdma/ib_umem.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/rdma/ib_umem.h b/include/rdma/ib_umem.h
index 49172098a8de14..3e0c2c356d142b 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -185,6 +185,10 @@ static inline unsigned long ib_umem_find_best_pgoff(struct ib_umem *umem,
 {
 	return 0;
 }
+static inline bool ib_umem_is_contiguous(struct ib_umem *umem)
+{
+	return false;
+}
 static inline
 struct ib_umem_dmabuf *ib_umem_dmabuf_get(struct ib_device *device,
 					  unsigned long offset,
-- 
2.53.0



