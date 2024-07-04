Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3C41AB8F8;
	Thu,  4 Jul 2024 09:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720085342; cv=none; b=FnfrZpmfyi1KlEQpge34uerKVLL1disN/9AXHD21T7Xy7LTrfg+GpwDGFkayo5qPLk52CD2b/CB2wJr35gQMD7k7fR6RDDOkja3ywEEU28hXsomXNgBpehochojYj/x6OVycv7+sCvoe5kuvleVoNb98Sg4mE98hrxK5eXkWG4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720085342; c=relaxed/simple;
	bh=99QdLiQfWVvNrakKybpaotUBHFtBmS12E1R2ONNXAUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BunVd6meQKuX2ONp2+Dr5thAcgd+OxzK1EWgfAL2eCgU+IR6EN0vznja/Jz84ye1CPisfei/YK2gLhqOPqGaSzL/8g0a1D0ALWhFcZSCG2x4D9oy2o5bUIlkSNjsq2JEcCmrAse0gzwcdIevmtGYIVyClMMSD3UoUKpFgjxKiDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSQnWx+o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSQnWx+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C181C4AF0A;
	Thu,  4 Jul 2024 09:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720085341;
	bh=99QdLiQfWVvNrakKybpaotUBHFtBmS12E1R2ONNXAUo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mSQnWx+oYdMK4tn623s9b61z8DkjTc7HlS1IFjpffqtWuvzMYwDwtfhQN0MZiAcR3
	 Ntxi6aLTOGvgnuMajtSLx1vRR9xHd9T72eGe/yHcuftprHDv4qS6BqF3Yq15Ycztl3
	 xTfQzM3HCoc4iMwGh5ZonO9IUqVEiXRZtZkrNJ7U=
Date: Thu, 4 Jul 2024 11:27:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 5.10 000/290] 5.10.221-rc1 review
Message-ID: <2024070447-robbing-devalue-c16d@gregkh>
References: <20240703102904.170852981@linuxfoundation.org>
 <CA+G9fYu8dpsNyqPk53wyq1ZTKmCJ3gUb6JBjH3OM9p2pqL_E-A@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu8dpsNyqPk53wyq1ZTKmCJ3gUb6JBjH3OM9p2pqL_E-A@mail.gmail.com>

On Wed, Jul 03, 2024 at 11:41:54PM +0530, Naresh Kamboju wrote:
> On Wed, 3 Jul 2024 at 16:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.221 release.
> > There are 290 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 05 Jul 2024 10:28:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.221-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> The s390 builds failed on stable-rc 5.10.221-rc1 due to following build
> warnings / errors. These errors were also noticed on stable-rc 5.4.279-rc1.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Regressions found on s390:
> 
>   - gcc-12-defconfig
>   - clang-18-defconfig
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
>       |                             ^               ^
> 
> Build log link,
>  [1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.220-291-g4d0fada143ed/testrun/24509787/suite/build/test/gcc-12-defconfig/log
> 
> 
> Build config url:
>   config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXjGemFUwKSWd98LvKtd4i3uF/config
>   download_url:
> https://storage.tuxsuite.com/public/linaro/lkft/builds/2ijXjGemFUwKSWd98LvKtd4i3uF/
> 
> metadata:
>   git_describe: v5.10.220-291-g4d0fada143ed
>   git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git_short_log: 4d0fada143ed ("Linux 5.10.221-rc1")
>   toolchain: gcc-12
>   arch: s390
> 

Found the issue, will push out -rc2 versions soon, thanks.

greg k-h
