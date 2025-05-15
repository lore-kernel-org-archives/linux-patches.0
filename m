Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA2820C026
	for <patches@lists.linux.dev>; Thu, 15 May 2025 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747322766; cv=none; b=A/znQrzB24jP3cLyXakOApPhilEejLesqXVDU7ISIUMg8glFmyRPGt2pvXE9/E8efc4D+Y9DbowD5kFOJV567LSbC8Zi1f9TDf2TD53EWrmuGv+pE2D78qxGIu7Qh/ErdltIoimfJP9wqKAhRL6/Js30MEyYT5ZLHb08yFEWWVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747322766; c=relaxed/simple;
	bh=ZArRs3HPLf9KeUKhJEOw3f0CEX59vDwwhKUGHW10dag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l02G8qe8UaTsSk/zQcA3UKrI7EPUab8ePOkMhZTjXIWINxenaDngF5YOly70nXuRXNY3Dn1lvWH+J6XnTHmSHjxF+6F2SbHSdnWfksgjSmgW+SbDca9PwZz9WaEgsJga5adKlBb13L1KJa/F/DDlLlpcI368/Ve6xinhUXcVIEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WG5Pq+YC; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WG5Pq+YC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747322765; x=1778858765;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=ZArRs3HPLf9KeUKhJEOw3f0CEX59vDwwhKUGHW10dag=;
  b=WG5Pq+YC8Rn78yhsYv7OY7tVCq5ZdxBU9vln7TzX5LrLdoJZPGdEY5bl
   6Ew99+G+TJoZXrzdXb1YL1qV5EzE4qPvXYjZQCbipt80SMW+u/FEf3Uwx
   /Yt++Se18Qg6dH9lWQ0EFv60g7Sc4XNEySVxBXzgEN7Wr3K+ipNR72/ka
   46oXoaL/8Ca5xhKVuJkJ3mOSq/7SkdRhOQQWnKfXZZT0TmZyV7ESd5khx
   C+NTc5OlqoPCJfkwVdC6ynCjHrELiSjNDpkZ2SdD/hEUlMUmyfqcxSvYI
   HUBQ9255KD1Y4WskfYC34K+2GibxfOc8WeoVPtxDjYlNazrPt57K22Y5s
   Q==;
X-CSE-ConnectionGUID: 6U01ag1mQHy4AGNuKgiryw==
X-CSE-MsgGUID: Q2nCsr84RAeLhe+eagHc0g==
X-IronPort-AV: E=McAfee;i="6700,10204,11434"; a="71778597"
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="71778597"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 08:26:04 -0700
X-CSE-ConnectionGUID: E6tAvZ2vQvi80tyoulfXOA==
X-CSE-MsgGUID: QgQbqN/ESDaP4p4sFdQ0GA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,291,1739865600"; 
   d="scan'208";a="142413561"
Received: from gkhatri-mobl.amr.corp.intel.com (HELO desk) ([10.125.146.13])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2025 08:26:03 -0700
Date: Thu, 15 May 2025 08:25:57 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc2 review
Message-ID: <20250515152557.a4q2cqab4uvhnpia@desk>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
 <9af6afb1-9d91-48ea-a212-bcd6d1a47203@oracle.com>
 <e1ea37bd-ea7d-4e8a-bb2f-6be709eb99f4@roeck-us.net>
 <2025051527-travesty-shape-0e3b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025051527-travesty-shape-0e3b@gregkh>

