Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C1C19E836;
	Tue, 22 Oct 2024 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729604659; cv=none; b=mwvRdCruMzbOxnDC7As9t1eupQseTSaFr21uai+cwLWMRaw6vYnn4XTngsrBjJXlglClAdrqp918mISUpI9cdTFRD6HDlaek7e5AWXOlTAMqdfrFZI5TWOpIcU1VQHikrV30SCSI5qeKFBdiQHNcoekm4xSggHOfAAcsRvgIyCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729604659; c=relaxed/simple;
	bh=ottGwOKZ3ymjkiIWssqkHiG4TV1fGDBzEirqNxc8ikU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/0HFknVxEJFNqqIz7MtTetS9JKLjCtNvO7f4of+h+aaWtoF5+Qu0TBQ7t1xwFvUKicJeTVKnck1OCevWgg2brWZXu63DpahNy2OKDY3DJvBsZ5JEV91WOyhNycSpjEkEO32uDPT8If4QmGuEJc6LDBvwduApIY3Eim1CLT5n7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=raPJJXvb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="raPJJXvb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC43C4CEE6;
	Tue, 22 Oct 2024 13:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729604658;
	bh=ottGwOKZ3ymjkiIWssqkHiG4TV1fGDBzEirqNxc8ikU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=raPJJXvbXaNixDs9Yo5CA6e/2maVu0m2Xq1ltHywp5lBCEKVFstYFKx7pV3oh52qd
	 Xad7eJF0RSI3QnOSS34qyq8kvjzwAdckei8gHOOtiXX436RKF2tVuPKtvpUENQHCrT
	 FImAEFQkORNjefBx8nR3b6JQCZIY0o9H9WLLJPnA=
Date: Tue, 22 Oct 2024 15:44:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/91] 6.1.114-rc1 review
Message-ID: <2024102207-neuter-phobia-cb39@gregkh>
References: <20241021102249.791942892@linuxfoundation.org>
 <CA+G9fYtXZfLYbFFpj25GqFRbX5mVQvLSoafM1pT7Xff6HRMeaA@mail.gmail.com>
 <2024102216-buckskin-swimmable-a99d@gregkh>
 <20241022091418.tbmk3sswlzsv7azu@quack3>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241022091418.tbmk3sswlzsv7azu@quack3>

On Tue, Oct 22, 2024 at 11:14:18AM +0200, Jan Kara wrote:
> On Tue 22-10-24 10:56:34, Greg Kroah-Hartman wrote:
> > On Tue, Oct 22, 2024 at 01:38:59AM +0530, Naresh Kamboju wrote:
> > > On Mon, 21 Oct 2024 at 16:11, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.1.114 release.
> > > > There are 91 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.114-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > The arm allmodconfig build failed due to following warnings / errors with
> > > toolchain clang-19.
> > > For all other 32-bit arch builds it is noticed as a warning.
> > > 
> > > * arm, build
> > >   - clang-19-allmodconfig
> > > 
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > 
> > > Build warning / error:
> > > -----------
> > > fs/udf/namei.c:747:12: error: stack frame size (1560) exceeds limit
> > > (1280) in 'udf_rename' [-Werror,-Wframe-larger-than]
> > >   747 | static int udf_rename(struct user_namespace *mnt_userns,
> > > struct inode *old_dir,
> > >       |            ^
> > > 1 error generated.
> > 
> > Odd that this isn't seen in newer kernels, any chance you can bisect?
> 
> Glancing over the commits in stable-rc it seems the series is missing
> commit 0aba4860b0d021 ("udf: Allocate name buffer in directory iterator on
> heap").

Thanks, I'll go queue that up now.

greg k-h
