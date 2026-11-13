Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591275;
	b=cJmUsFIenYbsJ8yCRnw4uM8oSFw3OpbnFu1T6FZ69sDeIJONvzqSSGWBDblzxiDpJ5GC
	 OPpLTcWv5X4iQ3GQ032w52HZcAtEboM9I0jGVUg4SgtwoaIu/m3ZH13PAtYfcgsV0zrhT
	 uLLS9ajTUM05Dn5um5NA1t31NPzFe980phCRQJJlaV+8MxIzRzMo4eUavUNnxdCioNA6D
	 3HjAs9Y7YKCSelu7zsNY7hRccK9Gg8Lj8rXEANxe6N4tkF1190TPJOooeMNWZGFGst8vG
	 T2+yNPckCE41oo2TyT6n4jYTRdrR0bmM98KL3J/M8uSNpMvlgVQeZ+KMk8wsbcTsH3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Q+NyHo9trkyCl33pqsuKOvBFdoMvvq2ZidtuVRRk96c=;
	b=SUhwV9hUjcmr7Z1SN3g77AARSd4Or+eeDT7bJbsZoPx25vrUXmqPaqjx60ykmZhfkRHS
	 kXsQ1XjoLLFggZdPkoB8XyK7FRiBUsmQ/dYVd9c24skQ+imsNVocfl8zpgn8ofYBAmMxI
	 FSVo+mXCnjlr2rSp6yghBLbOr8qabwtjkSWU0XR6TYU0SXgJmgY1yaitfR/RBguHz4oFN
	 EsUPagJ4+Fo6R644BySMTbHs9tZvlzoetyG5Cjq4860LTU/YRzbg6qXWI+aAaEcIx5+tj
	 78X+wMWkPc83pZTVlAaZxjWqcV+O1aNhoGM/Z/zzuz1ctGDsakFBVY3SEDd/O5KZTdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqlAqv59;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1016076FBD;
	Fri, 13 Nov 2026 17:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kqlAqv59
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED9091F000C4;
	Fri, 13 Nov 2026 17:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591275;
	bh=Q+NyHo9trkyCl33pqsuKOvBFdoMvvq2ZidtuVRRk96c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kqlAqv59GcGUSvhGfttuSNt4LcRKDIA7ZUIE+xtaNj3I4nP4prDqmlfxfB9ziyCRj
	 ULWnJxmGfyqTmfqKO/psrFYYhSb4I5s3/3e4LSehLwNHWXUkafr9fF7YaKAQIQ2YpM
	 MZYXkyaQ+OasaShTGDM6u81FoAmSOdbzGPgflaoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamid Nassiby <hamid.nassiby@nokia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 397/670] Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"
Date: Fri, 13 Nov 2026 10:49:21 -0500
Message-ID: <20261113153825.208309311@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Hamid Nassiby <hamid.nassiby@nokia.com>

This reverts commit 7fbea59f737eb3a47368ee5253e708cb342faf8b, which is
commit a76a5ae2c6c6 upstream.

The upstream change is only correct on top of commit 156c0c5d1463
("mm/page_owner: introduce struct stack_print_ctx"), which first appeared
in v6.19. That commit makes page_owner_stack_open() allocate a struct
stack_print_ctx through seq_open_private() and moves the stack_list
cursor into it, so ->release() must free it with seq_release_private().
6.12 does not have that commit: page_owner_stack_open() passes a size of 0
to seq_open_private(), so there is nothing to leak, and
stack_start()/stack_next() store the current struct stack node directly
in m->private.

The upstream commit was backported because it is tagged for stable and
carries a Fixes tag for 765973a09803 ("mm,page_owner: display all stacks
and their count"), but the leak it fixes only exists since 156c0c5d1463.

seq_release_private() kfree()s m->private. Closing show_stacks before
EOF therefore frees a struct stack node that is still linked in
stack_list, and the next reader of show_stacks walks into freed memory.
On v6.12.115 (x86_64 QEMU, KASAN, page_owner=on), a single 4 KiB read()
and close() followed by a full read gives:

  BUG: KASAN: slab-use-after-free in stack_print+0x165/0x170
  Read of size 8 at addr ff11000005259d40 by task init/1
  ...
  Allocated by task 1:
   __kasan_kmalloc+0x7f/0x90
   __set_page_owner+0x45c/0x6c0
  ...
  Freed by task 1:
   kfree+0x1a0/0x390
   seq_release_private+0x58/0x110
   full_proxy_release+0xe3/0x290
   __fput+0x35c/0xac0
   __x64_sys_close+0x79/0xc0
  ...
  The buggy address belongs to the object at ff11000005259d40
   which belongs to the cache kmalloc-16 of size 16

Without KASAN, a partial read followed by a full read
("head -12 show_stacks; cat show_stacks") panics arm64 hardware running
a 6.12.108-based kernel:

  Unable to handle kernel paging request at virtual address 0030206235376d88
  pc : stack_print+0x20/0xd0
  lr : seq_read_iter+0x340/0x470
  Call trace:
   stack_print+0x20/0xd0
   seq_read_iter+0x340/0x470
   seq_read+0xf0/0x140
   full_proxy_read+0x54/0xa0
   vfs_read+0xc8/0x348
   ksys_read+0x6c/0x118
  Kernel panic - not syncing: Oops: Fatal exception

With this revert applied, the QEMU reproducer completes 20
partial-read/full-read cycles without a KASAN report. mm/page_owner.c is
unchanged between v6.12.115 and v6.12.116.

Backporting 156c0c5d1463 instead is not proposed: it prepares for the
new show_handles and show_stacks_handles debugfs files rather than
fixing anything, so reverting the backport is the minimal change for
stable.

Link: https://lore.kernel.org/stable/20260106170507.666343896@linuxfoundation.org/
Signed-off-by: Hamid Nassiby <hamid.nassiby@nokia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5d1c946c0008f..d2783b7c06619 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -937,7 +937,7 @@ static const struct file_operations page_owner_stack_operations = {
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= seq_release,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)
-- 
2.53.0



