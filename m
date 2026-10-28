Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213748;
	b=1rS/kh4SxQPTW+XinRwkGiA8gBDBqLNsNXU9w/LxHE8SB57PGikwe51ppOceOHmRcPF/
	 uTZJoB5yGmKCNA8BueTYJbwIad636uMD03Gubv2IpSaCCcMNOrQpxUKTiMyNEzGdHO2ll
	 d87NG5T+JeksSWPMaidNfFDgFTXX13TCE41G117Vch9VUrkWzymNdvw5K5ATP0YlrubCK
	 KaiG52Sy54TsiGuvssl7EyjNqlxWMQdx3+Y/srykSOFiueQAxkOiWJXErCEMrpUzOjdHd
	 XlqWV92vhnNaw86qi2coRk/nh5QF5DxEeu5NcEXlRY76sKW+xrIdROqnqm99r7l9tug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213748;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jGSt3W4HVSEnpFZhu0AktCgsx8FoNYrcIRi9gGahg88=;
	b=qrYki9PN6FbbSTokXf9FTEN9yuq3TTJVG6ocGBkoZJ+QlYRN9CTQH6TKiliBnxMwh6p2
	 ynAx9YFoqXaYUmivBxOCjsa/G8H3e0mOQJkL0BGzzzG3TkbbyzFCldlj82YkwhM5w6Yyk
	 E/9ySkBb1hJLHattNPqh1muzR3mFniVxi8Cqy7rc7QeQKgYHrn+aIXkOWE9x9/LiPkkgA
	 c/od3OEfaH0vURM975cpc0q3RxTysQV4zzCnmgALNEaVM3/JkrTw72KG032bR0SRgOVJy
	 TGt2tvMzwg+0lQBCMxwXB3NwUS18dCdp3ZhPmGt+G5veAZD1HC8Z84q2EK8oigRhyPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9nW8iCi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C73606A31C;
	Wed, 28 Oct 2026 18:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9nW8iCi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EAE1F01825;
	Wed, 28 Oct 2026 18:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213747;
	bh=jGSt3W4HVSEnpFZhu0AktCgsx8FoNYrcIRi9gGahg88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9nW8iCiWwpbZAoZ6Ltq42p4YBgGOJ5Pd0G5LWxH5/BAbA2oQzSz4J+l2qozTY43B
	 LocfaTG6w0Bm6hxDIwTYgpx82zfcU36OyjxAWDpYFBVpdz/fgbWOr3G4Dx7Pz/1abm
	 xoYQrm5UtF7aDDI8v5WJo9S2cP7VjTNDPJEkNqkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0614/1887] mm/userfaultfd: reset ptes when close() for wr-protected ones
Date: Wed, 28 Oct 2026 17:45:10 +0100
Message-ID: <20261028170513.383987072@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Xu <peterx@redhat.com>

[ Upstream commit c88033efe9a391e72ba6b5df4b01d6e628f4e734 ]

Userfaultfd unregister includes a step to remove wr-protect bits from all
the relevant pgtable entries, but that only covered an explicit
UFFDIO_UNREGISTER ioctl, not a close() on the userfaultfd itself.  Cover
that too.  This fixes a WARN trace.

The only user visible side effect is the user can observe leftover
wr-protect bits even if the user close()ed on an userfaultfd when
releasing the last reference of it.  However hopefully that should be
harmless, and nothing bad should happen even if so.

This change is now more important after the recent page-table-check
patch we merged in mm-unstable (446dd9ad37d0 ("mm/page_table_check:
support userfault wr-protect entries")), as we'll do sanity check on
uffd-wp bits without vma context.  So it's better if we can 100%
guarantee no uffd-wp bit leftovers, to make sure each report will be
valid.

Link: https://lore.kernel.org/all/000000000000ca4df20616a0fe16@google.com/
Fixes: f369b07c8614 ("mm/uffd: reset write protection when unregister with wp-mode")
Analyzed-by: David Hildenbrand <david@redhat.com>
Link: https://lkml.kernel.org/r/20240422133311.2987675-1-peterx@redhat.com
Reported-by: syzbot+d8426b591c36b21c750e@syzkaller.appspotmail.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/userfaultfd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 6ebee2b3a5a83..79b0f22eedd71 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -908,6 +908,10 @@ static int userfaultfd_release(struct inode *inode, struct file *file)
 			prev = vma;
 			continue;
 		}
+		/* Reset ptes for the whole vma range if wr-protected */
+		if (userfaultfd_wp(vma))
+			uffd_wp_range(mm, vma, vma->vm_start,
+				      vma->vm_end - vma->vm_start, false);
 		new_flags = vma->vm_flags & ~__VM_UFFD_FLAGS;
 		prev = vma_merge(mm, prev, vma->vm_start, vma->vm_end,
 				 new_flags, vma->anon_vma,
-- 
2.53.0



