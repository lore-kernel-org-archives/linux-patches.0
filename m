Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1560037F8AF;
	Thu, 30 Jul 2026 16:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428223; cv=none; b=eg5PmJd3/xLpmdafyZxyWeGQslYyVrgQhulyOP7BCpwrmboQHp37J7z+pcguJJ5oVISbn8mFqjRzHPoX4gVq7Me6NthlD+z6Wz7+kss07Vq114ItekMKPyLSd7FauHkc9WZ1+qMoq0FZ+YN2mvxnmOlpvrwYfn6/ulJB0CnpRtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428223; c=relaxed/simple;
	bh=N39GDWBRXphSjDrEp7WAuY+mz1yC2sy+u+4G2a5xMhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jmHRcYl8HXplVQPqqAYr2gh780xDz7nJekjtGzGe6+jttshYpFrRTqfW+fZbmO7nDvz5xxqnDHSpYrKAu0pp0q5C2eWzjtpVWKxXIpWvrdKBWgvEtktIzt1ZOb8bppvrq1OxD+EqVz6q/uwK8LOeV4BoRGCaR5q8YdJHeHfs/U8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJs52TPT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJs52TPT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C3A1F00A3A;
	Thu, 30 Jul 2026 16:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785428222;
	bh=ICF1UQ7gKB8GZFKl/NL2qR8gH1avPJeVeluo14kN5m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WJs52TPTx9XJlY8QWGZUxmcCxXKiDZm/s0O6rSXj05+/oaB65DOwetA9zMwXS0koG
	 ybd52ind/N6Q9Z+Y591UHHgYF63dLVQTgE0qpCTTG2p9OBLJnJev76XGus2sJkgpOT
	 lA/X05uQo5H6QsUTWd25hyPzyHfvMfiJpbR51C+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 445/484] nfs: remove dead code for the old swap over NFS implementation
Date: Thu, 30 Jul 2026 16:15:42 +0200
Message-ID: <20260730141433.148489978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 7e8e78a0ba00c88f0ded86de64bdddc82e06b196 ]

Remove the code testing folio_test_swapcache either explicitly or
implicitly in pagemap.h headers, as is now handled using the direct I/O
path and not the buffered I/O path that these helpers are located in.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Stable-dep-of: 27934d02cbeb ("NFS: Charge unstable writes by request size, not folio size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/internal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -791,7 +791,7 @@ static inline void nfs_folio_mark_unstab
 					   struct nfs_commit_info *cinfo)
 {
 	if (folio && !cinfo->dreq) {
-		struct inode *inode = folio_file_mapping(folio)->host;
+		struct inode *inode = folio->mapping->host;
 		long nr = folio_nr_pages(folio);
 
 		/* This page is really still in write-back - just that the


