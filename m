Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213152;
	b=X0yXge5X2rmu1A9GxjeJewQrn0bHBLlW/dgfamMuPKpxatnrj5x2MjfK44RNszn2ykdV
	 rR6YjX0WmGnxs5ynXwVIl4i6PL28hjyJjv4VMnJAuNh7BT8SeRCG3CqV3YExGparVPPJS
	 /4y5PNMc1zUMYbaadJKRtbhYRghGMJI+pR/J6cuEfJWzISPmnYLUtWuTHXfq2EBCRuqh6
	 fPIKaFl9X2HvfikjM+FsvaYl143O/9tTAcz0ZrnIqRcO8w+RFDI0ZnFgtV1BXhPlRc1QM
	 B/ayzZhiIRnzVcMlyh3A28CgnNpXEbLCXpccwG9yjvTJlUKmOqqRJnVx2Ocg9ip9stA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213152;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q2g9Jw7WFxJv41D3VAOLvCnxIbGQaHPkczeID8LrYHI=;
	b=5EIcZaSanZaJBccqDCu1BAUPGDNcq6TZvwbwCEW3yiKpVGpC+bQ999mObECdZkv9Vryw
	 7N1DZx+DVKqnoQCFdtc+OecnkwH3gGckhCsnYGeOpIQ/71ZQdJP42C6VpJXaZiAFiNiqQ
	 uwNi6xIVaFf7SNttwQ0bfPs9v5IPwySAUjLkdMJKzt7p67zINOm1nwbgDyc2yamegWQvd
	 cmFR58wrzDeMH0zWDhhZq+cUSyjFE1bRUShoz4kx1kAT5EAhfzVHIEWfRSr9DknmUyX1A
	 uGmZBqQ+bmkWoeGJ9RPL4Yc7DROItn7peo85PtFb67euOse5Rph/zz9wl7dU3d3eIsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEUnrM6Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67DF3606A334;
	Wed, 28 Oct 2026 18:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LEUnrM6Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF33F1F01825;
	Wed, 28 Oct 2026 18:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213152;
	bh=q2g9Jw7WFxJv41D3VAOLvCnxIbGQaHPkczeID8LrYHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LEUnrM6YSu6gjI+om2iWsoBDbAbWYlbQbSGpbmaeMBgMkV2iwvPw06xjEImkJAXR4
	 O8YEJzsvDG1rFc17f2qxQMP9xb22i9Q2ASr/gIEw0u+BBF8EXhY7CPKF3Dgk5l3Ebg
	 b/niFjtzVuCGRNVwDlKPcmlLwcxOc3/i4vglYGOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Zi Yan <ziy@nvidia.com>,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Dave Jones <davej@codemonkey.org.uk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0406/1887] fs: Free any excess xarray nodes in clear_inode()
Date: Wed, 28 Oct 2026 17:41:42 +0100
Message-ID: <20261028170508.471652083@linuxfoundation.org>
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit ee3f011250104129893d8e9599147e457d4d7280 ]

For many years we've had a hard to hit leak of xarray nodes.  Hugh
documented it well in commit 786b31121a2c.  Recently people and
syzbot have found ways to force it to happen with madvise.  Rather
than fix the leaks where they happen, just call xa_destroy() which
has the side-effect of cycling the i_pages lock.

Cc: Rik van Riel <riel@surriel.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Link: https://lore.kernel.org/all/20260121062243.1893129-1-tujinjiang@huawei.com/
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://patch.msgid.link/20260623192850.1595958-1-willy@infradead.org
Reviewed-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/inode.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 0036d5c68fd41..5c46e7bb931db 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -642,21 +642,18 @@ void dump_mapping(const struct address_space *mapping)
 void clear_inode(struct inode *inode)
 {
 	/*
-	 * We have to cycle the i_pages lock here because reclaim can be in the
-	 * process of removing the last page (in __filemap_remove_folio())
-	 * and we must not free the mapping under it.
+	 * We have to cycle the i_pages lock here because reclaim
+	 * can be in the process of removing the last page (in
+	 * __filemap_remove_folio()) and we must not free the mapping
+	 * under it.  We also remove nodes which are empty; these
+	 * can occur in two different ways.  The first is that radix
+	 * tree expansion can fail partway and the second is that THP
+	 * collapse_file() can allocate some temporary nodes and not
+	 * clean them up.
 	 */
-	xa_lock_irq(&inode->i_data.i_pages);
+	xa_destroy(&inode->i_data.i_pages);
+
 	BUG_ON(inode->i_data.nrpages);
-	/*
-	 * Almost always, mapping_empty(&inode->i_data) here; but there are
-	 * two known and long-standing ways in which nodes may get left behind
-	 * (when deep radix-tree node allocation failed partway; or when THP
-	 * collapse_file() failed). Until those two known cases are cleaned up,
-	 * or a cleanup function is called here, do not BUG_ON(!mapping_empty),
-	 * nor even WARN_ON(!mapping_empty).
-	 */
-	xa_unlock_irq(&inode->i_data.i_pages);
 	BUG_ON(!list_empty(&inode->i_data.private_list));
 	BUG_ON(!(inode->i_state & I_FREEING));
 	BUG_ON(inode->i_state & I_CLEAR);
-- 
2.53.0



