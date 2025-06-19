Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EA51D555
	for <patches@lists.linux.dev>; Thu, 19 Jun 2025 05:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750312249; cv=none; b=S/kCFjgowl3ZxH8Nn63plp3xNH8RuHaj7L0wXjrEP6PZf1zdosMhWAWbCWLCMCHkzOxg6/8WtGgADdO3xe/LspkiK4b8VsCEWNSGoz31EIe0qzIkIgRxeWsdCQqTcK08nIocOlIV0ecYxCNSnZC1/yEqFhjEugJAogkiDUBmWuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750312249; c=relaxed/simple;
	bh=KXm6uCC5yRgIomOYTQC5Qq/VKBar4sWaDZWjrk7jhtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCZTO86Imju6nbf8UTCPjpPkssZPg2XytdtrJ2qLyNBFu/zJrSVgzs0I+MRh5C4r89aYBWxwALnhmyxwIQIEG6lpvz85MTmBif2Y5L+5Ld1AeNND/8x7YOe9jZlgMqbUjQ1bYhmj6qtd2HSWU7H876I/GYaLCdiIJ7QTo6zGAoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=B59Ex9gw; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="B59Ex9gw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1750312245;
	bh=KXm6uCC5yRgIomOYTQC5Qq/VKBar4sWaDZWjrk7jhtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=B59Ex9gwa1HHxtit1YjeiXIkCmyjPaTczWB7G2MaExt71yiLGmvdDmHUT6lTkX1iC
	 toYl5NqVA4dseFvIDZkpxscxGX57I2EHfP8wP+hG4nIDT3LO9kyxC20Nn2qQVCAdHs
	 QHx3hNH3kNBm1lDg/Ht5RS2fD9SXz3OlPjLS/eR8=
Date: Thu, 19 Jun 2025 07:50:43 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <a757c5d9-06f4-4ed0-9de9-08edbd16134a@t-8ch.de>
References: <20250617152451.485330293@linuxfoundation.org>
 <cc048abb-fbc0-4a79-b78a-90bfa3f8446d@sirena.org.uk>
 <2025061858-reproduce-revolving-cae0@gregkh>
 <1081af30-1273-4a9a-a864-f59f1cb54fd1@t-8ch.de>
 <2025061949-epilepsy-punk-fb4e@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2025061949-epilepsy-punk-fb4e@gregkh>

On 2025-06-19 06:19:52+0200, Greg Kroah-Hartman wrote:
> On Wed, Jun 18, 2025 at 04:15:09PM +0200, Thomas Weißschuh wrote:
> > On 2025-06-18 15:19:11+0200, Greg Kroah-Hartman wrote:
> > > On Wed, Jun 18, 2025 at 12:58:00PM +0100, Mark Brown wrote:
> > > > On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.15.3 release.
> > > > > There are 780 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > 
> > > > This breaks the build of the arm64 selftests due to a change in nolibc,
> > > > it appears that "tools/nolibc: properly align dirent buffer" is missing
> > > > some dependency:
> > > > 
> > > > aarch64-linux-gnu-gcc -fno-asynchronous-unwind-tables -fno-ident -s -Os -nostdlib \
> > > > 	-include ../../../../include/nolibc/nolibc.h -I../..\
> > > > 	-static -ffreestanding -Wall za-fork.c /build/stage/build-work/kselftest/arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> > > > In file included from ./../../../../include/nolibc/nolibc.h:107,
> > > >                  from <command-line>:
> > > > ./../../../../include/nolibc/dirent.h: In function ‘readdir_r’:
> > > > ./../../../../include/nolibc/dirent.h:62:64: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__nolibc_aligned_as’
> > > >    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
> > > >       |                                                                ^~~~~~~~~~~~~~~~~~~
> > > > ./../../../../include/nolibc/dirent.h:62:64: error: implicit declaration of function ‘__nolibc_aligned_as’ [-Wimplicit-function-declaration]
> > > > ./../../../../include/nolibc/dirent.h:62:84: error: expected expression before ‘struct’
> > > >    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
> > > >       |                                                                                    ^~~~~~
> > > > ./../../../../include/nolibc/dirent.h:63:47: error: ‘buf’ undeclared (first use in this function)
> > > >    63 |         struct linux_dirent64 *ldir = (void *)buf;
> > > >       |                                               ^~~
> > > > ./../../../../include/nolibc/dirent.h:63:47: note: each undeclared identifier is reported only once for each function it appears in
> > > 
> > > Thanks for the report, I'll go drop all nolibc patches from the queues
> > > for now.
> > 
> > Thanks.
> > 
> > Shouldn't the bots apply prerequisite patches from the series automatically?
> 
> Hopefully yes, obviously it doesn't always work :)

Is there something we can do to help the tools?

> > This patch comes from [0] and the prerequisite is in there.
> > 
> > Also all nolibc patches which should go to stable are tagged as such.
> > Can you configure the bots not to pick up any nolibc patches automatically?
> 
> Yes we can!  I will add the needed regex to the file:
> 	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list
> should it be:
> 	tools/include/nolibc/*
> 	tools/testing/selftests/nolibc/*
> ?

Looks good, thanks.


Thomas
