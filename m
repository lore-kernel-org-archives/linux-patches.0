Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033DA2E2F0F;
	Tue, 15 Jul 2025 13:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585936; cv=none; b=Hj+6p2HfkAgYyRHBq3ox+8QmbLivjlvZaEgWHDPjh6VczdIJV4m7+yAeRrTf9H1WQNET8eBeg6DrtUxzQRpabTfFVl8vAqB8letooF4cS+ZhZ9GSkLucv1cInTcP2YpPSJJp1byHEZZoIVqkVgXIvPlyspUXP+7enNL17XWywE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585936; c=relaxed/simple;
	bh=B/3PSWz/S5N5/ipt9cOtCJctXYHjBBTHt9vHzPWguY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JPzVtJyKwT7/g5asON9lrCF27LW5VOk7zsrIR5bQPZVC2CdQ/4RUmsTL5d6dMj1OdQ1FpFH1RXEuJAjRPmcLxWRtDbJLg99c3VlloJSTxBhHGGDiaPiHjj3TVgkUqG901n/iXg8eDOltVL/3i9gFFgtYBwZ7tifunGfEQOkkilg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zqxztoQv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zqxztoQv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BED1C4CEE3;
	Tue, 15 Jul 2025 13:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585935;
	bh=B/3PSWz/S5N5/ipt9cOtCJctXYHjBBTHt9vHzPWguY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zqxztoQvnY0e6NhzufidR7jYLKvYZNFYYBSbRmhwJPVeZm9DWzti87iib4s0pvMF1
	 l34Ho7kfDiHs+MsnYhz1n5P+tklx6IZ6hv4o3O74WOuzDSgvPS4fbk/y3WIkAIIVgC
	 Xflzo61QQLlTPqmdwnFTY9gLaiSq05EBMAK9lGBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.6 063/109] erofs: fix to add missing tracepoint in erofs_read_folio()
Date: Tue, 15 Jul 2025 15:13:19 +0200
Message-ID: <20250715130801.406011581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -358,6 +358,8 @@ int erofs_fiemap(struct inode *inode, st
  */
 static int erofs_read_folio(struct file *file, struct folio *folio)
 {
+	trace_erofs_read_folio(folio, true);
+
 	return iomap_read_folio(folio, &erofs_iomap_ops);
 }
 


