Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916722D23A6;
	Sat, 12 Sep 2026 13:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219554; cv=none; b=K9K/Kl5JIKPuRMx+UogVWDTVAa6IkA1Rf7yf2TChiIQcY9Ef5BXMgqfOw55OEOv24TRctg/9D2Yx7rc+Y/JrqcSV/T/zYdILem9ph3knUcNI7biG06Fg+1U8IjwqB99/UWxtgd0g+siDCGsQE6FDGgN3r2zXwwNDWc+4auN4W5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219554; c=relaxed/simple;
	bh=n1cJd8kWnxFTrWivNww91O68Rim9J+jcxvihMIsmOOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oyEJ1xUqN/23SMakUye6RCbSDyi8qCLYVjFUwCDQSHq4E8Gf8k/gFPLWn1C4ywdf6kjF02CvHOms2i47tzZPijRjhs20r9Wb2oe/uU8PstnDOud0t6JEyWbUMESawrs6rtQAZ+8qv+5PbtF+ZK+xmJj/HMhZnf3ttlWXPz3djuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuRnXbpY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuRnXbpY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA9A1F000FF;
	Sat, 12 Sep 2026 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219553;
	bh=pbYTx+UUKgrPppYbJlkSt1XPeJRMidswS8SoTslIvP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuRnXbpYrrR1oi5fHpUZpc5WRRD56U30A6joi5xoUUtxYFedNLh2mHAYcA9mySxL3
	 rUJ5m2+ULXKtiVY3EViS4UzmAxQDsVdYaRgxNCIbrb6rHR0faKt5XH30g4htSqoxsF
	 DgDJwZFvbdXiUM5sctjIf5Zq0PmQ7vWK8O7L5jSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Popov <alex.popov@linux.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.12 1373/1376] x86/Kconfig: Reenable PTDUMP on i386
Date: Sat, 12 Sep 2026 09:03:19 +0200
Message-ID: <20260912065638.134802243@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Alexander Popov <alex.popov@linux.com>

commit 4f115596133fa168bac06bb34c6efd8f4d84c22e upstream.

The commit

  f9aad622006bd64c ("mm: rename GENERIC_PTDUMP and PTDUMP_CORE")

has broken PTDUMP and the Kconfig options that use it on ARCH=i386, including
CONFIG_DEBUG_WX.

CONFIG_GENERIC_PTDUMP was renamed into CONFIG_ARCH_HAS_PTDUMP, but it was
mistakenly moved from "config X86" to "config X86_64". That made PTDUMP
unavailable for i386.

Move CONFIG_ARCH_HAS_PTDUMP back to "config X86" to fix it.

  [ bp: Massage commit message. ]

Fixes: f9aad622006bd64c ("mm: rename GENERIC_PTDUMP and PTDUMP_CORE")
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -26,7 +26,6 @@ config X86_64
 	depends on 64BIT
 	# Options that are inherently 64-bit kernel only:
 	select ARCH_HAS_GIGANTIC_PAGE
-	select ARCH_HAS_PTDUMP
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128
 	select ARCH_SUPPORTS_PER_VMA_LOCK
 	select ARCH_SUPPORTS_HUGE_PFNMAP if TRANSPARENT_HUGEPAGE
@@ -94,6 +93,7 @@ config X86
 	select ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
 	select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
 	select ARCH_HAS_PMEM_API		if X86_64
+	select ARCH_HAS_PTDUMP
 	select ARCH_HAS_PTE_DEVMAP		if X86_64
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_HW_PTE_YOUNG


