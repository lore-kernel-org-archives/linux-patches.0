Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC221EDA09
	for <patches@lists.linux.dev>; Mon, 19 May 2025 19:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747684231; cv=none; b=ORaSUDdV7lzytGcbWeuPvnlbkaV6rn4DmeYf3Vht4Rn7CUs9xindkVhzwpWU2fz3IguwDZCO2y9/sXIAU7JMsFoKhJwbF651GlKyuc4ENROA1w44vr4k/w6I0q1t6vqcgZS8jCuRZjzdD/lq65yzQBX5HGnZIV5g8ddHhp4HCpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747684231; c=relaxed/simple;
	bh=YD+qRoMazuh2TKk+L6Zu0sganjL3uVQPsYulM1ha2UA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sVDKjXhnkRVmkU0YSVgvnRErWKXgr/OMTjakiYkZLvTkMB+CdhsYyf6/f/BlfqmdmneieQ3wTXXjsL2yf2eNFLjDYa4Qx24UbksIcqc1bwqnq9v/lJsRdylv0WVAdSGvPXi+JGtwavyCad1whXW19Wp43fo8xVMMU1WpZ06X7dg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=gHPfxdAC; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="gHPfxdAC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1747684229; x=1779220229;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=YD+qRoMazuh2TKk+L6Zu0sganjL3uVQPsYulM1ha2UA=;
  b=gHPfxdAC7NQBOxIb0AG880nsiqcMjwjUDWNkMd1V81/cQbea+a/1Gk9A
   62c0ngkq/wBn36EAGjI8ECVhbbEnBjK79xtXcp8piQ5v7/NFIkxcDiM4q
   qkGsaelINd441zBZdk5CGjAwjHbVTV4phS+S49a9zPc2D4ucX5mWCE323
   5A8EDKttc9vmecYCypnEfDzVPAPo/8PrnqBMeTFd9IppJMkIhDuvPsjRQ
   PTtggDamLNajPq3/8ISBkK0dn7dCX+9C7NernsJN5Tro9zzT0v3r4r7E4
   ziqUsZ8QvjbvtshID/lVeBNcgjV/JMTy4+BxLWOQfMiIskEuqW1zjGyMo
   Q==;
X-CSE-ConnectionGUID: 1ye4PGzOTz+k48lZAUJUkQ==
X-CSE-MsgGUID: lZ3viB6YT+urEJQqFX7YDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11438"; a="74997038"
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="74997038"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 12:50:28 -0700
X-CSE-ConnectionGUID: odPu1XaHSW2Rae7MLZxRww==
X-CSE-MsgGUID: m2vyWQeQSRSMfl/yBWF+Sw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,301,1739865600"; 
   d="scan'208";a="140364826"
Received: from shikevix-mobl.amr.corp.intel.com (HELO desk) ([10.125.146.20])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2025 12:50:28 -0700
Date: Mon, 19 May 2025 12:50:21 -0700
From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Natanael Copa <ncopa@alpinelinux.org>,
	Guenter Roeck <linux@roeck-us.net>,
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
Message-ID: <20250519195021.mgldcftlu5k4u5sw@desk>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
 <9af6afb1-9d91-48ea-a212-bcd6d1a47203@oracle.com>
 <e1ea37bd-ea7d-4e8a-bb2f-6be709eb99f4@roeck-us.net>
 <2025051527-travesty-shape-0e3b@gregkh>
 <20250515152557.a4q2cqab4uvhnpia@desk>
 <2025051931-hardy-had-44a3@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025051931-hardy-had-44a3@gregkh>

