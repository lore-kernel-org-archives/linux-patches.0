Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC7E26B2AD;
	Tue, 24 Jun 2025 10:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750760831; cv=none; b=ZApZ7uzrX+TXN1PnBBS7fsVeC2Xx662zVnqzeGZf0wKwbYz77dBnvAc1mwHy1bq6WfogJRX6r1BDXy6KaYMhSXuos/UEcMejWm1nTER+jPO35/9HDscyktvsw5jfSianbhisSrdX35o7ZE6jdEWPM/VgNQprH1W1TNMaoOypvqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750760831; c=relaxed/simple;
	bh=3VL2ZDaeQDvTAIFDhdlXuLjhBEWyHHUcwX01jX3cGqA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uBDu1Bu1ctMON9lRniNupOGqaAypcvGZaZ8F7NCzJW7HBe3yno2B9IOon7MX4jibW30DAkhTw66+dzy70nFk/b7M2ePywDavxQf/+b2YLI+DRviXTnfb2BeCKBE//94QaSY31pseF5kgd4WahEBfL6X+1a0jHr0wAwpxF+frhss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g03dfxio; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g03dfxio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A80C4CEF1;
	Tue, 24 Jun 2025 10:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750760831;
	bh=3VL2ZDaeQDvTAIFDhdlXuLjhBEWyHHUcwX01jX3cGqA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g03dfxio0dn9OjGUhqbB9BMwcW6zwImbvgJcdQHvYSKEqqVlm+aOhNI1+Z1KdgF0I
	 mjd9iDzCyt/uv65zT2pGlNOe8moqYM/NnmKrF9SJdz/1QIgn6sEjyIHcJtGo+hFxyx
	 lRCedPrAnE1PdQCTWcwV7WHFDffuReRF7ipWtVq0=
Date: Tue, 24 Jun 2025 11:27:06 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Julien Thierry <jthierry@redhat.com>,
	James Morse <james.morse@arm.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.10 000/355] 5.10.239-rc1 review
Message-ID: <2025062457-uncouple-oncoming-f933@gregkh>
References: <20250623130626.716971725@linuxfoundation.org>
 <CA+G9fYt2e-ZGhU57oqWwC1_t2RPgxLCJFVC0Pa8-fYPkZcUvVQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt2e-ZGhU57oqWwC1_t2RPgxLCJFVC0Pa8-fYPkZcUvVQ@mail.gmail.com>

On Tue, Jun 24, 2025 at 01:56:56AM +0530, Naresh Kamboju wrote:
> On Mon, 23 Jun 2025 at 18:39, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.239 release.
> > There are 355 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 25 Jun 2025 13:05:51 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regressions on arm64 tinyconfig builds with gcc-12 and clang failed on
> the Linux stable-rc 5.10.239-rc1.
> 
> Regressions found on arm
> * arm64, build
>   - clang-20-allnoconfig
>   - clang-20-tinyconfig
>   - gcc-12-allnoconfig
>   - gcc-12-tinyconfig
>   - gcc-8-allnoconfig
>   - gcc-8-tinyconfig
> 
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: stable-rc 5.10.239-rc1 arm64 insn.h error use of
> undeclared identifier 'FAULT_BRK_IMM'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 
> ## Build errors
> arch/arm64/include/asm/insn.h:573:9: error: use of undeclared
> identifier 'FAULT_BRK_IMM'
>   573 |         return AARCH64_BREAK_FAULT;
>       |                ^
> arch/arm64/include/asm/insn.h:26:54: note: expanded from macro
> 'AARCH64_BREAK_FAULT'
>    26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON |
> (FAULT_BRK_IMM << 5))
>       |                                                      ^
> arch/arm64/include/asm/insn.h:583:9: error: use of undeclared
> identifier 'FAULT_BRK_IMM'
>   583 |         return AARCH64_BREAK_FAULT;
>       |                ^
> arch/arm64/include/asm/insn.h:26:54: note: expanded from macro
> 'AARCH64_BREAK_FAULT'
>    26 | #define AARCH64_BREAK_FAULT    (AARCH64_BREAK_MON |
> (FAULT_BRK_IMM << 5))
>       |                                                      ^
> 2 errors generated.

Now fixed, thanks.

greg k-h
