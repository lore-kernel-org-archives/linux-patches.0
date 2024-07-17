Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C8D182B9;
	Wed, 17 Jul 2024 06:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721197467; cv=none; b=XM/08XFiwdiJraRXyiuBlkEevmlK+Ka/a/gfxJU6FuZTfQgkIopZtKFpwnPm7u/m2OzcMrPMZlyvV6v+ooRBilhH9yBw/NWB5ehKJ66E+0WIvtni77sZfIqXInVFshFt13junjlxMxmEUPYpiLNzgbGtOZpMC9GZI5Ep3NQa+a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721197467; c=relaxed/simple;
	bh=RdbzDXJzGn73GVJApCxOgvtdvQRZ69jsEk+ZWOuXZ0E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u0qNdIZjGvmho2WPLMExIcfwLs6uMQOicG3oWJ799EjEBQ0Taozepql2rqbA/CAwTSCle1VsJup++0GOAhtM/zFLZeXc7fXr8MfoIm9PuvNQx6gcRL37mWWB0PbuUnfWElNjVpUojULx3os9/d0tqoVY/paRA6FxnyIxa8kwbw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7h37oqy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7h37oqy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3101AC32782;
	Wed, 17 Jul 2024 06:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721197466;
	bh=RdbzDXJzGn73GVJApCxOgvtdvQRZ69jsEk+ZWOuXZ0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c7h37oqyeaqjsB5VzBL/uK+JriHqGPmA7682SWLa2sA1cOGRBAJmH+eZ0zfZ2iHiW
	 TcFtJ5A4wRIs4v4+wrFPBGYjRGUhXGgkIbs2yHeIX4TJtfD7MiPa+53jj5nXuruO7s
	 Ec+U/Os1B5XfRslgdjFKTAVRFVm3dR+FjFo2YQDI=
Date: Wed, 17 Jul 2024 08:24:23 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/96] 6.1.100-rc1 review
Message-ID: <2024071701-boned-drove-1269@gregkh>
References: <20240716152746.516194097@linuxfoundation.org>
 <aaccd8cc-2bfe-4b2e-b690-be50540f9965@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaccd8cc-2bfe-4b2e-b690-be50540f9965@gmail.com>

On Tue, Jul 16, 2024 at 11:42:39AM -0700, Florian Fainelli wrote:
> On 7/16/24 08:31, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.100 release.
> > There are 96 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 18 Jul 2024 15:27:21 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.100-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Commit acbfb53f772f96fdffb3fba2fa16eed4ad7ba0d2 ("cifs: avoid dup prefix
> path in dfs_get_automount_devname()") causes the following build failure on
> bmips_stb_defconfig:
> 
> In file included from ./include/linux/build_bug.h:5,
>                  from ./include/linux/container_of.h:5,
>                  from ./include/linux/list.h:5,
>                  from ./include/linux/module.h:12,
>                  from fs/smb/client/cifsfs.c:13:
> fs/smb/client/cifsproto.h: In function 'dfs_get_automount_devname':
> fs/smb/client/cifsproto.h:74:22: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   if (unlikely(!server->origin_fullpath))
>                       ^~
> ./include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>  # define unlikely(x) __builtin_expect(!!(x), 0)
>                                           ^
> In file included from fs/smb/client/cifsfs.c:35:
> fs/smb/client/cifsproto.h:78:14: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>         server->origin_fullpath,
>               ^~
> fs/smb/client/cifsproto.h:79:21: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>         strlen(server->origin_fullpath),
>                      ^~
> fs/smb/client/cifsproto.h:88:21: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   len = strlen(server->origin_fullpath);
>                      ^~
> fs/smb/client/cifsproto.h:93:18: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   memcpy(s, server->origin_fullpath, len);
>                   ^~
> In file included from ./include/linux/build_bug.h:5,
>                  from ./include/linux/container_of.h:5,
>                  from ./include/linux/list.h:5,
>                  from ./include/linux/wait.h:7,
>                  from ./include/linux/wait_bit.h:8,
>                  from ./include/linux/fs.h:6,
>                  from fs/smb/client/cifs_debug.c:8:
> fs/smb/client/cifsproto.h: In function 'dfs_get_automount_devname':
> fs/smb/client/cifsproto.h:74:22: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   if (unlikely(!server->origin_fullpath))
>                       ^~
> ./include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
>  # define unlikely(x) __builtin_expect(!!(x), 0)
>                                           ^
> In file included from fs/smb/client/cifs_debug.c:16:
> fs/smb/client/cifsproto.h:78:14: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>         server->origin_fullpath,
>               ^~
> fs/smb/client/cifsproto.h:79:21: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>         strlen(server->origin_fullpath),
>                      ^~
> fs/smb/client/cifsproto.h:88:21: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   len = strlen(server->origin_fullpath);
>                      ^~
> fs/smb/client/cifsproto.h:93:18: error: 'struct TCP_Server_Info' has no
> member named 'origin_fullpath'
>   memcpy(s, server->origin_fullpath, len);
>                   ^~
> host-make[6]: *** [scripts/Makefile.build:250: fs/smb/client/cifsfs.o] Error
> 1
> host-make[6]: *** Waiting for unfinished jobs....

Ugh, this was because I had to add a fixup patch for a different patch
here.  I'll go drop both of them for now, thanks.

greg k-h
