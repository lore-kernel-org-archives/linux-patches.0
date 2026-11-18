Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044177;
	b=ZKPOEzEx7Hbnj3jVeDTX3Q0cHdybG20u3Rbb0NW6Qvq1gMgRpMpA98yyj5GFZCGVhRP8
	 GI1CsqDVrjvMcFnlSIsXFlYBDscPnLXn05uLyhvJ4KGgJfIm+GsEfkilVJBZPtiHvV9Lj
	 bFAQM+iPHupY1imoTwQdfSKHxXYIw0ACCxRfMyHgr8HF/YhywwBArSC6DY/CS3Y1OZl5O
	 L6ZORVq/kdt9cxXdsWLny8tw0JKKlbeD3jTR+35VEK8DJldRX25/2lD2XLKUPssRW1B/D
	 6ly5HSviNnJVqrORZIFUoCtSxNIFhOkOUUU8bQj5Ue8q38PYvo2F2fcn42zL4gHFQ0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LBo3HgvqKRxZZkD6iKQQHcPJp90uqOcgtLFEvH61qAQ=;
	b=efrJRbSA/PpsKan4q99C/IbUhRSLoX8mJsQPKfVWKhOYkM2gFpIpDVgyBlp/UgU5idml
	 wNRxb9H0nMAAGy0LD4wszeWt0efnK0oadgSRdr2mxlUZiNKTrtsZLEi+ENzF5MwzPoORH
	 VElAbkSylOVWVIzzK3N7ex8S14PdttC+vhx3ZkNEUsxIE6s5rBqrDiUUJMtUOaP71W7tw
	 SbqmWG1Y9e/QZJYr6FSKMOSXaIVzdlt8weHFXMpsquOzt+3xVrzNK2LPhxX5Mu+WAmIS1
	 eCW1B0eGlKKAOiPQsFTsL6/a3mHgj2KwkIfQS/qBPSDy8K91s4TPfE9XD2Io1AigaVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1D7TLlmb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6C0606A32A;
	Wed, 18 Nov 2026 23:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1D7TLlmb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 186681F000C4;
	Wed, 18 Nov 2026 23:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044177;
	bh=LBo3HgvqKRxZZkD6iKQQHcPJp90uqOcgtLFEvH61qAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1D7TLlmbA4sjZfGLjNdjMjmUmA+bwiVOdHhaPt/gOHXqV59nvsF8KSkzYuGHRYNLQ
	 sjt8g0OG5G1IeHpfhkJlLp/wSWjSTCflnLQd4qtTCNWu8+wHFuISppkOjD95sVQwb4
	 CcaTqxfCFqevK81sm3RAtkn2mPrc+0OhG3MzDYSQ=
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
Subject: [PATCH 6.1 0476/2857] smb: client: only require read lease for size-extending zero range
Date: Wed, 18 Nov 2026 15:25:10 +0100
Message-ID: <20261118150218.580396657@linuxfoundation.org>
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

From: Paulo Alcantara <pc@manguebit.org>

[ Upstream commit fafc68cccf8a00ed0a1f47c1413a3f16ce4dcdfa ]

smb3_zero_range() refuses any FALLOC_FL_ZERO_RANGE that clears
FALLOC_FL_KEEP_SIZE with -EOPNOTSUPP whenever the inode is not read
caching:

	/* if file not oplocked can't be sure whether asking to extend size */
	rc = -EOPNOTSUPP;
	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
		goto zero_range_exit;

The read lease is only needed to trust the cached i_size when deciding
whether the range extends the file. When it is not held, the size can
instead be fetched from the server, which is authoritative, rather than
refusing the request outright: query the server's end of file and take
the larger of it and the cached size for the interior-vs-extend
decision. The larger of the two is used because the server's end of
file reflects another client's growth while the cached size reflects
this client's own writes that may not have reached the server yet;
using the server size alone would wrongly shrink the file when the
range flush above left an extending write unwritten.

The query isn't lease-protected either, so its result is only trusted to
confirm the range is interior, never to justify extending: if it still
shows the range going past EOF, refuse with -EOPNOTSUPP instead of
calling SMB2_set_eof(), which could otherwise shrink the file if another
client extended it further between the query and the call.  For the same
reason, take the larger of the already-computed i_size and a fresh
i_size_read(inode) right before that call, instead of relying on either
alone: the local variable carries the query's result, which is never
written back to the inode, while a concurrent write on this client can
still extend the cached i_size during the flush, the query, or the
zero-data round trip that happen in between.

Rejecting interior ranges is observed as generic/363 randomly failing
against Windows Server with

	do_zero_range: fallocate: Operation not supported

fsx issues an interior, non-KEEP_SIZE zero range while the inode is
transiently not read caching: the server had just downgraded the file's
lease from RWH to RH after breaking the write caching, and the ensuing
handle reopen/revalidation left CIFS_CACHE_READ momentarily clear. The
range sat well within the server's end of file, so no extend was
needed, yet the range was refused and fsx aborted. This keeps the
emulation correct even when a genuine lease break from another client
leaves the inode without read caching -- the case the -EOPNOTSUPP guard
turned into a hard failure. The extra round trip only happens on the
no-lease path; the common cached case is unchanged.

Fixes: 30175628bf7f ("[SMB3] Enable fallocate -z support for SMB3 mounts")
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
[ sashal: Moved new_size assignment earlier, added the remote_i_size declaration, and kept the __le64 eof conversion for SMB2_set_eof() since it takes a pointer here. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index b9039f917c545..a7b884e8c3412 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3507,6 +3507,21 @@ static long smb3_zero_data(struct file *file, struct cifs_tcon *tcon,
 			  0, NULL, NULL);
 }
 
+static long query_server_eof(const unsigned int xid,
+			     struct cifs_tcon *tcon,
+			     struct cifsFileInfo *cfile,
+			     unsigned long long *eof)
+{
+	struct smb2_file_all_info file_inf = {};
+	long rc;
+
+	rc = SMB2_query_info(xid, tcon, cfile->fid.persistent_fid,
+			     cfile->fid.volatile_fid, &file_inf);
+	if (!rc)
+		*eof = le64_to_cpu(file_inf.EndOfFile);
+	return rc;
+}
+
 static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 			    unsigned long long offset, unsigned long long len,
 			    bool keep_size)
@@ -3515,7 +3530,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	unsigned long long i_size, new_size;
+	unsigned long long i_size, remote_i_size, new_size;
 	long rc;
 	unsigned int xid;
 	__le64 eof;
@@ -3544,10 +3559,17 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	 */
 	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 
-	/* if file not oplocked can't be sure whether asking to extend size */
-	rc = -EOPNOTSUPP;
-	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
-		goto zero_range_exit;
+	new_size = offset + len;
+	if (!keep_size && !CIFS_CACHE_READ(cifsi)) {
+		rc = query_server_eof(xid, tcon, cfile, &remote_i_size);
+		if (rc)
+			goto zero_range_exit;
+		i_size = max(i_size, remote_i_size);
+		if (i_size < new_size) {
+			rc = -EOPNOTSUPP;
+			goto zero_range_exit;
+		}
+	}
 
 	rc = smb3_zero_data(file, tcon, offset, len, xid);
 	if (rc < 0)
@@ -3556,8 +3578,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	new_size = offset + len;
-	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
+	if (!keep_size && umax(i_size, i_size_read(inode)) < new_size) {
 		eof = cpu_to_le64(new_size);
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, &eof);
-- 
2.53.0



