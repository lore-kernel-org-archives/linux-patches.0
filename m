Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2946156E8;
	Fri,  1 Dec 2023 08:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CwbBr27Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53D4C433C7;
	Fri,  1 Dec 2023 08:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701418895;
	bh=OKS0JCKamFhmCor3B2OdSqntV8C4c+PuG2UIpJdXH4E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CwbBr27QancFl5SsDiCAeqK0h6GIfpWctB8vnWdJIy6hcQdTxmXb1JoEFE1QfOs1s
	 7QThHtLTafWNjb1+IEqP/mB4zEeYcTlZxQWqpTWmYeYVw/vz2w6nc2vCOltLb9ajzj
	 1jhSucoNJGyhddFVbKQ5u1axO3gtoZlsQGUFmy/4=
Date: Fri, 1 Dec 2023 08:21:33 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: flaniel@linux.microsoft.com,
	Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, Guenter Roeck <linux@roeck-us.net>,
	flaniel@linux.microsoft.com
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
Message-ID: <2023120134-sabotage-handset-0b0d@gregkh>
References: <20231130162133.035359406@linuxfoundation.org>
 <CAEUSe7-yhmQkr1iK-82+Sc_YpVtWUQhuKoazoXHF_3oP9XTt4Q@mail.gmail.com>
 <e2e50813-79ba-4c84-b6ae-6885cbef54ab@roeck-us.net>
 <CAEUSe78tYPTFuauB7cxZzvAeMhzB_25Q8DqLUfF7Nro9WsUhNw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe78tYPTFuauB7cxZzvAeMhzB_25Q8DqLUfF7Nro9WsUhNw@mail.gmail.com>

On Thu, Nov 30, 2023 at 12:11:31PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 30 Nov 2023 at 11:44, Guenter Roeck <linux@roeck-us.net> wrote:
> > On 11/30/23 09:21, Daniel Díaz wrote:
> > > Hello!
> > >
> > > Lots of failures everywhere:
> > > * clang-17-lkftconfig                 arm64
> > > * clang-17-lkftconfig                 arm64
> > > * clang-17-lkftconfig                 arm64
> > > * clang-lkftconfig                    arm64
> > > * clang-lkftconfig                    arm
> > > * clang-lkftconfig                    i386
> > > * clang-lkftconfig                    x86_64
> > > * gcc-12-lkftconfig                   arm64
> > > * gcc-12-lkftconfig                   arm
> > > * gcc-12-lkftconfig                   i386
> > > * gcc-12-lkftconfig                   x86_64
> > > * gcc-12-lkftconfig-64k_page_size     arm64
> > > * gcc-12-lkftconfig-64k_page_size     arm64
> > > * gcc-12-lkftconfig-armv8_features    arm64
> > > * gcc-12-lkftconfig-debug             arm64
> > > * gcc-12-lkftconfig-debug             arm64
> > > * gcc-12-lkftconfig-debug             arm
> > > * gcc-12-lkftconfig-debug             i386
> > > * gcc-12-lkftconfig-debug             x86_64
> > > * gcc-12-lkftconfig-debug-kmemleak    arm64
> > > * gcc-12-lkftconfig-debug-kmemleak    arm
> > > * gcc-12-lkftconfig-debug-kmemleak    i386
> > > * gcc-12-lkftconfig-debug-kmemleak    x86_64
> > > * gcc-12-lkftconfig-devicetree        arm64
> > > * gcc-12-lkftconfig-kasan             arm64
> > > * gcc-12-lkftconfig-kasan             arm64
> > > * gcc-12-lkftconfig-kasan             x86_64
> > > * gcc-12-lkftconfig-kselftest         arm64
> > > * gcc-12-lkftconfig-kselftest-kernel  arm64
> > > * gcc-12-lkftconfig-kselftest-kernel  arm
> > > * gcc-12-lkftconfig-kselftest-kernel  i386
> > > * gcc-12-lkftconfig-kunit             arm64
> > > * gcc-12-lkftconfig-kunit             arm64
> > > * gcc-12-lkftconfig-kunit             arm
> > > * gcc-12-lkftconfig-kunit             i386
> > > * gcc-12-lkftconfig-kunit             x86_64
> > > * gcc-12-lkftconfig-libgpiod          arm64
> > > * gcc-12-lkftconfig-libgpiod          arm
> > > * gcc-12-lkftconfig-libgpiod          i386
> > > * gcc-12-lkftconfig-libgpiod          x86_64
> > > * gcc-12-lkftconfig-perf              arm64
> > > * gcc-12-lkftconfig-perf-kernel       arm64
> > > * gcc-12-lkftconfig-perf-kernel       arm
> > > * gcc-12-lkftconfig-perf-kernel       i386
> > > * gcc-12-lkftconfig-perf-kernel       x86_64
> > > * gcc-12-lkftconfig-rcutorture        arm64
> > > * gcc-12-lkftconfig-rcutorture        arm64
> > > * gcc-12-lkftconfig-rcutorture        arm
> > > * gcc-12-lkftconfig-rcutorture        i386
> > > * gcc-12-lkftconfig-rcutorture        x86_64
> > >
> > > It's essentially this:
> > >
> > > -----8<-----
> > >    make --silent --keep-going --jobs=8
> > > O=/home/tuxbuild/.cache/tuxmake/builds/1/build ARCH=x86_64 SRCARCH=x86
> > > CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc'
> > > 'HOSTCC=sccache gcc'
> > >    arch/x86/kernel/smp.o: warning: objtool: sysvec_reboot()+0x51:
> > > unreachable instruction
> > >    x86_64-linux-gnu-ld: kernel/trace/trace_kprobe.o: in function
> > > `__trace_kprobe_create':
> > >    trace_kprobe.c:(.text+0x2f39): undefined reference to
> > > `kallsyms_on_each_symbol'
> > >    x86_64-linux-gnu-ld: kernel/trace/trace_kprobe.o: in function
> > > `create_local_trace_kprobe':
> > >    trace_kprobe.c:(.text+0x384b): undefined reference to
> > > `kallsyms_on_each_symbol'
> > >    make[1]: *** [/builds/linux/Makefile:1227: vmlinux] Error 1
> > >    make[1]: Target '__all' not remade because of errors.
> > >    make: *** [Makefile:226: __sub-make] Error 2
> > >    make: Target '__all' not remade because of errors.
> > > ----->8-----
> > >
> > > It only affects 5.15. Bisection in progress.
> >
> > I guess it will point to
> >
> > >> Francis Laniel <flaniel@linux.microsoft.com>
> > >>      tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols
> 
> It sure did!:
> 
>   commit 7b4375c36a4c0e1b4b97ccbcdd427db5a460e04f
>   Author: Francis Laniel <flaniel@linux.microsoft.com>
>   Date:   Fri Oct 20 13:42:49 2023 +0300
> 
>       tracing/kprobes: Return EADDRNOTAVAIL when func matches several symbols
> 
>       commit b022f0c7e404887a7c5229788fc99eff9f9a80d5 upstream.
> 
> Reverting that commit made the build pass again.

{sigh}

Francis, I think this is the second or third time this has happened with
the attempt to get this patch merged.  I'm going to go drop it from all
of the pending stable queues again, and please, if you wish to have it
applied in the future, I am going to have to see some proof it was
actually tested on the architectures that it keeps breaking.

thanks,

greg k-h
