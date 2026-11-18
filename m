Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021185;
	b=Bqgkn0L7QN0S3dRVYHWnQ2xbhm5naUMZm+hSwQYFb5hEEAvcEkzG+UGfnAoShgW9P8Bp
	 pJNGp8YmLIq/ekLP15kmI0CtKEeOVFVTMVoYttx4LpGFxJ8pLq2r+/D1xG7M2Xu6BdczX
	 mWMca2T18LLcr85DAsqah4msKEMPuEkEh1Jm/SY/f3QSKrb3e8JptHtcQbb2VC9boOWQ2
	 kQQs6Y+09EU/rIrV0r/Ka7HlW24S/h6pU2i8bvZcWqJ22aAlin4bLXGtTgVReHgm22o98
	 fYsf8d7s2YuT+iWGZgbHS4nt2+38QQyConM+mZK+K/iMrNFaepP2SRX2nCVqAAuXFPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3x3eY9Uf1Y7xbxRiMTEJ4K+kEQlefZxZ5v5pl8fP8Ao=;
	b=IL9lrWu+pTSe+72Lv+VEF0c3dmH1Abdr3GtkbNPyaTm4xzQV0VKJO9iTwqpmkMW52utc
	 kgrNSx+9fGE8L82q2usbcP++ws521QhyksCuz9THHmDkymTz9XTwjTn2frSEtv17XDoce
	 Mm8yvzcdM8OklLwF42IwXSboVtnRCxH355gKVflRMKJn/z17pqAhCEzZnIboYPtQ/i9B0
	 zuz/W4FnbwenAS7x/PyyIQP4uufOKY9qWH7tcb2dhqYh8ESn4+yZQwiT58mdI1nucGoOs
	 jI6Owv5jvNW2hvxcC9soGP7SCTJlcCnNabpL2lTCYgYbLIfnGqyzUg7bfYZImVebBxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHCq0tay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7BC9606A31C;
	Wed, 18 Nov 2026 16:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sHCq0tay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02A3C1F000C4;
	Wed, 18 Nov 2026 16:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021185;
	bh=3x3eY9Uf1Y7xbxRiMTEJ4K+kEQlefZxZ5v5pl8fP8Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHCq0tayn9qe8Lhef3Qtt1UW175yeneoz+1oZ1nL/gs79PEc6RvIlwnABvAWRDcJr
	 zBtpyZl5CEnM0FEU+LK61kg7N4XqNl33NBnD0MjE+2C4MIzBenAUKKnXTPN9XqDZlL
	 H+v31JD4+CdOkRfbJtlKj+S6I5B0YPakS5JvGtRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Liu <liubaolin@kylinos.cn>,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2216/2651] ntfs: restart the zone search when the allocation hint fails
Date: Wed, 18 Nov 2026 15:57:36 +0100
Message-ID: <20261118150405.392088101@linuxfoundation.org>
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

From: Matthias Goergens <matthias.goergens@gmail.com>

[ Upstream commit 18d4d2a3ce756af690a620a5199616ce2611c2c9 ]

When ntfs_cluster_alloc() is given a start_lcn, it first tries the
clusters from there on.  If that does not satisfy the request, it moves
on to the zone's current position, but keeps the pass, the zone_end and
the has_guess state it had.  That loses free clusters in two ways.  If
the search had already moved on to pass 2, whose range ends at the hint,
it scans only from the zone position to the hint and misses every free
cluster between the start of the zone and the zone position.  If no
cluster had been tested yet, has_guess is still set, so the cluster at
the zone position is tried as if it had been the hint, and when that
cluster is in use the rest of the bitmap buffer is skipped.

Both happen when the hint lies at or past the end of the volume, which
ntfs_attr_map_cluster() produces when it extrapolates from the last
allocated run across a hole.  The allocator then finds nothing, shrinks
the MFT zone to nothing trying to satisfy the request, and fails with
-ENOSPC.

To reproduce on a 128 MiB volume with 4 KiB clusters, extend two files
in turn by one cluster at a time, alternating between fallocate(),
write() past EOF and truncate() up, so that the runs of each file are
separated by holes.  When the volume is full, truncate both files back
to 1 MiB and start again.  During the second round a one-cluster
fallocate() fails with ENOSPC while 40 MiB is free.

Start the zone over as if no hint had been given.  A contiguous request
can get there with the run from the hint already allocated, when that
run reached the end of a bitmap buffer or of the zone.  Return that run
instead, as when a cluster in use ends it; going on at the zone position
gives the request a second run that its caller does not expect.  That
could happen before this patch too, whenever the cluster at the zone
position was free.  ntfs_attr_map_cluster() reports and zeroes only the
first run, so after a fallocate() of 20 clusters over a hole, with the
hint 4 clusters before the end of the volume, 16 of them read back the
data of a deleted file.

Fixes: 11ccc9107dc4 ("ntfs: update runlist handling and cluster allocator")
Suggested-by: Baolin Liu <liubaolin@kylinos.cn>
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs/lcnalloc.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs/lcnalloc.c b/fs/ntfs/lcnalloc.c
index 0d6cd08ee2e76..c58e689fb5852 100644
--- a/fs/ntfs/lcnalloc.c
+++ b/fs/ntfs/lcnalloc.c
@@ -506,13 +506,32 @@ struct runlist_element *ntfs_cluster_alloc(struct ntfs_volume *vol, const s64 st
 		}
 
 		if (!used_zone_pos) {
+			/*
+			 * The run at @start_lcn reached the end of the buffer
+			 * or the zone.  A contiguous request gets that run
+			 * alone, not a second one from the zone position.
+			 */
+			if (is_contig && rlpos)
+				goto out;
+			/*
+			 * Leaving @start_lcn for the zone position starts the
+			 * zone over as if no hint had been given, even if the
+			 * search had already reached pass 2, whose range ends
+			 * at @start_lcn.
+			 */
 			used_zone_pos = 1;
-			if (search_zone == 1)
+			has_guess = 0;
+			pass = 1;
+			if (search_zone == 1) {
 				zone_start = vol->mft_zone_pos;
-			else if (search_zone == 2)
+				zone_end = vol->mft_zone_end;
+			} else if (search_zone == 2) {
 				zone_start = vol->data1_zone_pos;
-			else
+				zone_end = vol->nr_clusters;
+			} else {
 				zone_start = vol->data2_zone_pos;
+				zone_end = vol->mft_zone_start;
+			}
 
 			if (!zone_start || zone_start == vol->mft_zone_start ||
 			    zone_start == vol->mft_zone_end)
-- 
2.53.0



