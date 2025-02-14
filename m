Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2FD2222A9;
	Fri, 14 Feb 2025 08:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739521242; cv=none; b=lns4CbaNm5tH2DZOcvtIjEvMlZxLXBwwpuhWHykYVnwEXSfGFTWN+0exoJyQG8D2b7KOg1P6Dqia5kqUdKEcIwXvck6jGHHs7G0TvK30jiMLHCQgC68StXMswn7GwDWTVu6uoovqrz2dAveJuThX5A9xKpytkVp4sipPcbcjUR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739521242; c=relaxed/simple;
	bh=nLdxEF3kZeijles7ZTO7jwOe50bQ9rS9IR16ifcC8ms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pj6xt58t2Xr0mqjutNvWXKHio3LVWqobOdbkyt/xRNyUSIn9olb5KFx3f3IwVbVe7dldGcP57wMrZaKu5hF3hHACwe52MQbSrEV6f2P8NfRJ1+X6gOFyygIQmRwYxydcZa0+rpfG48WsONNsFhCO31HEe1TJrP+ZtB0gMxPvf3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHj0fMLO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHj0fMLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0764C4CED1;
	Fri, 14 Feb 2025 08:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739521240;
	bh=nLdxEF3kZeijles7ZTO7jwOe50bQ9rS9IR16ifcC8ms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHj0fMLOaKquWrSjQBq0eZYV/q1DIy7zSuFm9PqY5IsQp7hZEAIOohL8qi65jk5Ov
	 W7lxk+evthkzyPHnFNyta1yH8AJyhuaxGNKhsms/YCOSvU1jwF/KgIVvqskg1edE8c
	 yfU4nw6kQgNV4hU+FT8dEGns021NVRs5UUR970Uw=
Date: Fri, 14 Feb 2025 09:20:37 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Darrick Wong <darrick.wong@oracle.com>
Subject: Re: [PATCH 6.12 000/422] 6.12.14-rc1 review
Message-ID: <2025021418-provoke-trilogy-2d6e@gregkh>
References: <20250213142436.408121546@linuxfoundation.org>
 <c6c19838-dfa0-4e94-b7bd-1dd49449573b@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6c19838-dfa0-4e94-b7bd-1dd49449573b@oracle.com>

On Fri, Feb 14, 2025 at 01:23:23PM +0530, Harshit Mogalapalli wrote:
> Hi,
> 
> 
> On 13/02/25 19:52, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.12.14 release.
> > There are 422 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> I see these build failures:
> 
> fs/xfs/xfs_trans.c: In function '__xfs_trans_commit':
> fs/xfs/xfs_trans.c:843:40: error: macro "xfs_trans_apply_dquot_deltas"
> requires 2 arguments, but only 1 given
>   843 |         xfs_trans_apply_dquot_deltas(tp);
>       |                                        ^
> In file included from fs/xfs/xfs_trans.c:15:
> fs/xfs/xfs_quota.h:169:9: note: macro "xfs_trans_apply_dquot_deltas" defined
> here
>   169 | #define xfs_trans_apply_dquot_deltas(tp, a)
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> fs/xfs/xfs_trans.c:843:9: error: 'xfs_trans_apply_dquot_deltas' undeclared
> (first use in this function); did you mean 'xfs_trans_apply_sb_deltas'?
>   843 |         xfs_trans_apply_dquot_deltas(tp);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |         xfs_trans_apply_sb_deltas
> fs/xfs/xfs_trans.c:843:9: note: each undeclared identifier is reported only
> once for each function it appears in
> make[4]: *** [scripts/Makefile.build:229: fs/xfs/xfs_trans.o] Error 1
> make[4]: *** Waiting for unfinished jobs....
> make[3]: *** [scripts/Makefile.build:478: fs/xfs] Error 2
> make[3]: *** Waiting for unfinished jobs....
> make[2]: *** [scripts/Makefile.build:478: fs] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [/builddir/build/BUILD/kernel-6.12.14/linux-6.12.14-master.20250214.el9.rc1/Makefile:1937:
> .] Error 2
> make: *** [Makefile:224: __sub-make] Error 2
> 
> 
> This commit: 91717e464c593 ("xfs: don't lose solo dquot update
> transactions") in the 6.12.14-rc1 is causing this.

Odd, I am guessing that you do not have CONFIG_XFS_QUOTA enabled?

thanks,

greg k-h
