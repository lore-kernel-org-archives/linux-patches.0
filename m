Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB73281525;
	Tue,  3 Jun 2025 09:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942460; cv=none; b=nqdY0UkTrBJbm/wZ0SiJaFpPcxuVusg11JB78JqpyrofDcHGFgXBpMbmz0xFuTShJKLQv5Qtt6fwHTWhgf4uffLfAkG+C7kQv7bL/cJ2GoacxDotR2fYJEaSXKu6eG9zuo8aUwspi3qV63atJYHxyy8HpLTw7ODUy820HbTGQFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942460; c=relaxed/simple;
	bh=5Q2I59NE9+CY7+YJCg/Hc9K/P5/Ft8Q5YrHc4Tp+YtA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WCzdjdJX+CcyXjiqQeWA/743rOiynuLmp4GFNMj0lpmymuS2aDt80Vi7pE9rrcHjeUvkITyhP0A0gaUdIyhjf+TqXRgQLGIiPOqcGOJfjJo4F/HWp6SWvF/WlrYzee1WP92lDfKgYLANyDNR5H7TaG+fJh0x2hNCBBtwzq74Tbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EbUNfneh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EbUNfneh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03DAC4CEED;
	Tue,  3 Jun 2025 09:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748942459;
	bh=5Q2I59NE9+CY7+YJCg/Hc9K/P5/Ft8Q5YrHc4Tp+YtA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EbUNfneh0eKJSArmtyIOrZoX72K5gEw9TRmhOrkDGs65ptVd3gHiBEfKgYNLLAfOE
	 tV1ZvvWDFYhQuCfmiLa2z9oecIUNUFhhJ51NLRbis9RYTSOlNPEBy2LV923PnPfIHk
	 Nf3JguQnUrZNtQHRWBcV9Ai49nhTCv0wxGT3dNbg=
Date: Tue, 3 Jun 2025 09:58:53 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <2025060344-kiwi-anagram-fc9e@gregkh>
References: <20250602134307.195171844@linuxfoundation.org>
 <4c608184-5a64-4814-a70a-d2395662d437@gmail.com>
 <52e321d9-2695-4677-b8bf-4be99fc0d681@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <52e321d9-2695-4677-b8bf-4be99fc0d681@gmail.com>

On Mon, Jun 02, 2025 at 09:50:24AM -0700, Florian Fainelli wrote:
> On 6/2/25 09:49, Florian Fainelli wrote:
> > On 6/2/25 06:44, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.238 release.
> > > There are 270 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
> > > patch-5.10.238-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> > > rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> > BMIPS_GENERIC:
> > 
> > Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> > 
> > Similar build warning as reported for 5.4, due to the same commit:
> > 
> > commit b47e6abc7dc5772ecb45383d9956f9fcb7fdf33c
> > Author: Jeongjun Park <aha310510@gmail.com>
> > Date:   Tue Apr 22 20:30:25 2025 +0900
> > 
> >      tracing: Fix oob write in trace_seq_to_buffer()
> > 
> >      commit f5178c41bb43444a6008150fe6094497135d07cb upstream.
> > 
> > In file included from ./include/linux/kernel.h:15,
> >                   from ./include/asm-generic/bug.h:20,
> >                   from ./arch/arm/include/asm/bug.h:60,
> >                   from ./include/linux/bug.h:5,
> >                   from ./include/linux/mmdebug.h:5,
> >                   from ./include/linux/mm.h:9,
> >                   from ./include/linux/ring_buffer.h:5,
> >                   from kernel/trace/trace.c:15:
> > kernel/trace/trace.c: In function 'tracing_splice_read_pipe':
> > ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
> > types lacks a cast
> >     20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> >        |                                   ^~
> > ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
> >     26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
> >        |                  ^~~~~~~~~~~
> > ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
> >     36 |         __builtin_choose_expr(__safe_cmp(x, y), \
> >        |                               ^~~~~~~~~~
> > ./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
> >     45 | #define min(x, y)       __careful_cmp(x, y, <)
> >        |                         ^~~~~~~~~~~~~
> > kernel/trace/trace.c:6688:43: note: in expansion of macro 'min'
> >   6688 | min((size_t)trace_seq_used(&iter->seq),
> >        |                                           ^~~
> > 
> 
> And also this one:
> 
> commit e0a3a33cecd3ce2fde1de4ff0e223dc1db484a8d
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Mar 5 13:05:50 2025 +0000
> 
>     tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()
> 
>     [ Upstream commit f8ece40786c9342249aa0a1b55e148ee23b2a746 ]
> 
> 
> on ARM64:
> 
> In file included from ./include/linux/kernel.h:15,
>                  from ./include/linux/list.h:9,
>                  from ./include/linux/module.h:12,
>                  from net/ipv4/inet_hashtables.c:12:
> net/ipv4/inet_hashtables.c: In function 'inet_ehash_locks_alloc':
> ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
> types lacks a cast
>    20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
>       |                                   ^~
> ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
>    26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
>       |                  ^~~~~~~~~~~
> ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
>    36 |         __builtin_choose_expr(__safe_cmp(x, y), \
>       |                               ^~~~~~~~~~
> ./include/linux/minmax.h:52:25: note: in expansion of macro '__careful_cmp'
>    52 | #define max(x, y)       __careful_cmp(x, y, >)
>       |                         ^~~~~~~~~~~~~
> net/ipv4/inet_hashtables.c:946:19: note: in expansion of macro 'max'
>   946 |         nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE /
> locksz);
>       |                   ^~~
> 

For both of these, I'll just let them be as they are ok, it's just the
mess of our min/max macro unwinding causes these issues.

Unless they really bother someone, and in that case, a patch to add the
correct type to the backport to make the noise go away would be greatly
appreciated.

thanks,

greg k-h
