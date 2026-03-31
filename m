Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273C9425CC3;
	Tue, 31 Mar 2026 16:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975917; cv=none; b=deytvXtp5X4H8wW8M3xW4dwi5Qod3NPTbh+rliuH+Q7EUb78EiIm9xoYSGd1Vz/6XqVIGVbke5Ph13LDi6LoN8qLizBvSoZiC28yXkXRt0qlQoFYkvsaRgjMd9st6teLPhihzpHrZ3VBiUb7I4qrfON3PqlsFOITmMsrwk9G+PY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975917; c=relaxed/simple;
	bh=NPqYjcrobh3HItsqev+dhFs4e3NTT5OFT5ybrsXTY40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=thDqpixyJZclSYi6gmhuhbqvM3smkpvYU7iP5lD5QwKmyIwgGarCt7adlr0C2iMQB91lfMvPql7+0iX5g/YhbBLrExk1xwfaF+MP5jZ1R8Y3FDKD4d2yGKS8gFRxNrNwVmPZk+F/or9fIhLX6C7rLxROIGfbZSeay6s/l2GMl+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LnBtm4/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LnBtm4/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EAAC19423;
	Tue, 31 Mar 2026 16:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975917;
	bh=NPqYjcrobh3HItsqev+dhFs4e3NTT5OFT5ybrsXTY40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LnBtm4/pBtRjTUtRufw49VVNRXPm3SKQd0BxbGfycwmo+pA7LWPIEXQQwnWfZkXt7
	 +uKriqK6WfaGM9UhR3Um+oAbbSJH/0SwGW/IX1A/HibTmTwbuOn3yLApR5N/G0Lsie
	 Gf7WJIsI3L0RM0v1A09KC8nst8pmnwPgURegJ/G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Arnd Bergmann <arnd@arndb.de>,
	stable@kernel.org
Subject: [PATCH 6.12 135/244] s390/syscalls: Add spectre boundary for syscall dispatch table
Date: Tue, 31 Mar 2026 18:21:25 +0200
Message-ID: <20260331161746.638674198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 48b8814e25d073dd84daf990a879a820bad2bcbd upstream.

The s390 syscall number is directly controlled by userspace, but does
not have an array_index_nospec() boundary to prevent access past the
syscall function pointer tables.

Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Fixes: 56e62a737028 ("s390: convert to generic entry")
Cc: stable@kernel.org
Assisted-by: gkh_clanker_2000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/2026032404-sterling-swoosh-43e6@gregkh
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/s390/kernel/syscall.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/s390/kernel/syscall.c
+++ b/arch/s390/kernel/syscall.c
@@ -13,6 +13,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/nospec.h>
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/fs.h>
@@ -114,6 +115,7 @@ static void do_syscall(struct pt_regs *r
 	if (likely(nr >= NR_syscalls))
 		goto out;
 	do {
+		nr = array_index_nospec(nr, NR_syscalls);
 		regs->gprs[2] = current->thread.sys_call_table[nr](regs);
 	} while (test_and_clear_pt_regs_flag(regs, PIF_EXECVE_PGSTE_RESTART));
 out:


