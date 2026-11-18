Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034880;
	b=UEMZXXzFa8fWAwXrIiYfKE7xMhThLQW1K0W8D1oWorx/p88imDj+Bzin5fzD26RZM8gB
	 zEb3VVG6osj0Gjc/rn03cILdkB38XViGYlVB2zpq94RJDZcI4HZxOkNhFG5wtCWmZgYF1
	 A4DlZQOGxWabZ9ddnBHA1EAOJ2juMQ52KHlvWMe6WZrhvy57awYtCla2kZLTOmeQznmLp
	 hS3WxZnqAfjHsTtkg0hDErRn+2ya7QyQCAgtZ/dKmgFGPXo11FISb4HxQw2ClWBlZX/KD
	 +80WiVmiTkN9vtFwLfGqtDxjR9PdX4l9JOSyE2NDWk4TdF0OMEtqPGK//h84DEKsAYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034880;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iA/CPga8Qx8VGse9AI1gF/Lua/D5IOnoW4DM7R2qBzo=;
	b=mNieLdC4SI/utFEBAWmf7fQRiBdjJbo8mxSqJUD6T6+I/UX/19Fb+TJp3oJDpMuPW7W9
	 Hw0NA8qrSz9qMiKgEBHzL2h26yJUE/iAX1JdbtHMmk7D8jDjhj7cwaQR80JarRNySTQED
	 /a1C3no2KMqONrPqVEdbohFDq0StWS8dsWaDT/pSShiCbUHKMUPF4zTSxBRw2khHmeqQD
	 bozweXgoJJgfy6TlabbOnV/5W+jBUgC5AsNbCpo0jegPmfDWtHtddomCbR09AJ9GJovzl
	 4B3zIN3R6ranIJn+86D6GBkTNvmJeIkWZ7qfWqXkClBeNwCL/+huJnbg/IULT7KjfJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYT8t0m0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C6B606A31C;
	Wed, 18 Nov 2026 20:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CYT8t0m0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEFC1F000C4;
	Wed, 18 Nov 2026 20:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034879;
	bh=iA/CPga8Qx8VGse9AI1gF/Lua/D5IOnoW4DM7R2qBzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYT8t0m0TDMwqc9Ed04MLAzOw3aONfRrwXjPY2AwzMwGASvbsvGwcO+SLhdsDKjok
	 U2ddtdpSIGgwkVyvCWVfn9kqwI0oWwrLb8KN7aus5czeiVbqycyAygcA+4PVWoDIuY
	 8VX57hNLixD3sel3iQOwIpbeOq+jnQrBoYCdvDgQ=
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
Subject: [PATCH 6.6 0525/3318] smb: client: only require read lease for size-extending zero range
Date: Wed, 18 Nov 2026 15:19:07 +0100
Message-ID: <20261118150332.947757249@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Added the missing remote_i_size local declaration in smb3_zero_range() since the surrounding context lacked it. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/smb/client/smb2ops.c | 33 +++++++++++++++++++++++++++------
 1 file changed, 27 insertions(+), 6 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index 256b8ddbc2b2f..f657d9696d1da 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -3254,6 +3254,21 @@ static long smb3_zero_data(struct file *file, struct cifs_tcon *tcon,
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
@@ -3262,7 +3277,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	struct inode *inode = file_inode(file);
 	struct cifsInodeInfo *cifsi = CIFS_I(inode);
 	struct cifsFileInfo *cfile = file->private_data;
-	unsigned long long i_size, new_size;
+	unsigned long long i_size, remote_i_size, new_size;
 	long rc;
 	unsigned int xid;
 
@@ -3298,10 +3313,16 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	 */
 	truncate_pagecache_range(inode, min(offset, i_size), offset + len - 1);
 
-	/* if file not oplocked can't be sure whether asking to extend size */
-	rc = -EOPNOTSUPP;
-	if (keep_size == false && !CIFS_CACHE_READ(cifsi))
-		goto zero_range_exit;
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
 
 	fscache_invalidate(cifs_inode_cookie(inode), NULL,
 			   i_size_read(inode), 0);
@@ -3313,7 +3334,7 @@ static long smb3_zero_range(struct file *file, struct cifs_tcon *tcon,
 	/*
 	 * do we also need to change the size of the file?
 	 */
-	if (keep_size == false && (unsigned long long)i_size_read(inode) < new_size) {
+	if (!keep_size && umax(i_size, i_size_read(inode)) < new_size) {
 		rc = SMB2_set_eof(xid, tcon, cfile->fid.persistent_fid,
 				  cfile->fid.volatile_fid, cfile->pid, new_size);
 		if (rc >= 0) {
-- 
2.53.0