On Mon, May 19, 2025 at 05:27:30PM +0200, Greg Kroah-Hartman wrote:
> On Thu, May 15, 2025 at 08:25:57AM -0700, Pawan Gupta wrote:
> > On Thu, May 15, 2025 at 07:35:26AM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, May 14, 2025 at 01:49:06PM -0700, Guenter Roeck wrote:
> > > > On 5/14/25 13:33, Harshit Mogalapalli wrote:
> > > > > Hi Greg,
> > > > > 
> > > > > On 15/05/25 01:35, Greg Kroah-Hartman wrote:
> > > > > > On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
> > > > > > > Hi Greg,
> > > > > > > On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> > > > > > > > This is the start of the stable review cycle for the 6.6.91 release.
> > > > > > > > There are 113 patches in this series, all will be posted as a response
> > > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > > let me know.
> > > > > > > > 
> > > > > > > > Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> > > > > > > > Anything received after that time might be too late.
> > > > > > > 
> > > > > > > ld: vmlinux.o: in function `patch_retpoline':
> > > > > > > alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
> > > > > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > > > > 
> > > > > > > We see this build error in 6.6.91-rc2 tag.
> > > > > > 
> > > > > > What is odd about your .config?  Have a link to it?  I can't duplicate
> > > > > > it here on my builds.
> > > > > > 
> > > > > 
> > > > > So this is a config where CONFIG_MODULES is unset(!=y) -- with that we could reproduce it on defconfig + disabling CONFIG_MODULES as well.
> > > > > 
> > > > 
> > > > Key is the combination of CONFIG_MODULES=n with CONFIG_MITIGATION_ITS=y.
> > > 
> > > Ah, this is due to the change in its_alloc() for 6.6.y and 6.1.y by the
> > > call to module_alloc() instead of execmem_alloc() in the backport of
> > > 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches").
> > 
> > Sorry for the trouble. I wish I had a test to catch problems like this. The
> > standard config targets defconfig, allyesconfig, allnoconfig, etc. do not
> > expose such issues. The only thing that comes close is randconfig.
> > 
> > CONFIG_MODULES=n is not a common setting, I wonder how people find such
> > issues? (trying to figure out how to prevent such issues in future).
> > 
> > > Pawan, any hints on what should be done here instead?
> > 
> > Since dynamic thunks are not possible without CONFIG_MODULES, one option is
> > to adjust the already in 6.6.91-rc2 patch 9f35e331144a (x86/its: Fix build
> > errors when CONFIG_MODULES=n) to also bring the ITS thunk allocation under
> > CONFIG_MODULES.
> > 
> > I am not seeing any issue with below build and boot test:
> > 
> >   #!/bin/bash -ex
> > 
> >   ./scripts/config --disable CONFIG_MODULES
> >   ./scripts/config --disable CONFIG_MITIGATION_ITS
> >   # https://github.com/arighi/virtme-ng
> >   vng -b
> >   vng -- lscpu
> > 
> >   # main test
> >   ./scripts/config --disable CONFIG_MODULES
> >   ./scripts/config --enable CONFIG_MITIGATION_ITS
> >   vng -b
> >   vng -- lscpu
> > 
> >   ./scripts/config --enable CONFIG_MODULES
> >   ./scripts/config --disable CONFIG_MITIGATION_ITS
> >   vng -b
> >   vng -- lscpu
> > 
> >   ./scripts/config --enable CONFIG_MODULES
> >   ./scripts/config --enable CONFIG_MITIGATION_ITS
> >   vng -b
> >   vng -- lscpu
> > 
> >   echo "PASS"
> > 
> > Similar change is required for 6.1 and 5.15 as well. 6.12 is fine because
> > it uses execmem_alloc().
> > 
> > --- 8< ---
> > From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> > Subject: [PATCH 6.6] x86/its: Fix build errors when CONFIG_MODULES=n
> > 
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > commit 9f35e33144ae5377d6a8de86dd3bd4d995c6ac65 upstream.
> > 
> > Fix several build errors when CONFIG_MODULES=n, including the following:
> > 
> > ../arch/x86/kernel/alternative.c:195:25: error: incomplete definition of type 'struct module'
> >   195 |         for (int i = 0; i < mod->its_num_pages; i++) {
> > 
> >   [ pawan: backport: Bring ITS dynamic thunk code under CONFIG_MODULES ]
> > 
> > Fixes: 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > Acked-by: Dave Hansen <dave.hansen@intel.com>
> > Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > ---
> >  arch/x86/kernel/alternative.c | 12 +++++++++++-
> >  1 file changed, 11 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> > index 6085919d3b3e..c6d9a3882ec8 100644
> > --- a/arch/x86/kernel/alternative.c
> > +++ b/arch/x86/kernel/alternative.c
> > @@ -129,6 +129,7 @@ const unsigned char * const x86_nops[ASM_NOP_MAX+1] =
> >  
> >  #ifdef CONFIG_MITIGATION_ITS
> >  
> > +#ifdef CONFIG_MODULES
> >  static struct module *its_mod;
> >  static void *its_page;
> >  static unsigned int its_offset;
> > @@ -244,7 +245,16 @@ static void *its_allocate_thunk(int reg)
> >  	return thunk;
> >  }
> >  
> > -#endif
> > +#else /* CONFIG_MODULES */
> > +
> > +static void *its_allocate_thunk(int reg)
> > +{
> > +	return NULL;
> > +}
> > +
> > +#endif /* CONFIG_MODULES */
> > +
> > +#endif /* CONFIG_MITIGATION_ITS */
> >  
> >  /*
> >   * Fill the buffer with a single effective instruction of size @len.
> > -- 
> > 2.34.1
> > 
> 
> This looks to still be causing problems, see these two reports of build
> problems with the latest 6.1 and 6.6 releases with this commit in it:
> 	https://lore.kernel.org/r/20250519164717.18738b4e@ncopa-desktop
> 	https://lore.kernel.org/r/2f1ae598-0339-4e17-8156-03e8525a213d@roeck-us.net

These reports appear to be related to a merge resolution of "x86/its:
FineIBT-paranoid vs ITS" in 6.6 (and 6.1):

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.6.91&id=772934d9062a0f7297ad4e5bffbd904208655660

which is different from 6.12:

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=v6.12.29&id=7e78061be78b8593df9b0cd0f21b1fee425035de

Basically its_static_thunk() needs to be under #ifdef CONFIG_MITIGATION_ITS

I guess there needs to be a separate patch to fix this?
