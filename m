Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBADD2EB5D2;
	Tue, 15 Jul 2025 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587089; cv=none; b=I7j9PItzef5l3QWEGvZiaCodYUA/RLo6EJchF9VFQcTrHohylcIPmZQ7MHin0z4a4nb4mqq6Yp+nCwswk4S/KSqe3m5Ca4Hda/unyQB57BhUkhXvJGqalwIjayRPiYtCbvVcIOuE1zH3Wd9TLaAK7RRKMLyvTRHLjjmGv4uGZcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587089; c=relaxed/simple;
	bh=syL/pDX4A19sTKMRiOM4fPaytMInNoFiW/CBU6jy28U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ssyVExB6SsZJeeliSzU+iRqCJdP+nwWaga1Hg+ZVHp50qcd9zc1C2vz4HT3pTwmOvBv3XmAnBwEpnUB0bmwQtWcPkqH2SUf1lNNfZV3CxPLUPo25W418v7D6+3TQYZMVU/MBWb6OtV39sQ1+B3gLKYa1t3C7Guy3cpHHnbAFGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zm3Kd5tK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zm3Kd5tK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B29C4CEE3;
	Tue, 15 Jul 2025 13:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587089;
	bh=syL/pDX4A19sTKMRiOM4fPaytMInNoFiW/CBU6jy28U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zm3Kd5tKByrURgsbQ6LoJ/dDUXCCTJcOF03dXzjU+6nd7cN0qrj4eHHSro8yTgk7Y
	 fKgPJrm0NI10Zd9jgYDmHM3qVLWbCkTmq4DiTC7rRTKcddqJNzDTviNtoaWIzVE/Tt
	 nsmkc/qbwo+Y4s8l45l1watwbcaypZMGYqiIngA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.15 121/192] erofs: fix to add missing tracepoint in erofs_read_folio()
Date: Tue, 15 Jul 2025 15:13:36 +0200
Message-ID: <20250715130819.745771386@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -350,6 +350,8 @@ int erofs_fiemap(struct inode *inode, st
  */
 static int erofs_read_folio(struct file *file, struct folio *folio)
 {
+	trace_erofs_read_folio(folio, true);
+
 	return iomap_read_folio(folio, &erofs_iomap_ops);
 }
 


