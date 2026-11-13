Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585841;
	b=yQ1OCwBELA0OMmuus/PVoW+CdZ7BIpd8OWMMDGGTTyjv6TRvguzAylb4A+VvRYIG+3fr
	 7f0boL9ZwmD6tTX3mpliN5QOh8H+fah37a3bmvgRyI9QIpJxUpnGyBy9VqUe9RR77WLDO
	 lkJR605F7PF6xlYwv/6TXYkXUFOQLKZ2CoIjFrRW7jiIfgS/ZnIb4m6nPCGFwAGR0ays0
	 A1P8+991y+fjawQu13Z3KJLn5+FwXDCGFWumxb5YXCc8f6JHnlpbaKkDR+17fQ43KmC22
	 erJiZol9F6TqD4hkvSJaG2Is+JdpO2x96vinupqo2aXmUGsskkjU+JkvLV1WRwaPN7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9WuZZPMP/3cGK3oWv+o2lBQHp3ellf0TgQ2RBuOgM4I=;
	b=5IEqlq69BvkU6drc/dyI5JGmlXIYOG9HOpCloNS4X4S6lwmDj5xqfOG4K3tOn52xuc38
	 gplzgtBv7e/LYCQSVVjfpxaNnbDnfq6mpwU8rEp1SqZljLN621TOB2LU7Li6X//DAsevI
	 eImvYWLWjMTpv3XKWEGbWXM+CJAGzJRb1NwlTYgx0vBBSM3r87t8/FpWBUiccUqKx5dKT
	 9nCVqmCQo+3UkUaN/grRb/MkDGbTZhwKijBzWkx51p30AaHVavYGBz/kDcMZqZp4FBkBq
	 wcSml01jz1AzmGAjZOARuQ91Prs3fUnPyri7Hx9U0XUtkkK/HawRM7oSg/0H/u4uqNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzqF7sJi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D788606BA90;
	Fri, 13 Nov 2026 16:04:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzqF7sJi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E511F000C4;
	Fri, 13 Nov 2026 16:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585841;
	bh=9WuZZPMP/3cGK3oWv+o2lBQHp3ellf0TgQ2RBuOgM4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzqF7sJiFkxsCSHAw70V9/XJ9wjZ00Fp3j8OtrqH2T5RmFvke2+msv7H3Pq3G/7SJ
	 MSaxd9YEWlLhWE3eND0BTmknFYwmPx17UapqSO87l5qwt029rCIV8NsvVJELC1Fci5
	 dPppzrE/+PJo7AyUSOVmOYx9YNVLxU46NMDY+RBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+799a0e744ac47f928024@syzkaller.appspotmail.com,
	syzbot+43fc5ba6dcb33e3261ca@syzkaller.appspotmail.com,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 412/507] udf: dont let the extent type hide an exhausted free-space table extent
Date: Fri, 13 Nov 2026 10:51:56 -0500
Message-ID: <20261113153810.698151828@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

[ Upstream commit da582d84fcf5f2f0c1d7760e1a899ca7cedb80fc ]

udf_table_new_block() takes the first block of the free-space table
extent closest to the goal.  It keeps that extent's type and length
together in goal_elen, subtracts one block, and deletes the extent only
if goal_elen then reaches zero.  UDF 2.60 section 2.3.7.1 requires the
free-space extents of an Unallocated Space Entry to be of type 1
(allocated but not recorded), and mkudffs writes them that way.  For
such an extent the type bits keep goal_elen non-zero, so taking its last
block leaves a type-1 extent of length zero behind, starting at the
block after the extent, which is in use.

The next allocation that picks this empty extent returns that in-use
block.  Subtracting a block from 0x40000000 then borrows from the type
bits, and the extent becomes type 0 with a length of 2^30 - blocksize:
about a gigabyte of "free" space overlapping live metadata, the other
table extents and whatever lies behind the partition.  From then on
blocks are handed out twice, or past the end of the partition.

Extents that udf_table_free_blocks() adds are type 0, where the check
works, so only tables written by mkudffs or by another implementation
are affected.  Nothing more than filling such a filesystem is needed:
on a fresh 1 MiB "mkudffs --space=unalloctable" image, creating empty
files until the partition is full writes file entries over the reserve
volume descriptor sequence and the backup anchor, and df then reports a
negative amount of used space.

On syzbot's images the same double allocation is what the two reports
below trip over.  In the first, ftruncate() extends a new file with
enough hole extents to need a chain of allocation extent descriptors;
one AED is placed on another inode's file entry, and a later one is
placed on the block of the AED currently being filled, which
udf_setup_indirect_aext() zeroes, so __udf_add_aext() finds
lengthAllocDescs out of step with its cursor.  In the second, an AED
is placed past the end of the device, sb_getblk() fails, and the error
path of udf_do_extend_file() calls udf_truncate_extents() on an extent
list that no longer covers i_size.

Keep the type separately from the length, as udf_table_prealloc_blocks()
already does.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reported-by: syzbot+799a0e744ac47f928024@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=799a0e744ac47f928024
Reported-by: syzbot+43fc5ba6dcb33e3261ca@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=43fc5ba6dcb33e3261ca
Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
Link: https://patch.msgid.link/6b51c38d2d069544053c542470950e2a448b0b8d.1793349907.git.matthias.goergens@gmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index 30cec56001491..2ec577b4321c9 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -572,7 +572,7 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	uint32_t elen, goal_elen = 0;
 	struct kernel_lb_addr eloc, goal_eloc;
 	struct extent_position epos, goal_epos;
-	int8_t etype;
+	int8_t etype, goal_etype = 0;
 	struct udf_inode_info *iinfo = UDF_I(table);
 	int ret = 0;
 
@@ -623,7 +623,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 			goal_epos.block = epos.block;
 			goal_epos.offset = epos.offset - adsize;
 			goal_eloc = eloc;
-			goal_elen = (etype << 30) | elen;
+			goal_elen = elen;
+			goal_etype = etype;
 		}
 	}
 
@@ -647,7 +648,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	goal_elen -= sb->s_blocksize;
 
 	if (goal_elen)
-		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
+		udf_write_aext(table, &goal_epos, &goal_eloc,
+			       (goal_etype << 30) | goal_elen, 1);
 	else
 		udf_delete_aext(table, goal_epos, &freed);
 	brelse(goal_epos.bh);
-- 
2.53.0



