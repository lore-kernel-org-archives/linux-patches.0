Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FEE1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6124C36AE3;
	Fri, 25 Mar 2022 01:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170845;
	bh=G00uFliYSIHQojhdXheZE8XyuBUYyOvS7yjTAZoSnos=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=yeRTHO3FLmAJlzy0dGrT3Gw7P6+znIETJEDm/b8EnZyfOGw47KCUuMEb9GsuArrZz
	 dU8jSYeJAfoHc1UlRMDBG4l2ZgLx55mETrSsR+veciDJeUxZS/pmyFAhxCOzq2j0VD
	 +ds/oYOgMfPcfTQxrchCoa3xMuwO3wEKMi+oLlnA=
Date: Thu, 24 Mar 2022 18:14:05 -0700
To: will@kernel.org,tglx@linutronix.de,mingo@redhat.com,hpa@zytor.com,catalin.marinas@arm.com,anshuman.khandual@arm.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 110/114] mm: generalize ARCH_HAS_FILTER_PGPROT
Message-Id: <20220325011405.D6124C36AE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm: generalize ARCH_HAS_FILTER_PGPROT

ARCH_HAS_FILTER_PGPROT config has duplicate definitions on platforms that
subscribe it.  Instead make it a generic config option which can be
selected on applicable platforms when required.

Link: https://lkml.kernel.org/r/1643004823-16441-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    3 ---
 mm/Kconfig       |    3 +++
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/arch/x86/Kconfig
@@ -337,9 +337,6 @@ config GENERIC_CALIBRATE_DELAY
 config ARCH_HAS_CPU_RELAX
 	def_bool y
 
-config ARCH_HAS_FILTER_PGPROT
-	def_bool y
-
 config ARCH_HIBERNATION_POSSIBLE
 	def_bool y
 
--- a/mm/Kconfig~mm-generalize-arch_has_filter_pgprot
+++ a/mm/Kconfig
@@ -762,6 +762,9 @@ config ARCH_HAS_CURRENT_STACK_POINTER
 	  register alias named "current_stack_pointer", this config can be
 	  selected.
 
+config ARCH_HAS_FILTER_PGPROT
+	bool
+
 config ARCH_HAS_PTE_DEVMAP
 	bool
 
_
