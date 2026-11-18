Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037160;
	b=TSMRZpEYVZZvzFqtbbj4j2TWkPqetDUcl36tbx73CRIgK7B2+daWY0Fhhtxh98QBIf87
	 LaiLZ54A4DnUAQ47W0IRvNdfB2FvVfEtK9UATNxgDmVSnmIby91wD3fdONWHFf/Q6Vzql
	 pYzddjuI7By/79GIFDvVK/zD6ar1vpWxQnk6YJlfnu5RWGUvgbvVV9nez0eFdKYerUStp
	 VHZTr/27KFWzlZtMaOHPHXZTybQMB0OqZo5ssh8RKs5cpDkKYyrL4OSs1d2EOGjgfOhrt
	 QvrqbdiDbxSc6yjCZ9Xa/kHJPjNI2W8TwLcCPTkTstjHFh5aBD+c0uvnhzWQ7NpWeyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=MDU9a7WoO5p7RPtM+eqUZNEqNa5U3kOO+AkVFBeTrCE=;
	b=qT/wRv18gywnOrMP7MWrabkwIVfx/Um+6ouTJtTFrMAM9Q5cFh1nCUPEAD9tDu01uB4/
	 wsreoFERqVb4967bpZENp5yPZQr5LaMSYRv6I3rLpVCU75iqytfmpsgFkGlGr3+cjF2OA
	 f2Q3qCrsYISCE6Lomlkf7J+PUrcx3UROJBGgnkqxACuqMILzrz3h6gnQOB5/6QS0swo5Y
	 lnOO0PwT/SppjmfhEcLENmyLWV0u9ScMFFwdK9n68IZPfOwdxUcHkynYfvf7Fyrzh3Rhm
	 EfmLQXpxoP1odN5hSaIyWfElPf8HP7SCOM99KiES4BxXL9Nu1VysTgldQtQqxroJWsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czyfJYNH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506A3606A334;
	Wed, 18 Nov 2026 21:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=czyfJYNH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7B031F000C4;
	Wed, 18 Nov 2026 21:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037160;
	bh=MDU9a7WoO5p7RPtM+eqUZNEqNa5U3kOO+AkVFBeTrCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=czyfJYNHYjf+x/U9IFw5QxT8quUTA1qI0/CKtWdlkj0lZbqcOk/fPm8sYHNPz4LxU
	 tQ+f84wkPGTKiU4FYIC9XXiaKg9fQ8nMPjEf10d8rDmD+H1b1uaaD0L9fMmwAMz6mH
	 sQ2VP2N8lc9OVnPqy5rQHyjl8XaRY7xLTn3kVHBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1315/3318] xfs: improve dirent bounds checking in scrub and repair
Date: Wed, 18 Nov 2026 15:32:17 +0100
Message-ID: <20261118150359.755464341@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

[ Upstream commit 5d470234d04dae6fe2ca2cf4b9ef277b78c7e05a ]

LOLLM complains that we don't do enough bounds checking of the directory
entries in directory blocks when we're looking for errors or trying to
salvage entries.  Let's improve that with more detailed checks.

Cc: stable@vger.kernel.org # v4.16
Fixes: ce92d29ddf9908 ("xfs: directory scrubber must walk through data block to offset")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
[ sashal: inlined the upstream scrub helpers’ checks into the existing xchk_dir_rec() loop because those helpers are absent ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/xfs/scrub/dir.c | 59 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 53 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 0b491784b7594..7231a7df4aed6 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -167,6 +167,7 @@ xchk_dir_rec(
 	xfs_dahash_t			hash;
 	struct xfs_dir3_icleaf_hdr	hdr;
 	unsigned int			tag;
+	bool				foundit = false;
 	int				error;
 
 	ASSERT(blk->magic == XFS_DIR2_LEAF1_MAGIC ||
@@ -211,28 +212,67 @@ xchk_dir_rec(
 	dent = bp->b_addr + off;
 
 	/* Make sure we got a real directory entry. */
-	iter_off = geo->data_entry_offset;
 	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
 	if (!end) {
 		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 		goto out_relse;
 	}
-	for (;;) {
+	iter_off = geo->data_entry_offset;
+	while (iter_off < end) {
 		struct xfs_dir2_data_entry	*dep = bp->b_addr + iter_off;
 		struct xfs_dir2_data_unused	*dup = bp->b_addr + iter_off;
+		unsigned int			advance;
 
-		if (iter_off >= end) {
+		/* must have freetag */
+		advance = offsetof(typeof(*dup), length);
+		if (iter_off + advance >= end) {
 			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
 			goto out_relse;
 		}
 
 		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
-			iter_off += be16_to_cpu(dup->length);
+			if (iter_off + sizeof(*dup) > end) {
+				xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+						rec_bno);
+				goto out_relse;
+			}
+
+			advance = xfs_dir2_data_unusedsize(be16_to_cpu(dup->length));
+			if (!advance || iter_off + advance > end) {
+				xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK,
+						rec_bno);
+				goto out_relse;
+			}
+
+			iter_off += advance;
 			continue;
 		}
-		if (dep == dent)
+
+		/* must have namelen */
+		advance = offsetof(typeof(*dep), name);
+		if (iter_off + advance >= end) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+			goto out_relse;
+		}
+
+		/* Don't walk off the end of the block. */
+		advance = xfs_dir2_data_entsize(mp, dep->namelen);
+		if (!advance || iter_off + advance > end) {
+			xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+			goto out_relse;
+		}
+
+		if (dep == dent) {
+			foundit = true;
 			break;
-		iter_off += xfs_dir2_data_entsize(mp, dep->namelen);
+		}
+		iter_off += advance;
+	}
+
+	/* Hash tree must point to the exact dirent */
+	if (!foundit) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
 	}
 
 	/* Retrieve the entry, sanity check it, and compare hashes. */
@@ -246,6 +286,13 @@ xchk_dir_rec(
 		goto out_relse;
 	}
 
+	/* Name must not overflow end of block */
+	if ((char *)dent->name + dent->namelen >
+	    (char *)bp->b_addr + BBTOB(bp->b_length)) {
+		xchk_fblock_set_corrupt(ds->sc, XFS_DATA_FORK, rec_bno);
+		goto out_relse;
+	}
+
 	/* Does the directory hash match? */
 	dname.name = dent->name;
 	dname.len = dent->namelen;
-- 
2.53.0



