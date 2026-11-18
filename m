Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017319;
	b=ENO/EwJfiN0UgLGlJJ7YELcWNRl6vTYSgiB9TWi+EmT4eNk9VIjdSg5BBVolxnZcEyhq
	 HkmEokOD9NsL05kwYxmJcCR33SF1uybEn2rABIUTLkauGacYoLoc1sid+oGCA4sx29AYT
	 FAowzzeVrrxDtOShU7AXJhQvRRXJi6rl7+RBOY4X/lWgZQgKYNL8GldY051gWNfU0Akkg
	 W+cmH+IHsYLnaTSwJuYc+LGyhjLWuLCgsg+Xs5Vu73HNiln8sbT8/Bd1tJbInSHWMXv+E
	 8jnbksRSlXjxewvhCdcfSbMoPsvcN9Iqt1Tx4vga/MtXvtlPLEfK3GYctOZepGf3FkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQx8C8VBVFdCbEaPUm8CKiJYSr5LdEJdIqdDLhpn3Ig=;
	b=huGmxdiZNjH2DDduqRmKTXMK08tKS4fEWUGU404c8nVN/WL2thgWxIHxLFHk90dqyCcZ
	 /GSnQajAuxAyUZS4hkz7KL2LSts4X7yFF167AZyU42pMjMgbkFxzOY6o1QbAGroJcxk+k
	 nvzDxb+M3fRrXeoYv1E5U2OHDCoSmFKJy4iuLL/wv8EsW+Py+w6gWJvuiSNCe45RrFyea
	 cKJnqJIvkA43hVoRWCQ9y2xXurAxbihzPD0K81+PWE6QRtte/XUq9XUhPfsEXXZV4/RNZ
	 ech8taGpMaZkWIAdJg7BZZK7iA5KtDRTdLKy7966AxivZI5h4QJEao0fpnmT7K4XEKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2XGJZV3/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96BD9606A33A;
	Wed, 18 Nov 2026 15:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2XGJZV3/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D94E81F000C4;
	Wed, 18 Nov 2026 15:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017319;
	bh=JQx8C8VBVFdCbEaPUm8CKiJYSr5LdEJdIqdDLhpn3Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2XGJZV3/hKvVlE5+ib3I5LIA70F1Le3MzHgkgkj++APGwMGG1Jp/FDWkWnJLcEijn
	 C8sQPIpS2Sb+eyqobtanlFsRNlNuf7gEiltnlOYxZ3MRzyP4kyLuPvJuYoweDXnsaf
	 ytZHArMbfTgDowkNJ+GT89JErqO7KN+IxbXV49V0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Kanishka De Silva <kpskanna1915@gmail.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0825/2651] fuse: zero the correct range on a short read reply
Date: Wed, 18 Nov 2026 15:34:25 +0100
Message-ID: <20261118150317.591219240@linuxfoundation.org>
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

From: Joanne Koong <joannelkoong@gmail.com>

[ Upstream commit d0a079b5b94bf5e10f1c00bd092eda0333782037 ]

When a read reply is shorter than the requested range, fuse_copy_folio()
zeroes everything in the folio outside the copied bytes. However, for
folios with block sizes smaller than the folio size, this can clear
blocks outside the requested range which are uptodate, or dirty and have
not yet been written back.

Move the zeroing logic into fuse_copy_folios(), since descs[i].length
needs to be used, and clear only the tail of the requested range that
the server did not send.

