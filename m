Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9D22820BC;
	Mon, 19 May 2025 15:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747668454; cv=none; b=QmATNAAGLmw0oIQl0Fnoxs+Iz+KY0TGMQ8GCMYAl7ixomDKgZTThttm4tCzLxNaCbdAaOWixklNNHd0IFHAY2nw7cyTQJj4k/FzTC4Mq7N9Xu0P4eaMCvJ9U9nnUbNWsP06v+Z+Lt8d7QpbyjSZBFwHm6bVdzO5zn8VU8YQRVHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747668454; c=relaxed/simple;
	bh=t+V18x9K5U3txXXfD8+PUaO/b5cpwqu1b7n9tWAOFPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M0WT6XKrBbkCWhlVJ/8aLgQ1XimkI+lLL7JeJ+rTEzgWiL2ZSFIkHGd4MJWB9MUA63dbcbnzrDhlVhtbz2UEJ0ekGKQkEicsUXR5znaCKoT+Ud+LXUT/qfKrfhgT5P0LUpNhVb0YdkyyA8FASyfgWKboTqoYO+N6eojKbDZ+QoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz+6uRX0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz+6uRX0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2F26C4CEE4;
	Mon, 19 May 2025 15:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747668453;
	bh=t+V18x9K5U3txXXfD8+PUaO/b5cpwqu1b7n9tWAOFPM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wz+6uRX0un26SiQI4WLnR7eoKrHilQeIdCP3yUyIP5wyq8PMHyQV4mxaxyaiyg+QZ
	 5fOSpYU9hlHSVPVq/3HXij8x9xlYI69sTdFWSzoMfEDxsDp8mMbVTzfq3aNJZnEWkZ
	 GhB5Nb4pdGlBlGDbZGwm2/nICqffO4CBqxcd4RCM=
Date: Mon, 19 May 2025 17:27:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
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
Message-ID: <2025051931-hardy-had-44a3@gregkh>
References: <20250514125617.240903002@linuxfoundation.org>
 <861004b4-e036-4306-b129-252b9cb983c7@oracle.com>
 <2025051440-sturdily-dragging-3843@gregkh>
 <9af6afb1-9d91-48ea-a212-bcd6d1a47203@oracle.com>
 <e1ea37bd-ea7d-4e8a-bb2f-6be709eb99f4@roeck-us.net>
 <2025051527-travesty-shape-0e3b@gregkh>
 <20250515152557.a4q2cqab4uvhnpia@desk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250515152557.a4q2cqab4uvhnpia@desk>

