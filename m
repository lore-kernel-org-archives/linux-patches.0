Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801C2748C;
	Tue, 13 Dec 2022 16:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17D69C433EF;
	Tue, 13 Dec 2022 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1670950267;
	bh=XuyPsD72oPHirUFch10ORuPd8S8i15OahN565MHaV3Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UulrFBfvcnR1w6K3YNUjNDZcZ7syW1CNLwHP52g1fRg0NiL+ufzmvvXbtW+qWBLF4
	 JXeZbqtpwOTCcV7XYKGyfBsOp4vCdXCJSu6EP5sLRYjYy9QuPIqFYmCjzkJ6pAMdAD
	 bw0SJzye9X/1myFawQ6MwgsuUoS4+fcEnnFop6uNiQAyanNtA7pyKjmomzBETf7Wzs
	 H6EFFqunywPAOVhpjRz2tlrMOp6r/E/H83WJwJ9+W9PAetSChyYS8oPzhW2HwxpNDY
	 S2IjtGNRAwlu+HJpR/BxYZkoLbyjvbpj6n2ZQ/EuhnL5f9yjHHMN35Kxh9ycOjAjt5
	 VqC4SArSIY+lg==
Date: Tue, 13 Dec 2022 09:51:04 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, llvm@lists.linux.dev,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
Message-ID: <Y5iteH7jCU83w5qm@dev-arch.thelio-3990X>
References: <20221212130934.337225088@linuxfoundation.org>
 <CA+G9fYt7QTkGWPhj0NX8bcDOvEvf9jOW5Oaj8T2zmzasHjo1yA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt7QTkGWPhj0NX8bcDOvEvf9jOW5Oaj8T2zmzasHjo1yA@mail.gmail.com>

Hi Naresh,

On Tue, Dec 13, 2022 at 12:01:25PM +0530, Naresh Kamboju wrote:
> This is an additional report.
> Following issue is specific to clang nightly,
> 
> x86 clang-nightly builds failed with defconfig and tinyconfig due to
> below errors / warnings.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Regressions found on x86_64:
> 
>     - build/clang-nightly-tinyconfig
>     - build/clang-nightly-x86_64_defconfig
>     - build/clang-nightly-allnoconfig
>     - build/clang-nightly-lkftconfig
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/1/build LLVM=1 LLVM_IAS=1
> ARCH=x86_64 SRCARCH=x86 CROSS_COMPILE=x86_64-linux-gnu- HOSTCC=clang
> CC=clang
> 
> ld.lld: error: version script assignment of 'LINUX_2.6' to symbol
> '__vdso_sgx_enter_enclave' failed: symbol not defined
> llvm-objdump: error: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file
> or directory
> llvm-objcopy: error: 'arch/x86/entry/vdso/vdso64.so.dbg': No such file
> or directory
> make[4]: *** [/builds/linux/arch/x86/entry/vdso/Makefile:136:
> arch/x86/entry/vdso/vdso64.so] Error 1

Thanks for the report!

This is resolved in mainline now with commit 45be2ad007a9 ("x86/vdso:
Conditionally export __vdso_sgx_enter_enclave()"). I was going to
request stable backports once it was a little calmer but if people are
hitting this now, I guess now is as good a time as ever :) I believe it
should backport cleanly to 5.15+, which is where it is needed.

Cheers,
Nathan
