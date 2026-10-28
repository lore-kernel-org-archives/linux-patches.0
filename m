Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213166;
	b=VOxySKg5Oy+O+I75tYaCq7vDiiNWYM1TfBQmVVWxSusq/76eki1hab41lZ+uLZPqQnIR
	 uZWaR5lO8AF/u4cciqv6xMOAXTmnUBFA9gLOmxNBOGtAEEH5kBPIh7BuezqeHKMSuqhyT
	 Dgck90NoWRUXZ5ol0p6ZLPo632lCgUad4ryhcJDXIc15Fpxa6oXB/cEQlNG4Avx+8sx99
	 /T9E9fdgQxXQsCT805V51sFXHuQnzZWO/FwTmw/N5eTsBICr0YPYX58w0aUdYlPwzyEUE
	 SsgqYGbAWKm0ciNuZPZcWIAIMBuTV/Zh0kg4oYmAWsA3dQr93yY1BOuamggetfKp+Fg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213166;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7wyfPaNs08Xciwf6GGSYXQIaJ8x6Eq10qHjTXX+AHKU=;
	b=zkrTeQBUgXtIvIE8OQy9a3BSa5x26g9+aCciIp7I2fQW0E6nsItlidQYnzHttn1hHBmc
	 rIZQvf7SkdPDPsu8MikHNelg/PC6SGPveLGbEgb4GKsRJTUCOgcv3s4V7mITCQZ+8aNQw
	 xac+gKbn2s46BlaChcGOpZNBqH1z5NHhbSpAdlC4pNjQcQz9QuMwMPEhBU4dCFq3+2BC8
	 X7CO+wn987Vdy+xnhmm+1I5nCGZyWASdJHXLmTjtEOo/N22kDEdGpe6xIGJQT7TlPyaz0
	 xZVG0UKX9f80GEgpxRsh3p4YEqI+ymmteIcEmREEuhN61zZQCd7jY375vy0E6PuPoeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtLAyOtN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67F74606A31A;
	Wed, 28 Oct 2026 18:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MtLAyOtN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC7491F01825;
	Wed, 28 Oct 2026 18:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213166;
	bh=7wyfPaNs08Xciwf6GGSYXQIaJ8x6Eq10qHjTXX+AHKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtLAyOtN/Tpvrg+0mdWjJ6PgZcoTC5jXfSnrBYly44ZO+B8x7bGwb/2v+PBXXIV1D
	 73AIDM10mZNyNuPh8V9UkceKRfTq7gRPGLLQm3QIYsxEXMSG9ftOgBbi9hdnKwi6Qb
	 kU3IW47TKvC/CiuQT4LjgCa100y1EGj9UDi48bQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Christian Brauner <brauner@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0410/1887] smb: client: discard post-EOF pagecache when extending a file via zero range
Date: Wed, 28 Oct 2026 17:41:46 +0100
Message-ID: <20261028170508.566223552@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit da4fe97fb6c730d9c94a115c7bfa6f98e0d578d0 ]

smb3_zero_range() removed the pagecache only for the range being zeroed,
so when it extends the file the folio straddling the old EOF - which may
hold data dirtied past EOF through an mmap - was never dropped and became
visible as file content once the file was extended.

Lower the discard boundary to the smaller of the zero-range offset and the
old EOF.

Fixes: 72c419d9b073 ("cifs: fix smb3_zero_range so it can expand the file-size when required")
Reviewed-by: David Howells <dhowells@redhat.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Shyam Prasad N <sprasad@microsoft.com>
Cc: Tom Talpey <tom@talpey.com>
Cc: Bharath SM <bharathsm@microsoft.com>
Cc: stable@vger.kernel.org
[ sashal: Adjusted context because smb3_zero_range() lacks netfs_wait_for_outstanding_io(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 973a46daa37b3..3278591b3647b 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3542,8 +3542,11 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * We zero the range through ioctl, so we need remove the page caches
 	 * first, otherwise the data may be inconsistent with the server.
+	 *
+	 * Start at the old EOF when extending so the folio straddling it, which
+	 * may hold data written past EOF through an mmap, is dropped too.
 	 */
-	truncate_pagecache_range(inode, offset, offset + len - 1);
+	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 
 	/* if file not oplocked can't be sure whether asking to extend size */
 	rc = -EOPNOTSUPP;
-- 
2.53.0



