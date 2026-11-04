Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829654;
	b=YFxzMmsBIQFDLtwhy+qG5uzz+LvTrX35LYYhXzTmmfqi+GuiL8Z+QWM3mvtRlcqF8TNN
	 uPs/7WQEpKR+lJDjO/kAEpzmhCfrVTdybp0EH+Up8eGmmEM7J6+UM/kFXRqTMyzqLUMgE
	 udIu+OieeU2e0VSKYPKzSmoTtWtxq2K3vJleDV9GMPO/5HNzj2sIOWZmD5z4DnTL3aF8k
	 4N02/i7m163XAkq6xBRyDFSWv44RpGPJ+c31swZYj3Zqh1DSWhrQtuEUXFP1vzH0v8HWk
	 tHt/RxqRYsct/fRrbFDFx/VISoPpws8RmrBUM0fBtazEvyK2+kMSe/SW76Bm7RwIeUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829654;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qv33A15SdZthJw+nDotKZ5e6RaEkd8QkQB2CgW8WOHE=;
	b=041FEMqh/dDqkCWZhBfg4oAa0qYcQn1kgLDNFcQyesVGWu+PV7Z+6eUXRPohyTMoIzWn
	 g/N0hpWohjI/oUknNvxybpj/isJReiSaSdk58Z0WPAYfJcH7jci0JacjeOsOmWX4NziGf
	 jevrxVM/cDvontyoUhcLL0xazpmgTU/2YoKFiCGVyI3zJEqMJ4kFFpbYB5qdr0nJnxJDH
	 K0jDKgNV7TIzY/5Nr03HJbIg4hIKWFgveg9qccjWFSvpCx7iAi1682yl3AnQkBKzXL2Lx
	 odYJaf75fY+V+FVikngbbjrzWZglrsvkBpUycO80/yej+feqo/Jgx9xoGhsYDs2EC/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1nxKH0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4953606AC15;
	Wed,  4 Nov 2026 22:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r1nxKH0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A941F000C1;
	Wed,  4 Nov 2026 22:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829653;
	bh=qv33A15SdZthJw+nDotKZ5e6RaEkd8QkQB2CgW8WOHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r1nxKH0CymyypHeE7VzUZ4vjirp4QJXhGIO78+DY8abcZ+bd/S4F6Of2shCADAaVc
	 3kaZbzZBAIu5fJzvfz1G5QxwfGU7j+1oFj0fAkkqBj+FRIkQSOvel2+YApOy/S1iU9
	 vCgad+oFY8O2SYVhdG6MGgdfhvJSPTnx/wY9HDgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0257/1005] udf: bound lengthAllocDescs from unallocated space entry
Date: Wed,  4 Nov 2026 15:59:50 -0500
Message-ID: <20261104211051.067607455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 84b1a0b7b28d2..e50ecd6746104 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1488,6 +1488,10 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
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



