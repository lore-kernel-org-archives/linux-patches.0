Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15BB15C147;
	Fri, 30 Aug 2024 10:57:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015428; cv=none; b=XysLSJDM/nd+cE72U/7D6jTxKOSzdj6+jPyNFcqhF7iScqqIs2pgTkRAiUu0isWay2yEw2EzwG0PIKUvYwN6Xb4ahfElo9iRx4QgsN9xQ/1jcOIbZDv7dW6Kjj2JfbPrUQwUBjsSkOdOyym37Abd3msw83GpNwjp7667phdD8+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015428; c=relaxed/simple;
	bh=KsqVa04H80GFdfyL//UXuhuLq0MIdj7cLJLjxKOxZW8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OPZYqedN7U9IDE02caszUdXcMqedeuD1UmgVD+KU0fu5WRjY3veDzQepGpFn4I7visCwHuIJqgxE2yn0HMXZ4fUoyraMI0kq6SjtXrE4m+q8hS5zPIy3p9v0ixXAwp656mmDRymV0+sSFtkEtBwTNFRNxEf/HGpcCvtdZhKzPT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RJxUdJY2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RJxUdJY2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31B7C4CEC6;
	Fri, 30 Aug 2024 10:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725015427;
	bh=KsqVa04H80GFdfyL//UXuhuLq0MIdj7cLJLjxKOxZW8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RJxUdJY2wJt8pkSEYlwS/tGiQF0pu0zigwsvo43z04O+5gl6hy+aK1d7JbRID5lR5
	 l05lsHl10GspJDQyp+XlGQlznSL0L4VAoL/dLA2d67W5tMctNiSNbpjwZOIPGooCky
	 WzXFY5MoEo/UEAVPdFsTKaL29j/D5wwiuj81eios=
Date: Fri, 30 Aug 2024 12:57:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
Message-ID: <2024083051-nutshell-trend-602a@gregkh>
References: <20240817075228.220424500@linuxfoundation.org>
 <1c83d94d-1b56-4bd9-8a96-c5062c238c06@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1c83d94d-1b56-4bd9-8a96-c5062c238c06@sirena.org.uk>

On Tue, Aug 20, 2024 at 03:43:44PM +0100, Mark Brown wrote:
> On Sat, Aug 17, 2024 at 10:00:38AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.165 release.
> > There are 479 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This breaks the build of at least the KVM selftests on arm64 for me:
> 
> In file included from dirty_log_test.c:15:
> ../../../../tools/include/linux/bitmap.h: In function ‘bitmap_zero’:
> ../../../../tools/include/linux/bitmap.h:33:34: warning: implicit declaration of
>  function ‘ALIGN’ [-Wimplicit-function-declaration]
>    33 | #define bitmap_size(nbits)      (ALIGN(nbits, BITS_PER_LONG) / BITS_PER_
> BYTE)
>       |                                  ^~~~~
> ../../../../tools/include/linux/bitmap.h:40:32: note: in expansion of macro ‘bit
> map_size’
>    40 |                 memset(dst, 0, bitmap_size(nbits));
>       |                                ^~~~~~~~~~~
> /usr/bin/ld: /tmp/cc4JPVlx.o: in function `bitmap_alloc':
> /build/stage/linux/tools/testing/selftests/kvm/../../../../tools/include/linux/b
> itmap.h:126: undefined reference to `ALIGN'
> /usr/bin/ld: /build/stage/linux/tools/testing/selftests/kvm/../../../../tools/in
> clude/linux/bitmap.h:126: undefined reference to `ALIGN'
> collect2: error: ld returned 1 exit status
> 
> This bisects down to:
> 
> 9853a5bed65d507048dbe772bb84e6f905b772a3 is the first bad commit
> commit 9853a5bed65d507048dbe772bb84e6f905b772a3
> Author: Alexander Lobakin <aleksander.lobakin@intel.com>
> Date:   Wed Mar 27 16:23:49 2024 +0100
> 
>     bitmap: introduce generic optimized bitmap_size()
>     
>     commit a37fbe666c016fd89e4460d0ebfcea05baba46dc upstream.
> 
> A similar issue appears to affect at least the 5.10 -rc.

Thanks, I think I've fixed this up in the queues now.

greg k-h
