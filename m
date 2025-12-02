Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBCB3064BF;
	Tue,  2 Dec 2025 09:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764667759; cv=none; b=nWn8ipXc92Dy9vQzMfdpWgdgAIDuonCIjqJKyqeIk1OH/NL1pCNB8tjuRMsKvvUFCbOtQs1vOMAN/KZLGhWdIaHbxsA9hR+76iPv7thiU1dfxkuPwZLQbIEQPa3ALjkPcBCRD2AXizaRrz3qNdb66e+d9+D5zSJy3YPeASB98wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764667759; c=relaxed/simple;
	bh=hgIQtutR8Il7PNoGjaNPjJqfsYl2yf5DyJQuckT2vPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oFwGvzQgP9+oHHUjISGjbvPnYPF//y4f0YY0kNhUPhJLA0P9TPTfpAky3U3SCm1OaO9axpbCKgHjKPDFYZSLCZVq9VJd+mGZMQaftVh2JE1vjBwIhn21h+bQQ05lWowo3usHMENOlLlq6UOHHTOHcY3BSJiZwCc2/yY4+fsLw28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p4OqALg4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p4OqALg4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE9FCC4CEF1;
	Tue,  2 Dec 2025 09:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764667758;
	bh=hgIQtutR8Il7PNoGjaNPjJqfsYl2yf5DyJQuckT2vPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p4OqALg4dQXeTzcGl2eEoKwMSKtE4zpnKgSqpAr6yQG4b2RDj78BuM9UPQ1fBKmFm
	 f3HmYiflM+qhv9P9LS9tl4R0SKdgYH9YPVFKwKbUgyj+aHehPoi2YAcpiS9eHqsNyW
	 fswJIaj4/nzVf40FFhW2arRYQRO/qmSpUzzdViQw=
Date: Tue, 2 Dec 2025 10:29:15 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: ALOK TIWARI <alok.a.tiwari@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [External] : [PATCH 5.4 000/187] 5.4.302-rc1 review
Message-ID: <2025120235-flashbulb-embargo-3cc3@gregkh>
References: <20251201112241.242614045@linuxfoundation.org>
 <71053538-b880-45e8-9dd2-b2a533c1ebc0@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71053538-b880-45e8-9dd2-b2a533c1ebc0@oracle.com>

On Tue, Dec 02, 2025 at 09:27:10AM +0530, ALOK TIWARI wrote:
> 
> 
> On 12/1/2025 4:51 PM, Greg Kroah-Hartman wrote:
> > Ian Rogers<irogers@google.com>
> >      tools bitmap: Add missing asm-generic/bitsperlong.h include
> 
> f38ce0209ab455 "tools bitmap: Add missing asm-generic/bitsperlong.h include"
> 
> We are getting a build failure due to this commit.
> 
> ----
>   CC       util/bitmap.o
>   CC       util/hweight.o
> BUILDSTDERR: In file included from /builddir/build/BUILD/kernel-5.4.302/linux-5.4.302-master.20251201.el8.v1/tools/include/linux/bitmap.h:6,
> BUILDSTDERR:                  from ../lib/bitmap.c:6:
> BUILDSTDERR: /builddir/build/BUILD/kernel-5.4.302/linux-5.4.302-master.20251201.el8.v1/tools/include/asm-generic/bitsperlong.h:14:2:
> error: #error Inconsistent word size. Check asm/bitsperlong.h
> BUILDSTDERR:    14 | #error Inconsistent word size. Check asm/bitsperlong.h
> BUILDSTDERR:       |  ^~~~~
>   CC       util/smt.o
>   CC       util/strbuf.o
>   CC       util/string.o
>   CC       util/strlist.o
>   CC       util/strfilter.o
>   CC       util/top.o
>   CC       util/usage.o
>   CC       util/dso.o
> BUILDSTDERR: make[4]: *** [util/Build:227: util/bitmap.o] Error 1
> BUILDSTDERR: make[4]: *** Waiting for unfinished jobs....
>   LD       tests/perf-in.o
>   LD       arch/x86/util/perf-in.o
>   LD       arch/x86/perf-in.o
>   LD       arch/perf-in.o
>   LD       bench/perf-in.o
>   LD       ui/perf-in.o
> BUILDSTDERR: make[3]: *** [/builddir/build/BUILD/kernel-5.4.302/linux-5.4.302-master.20251201.el8.v1/tools/build/Makefile.build:143:
> util] Error 2
> BUILDSTDERR: make[3]: *** Waiting for unfinished jobs....
> BUILDSTDERR: make[2]: *** [Makefile.perf:593: perf-in.o] Error 2
> BUILDSTDERR: make[1]: *** [Makefile.perf:217: sub-make] Error 2
> BUILDSTDERR: make: *** [Makefile:70: all] Error 2
> BUILDSTDERR: error: Bad exit status from /var/tmp/rpm-tmp.blrvNZ (%build)

I can't get any tools/ targets to build on 5.4 and have not for quite
some time, so I'll have to trust you on this.  I'll go drop this commit
and push out a -rc2.

thanks,

greg k-h
