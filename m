Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029562;
	b=Cn0hPGvJxMOmvQpsGl1kRZxSICKhqjPeOqVZNdvZm0odOPVCIIB41ct69i/r5L1X3LVZ
	 3KkUzlITqBt4T2twPuQ3HGMtYN40XND2QI7SBrexFzBZ9sYOFa1sJN77cHBAfNRMQiOPT
	 clx/nUkmVS3U0JBxKpIV31PnwIY+u6fAPquEBE9dWs228eouJpL99/TiBTJGeWoVj4uH+
	 ROddDUR8LpKCI5fe07CUue2xQ/KjLzJOzfmiSyy2013mZFSBbcjsLHr+g8Yscsu7XffSX
	 JZLTP6O6MGX1B0Nlnkf9M+iYa658WTdxk+GAKhDhSgvsPx+cKHHDcDlWE84t/WvQ9nA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029562;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZHEl3a53R++HhyH/aL75r/MaUBDHaSuE3MZ5C7zNzW0=;
	b=f8Xtw/ws3O0V+2Ac4oYcLdvzpAC2kFjM0KQgnb0AZDQKAn4CLmsnr0c5TyY4gEi3bvp/
	 p2ZBjCS/3HQz3m67pKBmjhAbRBDJSIgkTKXM7mKcpP+lbouL6Kjd5kNox2j2TJEayw/Ss
	 W7o/nlqdv+A/NoYcbhn8dud1f+gXKbqGNP7m7pabA1PUOuqB/K+kbwATUHqrlTp4nqOOd
	 zGGomXKn8YznRh71FU/0eDYqx7UEyIg48FvmLR7AhhmRk6UgjPR3p9cIJJqz5dWrS6DRE
	 g0INlLrTsy30PJXs+KmkMDfVPZW6Y/JTy+PkNeNjGuPegWi8w72jb9kxAknX8ptiKZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aP+qMFjj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DE19606A320;
	Wed, 18 Nov 2026 19:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aP+qMFjj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F8FD1F000C4;
	Wed, 18 Nov 2026 19:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029562;
	bh=ZHEl3a53R++HhyH/aL75r/MaUBDHaSuE3MZ5C7zNzW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aP+qMFjj8LGO5yVe9WhK9wu9VTVyt3xfiZbMDFE4l6S2C+1ViomPL14kMT4eagXD/
	 euI7JXScbMBx4BOdgEVXgmpoXbNIHUftMldRU641fDVQoMown+YHf4UlsbhQC+UZBV
	 nmHWY7BjJaLRWY1XRgs5EaoFpugfKOYF9KQP6Xyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0394/1756] ntfs: Do not kmap page cache pages for compression
Date: Wed, 18 Nov 2026 15:42:01 +0100
Message-ID: <20261118150024.441889419@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 953b79a7a124c3dae86544cea581a5bc7655aa13 ]

These pages are accessed through vmap; they are not accessed
by calling page_address(), so they do not need to be kmapped.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Stable-dep-of: a32e893a077a ("fs/ntfs3: zero frame pages on read error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index f3d8483c9f543..5b38d31bb13f2 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2504,9 +2504,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	 * To simplify decompress algorithm do vmap for source
 	 * and target pages.
 	 */
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	frame_size = pages_per_frame << PAGE_SHIFT;
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL);
 	if (!frame_mem) {
@@ -2763,7 +2760,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 out:
 	for (i = 0; i < pages_per_frame; i++) {
 		pg = pages[i];
-		kunmap(pg);
 		SetPageUptodate(pg);
 	}
 
@@ -2850,9 +2846,6 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 		goto out1;
 	}
 
-	for (i = 0; i < pages_per_frame; i++)
-		kmap(pages[i]);
-
 	/* Map in-memory frame for read-only. */
 	frame_mem = vmap(pages, pages_per_frame, VM_MAP, PAGE_KERNEL_RO);
 	if (!frame_mem) {
@@ -2918,11 +2911,7 @@ int ni_write_frame(struct ntfs_inode *ni, struct page **pages,
 
 out3:
 	vunmap(frame_mem);
-
 out2:
-	for (i = 0; i < pages_per_frame; i++)
-		kunmap(pages[i]);
-
 	vunmap(frame_ondisk);
 out1:
 	for (i = 0; i < pages_per_frame; i++) {
-- 
2.53.0



