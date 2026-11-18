Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051250;
	b=I8JWwoK5udU9N9SB83Ay8jkxKvgSQOGRtqdAxG03nE0avEpO+xiOZOWGehOlIAYwF9AE
	 ONhk7hr6QkSLrcb/qb9VezBb72+9MTcwxLgr9evfev5vL0sHbKAVm3nP39QXmaqzyrlzj
	 FOQLvlS+dstGamI11k5wwvDF3U1Py4VxARmX+dh4QJBEeWVXWotdiVRS6Z+Lbj8kU7AK7
	 YYL9zEgv2KHnvQykyBUmoTLVac+7mhpjIfV78HlgUlTZRtbKqffW9jAXwJ4IcNw0kBhUR
	 RmLox8Ik82sr1C49/NJfNIKgkeC+QSttV4aqwc05jtN2R3ZM5iQEvVFbMGS00REdZ1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051250;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5dsCZhNUctZI66laskKrnI/MOnr5qCcnMKuY/RV06/A=;
	b=d8+4Ar5rt2QY45T9IwPCxqBrLHPPzzI++3h5GQaBMI+2zSgGDzJ2+8YNPuaDdhYPhPsO
	 QF2YBNfVP3WVwryeY3dlpOzsja3oo295uMf1W89oO5en1Br7FClekESnf/Q4o3+Ky5ZzV
	 YV6JwoC+Dqr9C/4goW8roCmUzgU1hVWXPMMatMmDdNKrJCU9CTVKtvNsU74iQYiMXNJXj
	 4BVigII6ZsVRXt+G6iPYpTWjHRJdJWTeIQ/ScKWluQWI2nt8iBk6lJx6bOGWmJFyN0KHn
	 bZjtooT2yjCdTSEnC0MkojlZbb1bt1wWZssqH0tElE8odOI/kKAarmQDTV0361xRCZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idoyHZGL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963CF606A32A;
	Thu, 19 Nov 2026 01:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=idoyHZGL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66B91F000C4;
	Thu, 19 Nov 2026 01:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051250;
	bh=5dsCZhNUctZI66laskKrnI/MOnr5qCcnMKuY/RV06/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idoyHZGLX4SzqKkq6oo+Z7ywxDmM7C7dNLFLkezGHPoxdE6R0IMG2tfbW8KU9BO7e
	 GqKmf3er+i/+SfpoUJYBIvqR8WqNXuL6BVBRANioPW8FD8bfeDuO3XITJVZAEMxX6r
	 pP9dFdfSgBcLbWXnvpXQbZ4VciDbwka7bagQw2LY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0143/2214] udf: bound lengthAllocDescs from unallocated space entry
Date: Wed, 18 Nov 2026 15:30:19 +0100
Message-ID: <20261118150015.889395691@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Vadayath <jay@artiphishell.com>

[ Upstream commit b8228f59dc58aea06dc024efd8f64c2d048c4578 ]

udf_read_inode() copies the on-disk lengthAllocDescs field of a USE
(unallocSpaceEntry) inode into iinfo->i_lenAlloc without checking that
it fits in the i_data buffer that is subsequently allocated for the
inode. udf_count_free_table(), called from udf_statfs(), then walks the
allocation descriptor array up to i_lenAlloc bytes, so a crafted UDF
image with lengthAllocDescs larger than (blocksize - sizeof(struct
unallocSpaceEntry)) causes udf_get_fileshortad() to read past the end
of the kmalloc'd i_data buffer.

KASAN report from mounting a crafted UDF image and calling statfs()
from an unprivileged process:

  BUG: KASAN: slab-out-of-bounds in udf_get_fileshortad+0x126/0x130
  Read of size 4 at addr ffff8880042137d8 by task poc/65
  Call Trace:
   dump_stack_lvl+0x53/0x70
   print_report+0xce/0x610
   kasan_report+0xce/0x100
   udf_get_fileshortad+0x126/0x130
   udf_current_aext+0x3c4/0xa10
   udf_next_aext+0x241/0x440
   udf_statfs+0xb7d/0x11c0
   statfs_by_dentry+0x117/0x1e0
   user_statfs+0xac/0x130
   __do_sys_statfs+0x80/0xe0
   do_syscall_64+0x102/0x5a0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reject USE inodes whose lengthAllocDescs would place descriptors past
the end of the i_data buffer, mirroring the checks the rest of the UDF
code performs on descriptor lengths.

This bug was discovered by Artiphishell's vTriage pipeline, which
generated a userspace reproducer that reliably triggers the KASAN
report on an unpatched kernel. The fix below was drafted with the
Claude coding assistant; a userspace reproducer (and the crafted UDF
image) is available on request.

Assisted-by: LLM
Signed-off-by: Jay Vadayath <jay@artiphishell.com>
Link: https://patch.msgid.link/20260717184021.13476-1-jay@artiphishell.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 455b9766bad24..4419070d5008a 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1335,6 +1335,10 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		iinfo->i_lenAlloc = le32_to_cpu(
 				((struct unallocSpaceEntry *)bh->b_data)->
 				 lengthAllocDescs);
+		if (iinfo->i_lenAlloc > bs - sizeof(struct unallocSpaceEntry)) {
+			ret = -EFSCORRUPTED;
+			goto out;
+		}
 		ret = udf_alloc_i_data(inode, bs -
 					sizeof(struct unallocSpaceEntry));
 		if (ret)
-- 
2.53.0