The range is also no longer cleared upfront in the non
cs->skip_folio_copy case. This is fine since a failed copy leaves those
blocks non-uptodate, so the uncopied bytes are never visible. This also
matches the pre-existing behavior in the non-short-read case (a failed
copy doesn't zero out the range in the folio). This lets the zeroing
logic stay the same regardless of whether the folio copy is skipped or
not.

Fixes: a4c9ab1d4975 ("fuse: use iomap for buffered writes")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reported-by: Kanishka De Silva <kpskanna1915@gmail.com>
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fuse/dev.c    | 44 +++++++++++++++++++-------------------------
 fs/fuse/dev.h    |  2 +-
 fs/fuse/notify.c |  2 +-
 3 files changed, 21 insertions(+), 27 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 4148e4488d778..660323040576f 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -1253,31 +1253,10 @@ static int fuse_ref_folio(struct fuse_copy_state *cs, struct folio *folio,
  * done atomically
  */
 int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
-		    unsigned offset, unsigned count, int zeroing)
+		    unsigned offset, unsigned count)
 {
 	int err;
 	struct folio *folio = *foliop;
-	size_t size;
-
-	if (folio) {
-		size = folio_size(folio);
-		if (zeroing && count < size) {
-			/*
-			 * When the copy is skipped the folio already holds the
-			 * payload, so only the bytes outside [offset, offset +
-			 * count) may be zeroed.
-			 *
-			 * Otherwise, the whole folio is cleared first so that a
-			 * failed copy leaves zeros rather than stale folio
-			 * contents.
-			 */
-			if (cs->skip_folio_copy)
-				folio_zero_segments(folio, 0, offset,
-						    offset + count, size);
-			else
-				folio_zero_range(folio, 0, size);
-		}
-	}
 
 	while (!cs->skip_folio_copy && count) {
 		if (cs->write && cs->pipebufs && folio) {
@@ -1294,7 +1273,7 @@ int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
 			}
 		} else if (!cs->len) {
 			if (cs->move_folios && folio &&
-			    offset == 0 && count == size) {
+			    offset == 0 && count == folio_size(folio)) {
 				err = fuse_try_move_folio(cs, foliop);
 				if (err <= 0)
 					return err;
@@ -1335,10 +1314,25 @@ static int fuse_copy_folios(struct fuse_copy_state *cs, unsigned nbytes,
 
 	for (i = 0; i < ap->num_folios && (nbytes || zeroing); i++) {
 		int err;
+		struct folio *folio = ap->folios[i];
 		unsigned int offset = ap->descs[i].offset;
-		unsigned int count = min(nbytes, ap->descs[i].length);
+		unsigned int length = ap->descs[i].length;
+		unsigned int count = min(nbytes, length);
+
+		/*
+		 * The reply may be shorter than what was asked for. The full
+		 * descs[i].length is reported as read, so the tail bytes the
+		 * server did not send are about to be marked uptodate and need
+		 * to be zeroed.
+		 *
+		 * Only [offset, offset + length) can be touched since the
+		 * rest of the folio can hold blocks that are already uptodate
+		 * or dirty, and clearing those would lose data.
+		 */
+		if (folio && zeroing && count < length)
+			folio_zero_range(folio, offset + count, length - count);
 
-		err = fuse_copy_folio(cs, &ap->folios[i], offset, count, zeroing);
+		err = fuse_copy_folio(cs, &ap->folios[i], offset, count);
 		if (err)
 			return err;
 
diff --git a/fs/fuse/dev.h b/fs/fuse/dev.h
index 8d25378c09183..f6c47ae0395bb 100644
--- a/fs/fuse/dev.h
+++ b/fs/fuse/dev.h
@@ -90,7 +90,7 @@ int fuse_backing_close(struct fuse_conn *fc, int backing_id);
 
 int fuse_copy_one(struct fuse_copy_state *cs, void *val, unsigned size);
 int fuse_copy_folio(struct fuse_copy_state *cs, struct folio **foliop,
-		    unsigned offset, unsigned count, int zeroing);
+		    unsigned offset, unsigned count);
 void fuse_copy_finish(struct fuse_copy_state *cs);
 
 #ifdef CONFIG_FUSE_IO_URING
diff --git a/fs/fuse/notify.c b/fs/fuse/notify.c
index fff059f8ad859..c0428e03d1381 100644
--- a/fs/fuse/notify.c
+++ b/fs/fuse/notify.c
@@ -190,7 +190,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 		folio_offset = offset_in_folio(folio, pos);
 		nr_bytes = min(num, folio_size(folio) - folio_offset);
 
-		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes, 0);
+		err = fuse_copy_folio(cs, &folio, folio_offset, nr_bytes);
 		if (!folio_test_uptodate(folio) && !err && folio_offset == 0 &&
 		    (nr_bytes == folio_size(folio) || file_size == end)) {
 			folio_zero_segment(folio, nr_bytes, folio_size(folio));
-- 
2.53.0



