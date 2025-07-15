Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F28A119D09C;
	Tue, 15 Jul 2025 13:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585599; cv=none; b=kgheuRE4NCbX1CzYwy4WhbD0U4c3HYC9buqv1D2s0PWZfob8mIs0Biv481uazZwz6nHpfUnaC+fcCOBehAN35O/OnvflHm3A3CEQ5IeEF1EvYsyajKNi9Pqb9YyX+wXff243ZF7Mi3cARVRm0YlGRaqUqhfVa/aqBA7+ax30hCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585599; c=relaxed/simple;
	bh=70HYWFoEIvEN/DpNUHiBvl3ocrDiWf8zxJhvfd5aBm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sQy5MZp0GeYc5AjvWRZvsSwyrP/u/t8yrdsSRfb7YP1tNNy8JH+Ul3puNH+AMmLAQzmNQxW7Oh5KlPsAA72pS8GeOszksVlckEOSQJeq4PH0FippY7rSYBktpE4fGc0snWk5zO1rGHLAUeVREvMVDZvxm+1ybh1oABLaFwD75xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xz86ixuP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xz86ixuP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E67C4CEE3;
	Tue, 15 Jul 2025 13:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585598;
	bh=70HYWFoEIvEN/DpNUHiBvl3ocrDiWf8zxJhvfd5aBm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xz86ixuPpgEVoy8EyKuIBZ0ak0sOSQ3ZYFZ5vV4c/+D7C7OS9aaqgMaC9fI3Zhubq
	 oPU21HgpdlZvGdeGJ2+caOCx1W0FJGfI8LdbutekBZOYSZNyOmCJizZq3AVr2Gw0fP
	 hBmqcRmbZNaDWNpRsFhLJ9vNd0VtHPy9JRGyns+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.12 101/163] erofs: fix to add missing tracepoint in erofs_read_folio()
Date: Tue, 15 Jul 2025 15:12:49 +0200
Message-ID: <20250715130812.913680007@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 99f7619a77a0a2e3e2bcae676d0f301769167754 upstream.

Commit 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
converts to use iomap interface, it removed trace_erofs_readpage()
tracepoint in the meantime, let's add it back.

Fixes: 771c994ea51f ("erofs: convert all uncompressed cases to iomap")
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250708111942.3120926-1-chao@kernel.org
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/data.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/erofs/data.c
+++ b/fs/erofs/data.c
@@ -378,6 +378,8 @@ int erofs_fiemap(struct inode *inode, st
  */
 static int erofs_read_folio(struct file *file, struct folio *folio)
 {
+	trace_erofs_read_folio(folio, true);
+
 	return iomap_read_folio(folio, &erofs_iomap_ops);
 }
 


