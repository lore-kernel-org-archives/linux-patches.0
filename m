Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B4D818DB20;
	Thu, 19 Jun 2025 04:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750306796; cv=none; b=iFo83t98sf68d19m4XfNwDbvfB6y9regEDopeSbBDESH7kv6NuDblD4bOaDlIXNREaiFEIoinxaAPITv08VsepDmizLcDvai9m6WPi40JSldx09gu6oWsbAro2SrXqhXNczdMA26LqqdlQAUK2PvHwYefGd2n5oAndzn9yYTY4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750306796; c=relaxed/simple;
	bh=a9ggqrpObwdtIrfKwVaF/LF6VA9WOZyLDWaH9jkVu1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XuDCeqmFmKBJK0PvO5fiO9fhUrthrDP9eUcRe4h3ZR2fGJkml4L29Jz1SCP8Iq6mOeWZ1H/B5bT9mTV1vuhZChCxyYMD18jX0VR2Ymm7YTFaE/6TzjjPb/Jzydp3vYBzbadKR2gG/saqMQDMrjyajP5GamzyMIPdPHzZoNR75Ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3HRrakB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3HRrakB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9B1C4CEEA;
	Thu, 19 Jun 2025 04:19:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750306796;
	bh=a9ggqrpObwdtIrfKwVaF/LF6VA9WOZyLDWaH9jkVu1E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A3HRrakBvuWxgvKb0YUerydvdMum3gbzzQhEgz1mPObyTOPaV94X4/qY0NaaFTM7k
	 5ZkVXrgflvY1FW66q115LL5uu1QO4sFwXmbArDYDbdXh7WPzfCw/NJJ7w85pGQe4ac
	 /nOWNJXF1n3WIfNdV1CghXcMmDmn3keh7niHq/QI=
Date: Thu, 19 Jun 2025 06:19:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025061949-epilepsy-punk-fb4e@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <cc048abb-fbc0-4a79-b78a-90bfa3f8446d@sirena.org.uk>
 <2025061858-reproduce-revolving-cae0@gregkh>
 <1081af30-1273-4a9a-a864-f59f1cb54fd1@t-8ch.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1081af30-1273-4a9a-a864-f59f1cb54fd1@t-8ch.de>

On Wed, Jun 18, 2025 at 04:15:09PM +0200, Thomas Weißschuh wrote:
> On 2025-06-18 15:19:11+0200, Greg Kroah-Hartman wrote:
> > On Wed, Jun 18, 2025 at 12:58:00PM +0100, Mark Brown wrote:
> > > On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.15.3 release.
> > > > There are 780 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > This breaks the build of the arm64 selftests due to a change in nolibc,
> > > it appears that "tools/nolibc: properly align dirent buffer" is missing
> > > some dependency:
> > > 
> > > aarch64-linux-gnu-gcc -fno-asynchronous-unwind-tables -fno-ident -s -Os -nostdlib \
> > > 	-include ../../../../include/nolibc/nolibc.h -I../..\
> > > 	-static -ffreestanding -Wall za-fork.c /build/stage/build-work/kselftest/arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> > > In file included from ./../../../../include/nolibc/nolibc.h:107,
> > >                  from <command-line>:
> > > ./../../../../include/nolibc/dirent.h: In function ‘readdir_r’:
> > > ./../../../../include/nolibc/dirent.h:62:64: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__nolibc_aligned_as’
> > >    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
> > >       |                                                                ^~~~~~~~~~~~~~~~~~~
> > > ./../../../../include/nolibc/dirent.h:62:64: error: implicit declaration of function ‘__nolibc_aligned_as’ [-Wimplicit-function-declaration]
> > > ./../../../../include/nolibc/dirent.h:62:84: error: expected expression before ‘struct’
> > >    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
> > >       |                                                                                    ^~~~~~
> > > ./../../../../include/nolibc/dirent.h:63:47: error: ‘buf’ undeclared (first use in this function)
> > >    63 |         struct linux_dirent64 *ldir = (void *)buf;
> > >       |                                               ^~~
> > > ./../../../../include/nolibc/dirent.h:63:47: note: each undeclared identifier is reported only once for each function it appears in
> > 
> > Thanks for the report, I'll go drop all nolibc patches from the queues
> > for now.
> 
> Thanks.
> 
> Shouldn't the bots apply prerequisite patches from the series automatically?

Hopefully yes, obviously it doesn't always work :)

> This patch comes from [0] and the prerequisite is in there.
> 
> Also all nolibc patches which should go to stable are tagged as such.
> Can you configure the bots not to pick up any nolibc patches automatically?

Yes we can!  I will add the needed regex to the file:
	https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list
should it be:
	tools/include/nolibc/*
	tools/testing/selftests/nolibc/*
?

thanks,

greg k-h
