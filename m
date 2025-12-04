Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714FE2EFDB2;
	Thu,  4 Dec 2025 16:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764865909; cv=none; b=Nfy2ZMWBje1gL4rJdr2SktqThSejVGLALDd3aiYZJ3D6jQgn0KEkbE1dRr6Yrqt3uTWes4Cgdh/StdiuCpdQNpGGrQfkULUMybtU2dZa4sXbDj+n1ZhYKwoZPUne28prsSSsJh8FRTBJOC9CK2ana2SpJHN7gEjjAEf1GNQ9cWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764865909; c=relaxed/simple;
	bh=GOkqapzzkxNpdpqm/Ka07TqgfQZHg71mJlB6JztUjHg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RyvjsXG75M65Fib9xU5hRqgt4Ju30pfSNjpbMQxUy+Jw3siNo9FXuxOMxs8YswUXK1lyu9qCv+YpuQijrc3a6HTbQu/yBvis1lybNiWlJPxAge6lfzaLH8VwrklrGnqi5tlHPvSspYTNdjOy2BE8CGGYGkJnGFH0Dv/YKmuipAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoBj5sQU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoBj5sQU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D5E7C4CEFB;
	Thu,  4 Dec 2025 16:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764865908;
	bh=GOkqapzzkxNpdpqm/Ka07TqgfQZHg71mJlB6JztUjHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AoBj5sQUsxpFI37S73Qn0E41TF/xOR/spMaYX2TKg7PIOMmqYVgbL/v1CEXsPXj3n
	 G5BDyp8OaEEx0wKTSv5+PfpEUPOg1pHS9JweuJrXY3zol0TaSansITbKZ+sSFZvT1J
	 WyOuPvmNW3qoyfNDbci7VG7Nds6xSp2baLhw+iJw=
Date: Thu, 4 Dec 2025 17:31:45 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/392] 5.15.197-rc1 review
Message-ID: <2025120440-evaporate-crawlers-ac2a@gregkh>
References: <20251203152414.082328008@linuxfoundation.org>
 <41e4124d-8cb3-44b9-871b-8fa64b54b303@sirena.org.uk>
 <b4d4d33e-07d8-4868-abc5-4161a63bb948@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4d4d33e-07d8-4868-abc5-4161a63bb948@gmail.com>

On Wed, Dec 03, 2025 at 10:51:17AM -0800, Florian Fainelli wrote:
> On 12/3/25 10:46, Mark Brown wrote:
> > On Wed, Dec 03, 2025 at 04:22:30PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.15.197 release.
> > > There are 392 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > 
> > I'm seeing a build failure in the KVM selftests on arm64 with this, due
> > to dddac591bc98 (tools bitmap: Add missing asm-generic/bitsperlong.h
> > include):
> > 
> > aarch64-linux-gnu-gcc -Wall -Wstrict-prototypes -Wuninitialized -O2 -g -std=gnu9
> > 9 -fno-stack-protector -fno-PIE -I../../../../tools/include -I../../../../tools/
> > arch/arm64/include -I../../../../usr/include/ -Iinclude -I. -Iinclude/aarch64 -I
> > ..   -pthread  -no-pie    dirty_log_perf_test.c /build/stage/build-work/kselftes
> > t/kvm/libkvm.a  -o /build/stage/build-work/kselftest/kvm/dirty_log_perf_test
> > In file included from ../../../../tools/include/linux/bitmap.h:6,
> >                   from dirty_log_perf_test.c:15:
> > ../../../../tools/include/asm-generic/bitsperlong.h:14:2: error: #error Inconsis
> > tent word size. Check asm/bitsperlong.h
> >     14 | #error Inconsistent word size. Check asm/bitsperlong.h
> >        |  ^~~~~
> > In file included from ../../../../usr/include/asm-generic/int-ll64.h:12,
> >                   from ../../../../usr/include/asm-generic/types.h:7,
> >                   from ../../../../usr/include/asm/types.h:1,
> >                   from ../../../../tools/include/linux/bitops.h:5,
> >                   from ../../../../tools/include/linux/bitmap.h:8:
> > ../../../../usr/include/asm/bitsperlong.h:20:9: warning: "__BITS_PER_LONG" redefined
> >     20 | #define __BITS_PER_LONG 64
> >        |         ^~~~~~~~~~~~~~~
> > In file included from ../../../../tools/include/asm-generic/bitsperlong.h:5:
> > ../../../../tools/include/uapi/asm-generic/bitsperlong.h:12:9: note: this is the location of the previous definition
> >     12 | #define __BITS_PER_LONG 32
> >        |         ^~~~~~~~~~~~~~~
> 
> Yes this also affects building "perf".

Now dropped, thanks.

greg k-h
