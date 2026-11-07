Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060822;
	b=fgcyOYtbK4m1MlQKlGrMeu+1/YwlNPk9A9JsiyHzpXPZQEFYEfpsnyxCKHDBsDgosyDX
	 59YVtok38KDA9ravylAV2i4UBnMGYqbk8kWd581ZcSJv4mT93L2hnNI6sEMIC5Esn1+QM
	 lTiu4/a9s7GOfz+DAl17tTLTF/pdvLKLIXTz58G1eH7RUlwxWiI16xmnCGC8m+AmN9DQG
	 6bRh8k7IS4R03t+WTPOgVCGDX7jBKdjfp/z7Sh088JaikFqAjFUAN8O1dQdghS8Rqlsw7
	 znoFn1jlYnW4k0jIKhAq2Sdk5kmv98DBu9Z0oFqkwtJP7M7OzyoQWBFx1Z2ha8QqQjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060822;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VkLzG+XQAaNH/I9bdrIk2PqEZqeKcaao8PP56gOgy44=;
	b=I4LsrnMQxkhFuLfeR0r0VfEyuY+Q65gWuVzdUMnzCo2p+fwPMqfuxXS6NvmwW0AaeuHe
	 6w1XPy0vDp40J5KwyYUZdWxAfIs3GwSYTEUY0fFw97Mfyto9JvQ8MCCOEZ97E3owWF57c
	 siEoJlTDlA+/mDvr1msso26/KaDK3i//uDEIHbSqQGzSDICo9Ua5oysZqqo3zUVjnqWAU
	 gc9VbZYCpv4RkeMROc8d6a1VFE1V/2PcLtjWupq/61nBGjXZyvSDEDa3w61y1Ma6ZFXKw
	 Vkw7xzmDWcAylPCsXlBXiQxWo380fG1EIpxInyfO65EVpUnuWJ86A4OH8MuzHWbu/cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XwJui4o;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BDDE606A326;
	Sat,  7 Nov 2026 14:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1XwJui4o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29F01F0089F;
	Sat,  7 Nov 2026 14:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060822;
	bh=VkLzG+XQAaNH/I9bdrIk2PqEZqeKcaao8PP56gOgy44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1XwJui4oLeoRtUBUar0cLcMsuWSjUVgW1Xfn2VNutzZzbOxSn/a+TnXmRAcrGNrw+
	 i7dJK1uvpZiYQrgPkIrmCIa1UBC//wx5Ko4G0D5WzLk+pdhOiiXBW5C+oU2kBKv0bn
	 RQ26zwF3hVyVS4YIbBnaR4A+XiVtdqbfzIhYwc4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0219/1536] udf: bound lengthAllocDescs from unallocated space entry
Date: Sat,  7 Nov 2026 08:37:15 -0500
Message-ID: <20261107135003.812365694@linuxfoundation.org>
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
index 05eddd60e80a7..78a04b2cb820d 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1481,6 +1481,10 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
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



