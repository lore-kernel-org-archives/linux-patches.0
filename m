Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061600;
	b=iOo9HwRryqVvzgrAWKExon+Z5L0jcE2lWElVYcyj4Ns5fYMGm8rBt8No8ZAnkJJLUqex
	 J8FYvu0I9UYgskV6ZgAWYyJi9ulTq4gxQARy9UMm4SHKL6tMzOiEVfr3Zx0i7rYMw2Y4/
	 3DAzc29XJyuGyCVY6qcsFHoQn+HD7IxCwdlaJwCoP1tQYpRHhwKo5KDRmMC9U/+gHpB6j
	 pt12nm/rYxQvG5mPcjT54I4pBDxSlszBQR/8726qA9b6Woo8VWy9xfoYR5tIJUT9hzroR
	 toz4ihNTgP3oCJoStylDYXhjMi6Pp3NQ6KNn3WT40ANu5VG1w6+FnOWUWJe6959KAwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e7ZusSjPlezR/HpaSSzkihmZrVSVhg3XlnY/Q2rzFw8=;
	b=1Q+QEw6Xwk7x7gODoIX+ELFW7g53zUTfwHQNS4rnoIJVS/VTZaa//cXlg+z8mIuaL4DX
	 hiC3DPeLsmCUoaMBJh2O/0IJjpFlVNRYHLl1VZd4GLnIRzTg7WWVCjoMuipQ1zy8foCoh
	 iVA0FL+GjAjFkuzk/YQFDs0ea20b6rhWiDviywSmv60BJmrTboTHmA0/f2gQp6CFIt00V
	 ebGidKbnZfZFCGDUHlu/E4SZVf6V5/SZlleUgGYhHK/XLZhy0bzbJinAyH4Z7JXOEr5W7
	 SG2E1Wp/G9L7DePOKQjF6VOl1/2vvi2Ed37QnFNR7jMrCT8VHtSrcmm8geYddCP+Vbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsmZRTgj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC54606A326;
	Sat,  7 Nov 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OsmZRTgj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865CC1F0089F;
	Sat,  7 Nov 2026 14:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061599;
	bh=e7ZusSjPlezR/HpaSSzkihmZrVSVhg3XlnY/Q2rzFw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OsmZRTgj/h66oo8dXLB6PMROgtvdCxbsRTjVRLbwQm+lY4qDkG7ctOPWjtEwHiVTi
	 JrCu6+iI+ZXQPiFnG8EXrJ29PtHfl6mAavN39eaoCI2XJ7DUGVCaAxSgTAclPikJtH
	 GiDLO8ATVIfi/RerpMSeSQ0GWALKTb7Tlpv6QRCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaming Zhang <r772577952@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Junxiao Bi <junxiao.bi@oracle.com>,
	Changwei Ge <gechangwei@live.cn>,
	Jun Piao <piaojun@huawei.com>,
	Heming Zhao <heming.zhao@suse.com>
Subject: [PATCH 6.12 0673/1536] ocfs2: fix chunk number of the first chunk in a local quota file
Date: Sat,  7 Nov 2026 08:44:49 -0500
Message-ID: <20261107135016.386749793@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiaming Zhang <r772577952@gmail.com>

commit 4effccfd50baee4f325694964aeee997dca7bd96 upstream.

Mounting a crafted OCFS2 image can corrupt kernel memory.  When the
local quota file header of such an image claims zero chunks, the first
quota entry allocated during the mount gets a chunk number taken from a
kernel pointer, and releasing that entry clears a bit far outside the
chunk bitmap.

The write will corrupt the data stored at that address, and the
corruption may lead to a system crash or damage unrelated data.
Mounting requires CAP_SYS_ADMIN, so it takes an untrusted image, such
as removable media or a loop mount of a file from elsewhere.

Since the chunk number comes from a kernel pointer, the address of the
bit that gets cleared differs from boot to boot, and the issue has been
reported under several titles:

- BUG: unable to handle kernel paging request in ocfs2_local_release_dquot
- KASAN: use-after-free Write in ocfs2_local_release_dquot
- KASAN: slab-out-of-bounds Write in ocfs2_local_release_dquot
- KASAN: slab-use-after-free Write in ocfs2_local_release_dquot
- KFENCE: use-after-free write in ocfs2_local_release_dquot

