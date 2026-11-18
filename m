Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059183;
	b=YZ92c7Ef4uk6X5C18Po1AItTgp9nCv8sihTkkZHXTxcGbS0P+kGtNUajmH81BKPo3VTA
	 6wJ/peXwRuxW26gTeh2BNJYI3t9MdTwg+DXyihptod8ApnkK+w5XqsluJOU6hdUuUDj7u
	 mVJHMNpLYqoIq5LrpfOxE0iPAlv2Xvlv0/H+t96FHoq3qxd71jw516d3znM+9J5w5HxkJ
	 mJsHSciSVKJLfX7pt3T5p/b5Niy3TdWfn5B5XWJAKjrSTWezjXk7/b8jllOPwY25K8Ak1
	 WAvdmzI5205CCbfnD6BeoYDYRNgyVt0DzpPfzc1dNlztcW2meV2EsZOmdoYXWclU8MQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAlD16U5kt56a4rF1tl1J7Q1rckISdrWYw9WotgX0tQ=;
	b=bA1CKRs6hPOxKDYA0LqZ3r6DxzJZ3jCCLl2FVEw7fwqMG6FYTNbua6dAQ4ZtGSPmI6QV
	 NVuSmQbNzSvU1Sjo9XIwZfLTFTZ9F644VUQ9bafZIaU7rORCSyF7mTlFnCjlyVGg0IQTk
	 cG92iIi4AjVGMRus4DubGv2cZp5Bw0ZccJr74nE2ZRnDgQ0l3Ptnzq8IrdAZBXWMTdhCD
	 jOECBvCJZRa6DjwEFMfec7FD/ouMBc2EaozaJqticXDeTY11DUC7UK8KAF6ygYqZqp/6O
	 n3zFqnaFnAK/JUb5NVyImMTZW4JHva99ZYHCi26QgeD29omxXUNja9hRK/AL/av5Keg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t36Bv3uw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAE0606A325;
	Thu, 19 Nov 2026 03:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t36Bv3uw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 436191F000C4;
	Thu, 19 Nov 2026 03:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059182;
	bh=sAlD16U5kt56a4rF1tl1J7Q1rckISdrWYw9WotgX0tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t36Bv3uw+oKNXtiDLYf2qqQIyXfeu/Upjsct1IR3v3i3HZhCRALrV7LCO4DdJ4Xyq
	 s0FaZ+DB5CdG10IgRfgL5aHKO5y1AGy5hDMQT927W3cHR4+kr2PqdzuIAnd+zrjtPB
	 h7e75iIkZEwI4xx93R9GNo8QILRvyq4UIPQ6kwmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+799a0e744ac47f928024@syzkaller.appspotmail.com,
	syzbot+43fc5ba6dcb33e3261ca@syzkaller.appspotmail.com,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0749/1848] udf: dont let the extent type hide an exhausted free-space table extent
Date: Wed, 18 Nov 2026 15:46:27 +0100
Message-ID: <20261118145947.888651122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e8e3e291ef819..0bbe86da3d133 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -580,7 +580,7 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	uint32_t elen, goal_elen = 0;
 	struct kernel_lb_addr eloc, goal_eloc;
 	struct extent_position epos, goal_epos;
-	int8_t etype;
+	int8_t etype, goal_etype = 0;
 	struct udf_inode_info *iinfo = UDF_I(table);
 
 	*err = -ENOSPC;
@@ -628,7 +628,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 			goal_epos.block = epos.block;
 			goal_epos.offset = epos.offset - adsize;
 			goal_eloc = eloc;
-			goal_elen = (etype << 30) | elen;
+			goal_elen = elen;
+			goal_etype = etype;
 		}
 	}
 
@@ -650,7 +651,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	goal_elen -= sb->s_blocksize;
 
 	if (goal_elen)
-		udf_write_aext(table, &goal_epos, &goal_eloc, goal_elen, 1);
+		udf_write_aext(table, &goal_epos, &goal_eloc,
+			       (goal_etype << 30) | goal_elen, 1);
 	else
 		udf_delete_aext(table, goal_epos);
 	brelse(goal_epos.bh);
-- 
2.53.0