On Thu, May 15, 2025 at 07:35:26AM +0200, Greg Kroah-Hartman wrote:
> On Wed, May 14, 2025 at 01:49:06PM -0700, Guenter Roeck wrote:
> > On 5/14/25 13:33, Harshit Mogalapalli wrote:
> > > Hi Greg,
> > > 
> > > On 15/05/25 01:35, Greg Kroah-Hartman wrote:
> > > > On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
> > > > > Hi Greg,
> > > > > On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> > > > > > This is the start of the stable review cycle for the 6.6.91 release.
> > > > > > There are 113 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> > > > > > Anything received after that time might be too late.
> > > > > 
> > > > > ld: vmlinux.o: in function `patch_retpoline':
> > > > > alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
> > > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > > 
> > > > > We see this build error in 6.6.91-rc2 tag.
> > > > 
> > > > What is odd about your .config?  Have a link to it?  I can't duplicate
> > > > it here on my builds.
> > > > 
> > > 
> > > So this is a config where CONFIG_MODULES is unset(!=y) -- with that we could reproduce it on defconfig + disabling CONFIG_MODULES as well.
> > > 
> > 
> > Key is the combination of CONFIG_MODULES=n with CONFIG_MITIGATION_ITS=y.
> 
> Ah, this is due to the change in its_alloc() for 6.6.y and 6.1.y by the
> call to module_alloc() instead of execmem_alloc() in the backport of
> 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches").

Sorry for the trouble. I wish I had a test to catch problems like this. The
standard config targets defconfig, allyesconfig, allnoconfig, etc. do not
expose such issues. The only thing that comes close is randconfig.

CONFIG_MODULES=n is not a common setting, I wonder how people find such
issues? (trying to figure out how to prevent such issues in future).

> Pawan, any hints on what should be done here instead?

Since dynamic thunks are not possible without CONFIG_MODULES, one option is
to adjust the already in 6.6.91-rc2 patch 9f35e331144a (x86/its: Fix build
errors when CONFIG_MODULES=n) to also bring the ITS thunk allocation under
CONFIG_MODULES.

I am not seeing any issue with below build and boot test:

  #!/bin/bash -ex

  ./scripts/config --disable CONFIG_MODULES
  ./scripts/config --disable CONFIG_MITIGATION_ITS
  # https://github.com/arighi/virtme-ng
  vng -b
  vng -- lscpu

  # main test
  ./scripts/config --disable CONFIG_MODULES
  ./scripts/config --enable CONFIG_MITIGATION_ITS
  vng -b
  vng -- lscpu

  ./scripts/config --enable CONFIG_MODULES
  ./scripts/config --disable CONFIG_MITIGATION_ITS
  vng -b
  vng -- lscpu

  ./scripts/config --enable CONFIG_MODULES
  ./scripts/config --enable CONFIG_MITIGATION_ITS
  vng -b
  vng -- lscpu

  echo "PASS"

Similar change is required for 6.1 and 5.15 as well. 6.12 is fine because
it uses execmem_alloc().

--- 8< ---
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Subject: [PATCH 6.6] x86/its: Fix build errors when CONFIG_MODULES=n

From: Eric Biggers <ebiggers@google.com>

commit 9f35e33144ae5377d6a8de86dd3bd4d995c6ac65 upstream.

Fix several build errors when CONFIG_MODULES=n, including the following:

../arch/x86/kernel/alternative.c:195:25: error: incomplete definition of type 'struct module'
  195 |         for (int i = 0; i < mod->its_num_pages; i++) {

  [ pawan: backport: Bring ITS dynamic thunk code under CONFIG_MODULES ]

Fixes: 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Dave Hansen <dave.hansen@intel.com>
Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/alternative.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 6085919d3b3e..c6d9a3882ec8 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -129,6 +129,7 @@ const unsigned char * const x86_nops[ASM_NOP_MAX+1] =
 
 #ifdef CONFIG_MITIGATION_ITS
 
+#ifdef CONFIG_MODULES
 static struct module *its_mod;
 static void *its_page;
 static unsigned int its_offset;
@@ -244,7 +245,16 @@ static void *its_allocate_thunk(int reg)
 	return thunk;
 }
 
-#endif
+#else /* CONFIG_MODULES */
+
+static void *its_allocate_thunk(int reg)
+{
+	return NULL;
+}
+
+#endif /* CONFIG_MODULES */
+
+#endif /* CONFIG_MITIGATION_ITS */
 
 /*
  * Fill the buffer with a single effective instruction of size @len.
-- 
2.34.1

