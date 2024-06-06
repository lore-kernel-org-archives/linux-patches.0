Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0A41BB6AF;
	Thu,  6 Jun 2024 14:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683495; cv=none; b=Atg1BO0bLhHdVvsYsFvRsdb2fEtCzUQ4zBzA57aCGNTEZ2u0tk07an9HY0Yc2Erg/IPl/iZvBESzD7R9m1iQdjIdo2uJV0oM24plTh1XbbIzgBmNY7AM/wPds2Ya5FMb7IPmFamwlveBC/PKIT0N66aMilw7NT72Xmhknrq4LM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683495; c=relaxed/simple;
	bh=FePEf7JIe25GawnGZVvpldCHODjw5P41rilk38w8KPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iITK1ff10hSEDQxwKzUVCIeaFYQmOzwJT80vbj1Ze9m4gz2ve7PTxyAPes9s8uJCf+N2D63Z9TYjetX6sEkam2VlOAUuDBYYTVWJQDg1v+pTWzooQdqJqoot8vhgI3B3VlykkpBHw4hSPDb77cdfmS5y/gjWBswr9/xi/1wTBIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2NJKWz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2NJKWz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C03C2BD10;
	Thu,  6 Jun 2024 14:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683495;
	bh=FePEf7JIe25GawnGZVvpldCHODjw5P41rilk38w8KPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2NJKWz3JFGoJzAPMXckH7k4qUbTf9APDoNycYgfCuhmHprJ+1SDDHEGtpo2quY8G
	 Q7HSzFVvcZ8R08ozxpzXnewSjt0GwULRcB4Mbh25vjj9T4+cSxgkyvF8oJ+H9O9/KI
	 X3mSZJC3ts9Jz0ewptE+AmnGrp3K/yJlVMTqUcfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tiwei Bie <tiwei.btw@antgroup.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 385/473] um: Fix the -Wmissing-prototypes warning for get_thread_reg
Date: Thu,  6 Jun 2024 16:05:14 +0200
Message-ID: <20240606131712.583559698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Tiwei Bie <tiwei.btw@antgroup.com>

[ Upstream commit 3144013e48f4f6e5127223c4ebc488016815dedb ]

The get_thread_reg function is defined in the user code, and is
called by the kernel code. It should be declared in a shared header.

Fixes: dbba7f704aa0 ("um: stop polluting the namespace with registers.h contents")
Signed-off-by: Tiwei Bie <tiwei.btw@antgroup.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/asm/processor-generic.h | 1 -
 arch/x86/um/shared/sysdep/archsetjmp.h  | 7 +++++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/um/include/asm/processor-generic.h b/arch/um/include/asm/processor-generic.h
index bb5f06480da95..9adfcef579c1c 100644
--- a/arch/um/include/asm/processor-generic.h
+++ b/arch/um/include/asm/processor-generic.h
@@ -95,7 +95,6 @@ extern struct cpuinfo_um boot_cpu_data;
 #define current_cpu_data boot_cpu_data
 #define cache_line_size()	(boot_cpu_data.cache_alignment)
 
-extern unsigned long get_thread_reg(int reg, jmp_buf *buf);
 #define KSTK_REG(tsk, reg) get_thread_reg(reg, &tsk->thread.switch_buf)
 extern unsigned long __get_wchan(struct task_struct *p);
 
diff --git a/arch/x86/um/shared/sysdep/archsetjmp.h b/arch/x86/um/shared/sysdep/archsetjmp.h
index 166cedbab9266..8c81d1a604a94 100644
--- a/arch/x86/um/shared/sysdep/archsetjmp.h
+++ b/arch/x86/um/shared/sysdep/archsetjmp.h
@@ -1,6 +1,13 @@
 /* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __X86_UM_SYSDEP_ARCHSETJMP_H
+#define __X86_UM_SYSDEP_ARCHSETJMP_H
+
 #ifdef __i386__
 #include "archsetjmp_32.h"
 #else
 #include "archsetjmp_64.h"
 #endif
+
+unsigned long get_thread_reg(int reg, jmp_buf *buf);
+
+#endif /* __X86_UM_SYSDEP_ARCHSETJMP_H */
-- 
2.43.0



