Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A631FEA5;
	Fri, 11 Aug 2023 03:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2492C433C7;
	Fri, 11 Aug 2023 03:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1691724983;
	bh=U3GBlXX0ekD2n+2mkEPFU8EeJfePOSnJ1WMlMuWPfmU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jN5bFL2F7ptpE3vnjGio9cXsXDiWR0OKjmvSz69OpthOBjdYgD3dO4Byp8sQKugnB
	 nr+T+DYpgtWub4Vcy+B1Y+4LL62D+Y0WI7EUQGDhfEBuiG4/HymLQLJxcj+jOzirxI
	 LqDklmG30R/f9s6YiXiszpz+2+5i4z5JOyXl6Z8MJqJ+oDesy0ieOh0IfRL3IHqAYo
	 WoRD4aoqtekJNED+625VcDODtGHo2MQBCYx9FVmoVfu4o/NnOKOW3JyTm+ym8bmdVZ
	 pxZujVgKR4eevM9KaQ6wT4oaZWYzRvaeS4Un1jB4d5nJGAaWTnjRjNNetCOYHtrITH
	 y9hjmS2qzCjMQ==
Date: Thu, 10 Aug 2023 20:36:20 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	clang-built-linux <llvm@lists.linux.dev>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sven Volkinsfeld <thyrc@gmx.net>,
	Daniel Kolesa <daniel@octaforge.org>
Subject: Re: [PATCH 6.1 000/127] 6.1.45-rc1 review
Message-ID: <20230811033620.GA10002@dev-arch.thelio-3990X>
References: <20230809103636.615294317@linuxfoundation.org>
 <CA+G9fYvQdQqTqCgbS4sit_Y2AtKtDiWMOkGZjoeSEFhc=M_jKw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvQdQqTqCgbS4sit_Y2AtKtDiWMOkGZjoeSEFhc=M_jKw@mail.gmail.com>

On Fri, Aug 11, 2023 at 08:52:01AM +0530, Naresh Kamboju wrote:
> Build errors:
> -----
> ld.lld: error: ./arch/x86/kernel/vmlinux.lds:193: at least one side of
> the expression must be absolute
> make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> 
> 
>   Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> upstream report:
> -----
>     - https://lore.kernel.org/llvm/CA+G9fYsdUeNu-gwbs0+T6XHi4hYYk=Y9725-wFhZ7gJMspLDRA@mail.gmail.com/
> 
> Proposed fix patch:
> -----
>   [PATCH] x86/srso: fix build breakage for LD=ld.lld
>   - https://lore.kernel.org/lkml/20230809-gds-v1-1-eaac90b0cbcc@google.com/T/
> 
> This patch is yet to be backported and CC to stable.

It's now in -tip, I would expect it to make -rc6:

https://git.kernel.org/tip/cbe8ded48b939b9d55d2c5589ab56caa7b530709

It should have had 'Cc: stable@vger.kernel.org' but I hope the Fixes:
tag alone will ensure it gets picked up once it hits mainline,
especially since there are other fixes that will come in that pull.

Cheers,
Nathan
