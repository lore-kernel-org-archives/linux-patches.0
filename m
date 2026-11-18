Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037897;
	b=iV5mhgJLKnMiRIXAv+ksM0vzR+VRe/bIfc9Htw0enNjsEHs46l3DbUWzF4d3KVIGmZJB
	 AjJaL0DfDR4al48VY9rPM7KE3WngcamQQ3yXAMiXT0oCv7p2KuudcI0g5i/aTKxccNxMi
	 xIG29MwfQzuxXTBaIXdZDRD1FBGnB92aBOoUItyE07MV8kJsWWcm/9RKeiwRpk3qXzDof
	 C+Yd9mVUuEyhoYrmSiY/6LCptQjl/zh5H7EHLK0xaqVAybDGXCevYbREqw/U6PIH/BRih
	 f2gpT0aWehw6TdgiMCx/zXxqrGqwK4YTz8fduSfRzbLubrF782UktDtMLZ5ZKGkmLLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zz9SEauJQB+ebEz++hW+XM3E3I/u6Vdwl3iIUkcwuGQ=;
	b=iXS+2O3zssjSsz4XR/Udsxns9+jfVpromkp2p2AMbC76WcGTpap53Lufg0hzVR3nOBEB
	 LOM/zSEooTzZ1Z6sCbN6pd9h8/Dx1K7MadY/NZNxnIQ9l5ovP9FEGde+aaM264UdqrL+r
	 HZwrwrlCmVeJAvQ0aW0DQvkYDVEEeJ28yT+wGPX/7jUPTkE5pDvqX233JRdrWWQUFcMXa
	 hdjgI9NW0LLluu8Z8zjMmT8Oh4iiloBj92R9+Zx56O/aByW4z5Jc2e2xSAWI90iod4VMF
	 4RVtdK8CxWWmvG4+4cHXEd0E0o7CqXu+rQYxgklpIkUAIhBz2FVZA8Gyi7Y8rbZ5y5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRbypgXQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A8CA606A320;
	Wed, 18 Nov 2026 21:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VRbypgXQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D851F000C4;
	Wed, 18 Nov 2026 21:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037897;
	bh=zz9SEauJQB+ebEz++hW+XM3E3I/u6Vdwl3iIUkcwuGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VRbypgXQEWhlSlQaTqF695aaVD87kOenAnOZy0JckEK0MOEWefOvidHPm6Tsm5m+V
	 zlQcK/vRDqlNMh1NP4rO2jMy+x9xAhD3JxROrbnQsODfQwxbYNzaLd+1HqOQaXIJnr
	 Q2PbSPr4D4eF3s5k8ntZhVKUGX3Wd80o/gGt721Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+799a0e744ac47f928024@syzkaller.appspotmail.com,
	syzbot+43fc5ba6dcb33e3261ca@syzkaller.appspotmail.com,
	Matthias Goergens <matthias.goergens@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1554/3318] udf: dont let the extent type hide an exhausted free-space table extent
Date: Wed, 18 Nov 2026 15:36:16 +0100
Message-ID: <20261118150407.638377592@linuxfoundation.org>
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
index e3a2d9426094b..6eee9d0da90da 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -589,7 +589,7 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 	uint32_t elen, goal_elen = 0;
 	struct kernel_lb_addr eloc, goal_eloc;
 	struct extent_position epos, goal_epos;
-	int8_t etype;
+	int8_t etype, goal_etype = 0;
 	struct udf_inode_info *iinfo = UDF_I(table);
 	int ret = 0;
 
@@ -640,7 +640,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
 			goal_epos.block = epos.block;
 			goal_epos.offset = epos.offset - adsize;
 			goal_eloc = eloc;
-			goal_elen = (etype << 30) | elen;
+			goal_elen = elen;
+			goal_etype = etype;
 		}
 	}
 
@@ -664,7 +665,8 @@ static udf_pblk_t udf_table_new_block(struct super_block *sb,
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



