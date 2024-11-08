Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E911D2F54;
	Fri,  8 Nov 2024 07:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731052252; cv=none; b=JqHP7E2acvCOti/UI7SOz5ydpHHwMbVC521mwN04crdSkEteVWBMLvMPZoe3SbQtHV+fyn7nL7U/uTfYQmqXwCRChrrXULC94NvMKaXNgyjDv0LlIdD7Xfepz/+OoylHLZR8lijpXaxU32vksccquHj/dKu1aTHnccitrOC3Icc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731052252; c=relaxed/simple;
	bh=PidCOc5vam5FIUslcJaLD9YUGnOw3EfiaT/M3s5atqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hnyZdV9TX53hzfWc/cBdNL6yYwoyeRMED3IpQk2tttuXrUIYDIjSoIBBYy09W5bJeFPds2xFyVIUHzfZrleZTbVBWdlG7guRZD2IBlW+LRgFDqFd/aGOQcpP0I2y5HdcAwhXahVvg3uRJt1ZKiKU3PEuy6Wyc1/Wowi0cHFnF7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QdBYMvYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QdBYMvYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558AFC4CECE;
	Fri,  8 Nov 2024 07:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731052251;
	bh=PidCOc5vam5FIUslcJaLD9YUGnOw3EfiaT/M3s5atqk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QdBYMvYq4Jbk51kd714CXMpJdgnw3V2SYQDUcIzQspywKEJQEdo+y+CSDIow1AEUc
	 OywSSlv45J8DHb6AH/LqP3z1ddfzU+PhIr33lGY+yXmGchC61vgxPCE/AVsKuESlRC
	 Angg1LHb4c6FXoNvDyTKWIdYB/dwnDdTV4LnDdig=
Date: Fri, 8 Nov 2024 08:50:49 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hagar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.4 000/461] 5.4.285-rc2 review
Message-ID: <2024110817-ozone-tanning-0df8@gregkh>
References: <20241107063341.146657755@linuxfoundation.org>
 <05671820-dee5-4b31-b585-5e1f034e65f6@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05671820-dee5-4b31-b585-5e1f034e65f6@gmail.com>

On Thu, Nov 07, 2024 at 08:39:39AM -0800, Florian Fainelli wrote:
> 
> 
> On 11/6/2024 10:47 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.285 release.
> > There are 461 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 09 Nov 2024 06:32:59 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.285-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on
> BMIPS_GENERIC:
> 
> Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
> 
> There are however new build warnings, on 32-bit:
> 
> In file included from ./include/linux/mm.h:29,
>                  from ./include/linux/pagemap.h:8,
>                  from ./include/linux/buffer_head.h:14,
>                  from fs/udf/udfdecl.h:12,
>                  from fs/udf/inode.c:32:
> fs/udf/inode.c: In function 'udf_current_aext':
> ./include/linux/overflow.h:61:22: warning: comparison of distinct pointer
> types lacks a cast
>    61 |         (void) (&__a == __d);                   \
>       |                      ^~
> fs/udf/inode.c:2202:21: note: in expansion of macro 'check_add_overflow'
>  2202 |                 if (check_add_overflow(sizeof(struct allocExtDesc),
>       |                     ^~~~~~~~~~~~~~~~~~
> 
> 
> On 64-bit:
> 
> fs/udf/inode.c: In function 'udf_current_aext':
> ./include/linux/overflow.h:60:15: warning: comparison of distinct pointer
> types lacks a cast
>   (void) (&__a == &__b);   \
>                ^~
> fs/udf/inode.c:2202:7: note: in expansion of macro 'check_add_overflow'
>    if (check_add_overflow(sizeof(struct allocExtDesc),
>        ^~~~~~~~~~~~~~~~~~
> ./include/linux/overflow.h:61:15: warning: comparison of distinct pointer
> types lacks a cast
>   (void) (&__a == __d);   \
>                ^~
> fs/udf/inode.c:2202:7: note: in expansion of macro 'check_add_overflow'
>    if (check_add_overflow(sizeof(struct allocExtDesc),
>        ^~~~~~~~~~~~~~~~~~
> 
> In file included from ./include/linux/mm.h:29,
>                  from ./include/linux/pagemap.h:8,
>                  from ./include/linux/buffer_head.h:14,
>                  from fs/udf/udfdecl.h:12,
>                  from fs/udf/super.c:41:
> fs/udf/super.c: In function 'udf_fill_partdesc_info':
> ./include/linux/overflow.h:60:15: warning: comparison of distinct pointer
> types lacks a cast
>   (void) (&__a == &__b);   \
>                ^~
> fs/udf/super.c:1162:7: note: in expansion of macro 'check_add_overflow'
>    if (check_add_overflow(map->s_partition_len,
>        ^~~~~~~~~~~~~~~~~~

Yes, this is due to commit d219d2a9a92e ("overflow: Allow mixed type
arguments") not being backported to 5.4 and 5.10.y trees.  If people
want to see these warnings removed, perhaps someone can provide a
working backport of this commit :)

thanks,

greg k-h
