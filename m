Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064199;
	b=vw534Jcy3L7dmF3/nV4/X9TQtD01WDRVMY8r84mHVYVrObluSegKvkJo59BVnLLiAsp+
	 C+q0PO6+aTRHDjWQ8crwC/Tj7MxpM3oDVLAye4fw94yr3oh4W/RHqg8RWWLV+Xb3bZfHo
	 X1Ph/YXx/IbL2OKUW/V7vayoLdf4xNMmIy0VNXsIzTPKObnr97WpfxL4xemQjh1Y9GjEW
	 51D+U2L4VgL2hgis53BbaNEXAk/n8wUUp1iJaTlmxO7rohuQUuD6DLB/XoRkmexwtlihR
	 kGHBBlHoWckf74OJBq7wJJqn+HSG8D3itMVCFVMJeXXpbUky75zP2OTRSpuFEioy4SA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Dx1vRwxgW+rt2YzUgdoxCKC39dH8zPP49BQ46ZlggMM=;
	b=Iv0bs7QY7Jz8La5bq2Db5SGKi4dy7iSrENkp5RY4F1e2l9pR5B2pcoSkCsFr0AfhZVSh
	 ohw0InRLAjVpfz9v5vGcAV87HQqC/5xilXo64WQGKp7L1awFeObNV3pIx245msfiV1nMp
	 XPPjiRwZULJn6EDee4gnkzO587JE5i+1dJl7ZtIBF8A7FMEmdTNgv74tZzZOjn8wfmzEx
	 GLjiTGznuEvmOSpV3Hi7lKvn+9FXPwblutXoWtPO+HI4kE7AkJBns1tfT/PBS2hYUULtQ
	 AU1/lo/jYDiAqxgrhUBhMoA5XkaNhHRiQjm4yCD6lBsM0dOQvwAl8yh+69znTRkSc+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jpn+0ntZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D67606EEB2;
	Sat,  7 Nov 2026 15:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jpn+0ntZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C12F1F008A2;
	Sat,  7 Nov 2026 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064198;
	bh=Dx1vRwxgW+rt2YzUgdoxCKC39dH8zPP49BQ46ZlggMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jpn+0ntZjVEldzsJtUAv+l3ASTZWjTCi1kRLguiqgfwkfGOZ0Bb8H3c/nusl4IY/x
	 1q5XVFNTQQxyh8kah22r5Cx8TZ0b/khukQKcOrYiQXCe7Om/JrwlNaDSUdCUv8HbvP
	 vwrkP2yPGQyijRSdJUI47/Wt1He+CUJKSTSMUo8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0299/1257] fuse: dont shorten the folio descriptor at LLONG_MAX
Date: Sat,  7 Nov 2026 08:43:15 -0500
Message-ID: <20261107134947.717580456@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit 4c72635f913850512d5fa74bf3eb7db3670398cf ]

fuse_send_readpages() and fuse_do_readfolio() both decrement the folio
descriptor length when handling the overflow case where a read would
exceed LLONG_MAX after incrementing the file position by the number of
bytes that need to be read in.

Shortening it is unnecessary (and for the virtio-fs paths, a bug), and
with fuse using iomap for handling reads, shortening it is buggy.

For fuse_send_readpages(), ap->descs[] is also what fuse_readpages_end()
reports back to iomap_finish_folio_read(). iomap accounted the full
length when the range was submitted, so the lengths reported on
completion have to add up to what was submitted. Reporting one byte less
leaves ifs->read_bytes_pending nonzero, folio_end_read() is never called,
and the folio stays locked.

This is currently reachable on fuseblk mounts configured with block
sizes smaller than the page size.

Fix this by leaving the descriptor length untouched. The reply will then
be one byte shorter than what the descriptor lengths add up to, and the
last byte will be zeroed in fuse_copy_folios().

This also fixes a bug in virtio-fs that existed before any iomap changes
were added to fuse. For virtio-fs, data there arrives by DMA rather than
through fuse_copy_folios(), so the only zeroing is in
virtio_fs_request_complete(), which compares the reply size against the
descriptor length. With the descriptor length shortened, the two are
equal and nothing gets zeroed, which means the unrequested byte is left
holding whatever was in the folio, when the folio is marked uptodate.
This is both in the fuse_do_readfolio() and fuse_send_readpages() paths.
This dates back to commit 2f1398291bf3 ("fuse: don't overflow LLONG_MAX
with end offset").

Fixes: 4ea907108a5c ("fuse: use iomap for readahead")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/file.c | 38 +++++++++++++++++++++++++++++---------
 1 file changed, 29 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 9a36d0329e221..b52f5b45646c9 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -864,18 +864,29 @@ static int fuse_do_readfolio(struct file *file, struct folio *folio,
 
 	attr_ver = fuse_get_attr_version(fm->fc);
 
-	/* Don't overflow end offset */
-	if (pos + (desc.length - 1) == LLONG_MAX)
-		desc.length--;
+	/*
+	 * Don't overflow end offset.
+	 *
+	 * Ask the server for len - 1 bytes. desc.length still holds the full
+	 * length. When the reply comes back, it will be one byte shorter than
+	 * desc.length and fuse_copy_folios() will zero that last byte.
+	 *
+	 * For this reason, desc.length must not be decremented too. The caller
+	 * reports the full length to iomap_finish_folio_read(), which marks
+	 * every block it covers uptodate. Shortening the descriptor would
+	 * suppress zeroing and leave the last byte holding stale data.
+	 */
+	if (pos + (len - 1) == LLONG_MAX)
+		len--;
 
-	fuse_read_args_fill(&ia, file, pos, desc.length, FUSE_READ);
+	fuse_read_args_fill(&ia, file, pos, len, FUSE_READ);
 	res = fuse_simple_request(fm, &ia.ap.args);
 	if (res < 0)
 		return res;
 	/*
 	 * Short read means EOF.  If file size is larger, truncate it
 	 */
-	if (res < desc.length)
+	if (res < len)
 		fuse_short_read(inode, attr_ver, res, &ia.ap);
 
 	return 0;
@@ -1068,11 +1079,20 @@ static void fuse_send_readpages(struct fuse_io_args *ia, struct file *file,
 	ap->args.page_zeroing = true;
 	ap->args.page_replace = true;
 
-	/* Don't overflow end offset */
-	if (pos + (count - 1) == LLONG_MAX) {
+	/*
+	 * Don't overflow end offset.
+	 *
+	 * Ask the server for count - 1 bytes. The reply is then one byte
+	 * shorter than what the descriptor lengths add up to, so
+	 * fuse_copy_folios() zeroes the last byte when it walks the folios.
+	 *
+	 * ap->descs[] must not be decremented here. It is what
+	 * fuse_readpages_end() reports back to iomap_finish_folio_read(), and
+	 * iomap has already accounted the full descriptor length, so shortening
+	 * it would leave ifs->read_bytes_pending nonzero and the folio locked.
+	 */
+	if (pos + (count - 1) == LLONG_MAX)
 		count--;
-		ap->descs[ap->num_folios - 1].length--;
-	}
 	WARN_ON((loff_t) (pos + count) < 0);
 
 	fuse_read_args_fill(ia, file, pos, count, FUSE_READ);
-- 
2.53.0