On Thu, May 15, 2025 at 08:25:57AM -0700, Pawan Gupta wrote:
> On Thu, May 15, 2025 at 07:35:26AM +0200, Greg Kroah-Hartman wrote:
> > On Wed, May 14, 2025 at 01:49:06PM -0700, Guenter Roeck wrote:
> > > On 5/14/25 13:33, Harshit Mogalapalli wrote:
> > > > Hi Greg,
> > > > 
> > > > On 15/05/25 01:35, Greg Kroah-Hartman wrote:
> > > > > On Thu, May 15, 2025 at 12:29:40AM +0530, Harshit Mogalapalli wrote:
> > > > > > Hi Greg,
> > > > > > On 14/05/25 18:34, Greg Kroah-Hartman wrote:
> > > > > > > This is the start of the stable review cycle for the 6.6.91 release.
> > > > > > > There are 113 patches in this series, all will be posted as a response
> > > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > > let me know.
> > > > > > > 
> > > > > > > Responses should be made by Fri, 16 May 2025 12:55:38 +0000.
> > > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > > ld: vmlinux.o: in function `patch_retpoline':
> > > > > > alternative.c:(.text+0x3b6f1): undefined reference to `module_alloc'
> > > > > > make[2]: *** [scripts/Makefile.vmlinux:37: vmlinux] Error 1
> > > > > > 
> > > > > > We see this build error in 6.6.91-rc2 tag.
> > > > > 
> > > > > What is odd about your .config?  Have a link to it?  I can't duplicate
> > > > > it here on my builds.
> > > > > 
> > > > 
> > > > So this is a config where CONFIG_MODULES is unset(!=y) -- with that we could reproduce it on defconfig + disabling CONFIG_MODULES as well.
> > > > 
> > > 
> > > Key is the combination of CONFIG_MODULES=n with CONFIG_MITIGATION_ITS=y.
> > 
> > Ah, this is due to the change in its_alloc() for 6.6.y and 6.1.y by the
> > call to module_alloc() instead of execmem_alloc() in the backport of
> > 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches").
> 
> Sorry for the trouble. I wish I had a test to catch problems like this. The
> standard config targets defconfig, allyesconfig, allnoconfig, etc. do not
> expose such issues. The only thing that comes close is randconfig.
> 
> CONFIG_MODULES=n is not a common setting, I wonder how people find such
> issues? (trying to figure out how to prevent such issues in future).
> 
> > Pawan, any hints on what should be done here instead?
> 
> Since dynamic thunks are not possible without CONFIG_MODULES, one option is
> to adjust the already in 6.6.91-rc2 patch 9f35e331144a (x86/its: Fix build
> errors when CONFIG_MODULES=n) to also bring the ITS thunk allocation under
> CONFIG_MODULES.
> 
> I am not seeing any issue with below build and boot test:
> 
>   #!/bin/bash -ex
> 
>   ./scripts/config --disable CONFIG_MODULES
>   ./scripts/config --disable CONFIG_MITIGATION_ITS
>   # https://github.com/arighi/virtme-ng
>   vng -b
>   vng -- lscpu
> 
>   # main test
>   ./scripts/config --disable CONFIG_MODULES
>   ./scripts/config --enable CONFIG_MITIGATION_ITS
>   vng -b
>   vng -- lscpu
> 
>   ./scripts/config --enable CONFIG_MODULES
>   ./scripts/config --disable CONFIG_MITIGATION_ITS
>   vng -b
>   vng -- lscpu
> 
>   ./scripts/config --enable CONFIG_MODULES
>   ./scripts/config --enable CONFIG_MITIGATION_ITS
>   vng -b
>   vng -- lscpu
> 
>   echo "PASS"
> 
> Similar change is required for 6.1 and 5.15 as well. 6.12 is fine because
> it uses execmem_alloc().
> 
> --- 8< ---
> From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> Subject: [PATCH 6.6] x86/its: Fix build errors when CONFIG_MODULES=n
> 
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 9f35e33144ae5377d6a8de86dd3bd4d995c6ac65 upstream.
> 
> Fix several build errors when CONFIG_MODULES=n, including the following:
> 
> ../arch/x86/kernel/alternative.c:195:25: error: incomplete definition of type 'struct module'
>   195 |         for (int i = 0; i < mod->its_num_pages; i++) {
> 
>   [ pawan: backport: Bring ITS dynamic thunk code under CONFIG_MODULES ]
> 
> Fixes: 872df34d7c51 ("x86/its: Use dynamic thunks for indirect branches")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Acked-by: Dave Hansen <dave.hansen@intel.com>
> Tested-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  arch/x86/kernel/alternative.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
> index 6085919d3b3e..c6d9a3882ec8 100644
> --- a/arch/x86/kernel/alternative.c
> +++ b/arch/x86/kernel/alternative.c
> @@ -129,6 +129,7 @@ const unsigned char * const x86_nops[ASM_NOP_MAX+1] =
>  
>  #ifdef CONFIG_MITIGATION_ITS
>  
> +#ifdef CONFIG_MODULES
>  static struct module *its_mod;
>  static void *its_page;
>  static unsigned int its_offset;
> @@ -244,7 +245,16 @@ static void *its_allocate_thunk(int reg)
>  	return thunk;
>  }
>  
> -#endif
> +#else /* CONFIG_MODULES */
> +
> +static void *its_allocate_thunk(int reg)
> +{
> +	return NULL;
> +}
> +
> +#endif /* CONFIG_MODULES */
> +
> +#endif /* CONFIG_MITIGATION_ITS */
>  
>  /*
>   * Fill the buffer with a single effective instruction of size @len.
> -- 
> 2.34.1
> 

This looks to still be causing problems, see these two reports of build
problems with the latest 6.1 and 6.6 releases with this commit in it:
	https://lore.kernel.org/r/20250519164717.18738b4e@ncopa-desktop
	https://lore.kernel.org/r/2f1ae598-0339-4e17-8156-03e8525a213d@roeck-us.net

thanks,

greg k-h
