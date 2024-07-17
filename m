Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B3A51BF2A;
	Wed, 17 Jul 2024 06:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721197295; cv=none; b=QVGhg9w/2kQhSqQFBu/tvY0hdqNAJxujLUP+399BP44mE1cNpShgx+7vBszI1pYYmbWgt7PFPtVeTEwaT5jAFP7kdVTuBCq6cwsFUkpUVXnkm6U/hriha5zra5/kByAeJZiK2zo/KFRwJKDMKtdGGL2VZZ5kg+lqUydikORtSyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721197295; c=relaxed/simple;
	bh=q9jAcsYVi0AP0LirS0bHameGExzxLo0sKr0m8WEbpeM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSWNlm6ZoV9A6G6sWy5WTR1qkS2i/46WrgoOqrH/o64jwZDJRjDvTN1/IEpVMnqR3JcOr5ay9f1NAXpGONmGgEj+O9BUirrdPeENU6dfT94PDf8oTxUSkjZVxuD0Kp5aa5QRSuN6ZhjeD4g5CQmp5n33SzdfEOkqXmkXHmTmowg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QZ40utq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QZ40utq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF5DC32782;
	Wed, 17 Jul 2024 06:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721197295;
	bh=q9jAcsYVi0AP0LirS0bHameGExzxLo0sKr0m8WEbpeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0QZ40utqOlyBTrWKNK36csYxkYhjqhq3qfwDw3mDB0jxVUx7e2U8WF9PFKDujzVcn
	 ebc9+ZCVNDI+TErsaoIY4WIPwM2XGqe4ZMWv2dgKg6ink+551yRZhyOYaUpJNccjMl
	 o2BTnRWTWSeSufaCfyygOHXg4AIqaqSLFGRRjnBE=
Date: Wed, 17 Jul 2024 08:21:32 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 000/144] 5.15.163-rc1 review
Message-ID: <2024071705-fable-implosive-5e34@gregkh>
References: <20240716152752.524497140@linuxfoundation.org>
 <CA+G9fYvVaSX9Ot2vekBOkLjUqCx=SbQqW4vWhypCnGwwBmX4xg@mail.gmail.com>
 <c7beb899-91dc-4fcd-816e-fa7ba6f956e4@suswa.mountain>
 <2024071743-anyhow-legroom-1d54@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024071743-anyhow-legroom-1d54@gregkh>

On Wed, Jul 17, 2024 at 08:15:08AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jul 16, 2024 at 03:45:33PM -0500, Dan Carpenter wrote:
> > On Wed, Jul 17, 2024 at 01:49:12AM +0530, Naresh Kamboju wrote:
> > > On Tue, 16 Jul 2024 at 21:37, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.15.163 release.
> > > > There are 144 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.163-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > The s390 builds failed on stable-rc 5.15.163-rc1 review due to following build
> > > warnings / errors.
> > > 
> > > First time seen on stable-rc 5.15 branch.
> > > 
> > >   GOOD: ba1631e1a5cc ("Linux 5.15.162-rc1")
> > >   BAD:  b9a293390e62 ("Linux 5.15.163-rc1")
> > > 
> > > * s390, build
> > >   - clang-18-allnoconfig
> > >   - clang-18-defconfig
> > >   - clang-18-tinyconfig
> > >   - clang-nightly-allnoconfig
> > >   - clang-nightly-defconfig
> > >   - clang-nightly-tinyconfig
> > >   - gcc-12-allnoconfig
> > >   - gcc-12-defconfig
> > >   - gcc-12-tinyconfig
> > >   - gcc-8-allnoconfig
> > >   - gcc-8-defconfig-fe40093d
> > >   - gcc-8-tinyconfig
> > > 
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > 
> > > Build regressions:
> > > --------
> > > arch/s390/include/asm/processor.h:253:11: error: expected ';' at end
> > > of declaration
> > >   253 |         psw_t psw __uninitialized;
> > >       |                  ^
> > >       |                  ;
> > > 1 error generated.
> > 
> > Need to cherry-pick commit fd7eea27a3ae ("Compiler Attributes: Add __uninitialized macro")
> 
> Thanks, as this keeps coming back, I'll go add this commit now to all
> branches and push out -rc2 releases in a few hours.

Nope, not doing this for 4.19.y, that's going to turn into too much of a
mess there.  I'll just drop the offending commit from that branch for
now, thanks.

greg k-h
