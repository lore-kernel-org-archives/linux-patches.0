Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065073;
	b=yswWX+HRYlpQy6b/nC25cX6ZXwBiuKO+Ts9QvpzDwXGDJb3pNq57e09MifASY82Z3ZH8
	 vIJmPu8Bn6hFHmFocqx7bZBgjXgOflFl8Y8kErlcRdl3x4GPLDIVyY4vfvdT0pQZ50lpT
	 Ou2sZVFV4c0ZNgi3OJOOS9K0JvOE2kln9CdsIZqIstHGp8L+cqCoB0nrKZZecHfJojWB6
	 +gkBskfTiZ++Mjh/71w9QNFBsC06ZkW93aaorp0EAHDJ5hKhvMBNS1ha28qktH18qr5u/
	 WGmIprf2YpbpKaHNBYtdQwu3B7ZW4/3i7rn4G9ASVlh+boiXb2YNpTDBAyj6ONiIRfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WrGik/Gfoodt/030ZwLuiiiWFA3sTfsaCvWLZIlDIpc=;
	b=GLW4O17yr1tlwISZ7X5EpI9mzUz6Rh4t5RpR5Ekl2qk0R7rbbgab+cEXHB6y/8gBEATc
	 yv2fMUksZz20tFH97vd1xjKK0OYcKMEsa9euzB8Kj/GzG+Mkjo2mCcjtNkgiRvlRUlw4n
	 +ycgaCAk6IPCABayDsZ9GlOI9IOs5NbVr16BYMAQqQw9OVX8eRCuQUAINAvAtUy1XpcF2
	 mQPyJtoVNw5pX1MgZdqYQCKfj//t4gkBezhfo1RrcE1/wwx/47MLwMEGLAoGTGHFwrsse
	 nd1cpJLPsIDkISYMzw7SfU7hg6KXrsl3/Llb84yFkwtYlgFi2gfk40Ob7r3oNTPurDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDhwCROn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FE8606A32C;
	Sat,  7 Nov 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uDhwCROn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B711F0089F;
	Sat,  7 Nov 2026 15:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065073;
	bh=WrGik/Gfoodt/030ZwLuiiiWFA3sTfsaCvWLZIlDIpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDhwCROnzguDwKiTh1gu1FngNaNkw989b1k0RrB7XVzqToJZZYB2TYgUveA1HzaJH
	 UxoGHe5o/fDnLgfx4ej7jeon6ctUC9mvl4pejB2CLU9rcK6iuJlZpSO+OGBGgfmOTD
	 WDnro2lpjdo1GgOycToXEGe/eRAW0/TbkCuJZxvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0912/1257] ntfs: use sync flag for direct MFT writes
Date: Sat,  7 Nov 2026 08:53:28 -0500
Message-ID: <20261107135004.535203278@linuxfoundation.org>
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

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit 43e2fff9f4ec9ff5a9731bf874327eca21259867 ]

Use the supplied sync flag for direct MFT writes instead of forcing
containing-unit writes to complete synchronously.

Pass sync=1 from ntfs_mft_record_free() so the MFT bitmap entry is not
released until the record write completes. Other direct-write callers keep
the completion mode requested by their caller.

The folio lock serializes write preparation, and PG_writeback keeps the
whole unit stable until all chained BIOs complete, so asynchronous
containing-unit writes remain safe.

Fixes: 115380f9a2f9 ("ntfs: update mft operations")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/mft.c | 17 ++++++++++-------
 fs/ntfs/mft.h | 14 ++++++++------
 2 files changed, 18 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs/mft.c b/fs/ntfs/mft.c
index 77acc26a85d90..8bb8b4085c8b0 100644
--- a/fs/ntfs/mft.c
+++ b/fs/ntfs/mft.c
@@ -671,9 +671,13 @@ static int ntfs_prepare_mft_record_io_units(struct ntfs_inode *ni,
  *
  * We only write the mft record if the ntfs inode @ni is dirty.
  *
- * On success, clean the mft record and return 0.
- * On error (specifically ENOMEM), we redirty the record so it can be retried.
- * For other errors, we mark the volume with errors.
+ * On success, clean the mft record and return 0.  On ENOMEM, redirty the
+ * record so it can be retried.  Asynchronous callers return success after
+ * redirtying while synchronous callers receive the error.  For other errors,
+ * mark the volume with errors.
+ *
+ * If @sync is false, PG_writeback keeps the folio stable and serializes later
+ * writers until the I/O completes.
  */
 int write_mft_record_nolock(struct ntfs_inode *ni, struct mft_record *m, int sync)
 {
@@ -693,8 +697,6 @@ int write_mft_record_nolock(struct ntfs_inode *ni, struct mft_record *m, int syn
 	WARN_ON(NInoAttr(ni));
 	WARN_ON(!folio_test_locked(folio));
 
-	if (vol->mft_io_unit_size > vol->mft_record_size)
-		sync = 1;
 	if (folio_test_writeback(folio))
 		folio_wait_writeback(folio);
 
@@ -804,7 +806,8 @@ int write_mft_record_nolock(struct ntfs_inode *ni, struct mft_record *m, int syn
 		ntfs_error(vol->sb,
 			"Not enough memory to write mft record. Redirtying so the write is retried later.");
 		mark_mft_record_dirty(ni);
-		err = 0;
+		if (!sync)
+			err = 0;
 	} else
 		NVolSetErrors(vol);
 	return err;
@@ -2959,7 +2962,7 @@ int ntfs_mft_record_free(struct ntfs_volume *vol, struct ntfs_inode *ni)
 	 * record to be freed is guaranteed to do it already.
 	 */
 	NInoSetDirty(ni);
-	err = write_mft_record(ni, ni_mrec, 0);
+	err = write_mft_record(ni, ni_mrec, 1);
 	if (err)
 		goto sync_rollback;
 
diff --git a/fs/ntfs/mft.h b/fs/ntfs/mft.h
index 28a79bf4c1c67..d2a31205e08c7 100644
--- a/fs/ntfs/mft.h
+++ b/fs/ntfs/mft.h
@@ -53,17 +53,19 @@ int write_mft_record_nolock(struct ntfs_inode *ni, struct mft_record *m, int syn
  * @sync:	if true, wait for i/o completion
  *
  * This is just a wrapper for write_mft_record_nolock() (see mft.c), which
- * locks the folio for the duration of the write.  The folio lock prevents
- * races between writing the mft record via the dirty inode code paths and via
- * page cache writeback or between neighbouring mft records residing in the
- * same folio.
+ * locks the folio while preparing the write.  write_mft_record_nolock() waits
+ * for prior folio writeback before modifying the folio and keeps PG_writeback
+ * set until the submitted I/O completes.  Together these serialize dirty
+ * inode writes, page cache writeback, and neighbouring mft record writes in
+ * the same folio.
  *
  * Locking the page also serializes us against ->read_folio() if the page is not
  * uptodate.
  *
  * On success, clean the mft record and return 0.  On allocation failure,
- * redirty the record for retry and return 0.  On other errors, return -errno
- * and mark the volume with errors.
+ * redirty the record for retry.  Asynchronous callers return 0 after
+ * redirtying, while synchronous callers receive -ENOMEM.  On other errors,
+ * return -errno and mark the volume with errors.
  */
 static inline int write_mft_record(struct ntfs_inode *ni, struct mft_record *m, int sync)
 {
-- 
2.53.0



