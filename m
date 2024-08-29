Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF221917C6;
	Thu, 29 Aug 2024 14:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724941420; cv=none; b=dJeZLwF1otz+0xm9d0LIbT6Es+yf3lorzHcVHZTesCEU1QEvTBAuTahQQEI+7U6xKtfOujiL88cJ2Nt/jlEp1h+QybvPS4rJpKe291yP7fJ0ucbCqUKcoAXXTZnm2yMz9lvjM/vhypXErcn+vdxulKfXiznwsCQDQdLFVbtP0AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724941420; c=relaxed/simple;
	bh=L7kOUyhtroHOG+jfX2l3pQ2YuW7zkoYziytOguA1iHA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q4i366J6fS85AMhNAyhdZ9NTnBZdspQGSCKjq6EcZ2uqyLUJcxPhO18fBiIxcE7Lpm0f5qfdWze0EZiY2QR81qyBUeT9ruLTImMy0gGuwtMmq8UlWwaRq3C5ONxZ8nClQAR7uOmlnq/LNlak0gtvAqqDgtm9dIa3fH4E486VZds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVMr5GjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVMr5GjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF93BC4CEC8;
	Thu, 29 Aug 2024 14:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724941419;
	bh=L7kOUyhtroHOG+jfX2l3pQ2YuW7zkoYziytOguA1iHA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZVMr5GjPkfSGZTOHT3LENBa14KrRbdXxICQRXZsPvEhZTZOXF1Md1t+IdbK4iH8qH
	 1eDO+S/6is3b2V9SMncM9Y41HZvQ6tXTLL2xzkyXGigV96lkhL8/CttDemP0r4GHgS
	 xxm5QWYnJAKBadpoXB7F3WfXbhhjI+fQhMqJodTk=
Date: Thu, 29 Aug 2024 16:23:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Message-ID: <2024082958-manpower-poise-4459@gregkh>
References: <20240827143843.399359062@linuxfoundation.org>
 <ffd773a0-d71c-4647-b7de-b22a008849ab@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ffd773a0-d71c-4647-b7de-b22a008849ab@gmail.com>

On Tue, Aug 27, 2024 at 10:47:53AM -0700, Florian Fainelli wrote:
> On 8/27/24 07:33, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.48 release.
> > There are 341 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Same problem as with the 6.1-rc, perf fails to build with:
> 
> In file included from ./util/header.h:10,
>                  from pmu-events/pmu-events.c:9:
> ../include/linux/bitmap.h: In function 'bitmap_zero':
> ../include/linux/bitmap.h:28:34: warning: implicit declaration of function
> 'ALIGN' [-Wimplicit-function-declaration]
>    28 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) /
> BITS_PER_BYTE)
>       |                                  ^~~~~
> ../include/linux/bitmap.h:35:32: note: in expansion of macro 'bitmap_size'
>    35 |                 memset(dst, 0, bitmap_size(nbits));
>       |                                ^~~~~~~~~~~
>   LD /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/pmu-events/pmu-events-in.o
>   LINK
> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf
> /local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o:
> in function `record__mmap_read_evlist':
> builtin-record.c:(.text+0x13578): undefined reference to `ALIGN'
> /local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o:
> in function `record__init_thread_masks_spec.constprop.0':
> builtin-record.c:(.text+0x13b10): undefined reference to `ALIGN'
> /local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld:
> builtin-record.c:(.text+0x13b68): undefined reference to `ALIGN'
> /local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld:
> builtin-record.c:(.text+0x13b9c): undefined reference to `ALIGN'
> /local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld:
> builtin-record.c:(.text+0x13bd8): undefined reference to `ALIGN'
> /local/stbopt_p/toolchains_303/stbgcc-12.3-1.0/bin/../lib/gcc/arm-unknown-linux-gnueabihf/12.3.0/../../../../arm-unknown-linux-gnueabihf/bin/ld: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf-in.o:builtin-record.c:(.text+0x13c14):
> more undefined references to `ALIGN' follow
> collect2: error: ld returned 1 exit status
> make[4]: *** [Makefile.perf:672: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/perf]
> Error 1
> make[3]: *** [Makefile.perf:242: sub-make] Error 2
> make[2]: *** [Makefile:70: all] Error 2
> make[1]: *** [package/pkg-generic.mk:294:
> /local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built]
> Error 2
> make: *** [Makefile:29: _all] Error 2

I think I've fixed this up now, but wow, I can't build perf at all for
6.6.y or 6.1.y.  So this might have been broken for a while?  Hopefully
people are just using perf from the latest kernel release anyway...

thanks,

greg k-h
