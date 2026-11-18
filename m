Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048203;
	b=aJ2XtX4254yLN8hQlUnSkKq1LnwWDQX28zI5snuC2HDPwrDosLC6j5Cj2yu0BBVpleEF
	 xUrQJy0MEK3JrqIFRm/4dd/CIQe+TbJUdytgqW8BAKLb41JEne7fV/CGdq6mvvK7zW7o1
	 ndlyFJxveH6ZXRmdfD3nRycvxicnGKmBY+yLW6fZcQGslsiRKKo2fKHvce747NXhCQf4Z
	 ZF/01VDbJa98THnBQ5oTy1xRh27cKKBfuhsbEAYiBhuk6cHAsRYp9Xbv58D33s5lRHMTJ
	 y9FkcvaBAfuu1UilIITR7s9IjmeptsBVQG7XhxI9MvUy4PtBHLLsGR+QMr40/jSiKyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jSkeKk6Sus5ofzgNjPeuDT+6ALV9o9BRuSBFuGRy6YM=;
	b=EZVvWn6P71j1FdVxSOHJnedmf4uqvPQ68nBF32AQ9znaq5yQk73ffm+l4d6hHvaoAgba
	 Rm4snT1l/5dTNkGjlP7VrBo77ep9aHQZaG+Z0rnmTjY9y9uov38O4f6WOBEjR2H5Dznp+
	 tmEqPcc5sr1VytFMHLIfULt0TQaDluPBbArIW/vyRZKJsHuRYu62i1dVnNYUDzMyTIXDQ
	 b0/ponRm+9Rwnbov9LfVI8LwNunMKCzY0h5QnzC5mh2pFTzFYDAt1nDOnSNCRXOJlnQXK
	 SOHDJtkQ/MKtf130pAv10wsKSZ5lnmJtEZ8YIEy7bj4ZV0WAMjWctV1SP+6aI3sglig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmxQHFKK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5D1606A325;
	Thu, 19 Nov 2026 00:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmxQHFKK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E8B1F000C4;
	Thu, 19 Nov 2026 00:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048202;
	bh=jSkeKk6Sus5ofzgNjPeuDT+6ALV9o9BRuSBFuGRy6YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmxQHFKKyls3GwHHaVsiomPwgm3Lo6KeQt5pCVTALp0m14KVbT7JEPUHn6DYKf5wg
	 O2alQhjaJaS4D5Sa7p7hOQ0qR56b0nDq4oJnzsGchMaklNXTJeqxyLBYDnji891Xvm
	 a2MZ4nH7hHnIC7aNHiowRjETqtntKN3rjT8Hs2V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1912/2857] gfs2: Fix the return value in gfs2_get_link() kernel-doc
Date: Wed, 18 Nov 2026 15:49:06 +0100
Message-ID: <20261118150310.061574523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 700a0a6892f7c0c541d5d23837cfab98cc744d17 ]

gfs2_get_link() returns the link target or an error pointer, but its
kernel-doc still describes an integer status. The mismatch dates back to
when gfs2_readlink() was replaced by generic_readlink() and persisted
across the removal of nd_set_link().

Describe the returned pointer and error value.

Fixes: c177c2ac8c5a ("Switch gfs2 to nd_set_link()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index c291b9382e994..02cac4dbf0b1d 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1779,7 +1779,7 @@ static int gfs2_rename2(struct user_namespace *mnt_userns, struct inode *odir,
  *
  * This can handle symlinks of any size.
  *
- * Returns: 0 on success or error code
+ * Returns: the link target on success, an ERR_PTR() on failure
  */
 
 static const char *gfs2_get_link(struct dentry *dentry,
-- 
2.53.0



