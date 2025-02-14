Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D64188713;
	Fri, 14 Feb 2025 13:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739540200; cv=none; b=dvrT40OkX9c0nMfT8AtT7ZxBR7w5WTXTlVOrMTRAszdHnhG3uSzXFvBMEX7EKqv9Zj1wWnIjQFVTbSf7y78O/0VmKQT5BR3XVnzF6FlxD5fk5VqOGfJHTDQ137QWTLajbiwazdJ4g5fwAzgjpghfsCYIBGO0lWYEphwV+20OJYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739540200; c=relaxed/simple;
	bh=FDr/8w/Mw3nuq3cwDe/Ou4ZfyPI0cVa0KRi+7EQU1+E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFqEcMJlIwYSIcfwAv69lXeMap+WmRdmtvmg/FTVD8KyprWN6nIv9+mmnW2KwsAHFaBZUtoaNE8cE42lgpS4gllxWRO0WmYOuc+tB93DxyyhmOJijeTmNo8u/qko57q27MLVy95C//KSheYtE4+04gQKxESm8aToPYyvA81SXyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N6TcpxKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N6TcpxKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA414C4CED1;
	Fri, 14 Feb 2025 13:36:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739540200;
	bh=FDr/8w/Mw3nuq3cwDe/Ou4ZfyPI0cVa0KRi+7EQU1+E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N6TcpxKrT5q1N+gF0T8eLdLziDSqVXHtFsKWqBNVWcpL3oxB6G3xNeJ9nnKBpY+RQ
	 To3+iWBftYdZ1JB/hGJLJMmjM3twaNChc5FtVMWBctiblWdOOTMC2nJ5mpMMb9mPC0
	 YIU9pNrOXjEhYHzuLU0uSJJpFVduRNOwXLBM8bG4=
Date: Fri, 14 Feb 2025 14:36:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Darrick Wong <darrick.wong@oracle.com>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Darren Kenny <darren.kenny@oracle.com>
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
Message-ID: <2025021420-scouring-circus-5dac@gregkh>
References: <20250213142436.408121546@linuxfoundation.org>
 <c6c19838-dfa0-4e94-b7bd-1dd49449573b@oracle.com>
 <2025021418-provoke-trilogy-2d6e@gregkh>
 <f25f0369-bbcc-47e5-8668-ddc8177ea02c@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f25f0369-bbcc-47e5-8668-ddc8177ea02c@oracle.com>

On Fri, Feb 14, 2025 at 03:24:08PM +0530, Harshit Mogalapalli wrote:
> Hi Greg,
> 
> On 14/02/25 13:50, Greg Kroah-Hartman wrote:
> > On Fri, Feb 14, 2025 at 01:23:23PM +0530, Harshit Mogalapalli wrote:
> > > Hi,
> > > 
> > > 
> > > On 13/02/25 19:52, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.12.14 release.
> > > > There are 422 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > 
> > > I see these build failures:
> > > 
> > > fs/xfs/xfs_trans.c: In function '__xfs_trans_commit':
> > > fs/xfs/xfs_trans.c:843:40: error: macro "xfs_trans_apply_dquot_deltas"
> > > requires 2 arguments, but only 1 given
> > >    843 |         xfs_trans_apply_dquot_deltas(tp);
> > >        |                                        ^
> > > In file included from fs/xfs/xfs_trans.c:15:
> > > fs/xfs/xfs_quota.h:169:9: note: macro "xfs_trans_apply_dquot_deltas" defined
> > > here
> > >    169 | #define xfs_trans_apply_dquot_deltas(tp, a)
> > >        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > fs/xfs/xfs_trans.c:843:9: error: 'xfs_trans_apply_dquot_deltas' undeclared
> > > (first use in this function); did you mean 'xfs_trans_apply_sb_deltas'?
> > >    843 |         xfs_trans_apply_dquot_deltas(tp);
> > >        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >        |         xfs_trans_apply_sb_deltas
> > > fs/xfs/xfs_trans.c:843:9: note: each undeclared identifier is reported only
> > > once for each function it appears in
> > > make[4]: *** [scripts/Makefile.build:229: fs/xfs/xfs_trans.o] Error 1
> > > make[4]: *** Waiting for unfinished jobs....
> > > make[3]: *** [scripts/Makefile.build:478: fs/xfs] Error 2
> > > make[3]: *** Waiting for unfinished jobs....
> > > make[2]: *** [scripts/Makefile.build:478: fs] Error 2
> > > make[2]: *** Waiting for unfinished jobs....
> > > make[1]: *** [/builddir/build/BUILD/kernel-6.12.14/linux-6.12.14-master.20250214.el9.rc1/Makefile:1937:
> > > .] Error 2
> > > make: *** [Makefile:224: __sub-make] Error 2
> > > 
> > > 
> > > This commit: 91717e464c593 ("xfs: don't lose solo dquot update
> > > transactions") in the 6.12.14-rc1 is causing this.
> > 
> > Odd, I am guessing that you do not have CONFIG_XFS_QUOTA enabled?
> > 
> 
> I do have that enabled.
> 
> CONFIG_XFS_QUOTA=y

Odd, that didn't trip in my test builds :(

Anyway, now dropped, thanks!

greg k-h
