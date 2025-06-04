Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFF9248864;
	Wed,  4 Jun 2025 08:06:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749024364; cv=none; b=QJ+lmsvnDYiudHlAwxblmZlbaW+1g1ly0Dmyr8EtwlqI7SadmVXbao8uRx+BmmMkbMcvBV2JeGimTj+GlcU2ArlqKlX+1r9otyDa4k18iOFObzrTUqzUYsEDbiHTcUwizDRvPayzYb5prx7TT8XUaqGhrqJ4iZLEeUsvREAVmLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749024364; c=relaxed/simple;
	bh=xS1R11uzqC459r4QjcDRxMAKoX1+B/CSgK8i1N/RzdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gMQKoBjrzldlTTNI3qi4Dc4zIlR2c7OZR9BHlkpcTe8hsHaNjj9aiY34ui+z7DsBe0NsUYVwH5xiLAdCJ+IokLcIf4o1PgVUyhlyvWwed/xbGLMeWX4b379heAt07s1yP+wOWp3Jj7fBfY/eHoH0VKqDylA50kUfeTnX7InuYXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=plwalYed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="plwalYed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4B2C4CEE7;
	Wed,  4 Jun 2025 08:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749024364;
	bh=xS1R11uzqC459r4QjcDRxMAKoX1+B/CSgK8i1N/RzdQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=plwalYed/vw6S10JNziXcVRYzG+GcprKkD0Ewu81fv0WFUZkYJL0DkZhLx/mUJkvN
	 chQyNlvv0q7nF5+Xqjx1hEzg4FcKMytpRvjcOY/CzXPabFjDczpGI4U0JYtW+iuy/z
	 iJPkHOEmuj8iSyu+DvOawYRc0us2mw1Gl++kTOv4=
Date: Wed, 4 Jun 2025 10:06:01 +0200
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
Message-ID: <2025060412-cursor-navigate-126d@gregkh>
References: <20250602134307.195171844@linuxfoundation.org>
 <4c608184-5a64-4814-a70a-d2395662d437@gmail.com>
 <52e321d9-2695-4677-b8bf-4be99fc0d681@gmail.com>
 <2025060344-kiwi-anagram-fc9e@gregkh>
 <b60e753c-eb13-46af-9365-1b33ae2e7859@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b60e753c-eb13-46af-9365-1b33ae2e7859@gmail.com>

On Tue, Jun 03, 2025 at 09:00:58AM -0700, Florian Fainelli wrote:
> On 6/3/25 00:58, Greg Kroah-Hartman wrote:
> > On Mon, Jun 02, 2025 at 09:50:24AM -0700, Florian Fainelli wrote:
> > > On 6/2/25 09:49, Florian Fainelli wrote:
> > > > On 6/2/25 06:44, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.10.238 release.
> > > > > There are 270 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > >      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/
> > > > > patch-5.10.238-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-
> > > > > rc.git linux-5.10.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > 
> > > > On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> > > > BMIPS_GENERIC:
> > > > 
> > > > Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> > > > 
> > > > Similar build warning as reported for 5.4, due to the same commit:
> > > > 
> > > > commit b47e6abc7dc5772ecb45383d9956f9fcb7fdf33c
> > > > Author: Jeongjun Park <aha310510@gmail.com>
> > > > Date:   Tue Apr 22 20:30:25 2025 +0900
> > > > 
> > > >       tracing: Fix oob write in trace_seq_to_buffer()
> > > > 
> > > >       commit f5178c41bb43444a6008150fe6094497135d07cb upstream.
> > > > 
> > > > In file included from ./include/linux/kernel.h:15,
> > > >                    from ./include/asm-generic/bug.h:20,
> > > >                    from ./arch/arm/include/asm/bug.h:60,
> > > >                    from ./include/linux/bug.h:5,
> > > >                    from ./include/linux/mmdebug.h:5,
> > > >                    from ./include/linux/mm.h:9,
> > > >                    from ./include/linux/ring_buffer.h:5,
> > > >                    from kernel/trace/trace.c:15:
> > > > kernel/trace/trace.c: In function 'tracing_splice_read_pipe':
> > > > ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
> > > > types lacks a cast
> > > >      20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> > > >         |                                   ^~
> > > > ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
> > > >      26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
> > > >         |                  ^~~~~~~~~~~
> > > > ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
> > > >      36 |         __builtin_choose_expr(__safe_cmp(x, y), \
> > > >         |                               ^~~~~~~~~~
> > > > ./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
> > > >      45 | #define min(x, y)       __careful_cmp(x, y, <)
> > > >         |                         ^~~~~~~~~~~~~
> > > > kernel/trace/trace.c:6688:43: note: in expansion of macro 'min'
> > > >    6688 | min((size_t)trace_seq_used(&iter->seq),
> > > >         |                                           ^~~
> > > > 
> > > 
> > > And also this one:
> > > 
> > > commit e0a3a33cecd3ce2fde1de4ff0e223dc1db484a8d
> > > Author: Eric Dumazet <edumazet@google.com>
> > > Date:   Wed Mar 5 13:05:50 2025 +0000
> > > 
> > >      tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()
> > > 
> > >      [ Upstream commit f8ece40786c9342249aa0a1b55e148ee23b2a746 ]
> > > 
> > > 
> > > on ARM64:
> > > 
> > > In file included from ./include/linux/kernel.h:15,
> > >                   from ./include/linux/list.h:9,
> > >                   from ./include/linux/module.h:12,
> > >                   from net/ipv4/inet_hashtables.c:12:
> > > net/ipv4/inet_hashtables.c: In function 'inet_ehash_locks_alloc':
> > > ./include/linux/minmax.h:20:35: warning: comparison of distinct pointer
> > > types lacks a cast
> > >     20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
> > >        |                                   ^~
> > > ./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
> > >     26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
> > >        |                  ^~~~~~~~~~~
> > > ./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
> > >     36 |         __builtin_choose_expr(__safe_cmp(x, y), \
> > >        |                               ^~~~~~~~~~
> > > ./include/linux/minmax.h:52:25: note: in expansion of macro '__careful_cmp'
> > >     52 | #define max(x, y)       __careful_cmp(x, y, >)
> > >        |                         ^~~~~~~~~~~~~
> > > net/ipv4/inet_hashtables.c:946:19: note: in expansion of macro 'max'
> > >    946 |         nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE /
> > > locksz);
> > >        |                   ^~~
> > > 
> > 
> > For both of these, I'll just let them be as they are ok, it's just the
> > mess of our min/max macro unwinding causes these issues.
> > 
> > Unless they really bother someone, and in that case, a patch to add the
> > correct type to the backport to make the noise go away would be greatly
> > appreciated.
> 
> Yeah that's a reasonable resolution, I will try to track down the missing
> patches for minmax.h so we are warning free for the stable kernels.

I tried in the past, it's non-trivial.  What would be easier is to just
properly cast the variables in the places where this warning is showing
up to get rid of that warning.  We've done that in some backports in the
past as well.

good luck!

greg k-h
