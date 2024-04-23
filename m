Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078EA143C46;
	Tue, 23 Apr 2024 21:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908685; cv=none; b=Hs0YuHflLdHjh7J8XUY8AbwJp8FVS5F+oupGEquf4PjfaE3FUR+5l3iT3JdFHLzpCdK/xCjmoXBSnC8wsU4UTbMntqCVI+f9qUXqBUnfrlIpXbUsvx3H971XfwACVsc6lhJgQ0h+UV4uUk5fh4sNCo+OCpjagXSHoeuDUo0IANo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908685; c=relaxed/simple;
	bh=+0FM8r+mU43uVx8HJ2q85y74PhRyMOIpHF+VcOyXdAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0DKdaWdZ2YrKuag1IyI3fXG6OHezkyOnb2SaTS1hMEVry+Xnh19/B4RgYlQwRODqQjzPkrZd38b0Dn+5xHxoB+c7fU6qsNlnDqWSZGV7slLbz+1QV45d/WE9unvVo2pB5tp9TH3nUEjmsLRwMA91U7hTNeWIL9i3scpY93MX2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DyPWaLCm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DyPWaLCm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E19C116B1;
	Tue, 23 Apr 2024 21:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908684;
	bh=+0FM8r+mU43uVx8HJ2q85y74PhRyMOIpHF+VcOyXdAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DyPWaLCmMXFIHygMO95FlSrOFUJMMMnGen2YKRen/o4YFi/uB+WCfqsTeQeAnv4JC
	 odHgTSZ82cHb7jtXtmk39VZKl0juo1lciydMp8X9+rSPE20/5Z6V6QVqb7bxmDBbx6
	 GkYG1V0a53U2gQIKAJwJubA0m0xhxyga1PoC55Rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 030/141] x86/head/64: Move the __head definition to <asm/init.h>
Date: Tue, 23 Apr 2024 14:38:18 -0700
Message-ID: <20240423213854.289965914@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

[ Commit d2a285d65bfde3218fd0c3b88794d0135ced680b upstream ]

Move the __head section definition to a header to widen its use.

An upcoming patch will mark the code as __head in mem_encrypt_identity.c too.

Signed-off-by: Hou Wenlong <houwenlong.hwl@antgroup.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/0583f57977be184689c373fe540cbd7d85ca2047.1697525407.git.houwenlong.hwl@antgroup.com
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/init.h |    2 ++
 arch/x86/kernel/head64.c    |    3 +--
 2 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/init.h
+++ b/arch/x86/include/asm/init.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_INIT_H
 #define _ASM_X86_INIT_H
 
+#define __head	__section(".head.text")
+
 struct x86_mapping_info {
 	void *(*alloc_pgt_page)(void *); /* allocate buf for page table */
 	void *context;			 /* context for alloc_pgt_page */
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -41,6 +41,7 @@
 #include <asm/trapnr.h>
 #include <asm/sev.h>
 #include <asm/tdx.h>
+#include <asm/init.h>
 
 /*
  * Manage page tables very early on.
@@ -84,8 +85,6 @@ static struct desc_ptr startup_gdt_descr
 	.address = 0,
 };
 
-#define __head	__section(".head.text")
-
 static void __head *fixup_pointer(void *ptr, unsigned long physaddr)
 {
 	return ptr - (void *)_text + (void *)physaddr;


