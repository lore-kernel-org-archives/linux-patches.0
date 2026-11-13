Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590522;
	b=N/vgFi/h/8mcZjwdu5gO0DoCh99cLNTJzY/PeTK2Y1p23o6OTh7r8hGCtdS5W+yuek0v
	 nmcc5MtxDdWOaVAD0mqmaLU/NwDiLUebIgJx48lVopCjiiAqdjkl6SVF/EBiE7I2ayw+1
	 G52646Rv40yrtv3+Rd5O8CcSFaprAt3iFjQZ2Qw9A3/fBfLqYsPfzQvKNKCRvcbYBEpXz
	 1I2Sf/YJeXq9tcQDmouNn3PnNUWZy90VWJXZdh9dNVCiayhtYOvSr+ntgsZdbS0rRfHRO
	 OtVpMOjbVQqAxIe4kAonQOuXimhShGay9OShutLUKFE4kRf7LAKh9aeW12/fuP47RIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KeFqERdzohW/XxCpedGHmzuN3m+pt2KSw2IEl4mrFPY=;
	b=EeIJnLpxXZmvohcpzYhTGG/cjK/oQb6oAz6Vpqlm95M4P/9CtAyHG4Q7avS4mPz3sXyd
	 CO6GZxjtUSNAkuwrifIJx9uUquGIt+JjucNMkTGSBqTYRuMnf5VmZw5rgYNhFDyVsnFQk
	 cfpXvZWZyvMGrO1BzL8I/gHq6hmrd/ZJz/7RS+C3qrYTfBFdYVgvkuDKCZl+cggoxN0TY
	 AN8V+xCgWcZfpGjdLCsPBiXqXT4TOcH48SQXE73vCO9v+1gclVJPZzQIqzHcujTv59AZR
	 zbQD05o1tI4OR9tIdFJ/pLYLP7wExFYq6K6ygrCRRMr2obEPpZlfRthYVYajUxTepKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AyEJx/D7";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 977F7606A8A7;
	Fri, 13 Nov 2026 17:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AyEJx/D7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A491F000C4;
	Fri, 13 Nov 2026 17:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590522;
	bh=KeFqERdzohW/XxCpedGHmzuN3m+pt2KSw2IEl4mrFPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyEJx/D7EV4LkhXfrE8KhUBxnzOSSgHL6+O7ie8O0f/8Cb2Cu3vb2wqXm8BDiXi/a
	 81yVgzxKQ1yscjJ5zZLr+a9chZ1v1xLJjz3M2as4hTHFJeZyHCa5X3nT5A1DZ+pNou
	 gJ5lZRc5/rQfldcv6FVi+hWD1AJ3T9zQTNFiua5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hamid Nassiby <hamid.nassiby@nokia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 467/686] Revert "mm/page_owner: fix memory leak in page_owner_stack_fops->release()"
Date: Fri, 13 Nov 2026 10:50:00 -0500
Message-ID: <20261113153836.713547123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Hamid Nassiby <hamid.nassiby@nokia.com>

This reverts commit 05a8edf607be826738dfc620a17d9d98e8976762, which is
commit a76a5ae2c6c6 upstream.

The upstream change is only correct on top of commit 156c0c5d1463
("mm/page_owner: introduce struct stack_print_ctx"), which first appeared
in v6.19. That commit makes page_owner_stack_open() allocate a struct
stack_print_ctx through seq_open_private() and moves the stack_list
cursor into it, so ->release() must free it with seq_release_private().
6.18 does not have that commit: page_owner_stack_open() passes a size of 0
to seq_open_private(), so there is nothing to leak, and
stack_start()/stack_next() store the current struct stack node directly
in m->private.

The upstream commit was backported because it is tagged for stable and
carries a Fixes tag for 765973a09803 ("mm,page_owner: display all stacks
and their count"), but the leak it fixes only exists since 156c0c5d1463.

seq_release_private() kfree()s m->private. Closing show_stacks before
EOF therefore frees a struct stack node that is still linked in
stack_list, and the next reader of show_stacks walks into freed memory.
On v6.18.60 (x86_64 QEMU, KASAN, page_owner=on), a single 4 KiB read()
and close() followed by a full read gives:

  BUG: KASAN: slab-use-after-free in stack_print+0x165/0x170
  Read of size 8 at addr ff110000062adfc0 by task init/1
  ...
  Allocated by task 1:
   __kasan_kmalloc+0x7f/0x90
   __set_page_owner+0x4a5/0x720
  ...
  Freed by task 1:
   kfree+0xf8/0x460
   seq_release_private+0x58/0x110
   full_proxy_release+0xa1/0x130
   __fput+0x35c/0xac0
   __x64_sys_close+0x79/0xd0
  ...
  The buggy address belongs to the object at ff110000062adfc0
   which belongs to the cache kmalloc-16 of size 16

Without KASAN, the same bug panics arm64 hardware running a
6.12.108-based kernel ("head -12 show_stacks; cat show_stacks").

With this revert applied, the QEMU reproducer completes 20
partial-read/full-read cycles without a KASAN report. mm/page_owner.c is
unchanged between v6.18.60 and v6.18.62.

Backporting 156c0c5d1463 instead is not proposed: it prepares for the
new show_handles and show_stacks_handles debugfs files rather than
fixing anything, so reverting the backport is the minimal change for
stable.

Link: https://lore.kernel.org/stable/20260106170556.173097317@linuxfoundation.org/
Signed-off-by: Hamid Nassiby <hamid.nassiby@nokia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index bc26764142ba5..589ec37c94aab 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -936,7 +936,7 @@ static const struct file_operations page_owner_stack_operations = {
 	.open		= page_owner_stack_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release_private,
+	.release	= seq_release,
 };
 
 static int page_owner_threshold_get(void *data, u64 *val)
-- 
2.53.0



