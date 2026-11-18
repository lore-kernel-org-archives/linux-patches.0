Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057419;
	b=2T+tWILH3g6jZGCNzHEIhw3Yus2qjBwSFbheM163LJK+0wNU5y8S04JQvUbQFpfHFGVZ
	 FUVigut9tlDeTUlSW5fbqhgiMUx5niv00HaqhwXeKb4TBHSrpDFeMsQlN3WgpWU11PnSg
	 uarcRhuVqu91qR7B5lReDiQ1byZHBFY4nsjVMElP/HrNqHHu0OMSnNXLGBLjJ/bB3SfFh
	 kGGRjXhF6liKQTlHaaQdPvwzpsclniUnxsgW/lsa+hcIPWL3t0X69Eq74V0KXh6nN4tGu
	 l//ljwh36XDSjO1w/36i5727w28iI/eGyg4u4Nt8CpiP3bQkw/5XYD0OjrcbOgvkgZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057419;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=e0AkTQWJG8S2lLnAOcihnVpxJa52Uer+juOhQVuMoe0=;
	b=PxraYhj8zuZ0thjWSdWN2EpdJb9+ZEhjMJq/lRt/AcW7AbzFVptda/GluMTdcRoxjOTu
	 wQmTR0sOHVgEPQOdjlBqvbrNKT6tagJ+GDoAGmZGG3cXOKH/BgYGnZq5X+HIqeJ0Cjmsa
	 m4FS+CTqMGpLz0kum87UJCeUbhuz3dtc6Un8jlobClPxSpypvM9OXR202eQ4iZb5F3Dix
	 EvKPCtLP1PkGIvLPjKuP5wPEr2gHjHb3y6ltWUYd6dTGAJkbImkqh/a5ojabXP0n0IGlt
	 bCaeV2KL8QDvqKp3KdHuoJGpZ+Z1ClsTgGqGXLlZsbH5A9GL35gJDT1iY3sUGe6Gcyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roD2Zl9V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E7860A2605;
	Thu, 19 Nov 2026 03:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roD2Zl9V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B921F000C4;
	Thu, 19 Nov 2026 03:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057419;
	bh=e0AkTQWJG8S2lLnAOcihnVpxJa52Uer+juOhQVuMoe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roD2Zl9VBq/ZMAVn0JHu3U8LLMM0/Piwh2onOLZk5ki5aCpNgEaQrSP5awuprr5hQ
	 9y5XpKbN1GyCvxsI0kWPdUV5JIhgMbgmRAztO0nZsaiHvNgyHPCMW+P6ebApPUWgbp
	 X6CxxcGAq/3Y0doAHehmaMVI5i4zFLld5KqAKPus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Vadayath <jay@artiphishell.com>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0123/1848] udf: bound lengthAllocDescs from unallocated space entry
Date: Wed, 18 Nov 2026 15:36:01 +0100
Message-ID: <20261118145916.174200017@linuxfoundation.org>
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
index 6afbc17af652b..849fb64fdb8e5 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -1425,6 +1425,10 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
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



