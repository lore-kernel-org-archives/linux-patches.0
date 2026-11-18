Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019797;
	b=N10R66kfKMaYDnU3Jsgm6IZIoBS+sHXoJz+AGzMlsyQcmetLUzLDbxrT/Qd9OrofeJUx
	 Dw1x2oSdAPteKTmX6eteYpGGJdBrFJyVCUl4sn7yQxT3IomH2PP7Tbx86GVC4DtYJniH8
	 tMr7DzoCtM+vusJY+DTbRS2Lby5TXK6+9iCfjK+3yJBuLqrOW4cILnW3T495zHWTup9/f
	 boZtxry99R7jwD821/Ou2dnaqJ1VrIWwoER1M84zyD++PrhvAaCDz0e0K+cyfQSEPDWev
	 i/eza+lS7Nw1F9gRCmOlj3bEVUSVdaUuTWUm1hl0AsndFGe7bxGyMYM7YyH4O07eKEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019797;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=g0TiSumrAujUzrU1Pxnp1GC30sr+8HxtKi5wUg+DTWg=;
	b=JfyHSRD3h3kxCr7WHlsARS9csE5WqOLuX6CHgbM+kUYbCYVETXIGNewxNUhG3hFit8//
	 2JgPjukzmE/mYEEIvOAsTkMD4yNezPmq41kwOtd2NzBODj2lEciPSUH08QM4C/NBFZBiJ
	 j84Df8Krus9AewqPOsWmI4mEiufVrIdGXt8IIyNQUNniz3bKCratcrQSiDSAhHlBhNScn
	 DZLxI6mFlM3pqOkmOZyzy42GTCWKKjiw7lhepJIVe7UhkjknIEOfEifYbrLA9CYfRSvvU
	 a8VN+dYk/tZDO3XUlrLOJRlOJCxdMrH/M1LXiHfPggyrve8CbF1+sxofUjmgq8kVM+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5Z7ELM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0537606A331;
	Wed, 18 Nov 2026 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n5Z7ELM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F861F000C4;
	Wed, 18 Nov 2026 16:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019797;
	bh=g0TiSumrAujUzrU1Pxnp1GC30sr+8HxtKi5wUg+DTWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n5Z7ELM+vPsi6J+II89wLqsjAus+XtGjxglVBto9wc1nAio5qYdmMy1G92sHfe9yp
	 gsindoZVwh3GMuERkCyQ8Mi/DANj1k5zeAvGTWbBwXfc6IBAz+jfBRmSGN/fJtlVJ3
	 dJbGztB/CsLbI3BZF2Kf0Pjh0VQnFmcdguvH86O0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1724/2651] fs/ntfs3: do not mark frame pages uptodate on read error
Date: Wed, 18 Nov 2026 15:49:24 +0100
Message-ID: <20261118150349.696994865@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 80218408836fa6fc91a9c26a9c014f81abf9e41f ]

ni_read_frame() ends with a loop that marks every page of a compressed
frame uptodate regardless of whether the read succeeded:

	out:
		for (i = 0; i < pages_per_frame; i++) {
			pg = pages[i];
			SetPageUptodate(pg);
		}

Non-critical frame pages come from __filemap_get_folio(FGP_CREAT) and are
not zeroed. On an error path that reaches out: before frame_mem is
written, these pages keep uninitialized page-allocator contents but are
still marked uptodate. A later read() is then served from the page cache
and returns that stale kernel memory to user space.

For an unprivileged user mounting a crafted NTFS image this is a
repeatable kernel memory disclosure.

Mark the pages uptodate only on success; on error leave them !uptodate so
the read path re-reads them or reports the error.

Fixes: 4342306f0f0d ("fs/ntfs3: Add file operations and implementation")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/frecord.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 4651dd8f6464c..0f56437169e09 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -2290,7 +2290,6 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 	u64 vbo_disk;
 	size_t unc_size = 0;
 	u32 frame_size, i, ondisk_size;
-	struct page *pg;
 	struct ATTRIB *attr;
 	CLST frame, clst_data;
 
@@ -2522,11 +2521,10 @@ int ni_read_frame(struct ntfs_inode *ni, u64 frame_vbo, struct page **pages,
 #endif
 	vunmap(frame_mem);
 out:
-	for (i = 0; i < pages_per_frame; i++) {
-		pg = pages[i];
-		if (err)
-			clear_highpage(pg);
-		SetPageUptodate(pg);
+	if (!err) {
+		for (i = 0; i < pages_per_frame; i++) {
+			SetPageUptodate(pages[i]);
+		}
 	}
 
 	return err;
-- 
2.53.0



