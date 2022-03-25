Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E801FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:11:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C7AC340EC;
	Fri, 25 Mar 2022 01:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170714;
	bh=B1+KuMKe6a0ebrhSbZUbxQWCqVdY0JkOGBPnaPRjQdw=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=WRKm0l9tth0JLtxyb7e6Ib2c1+G51SM4J6SeYo6GiPKF4r0di2Sg4aBRof964lByV
	 pu3TJvofJo4ynOhpu/aXGeTIRXf7Nwgbd/XuelhH4+H/j8TgOe4pGvhdOkYaleEDX6
	 Tbm9l7wJsp8No1FzKBrYn/1GmzVzaL2wzT3crj1Q=
Date: Thu, 24 Mar 2022 18:11:53 -0700
To: will@kernel.org,vincenzo.frascino@arm.com,ryabinin.a.a@gmail.com,pcc@google.com,mark.rutland@arm.com,glider@google.com,eugenis@google.com,elver@google.com,dvyukov@google.com,catalin.marinas@arm.com,andreyknvl@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 066/114] arm64: select KASAN_VMALLOC for SW/HW_TAGS modes
Message-Id: <20220325011153.E1C7AC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Andrey Konovalov <andreyknvl@google.com>
Subject: arm64: select KASAN_VMALLOC for SW/HW_TAGS modes

Generic KASAN already selects KASAN_VMALLOC to allow VMAP_STACK to be
selected unconditionally, see commit acc3042d62cb9 ("arm64: Kconfig:
select KASAN_VMALLOC if KANSAN_GENERIC is enabled").

The same change is needed for SW_TAGS KASAN.

HW_TAGS KASAN does not require enabling KASAN_VMALLOC for VMAP_STACK, they
already work together as is.  Still, selecting KASAN_VMALLOC still makes
sense to make vmalloc() always protected.  In case any bugs in KASAN's
vmalloc() support are discovered, the command line kasan.vmalloc flag can
be used to disable vmalloc() checking.

Select KASAN_VMALLOC for all KASAN modes for arm64.

Link: https://lkml.kernel.org/r/99d6b3ebf57fc1930ff71f9a4a71eea19881b270.1643047180.git.andreyknvl@google.com
Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Evgenii Stepanov <eugenis@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Collingbourne <pcc@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm64/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/Kconfig~arm64-select-kasan_vmalloc-for-sw-hw_tags-modes
+++ a/arch/arm64/Kconfig
@@ -208,7 +208,7 @@ config ARM64
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
 	select IRQ_FORCED_THREADING
-	select KASAN_VMALLOC if KASAN_GENERIC
+	select KASAN_VMALLOC if KASAN
 	select MODULES_USE_ELF_RELA
 	select NEED_DMA_MAP_STATE
 	select NEED_SG_DMA_LENGTH
_
