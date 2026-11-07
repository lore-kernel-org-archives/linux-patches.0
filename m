Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061804;
	b=QufF8WuEDbP7arWXCWTXb10Zc/I8rz8vG2JmG71swxuMP4BChIL1h4A/kgvdfWg3Cqyx
	 +k8hCF1rbVEA+xTE77BgFB51eXyfL4hmf3MRUFqgJtNcEYeK99yxaxJ5tGIHVvwTkDkbA
	 W212d6BlfBZSGeqjX01GkR/It02CpC8vyM3gaFfkyrw+6Et2C/eVnn24i4TJO/Xh50Ixo
	 Q70twD8pyWBz2qnml64TbPtJ8o8n1W+YSLAGFvEW/zyPyBwN/XSJRfB8N/j+vlN58xEHF
	 PScmGE/xS4BbtRLmw67ehf11Q5vNtIYNFU9or/9BVvvO72PDokJusjf8MaHrCiZZyiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vk9TipY78VzBICyWEBPNnhuznFFrXdnYwXD65cNCwUw=;
	b=hopCGyG/7UHOSzPcDfzVCSWRyTSh3u1iMy6YW+an84lHKdXVXtylVW3umq9FilIwyyTy
	 +D5CAIbmzwaLjwnQxvhOlBOLN5MjVlKCssOXE2zaE+cGmjvp8kc09NbQ7xphRdD05TH8s
	 E9OFRS5AZnhb4CiPomXPRUYSLClBAVOp3hxS5p6CoiR+hQaFkwauu1uB+2iOwo0ZF0Ho9
	 ghzak0fKKi/Mu+WQnRkTuVS/bMIDBoldubExsY8PxRBNlzZkRR85hBfv9+4z/qu/9sMOU
	 mYdfcc2p4Buft7Vs3tlRt8mSId2z+mplbE6IltOoEOwJUhiPpRnNi4X9Esx7sKn0kpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBxdW+F2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B694606A326;
	Sat,  7 Nov 2026 14:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VBxdW+F2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36AE1F008A4;
	Sat,  7 Nov 2026 14:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061803;
	bh=vk9TipY78VzBICyWEBPNnhuznFFrXdnYwXD65cNCwUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VBxdW+F29FD+Suie3KbwBjXJeXeEdaba0QcX4tGlhrATEKv1X6pkdgplxKyZdLlBn
	 JTJg6OfuWd/t+iuge1zE7ylIE8/xtmIuhWQpwEqVMwUm3ZsZsIaBqI2oMMz6h6RqBL
	 1XZVFMOazZnQ/VdxMXnSRxiFHPn9xFHPsReU0xZM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Atish Patra <atishp@meta.com>,
	Nikunj A Dadhania <nikunj@amd.com>
Subject: [PATCH 6.12 0792/1536] x86/mm/pat: Fix effective RW computation in lookup_address_in_pgd_attr()
Date: Sat,  7 Nov 2026 08:46:48 -0500
Message-ID: <20261107135019.786696968@linuxfoundation.org>
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

From: Mike Rapoport (Microsoft) <rppt@kernel.org>

commit ebaf7c9bbb1e16523d7036e7e1225ad2dfcc6482 upstream.

lookup_address_in_pgd_attr() accumulates the effective NX and RW bits of
the walked page table levels so that verify_rwx() can detect mappings that
are both writable and executable.

The RW bits are folded into a bool with

	rw &= pXd_flags(*pXd) & _PAGE_RW;

but _PAGE_RW is 0x2. So consider the accumulation line:

        rw &= pXd_flags(*pXd) & _PAGE_RW;

where rw=0x1 and the right side evaluates down to 0x2. It'll end up doing:

        rw = 0x1 & 0x2

and rw always ends up 0.

This way rw becomes false at the first level walked, regardless of the
actual permissions, and verify_rwx() treats every mapping as non-writable
and never reports a W^X violation.

Add double negation to the right side to normalize the _PAGE_RW flag to
0 or 1.

Assisted-by: Copilot:claude-opus-4.8
Fixes: ceb647b4b529 ("x86/pat: Introduce lookup_address_in_pgd_attr()")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Tested-by: Atish Patra <atishp@meta.com>
Tested-by: Nikunj A Dadhania <nikunj@amd.com>
Cc:stable@vger.kernel.org
Link: https://patch.msgid.link/20260813-cpa-fixes-v2-5-39b4ff90f91d@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/mm/pat/set_memory.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -682,7 +682,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_512G;
 	*nx |= pgd_flags(*pgd) & _PAGE_NX;
-	*rw &= pgd_flags(*pgd) & _PAGE_RW;
+	*rw &= !!(pgd_flags(*pgd) & _PAGE_RW);
 
 	p4d = p4d_offset(pgd, address);
 	if (p4d_none(*p4d))
@@ -693,7 +693,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_1G;
 	*nx |= p4d_flags(*p4d) & _PAGE_NX;
-	*rw &= p4d_flags(*p4d) & _PAGE_RW;
+	*rw &= !!(p4d_flags(*p4d) & _PAGE_RW);
 
 	pud = pud_offset(p4d, address);
 	if (pud_none(*pud))
@@ -704,7 +704,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_2M;
 	*nx |= pud_flags(*pud) & _PAGE_NX;
-	*rw &= pud_flags(*pud) & _PAGE_RW;
+	*rw &= !!(pud_flags(*pud) & _PAGE_RW);
 
 	pmd = pmd_offset(pud, address);
 	if (pmd_none(*pmd))
@@ -715,7 +715,7 @@ pte_t *lookup_address_in_pgd_attr(pgd_t
 
 	*level = PG_LEVEL_4K;
 	*nx |= pmd_flags(*pmd) & _PAGE_NX;
-	*rw &= pmd_flags(*pmd) & _PAGE_RW;
+	*rw &= !!(pmd_flags(*pmd) & _PAGE_RW);
 
 	return pte_offset_kernel(pmd, address);
 }