Note that none of these is a use-after-free in the quota code: the
chunk and its buffer head are alive.  The bit that gets cleared lies
far outside the bitmap.  KASAN and KFENCE name each report based on the
object occupying that address, which explains why the same issue is
reported under so many different titles.  In the report I sent, the
address fell in a free page, which KASAN labels use-after-free.

There are known reproducers.  Both a syzkaller and a C reproducer are
available from the Google Drive link [1] in my report thread.  The
issue was found by our modified syzkaller, not a theoretical thing
found by an LLM.  I have not seen it outside fuzzing, so it is not
affecting me in the real world.

The local quota file in OCFS2 is divided into chunks, and each chunk
begins with a header block holding a bitmap of the quota entries that
chunk has handed out.  Chunks are numbered from zero, and that number is
used to convert the file offset of an entry back into a bit position in
the bitmap.  ocfs2_local_quota_add_chunk() appends a new chunk to the
in-memory list and numbers it one past the chunk that was last:

	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
				   struct ocfs2_quota_chunk,
				   qc_chunk)->qc_num + 1;

The predecessor is looked up after the new chunk is added to the list, so
if the list was empty, the prev pointer is the list head itself.  The head
is the dqi_chunk member of struct ocfs2_mem_dqinfo and is not a chunk, so
reading qc_num through it lands 16 bytes past the start of the head, on
the dqi_gqinode pointer that follows it.  The first chunk of the file is
then numbered with the lower half of a kernel pointer instead of 0.

The list is empty when the local quota file header claims the file has no
chunks.  ocfs2_local_read_info() takes dqi_chunks from that header without
validating it, so an image with dqi_chunks == 0 takes this path when the
first quota entry is allocated.

ocfs2_create_local_dquot() turns the bad number into a file offset with
ol_dqblk_off(), which shifts a 32-bit block number left by the block size
bits, so the top bits of such a large block number are lost.
ocfs2_local_release_dquot() turns the offset back into a bit index with
ol_dqblk_chunk_off(), using the full chunk number, so the lost bits push
that index far outside the bitmap, and clearing it corrupts unrelated
memory.

Compute the chunk number before putting the chunk on the list, and use 0
when the list is empty.

Link: https://lore.kernel.org/20260914034940.4070970-1-r772577952@gmail.com
Link: https://drive.google.com/drive/folders/1-LzPTgOALEc3eOjmgM6oOfRKkYXJ-bnO?usp=drive_link [1]
Fixes: 9e33d69f553a ("ocfs2: Implementation of local and global quota file handling")
Signed-off-by: Jiaming Zhang <r772577952@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Closes: https://lore.kernel.org/lkml/CANypQFZ05tpth0Xc33gmP6jgPnkY4VuezyHcsajV-SqCsmN_gg@mail.gmail.com/
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>
Assisted-by: Claude Code:claude-opus-5
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Changwei Ge <gechangwei@live.cn>
Cc: Jun Piao <piaojun@huawei.com>
Cc: Heming Zhao <heming.zhao@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ocfs2/quota_local.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/fs/ocfs2/quota_local.c
+++ b/fs/ocfs2/quota_local.c
@@ -1074,10 +1074,13 @@ static struct ocfs2_quota_chunk *ocfs2_l
 		goto out;
 	}
 
+	if (list_empty(&oinfo->dqi_chunk))
+		chunk->qc_num = 0;
+	else
+		chunk->qc_num = list_entry(oinfo->dqi_chunk.prev,
+					   struct ocfs2_quota_chunk,
+					   qc_chunk)->qc_num + 1;
 	list_add_tail(&chunk->qc_chunk, &oinfo->dqi_chunk);
-	chunk->qc_num = list_entry(chunk->qc_chunk.prev,
-				   struct ocfs2_quota_chunk,
-				   qc_chunk)->qc_num + 1;
 	chunk->qc_headerbh = bh;
 	*offset = 0;
 	return chunk;


