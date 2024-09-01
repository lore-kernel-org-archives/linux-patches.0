Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7082A1B8;
	Sun,  1 Sep 2024 16:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209853; cv=none; b=kYZfSRblM3peZt9x1Om2g3fqKE0QpK1zLS2ukKXXvE6mb+fnBXeYQxnkP6lJJR7inddn7uszVDHYbxV3ffr3Wyw7IhpZUnlvEcBvtgww52YoTO8YgyFRP2EI2cOtJyDfi9J0MM9LDOuFIoMeDsWQimEuxLqpdhiTrjqB2LYfmzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209853; c=relaxed/simple;
	bh=FZVIR2tz3S+lzbDwQcSoDl1A+dVNocIZH2uY/bKkFKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vl3zwM5JxLzFllGMY8uo1Fpwe01ywElOoLH40gqvNjr9bNHhC3cq52s7EbjRngHZT0i3IT90yUrHOyng9LKqiwWRTLOMtAePD/eMBWw01Gu9j1OO1ZwVFhzwF9OiOz942EjQrVe6Mag3nQUrIrhAN8/kKssll7de9uEh7709yZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KpAp1e6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KpAp1e6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A8F3C4CEC3;
	Sun,  1 Sep 2024 16:57:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209852;
	bh=FZVIR2tz3S+lzbDwQcSoDl1A+dVNocIZH2uY/bKkFKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KpAp1e6Odu1kaULlXx+1GnSLz648cC1b9lKoNi7qVsLkmAQ3pjHXdZhDX6uHx/jIA
	 mxnAaaUm0gfQjiNgyDwcc3tCUJLVt5YH+NHHOyMNGDE/Nen3NfpfGAOg4LMA+hPIkn
	 5Hd7s9mP8+eHviJz/ufoKQJPfadRMBJwWEn2rrNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Yury Norov <yury.norov@gmail.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 014/215] fs/ntfs3: add prefix to bitmap_size() and use BITS_TO_U64()
Date: Sun,  1 Sep 2024 18:15:26 +0200
Message-ID: <20240901160823.791418936@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Lobakin <aleksander.lobakin@intel.com>

commit 3f5ef5109f6a054ce58b3bec7214ed76c9cc269f upstream.

bitmap_size() is a pretty generic name and one may want to use it for
a generic bitmap API function. At the same time, its logic is
NTFS-specific, as it aligns to the sizeof(u64), not the sizeof(long)
(although it uses ideologically right ALIGN() instead of division).
Add the prefix 'ntfs3_' used for that FS (not just 'ntfs_' to not mix
it with the legacy module) and use generic BITS_TO_U64() while at it.

Suggested-by: Yury Norov <yury.norov@gmail.com> # BITS_TO_U64()
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Yury Norov <yury.norov@gmail.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/bitmap.c  |    4 ++--
 fs/ntfs3/fsntfs.c  |    2 +-
 fs/ntfs3/index.c   |   11 ++++++-----
 fs/ntfs3/ntfs_fs.h |    4 ++--
 fs/ntfs3/super.c   |    2 +-
 5 files changed, 12 insertions(+), 11 deletions(-)

--- a/fs/ntfs3/bitmap.c
+++ b/fs/ntfs3/bitmap.c
@@ -661,7 +661,7 @@ int wnd_init(struct wnd_bitmap *wnd, str
 	wnd->total_zeroes = nbits;
 	wnd->extent_max = MINUS_ONE_T;
 	wnd->zone_bit = wnd->zone_end = 0;
-	wnd->nwnd = bytes_to_block(sb, bitmap_size(nbits));
+	wnd->nwnd = bytes_to_block(sb, ntfs3_bitmap_size(nbits));
 	wnd->bits_last = nbits & (wbits - 1);
 	if (!wnd->bits_last)
 		wnd->bits_last = wbits;
@@ -1325,7 +1325,7 @@ int wnd_extend(struct wnd_bitmap *wnd, s
 		return -EINVAL;
 
 	/* Align to 8 byte boundary. */
-	new_wnd = bytes_to_block(sb, bitmap_size(new_bits));
+	new_wnd = bytes_to_block(sb, ntfs3_bitmap_size(new_bits));
 	new_last = new_bits & (wbits - 1);
 	if (!new_last)
 		new_last = wbits;
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -493,7 +493,7 @@ static int ntfs_extend_mft(struct ntfs_s
 	ni->mi.dirty = true;
 
 	/* Step 2: Resize $MFT::BITMAP. */
-	new_bitmap_bytes = bitmap_size(new_mft_total);
+	new_bitmap_bytes = ntfs3_bitmap_size(new_mft_total);
 
 	err = attr_set_size(ni, ATTR_BITMAP, NULL, 0, &sbi->mft.bitmap.run,
 			    new_bitmap_bytes, &new_bitmap_bytes, true, NULL);
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1461,8 +1461,8 @@ static int indx_create_allocate(struct n
 
 	alloc->nres.valid_size = alloc->nres.data_size = cpu_to_le64(data_size);
 
-	err = ni_insert_resident(ni, bitmap_size(1), ATTR_BITMAP, in->name,
-				 in->name_len, &bitmap, NULL, NULL);
+	err = ni_insert_resident(ni, ntfs3_bitmap_size(1), ATTR_BITMAP,
+				 in->name, in->name_len, &bitmap, NULL, NULL);
 	if (err)
 		goto out2;
 
@@ -1523,8 +1523,9 @@ static int indx_add_allocate(struct ntfs
 	if (bmp) {
 		/* Increase bitmap. */
 		err = attr_set_size(ni, ATTR_BITMAP, in->name, in->name_len,
-				    &indx->bitmap_run, bitmap_size(bit + 1),
-				    NULL, true, NULL);
+				    &indx->bitmap_run,
+				    ntfs3_bitmap_size(bit + 1), NULL, true,
+				    NULL);
 		if (err)
 			goto out1;
 	}
@@ -2087,7 +2088,7 @@ static int indx_shrink(struct ntfs_index
 	if (err)
 		return err;
 
-	bpb = bitmap_size(bit);
+	bpb = ntfs3_bitmap_size(bit);
 	if (bpb * 8 == nbits)
 		return 0;
 
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -950,9 +950,9 @@ static inline bool run_is_empty(struct r
 }
 
 /* NTFS uses quad aligned bitmaps. */
-static inline size_t bitmap_size(size_t bits)
+static inline size_t ntfs3_bitmap_size(size_t bits)
 {
-	return ALIGN((bits + 7) >> 3, 8);
+	return BITS_TO_U64(bits) * sizeof(u64);
 }
 
 #define _100ns2seconds 10000000
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -1103,7 +1103,7 @@ static int ntfs_fill_super(struct super_
 
 	/* Check bitmap boundary. */
 	tt = sbi->used.bitmap.nbits;
-	if (inode->i_size < bitmap_size(tt)) {
+	if (inode->i_size < ntfs3_bitmap_size(tt)) {
 		err = -EINVAL;
 		goto put_inode_out;
 	}


