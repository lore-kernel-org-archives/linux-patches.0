Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3559D1AB915;
	Thu,  4 Jul 2024 09:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085345; cv=none; b=f02bgCENgOls4Cpmsyc11vo0sU+YeSrgtZcJ3Lu5tgSVTYRljN6YtgY6TCno3tCd+Ge806sGtOirRf8sy673CiLtqcVT70/eW4rP+CNDWFKY0/u87HNS7a1tMLka47JlbE+QNGMoEc8CmnwhJzX/42w3qax94kj4gaUbYmwMOyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085345; c=relaxed/simple;
	bh=ICJO2BIPLeaVKA/OpeWVCC50eAVgdLJ4opEqlcEfH6A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBXWWeocTiDwdLEAoWER5PEPFpreoQpz9UMZB13toSOURaZpoFpZSbsRoZsKQcRvrg0ST4re/AAso8g2QWSSILONr2LZwsIAyblNeXXSozLFiIeeCD6vyIDkDxSD4C7G6GCXbORaa41p/ynDBgTJbacAhilIB/kt72sXvtYE2so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd6lBk/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd6lBk/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B081C4AF0D;
	Thu,  4 Jul 2024 09:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720085344;
	bh=ICJO2BIPLeaVKA/OpeWVCC50eAVgdLJ4opEqlcEfH6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jd6lBk/Y27dZsYEgxnYuvMxHXjRKr6W4OnI4Iz+AOGiiwzVm3Qkk/xQO496Dy4+8o
	 ufltP+NiJku2P2jKLDFKeJtAM3jXd/uWFMyMegECs+W4w7/s4FQmLfosRRbAKZQKSp
	 o+z2aYBOuvHCXAEA5/ymnbPtIWWg3xklqUJoxA/4=
Date: Thu, 4 Jul 2024 11:28:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/189] 5.4.279-rc1 review
Message-ID: <2024070407-lanky-fifty-9b12@gregkh>
References: <20240703102841.492044697@linuxfoundation.org>
 <CA+G9fYvXVQ599HH3ZYfNEZrZwacR-0hzKCqrLa=+ON0hDTwwGQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvXVQ599HH3ZYfNEZrZwacR-0hzKCqrLa=+ON0hDTwwGQ@mail.gmail.com>

On Wed, Jul 03, 2024 at 11:18:15PM +0530, Naresh Kamboju wrote:
> On Wed, 3 Jul 2024 at 16:20, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.279 release.
> > There are 189 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 05 Jul 2024 10:28:06 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.279-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The s390 builds failed on stable-rc 5.4.279-rc1 due to following build
> warnings / errors.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Regressions found on s390:
> 
>   - gcc-12-defconfig
>   - gcc-8-defconfig-fe40093d
> 
> 
> Build log:
> ------
> arch/s390/include/asm/cpacf.h: In function 'cpacf_km':
> arch/s390/include/asm/cpacf.h:320:29: error: storage size of 'd' isn't known
>   320 |         union register_pair d, s;
>       |                             ^
> arch/s390/include/asm/cpacf.h:320:32: error: storage size of 's' isn't known
>   320 |         union register_pair d, s;
>       |                                ^
> arch/s390/include/asm/cpacf.h:320:32: warning: unused variable 's'
> [-Wunused-variable]
> arch/s390/include/asm/cpacf.h:320:29: warning: unused variable 'd'
> [-Wunused-variable]
>   320 |         union register_pair d, s;
>       |                             ^
> 
> Build log link,
>  [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.278-190-gccd91126c63d/testrun/24509933/suite/build/test/gcc-12-defconfig/log
>  [2] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.278-190-gccd91126c63d/testrun/24509933/suite/build/test/gcc-12-defconfig/details/
> 
> Build config url:
>   config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXtfDw1Nbem1ANR1V8mLxfNeR/config
>   download_url:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXtfDw1Nbem1ANR1V8mLxfNeR/
> 
> metadata:
>   git_describe: v5.4.278-190-gccd91126c63d
>   git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git_short_log: ccd91126c63d ("Linux 5.4.279-rc1")
>   toolchain: gcc-12
>   arch: s390

Should now be fixed, thanks.

greg k-h
