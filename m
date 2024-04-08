Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C3C97EF06;
	Mon,  8 Apr 2024 13:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583911; cv=none; b=VbJyIt4AByl2Ec0Md+p5eNoNIeRarqdzQf+f65LSIIUi/XLNP4BO2aIszShIzlFU23Bk+o9g8Fs/oZs4xZ5XnWnesQRMIKITqfoFdEbc9uB/bzJW5Fp91QtvM87rjns7ELa3RJ6ftrh3tSxXyyF4wUdcGz8zpHy8ZnHdP+1t4t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583911; c=relaxed/simple;
	bh=frRbsWdKE2Ou1pqA59yH7vpZwkCJ0FWcLZG3Em+KfFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KIdqYi/DNxtfz3IlKJZzwi1p1bsngweEq73Le1YI/EGteKpPROdDqxMrMjUEO8rWt2oSyHQHoHHZ42bXHpl69lOaI47glM+Yj8QY17BgBIeI2Ga+eZmAnlre/kORXsayW+ibZOkttdefgnRXGptHnO8+yDBnSj7FtTrWAaKzqBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVfP7Wuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVfP7Wuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B793AC433C7;
	Mon,  8 Apr 2024 13:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583911;
	bh=frRbsWdKE2Ou1pqA59yH7vpZwkCJ0FWcLZG3Em+KfFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVfP7Wuzrr7XdfkJlI4uPj/+yR01A3Cuy3aoEC23OD/Zb5wS8slV5udy14wbf7QkX
	 XYLhuv1fGjfq6lV5dkeVTckPUu6ut09VS7K4KRAhC2M4zbdhyrgjVRnTgBeKuW0x9Z
	 Oi3qrPuApMv4KkqAI2xdtUyd95UT1W55bFolDHgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hou Wenlong <houwenlong.hwl@antgroup.com>,
	Ingo Molnar <mingo@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 248/252] x86/head/64: Move the __head definition to <asm/init.h>
Date: Mon,  8 Apr 2024 14:59:07 +0200
Message-ID: <20240408125314.354577702@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hou Wenlong <houwenlong.hwl@antgroup.com>

commit d2a285d65bfde3218fd0c3b88794d0135ced680b upstream.

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


