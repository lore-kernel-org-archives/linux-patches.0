Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495262EAB81
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 14:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750256113; cv=none; b=aQeuiRJxR4nZU+A1Clg58rX0SQv1wDY1ieN2Hs3p1o+vfsWvztlIhBkqtLFH6+6+XI6Nq1/wLfIO5u+a3behQ8BQfuNmPTm/J8Ejzq52u8+RhBJ9EVISLYbPW6+pdLkjZPtoDMT0zvxrgttZ3lErnpRg5wqqn19OgunnuB8pbj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750256113; c=relaxed/simple;
	bh=EKTviWYqLv1yK2WFaMCAtqpkvPv1cokIZ4A5bpwZ5C8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M9opGkORw1NsNdA+wzJ4GA+Fj8viKnInOlXpoMr6bbTpuEVPCUoE1Ix5NGaO/H/SL71sHYAS6txqk83RXEgVqQGw1s2K1xbIzgl+M2wioqGPhroEno5kxNDPfVuf6c6zb3fLTdXXQ8CW1ikkQaJbvwU2GvF/XamIxXd4/D/W/AA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=R6eKWMt0; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="R6eKWMt0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1750256110;
	bh=EKTviWYqLv1yK2WFaMCAtqpkvPv1cokIZ4A5bpwZ5C8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R6eKWMt09qQIp/guJ1Mv/MBoou/bNRlTC0Lve0JDxB6N5E0UwBMbi+Pe5dh+f2M/L
	 jWaYyw/CYzgBkoIR6RbxWHvYRcxulhlOxqEKWGoJisPuCKy1ihDx3Irgiu8I6ahhEo
	 qSNV6LJ/pHB4/jTC+lW5200F4EXJgZKZb+sk6pnA=
Date: Wed, 18 Jun 2025 16:15:09 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <1081af30-1273-4a9a-a864-f59f1cb54fd1@t-8ch.de>
References: <20250617152451.485330293@linuxfoundation.org>
 <cc048abb-fbc0-4a79-b78a-90bfa3f8446d@sirena.org.uk>
 <2025061858-reproduce-revolving-cae0@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025061858-reproduce-revolving-cae0@gregkh>

On 2025-06-18 15:19:11+0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 18, 2025 at 12:58:00PM +0100, Mark Brown wrote:
> > On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.15.3 release.
> > > There are 780 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > This breaks the build of the arm64 selftests due to a change in nolibc,
> > it appears that "tools/nolibc: properly align dirent buffer" is missing
> > some dependency:
> > 
> > aarch64-linux-gnu-gcc -fno-asynchronous-unwind-tables -fno-ident -s -Os -nostdlib \
> > 	-include ../../../../include/nolibc/nolibc.h -I../..\
> > 	-static -ffreestanding -Wall za-fork.c /build/stage/build-work/kselftest/arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> > In file included from ./../../../../include/nolibc/nolibc.h:107,
> >                  from <command-line>:
> > ./../../../../include/nolibc/dirent.h: In function ‘readdir_r’:
> > ./../../../../include/nolibc/dirent.h:62:64: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__nolibc_aligned_as’
> >    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
> >       |                                                                ^~~~~~~~~~~~~~~~~~~
> > ./../../../../include/nolibc/dirent.h:62:64: error: implicit declaration of function ‘__nolibc_aligned_as’ [-Wimplicit-function-declaration]
> > ./../../../../include/nolibc/dirent.h:62:84: error: expected expression before ‘struct’
> >    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
> >       |                                                                                    ^~~~~~
> > ./../../../../include/nolibc/dirent.h:63:47: error: ‘buf’ undeclared (first use in this function)
> >    63 |         struct linux_dirent64 *ldir = (void *)buf;
> >       |                                               ^~~
> > ./../../../../include/nolibc/dirent.h:63:47: note: each undeclared identifier is reported only once for each function it appears in
> 
> Thanks for the report, I'll go drop all nolibc patches from the queues
> for now.

Thanks.

Shouldn't the bots apply prerequisite patches from the series automatically?
This patch comes from [0] and the prerequisite is in there.

Also all nolibc patches which should go to stable are tagged as such.
Can you configure the bots not to pick up any nolibc patches automatically?

[0] https://lore.kernel.org/lkml/20250419-nolibc-ubsan-v2-0-060b8a016917@weissschuh.net/


Thomas
