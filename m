Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726801FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 10:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD55CC433EF;
	Tue, 17 Jan 2023 10:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673950567;
	bh=dR7qjIIVRbYazvMmMxGCs47GM4Gnhrj2RGb3TbXFphc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kN4e5rFpIUwh/OsYkUvK1DGM20Yt0lDq4YaqzsCaSxja4iHHmNxvVUdgN+15NQ+y+
	 Ibgc3ygNvUynuraztV8+lqksTtGgLbZNzMnL4qYooeP2hgv9HPyaZER97wxt+ak8Sz
	 B5AB6Ay3Qyy+KSY5P1kiWxVKTe4TNDVFR6E32Yrg=
Date: Tue, 17 Jan 2023 10:32:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
Message-ID: <Y8ZrIb3sdTUqbt3t@kroah.com>
References: <20230116154743.577276578@linuxfoundation.org>
 <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>

On Mon, Jan 16, 2023 at 12:58:35PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Mon, 16 Jan 2023 at 10:06, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.164 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.164-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Preliminarily,
> 
> | /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
> | /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr'
> undeclared (first use in this function); did you mean 'idr'?
> |   427 |         if (!isr)
> |       |              ^~~
> |       |              idr
> 
> It's currently failing for arm, arm64, (not i386) and x86, with GCC 8,
> 10, 11, 12; Clang 15 and nightly. We'll test the extended set of
> architectures and update momentarily.

Thanks for the report, now fixed up in my tree, I'll push out a new -rc2
later today with it.

greg k-h
