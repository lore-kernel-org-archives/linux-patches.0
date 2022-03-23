Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02D86AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF93C340F2;
	Wed, 23 Mar 2022 23:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076793;
	bh=TX5G4upTJl4ETwZq2aediUjJjaKt4CWUAw7Nzl1Q/Yk=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=S9cgh3TOp6xBMD9sEIsuKIinWnvFoMVuDhTBT8a9qk3C97qbiSffFKCdgPam1R6NY
	 CoN0NxX3yq+FkiDPLoEk4dfMYtr7t68++9T2dmMBg8uk9/gJVXMfNfAaUUlZsmNKpD
	 4dcz9R6HfxoTm3vzcYJ3V+VibUT+u9LSggKNgXk0=
Date: Wed, 23 Mar 2022 16:06:33 -0700
To: will@kernel.org,tglx@linutronix.de,rmk+kernel@armlinux.org.uk,paul.walmsley@sifive.com,palmer@rivosinc.com,palmer@dabbelt.com,mingo@redhat.com,linux@armlinux.org.uk,hpa@zytor.com,ebiederm@xmission.com,dave.hansen@linux.intel.com,catalin.marinas@arm.com,bp@alien8.de,bhe@redhat.com,aou@eecs.berkeley.edu,alex@ghiti.fr,jszhang@kernel.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 25/41] kexec: make crashk_res, crashk_low_res and crash_notes symbols always visible
Message-Id: <20220323230633.BDF93C340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Jisheng Zhang <jszhang@kernel.org>
Subject: kexec: make crashk_res, crashk_low_res and crash_notes symbols always visible

Patch series "kexec: use IS_ENABLED(CONFIG_KEXEC_CORE) instead of #ifdef", v2.

Replace the conditional compilation using "#ifdef CONFIG_KEXEC_CORE" by a
check for "IS_ENABLED(CONFIG_KEXEC_CORE)", to simplify the code and
increase compile coverage.

I only modified x86, arm, arm64 and riscv, other architectures such as sh,
powerpc and s390 are better to be kept kexec code as-is so they are not
touched.


This patch (of 5):

Make the forward declarations of crashk_res, crashk_low_res and
crash_notes always visible.  Code referring to these symbols can then just
check for IS_ENABLED(CONFIG_KEXEC_CORE), instead of requiring conditional
compilation using an #ifdef, thus preparing to increase compile coverage
and simplify the code.

Link: https://lkml.kernel.org/r/20211206160514.2000-1-jszhang@kernel.org
Link: https://lkml.kernel.org/r/20211206160514.2000-2-jszhang@kernel.org
Signed-off-by: Jisheng Zhang <jszhang@kernel.org>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Paul Walmsley <paul.walmsley@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Alexandre Ghiti <alex@ghiti.fr>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kexec.h |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/kexec.h~kexec-make-crashk_res-crashk_low_res-and-crash_notes-symbols-always-visible
+++ a/include/linux/kexec.h
@@ -20,6 +20,12 @@
 
 #include <uapi/linux/kexec.h>
 
+/* Location of a reserved region to hold the crash kernel.
+ */
+extern struct resource crashk_res;
+extern struct resource crashk_low_res;
+extern note_buf_t __percpu *crash_notes;
+
 #ifdef CONFIG_KEXEC_CORE
 #include <linux/list.h>
 #include <linux/compat.h>
@@ -350,12 +356,6 @@ extern int kexec_load_disabled;
 #define KEXEC_FILE_FLAGS	(KEXEC_FILE_UNLOAD | KEXEC_FILE_ON_CRASH | \
 				 KEXEC_FILE_NO_INITRAMFS)
 
-/* Location of a reserved region to hold the crash kernel.
- */
-extern struct resource crashk_res;
-extern struct resource crashk_low_res;
-extern note_buf_t __percpu *crash_notes;
-
 /* flag to track if kexec reboot is in progress */
 extern bool kexec_in_progress;
 
_
