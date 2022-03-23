Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C406AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290F3C340EE;
	Wed, 23 Mar 2022 23:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076751;
	bh=Pj0a7BRdod/muY3okTMb5ef8U41UF/RI8dDG9p0DTKY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=ho3w+/rVgmW/GSz7YCT3rCmHg6iHZEaqqyx/hjffSkEjPEK9kG2xWJ0f+KQN7A+h+
	 m9gesD6og3mSb2gM4CM01sHKkQs9EAGWTMr8/mTXZ7Pq3qHnsLHsOevW0HJpPz+M94
	 NIEKDBef4VeclptRKJFPTf9GMRxqNULNVIXzO+9I=
Date: Wed, 23 Mar 2022 16:05:50 -0700
To: lkp@intel.com,guoren@kernel.org,feng.tang@intel.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 11/41] lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option
Message-Id: <20220323230551.290F3C340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Feng Tang <feng.tang@intel.com>
Subject: lib/Kconfig.debug: add ARCH dependency for FUNCTION_ALIGN option

0Day robots reported there is compiling issue for 'csky' ARCH
when CONFIG_DEBUG_FORCE_DATA_SECTION_ALIGNED is enabled [1]:

All errors (new ones prefixed by >>):

   {standard input}: Assembler messages:
>> {standard input}:2277: Error: pcrel offset for branch to .LS000B too far (0x3c)


Which was discussed in [2].  And as there is no solution for csky yet, add
some dependency for this config to limit it to several ARCHs which have no
compiling issue so far.

[1]. https://lore.kernel.org/lkml/202202271612.W32UJAj2-lkp@intel.com/
[2]. https://www.spinics.net/lists/linux-kbuild/msg30298.html

Link: https://lkml.kernel.org/r/20220304021100.GN4548@shbuild999.sh.intel.com
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Guo Ren <guoren@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/Kconfig.debug~lib-kconfigdebug-add-arch-dependency-for-function_align-option
+++ a/lib/Kconfig.debug
@@ -439,7 +439,8 @@ config SECTION_MISMATCH_WARN_ONLY
 	  If unsure, say Y.
 
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
-	bool "Force all function address 64B aligned" if EXPERT
+	bool "Force all function address 64B aligned"
+	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
_
