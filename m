Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C3B472F6E;
	Tue, 21 Jul 2026 17:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656136; cv=none; b=T8yykb8hCLd4txbAqf/EFshDSlXK9crhJvsyj+JY0qX3WJSNZPiX3EK0ycVbJG7ciIdSOaoIzZkKgUlpPkVyGaZwWF2m+iJSpSvXxGvTpgOsTi14klESoXFTwrhSbXWPGuRbVF9BEJym7DZIWwsf4TFhBO30JjrzISUz/Evm8Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656136; c=relaxed/simple;
	bh=cwRNzufFpALoF7L9DGJG30Ufa+1vWLOiBT4vL6tyU34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rwJRAOQ6Ar8Cs+bGogPYYg3QY3qr8chxeHVqcbG+HNMnrDbQEyPHg5n1hJZOHq0EhWXOIT2JxUO0jAZXPvinAYOvXAqUCDNot93OELcFujGJInZ2ZzgnJXAt+SrAoRo4zDbnJb71Dbpxw6ResjSq8FVCvWll2VaHQW2A2nHu5GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoNo7ds2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoNo7ds2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B43D1F000E9;
	Tue, 21 Jul 2026 17:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656135;
	bh=RWyDlaUteLimGvoPuT5mUz+J/ZY9+Qg6VKUaxIhdYw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YoNo7ds25n8CYV3UhszDnq3XyxZXgblWcIPxJfLB9SVWL7/ex1PR5eQjhW02y5wIQ
	 utuyuqKpgn9TmkZHd+aZ4OKT9djvB/PN4kO+i1uiNBwVvrYPtBk5L1ffuLdCLRpaVW
	 PwoOE6RarTviQfNfNFv0ILB7nmZ+EVqsMt0WtDxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0272/1611] RDMA/umem: Add ib_umem_is_contiguous() stub for !CONFIG_INFINIBAND_USER_MEM
Date: Tue, 21 Jul 2026 17:06:28 +0200
Message-ID: <20260721152521.168906539@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 113a5a230176d1..5122f78467675e 100644
--- a/include/rdma/ib_umem.h
+++ b/include/rdma/ib_umem.h
@@ -181,6 +181,10 @@ static inline unsigned long ib_umem_find_best_pgoff(struct ib_umem *umem,
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



