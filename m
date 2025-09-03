Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD74C2F29;
	Wed,  3 Sep 2025 17:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756920548; cv=none; b=DdD2sYnsLUwzDUcxKVDxEc8Taox6T1LX35n+nqenV3F6YnMt9+7Hsh7OfUlsnQwtoTJPPvulh2np9MOXXinRAC6DM7dlR3g5Jesr8YcKYN9NsWXSpRe7+82+gm7OJkJmykbH5vUnV/sHngpQAj69CCfFqPvqdG8YpuinpTwq3FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756920548; c=relaxed/simple;
	bh=+jTybdYK9ArCfVLiUy0Jqkmx/KrVQ1a3l0rTTupm3FM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3GS+soAjQp1jH7YA3ivEEjKC6T/yhgBe97Cf87KS4qAnAfI2JfKa+xBO3LSt+ZOXeY5Y4KkTTkcF7TgJUvDkW5TdL6D0O0ggGhhiILESSbO/BOozhENkTHOaJr/Ptat9hPYzUW1oxX6BJrNcGJAqOX4FewJyu1sajQX37aNHi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HTs8lbpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HTs8lbpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47582C4CEE7;
	Wed,  3 Sep 2025 17:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756920547;
	bh=+jTybdYK9ArCfVLiUy0Jqkmx/KrVQ1a3l0rTTupm3FM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HTs8lbprL63AXyz1DOJPxnteZSs8TXW203xae3nDzG3YIh698YkQzSoYQmbvim9n5
	 nMcBA//EewfAyPlN72o45AId/nzLx0NHgKulfgGUbzHkTyqIBJkURURKkj3Gag831a
	 wfMbCuPtI/ktOHQ4uhpqKpiAmTHQw1yr7kSRW4IjHFDtQQpfy6A2RgbMQ/alJhv68C
	 AY9i82cJKkEi/RwQf/aWD9w3/KGQc6lADExHnl2JT64Sxrr+Si3bq/itmGyjMbynoL
	 +hZ3Uyqc2TO3JXvFQ6/MpqnI9dX1bLwbMlt6ig3zKLBOLbIZNAIytc+1fqmyeQILpV
	 p2g0CDSpmkGIw==
Date: Wed, 3 Sep 2025 10:28:59 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	clang-built-linux <llvm@lists.linux.dev>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Ben Copeland <benjamin.copeland@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.4 00/23] 5.4.298-rc1 review
Message-ID: <20250903172859.GB3288670@ax162>
References: <20250902131924.720400762@linuxfoundation.org>
 <CA+G9fYtoKARW00i0ct=M+-1OAWoQhE_rvsS6RJPPQ7YEcZ4C1w@mail.gmail.com>
 <2025090317-envelope-professed-b38a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2025090317-envelope-professed-b38a@gregkh>

On Wed, Sep 03, 2025 at 11:48:11AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 03, 2025 at 03:11:26PM +0530, Naresh Kamboju wrote:
> > Build regression: stable-rc 5.4.298-rc1 powerpc/boot/util.S:44: Error:
> > junk at end of line, first unrecognized character is `0'
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Known issue, patch already submitted:
> 	https://lore.kernel.org/r/20250902235234.2046667-1-nathan@kernel.org
> 
> Will queue that up for the next round of releases, using clang-20 on
> 5.4.y is brave :)

Just for the record, there is nothing clang specific here, it is a
binutils problem. The clang-20 TuxMake containers just happen to have a
newer copy of binutils from Debian Trixie after [1]. I would expect one
of the updated GCC versions to reproduce the same issue, unless they
don't build 5.4 for other reasons. I always try to ensure every stable
version builds with latest clang so I would not consider it that brave
:)

I plan to send a v2 addressing Segher's comments later today.

[1]: https://gitlab.com/Linaro/tuxmake/-/commit/46280e20b8ed2df749e9115640271c0a6a2c812c

Cheers,
Nathan
