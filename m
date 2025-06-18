Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0045D1EDA26;
	Wed, 18 Jun 2025 13:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252760; cv=none; b=gSisdOyOmwlVwiUU8Ae8KpLW8JNaGi0rtDtKIJpYxY4XW5zli462rDCxqJkhLJyKoOlfNYgAr6sU0a0oCt7Qadi0Gi7vxhKy6k+gp5m30h4XEAMk5QvwWTZGyFlFjBKLNy1fho9IKCaOf8ouBaRdMNZUwh7x8dGpw+5M6Jq31Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252760; c=relaxed/simple;
	bh=yazIh7NKfaZXE4pU90+4eALmFMirOeimrbYE23sXx+A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ure7NzVdXMG/FwCVJyZeQifHTfXG3lLctF30FSl0bZI0qszf/qoi2fpFiljL6vQ8QZVrvINspELEFvZLIirHSlHkyrUNXzxPwzpOQtgyxeOhywkpazBrL+NLXseHIBO3lsHUCyQoUlfb+Y2pBTO83+rE6XDNO6Ysj/lAAefy30A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jEZmVs+F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jEZmVs+F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B761C4CEE7;
	Wed, 18 Jun 2025 13:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750252759;
	bh=yazIh7NKfaZXE4pU90+4eALmFMirOeimrbYE23sXx+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jEZmVs+FdSqcpXlWWnIGHErQ0wEcRACsKMEnd3vOjr0/P9S7o7NIYUrkM1l1BRoen
	 HOrzZLfN4a/75e98Axi628ZwCTHiWGFhOBlmH6VeDGHX9mWpqy6he1qyiVuK8zEKFi
	 0cwlrQoufnhr5N9qCbAnXYBZNq7UE4hbD9gfpaDw=
Date: Wed, 18 Jun 2025 15:19:11 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Message-ID: <2025061858-reproduce-revolving-cae0@gregkh>
References: <20250617152451.485330293@linuxfoundation.org>
 <cc048abb-fbc0-4a79-b78a-90bfa3f8446d@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cc048abb-fbc0-4a79-b78a-90bfa3f8446d@sirena.org.uk>

On Wed, Jun 18, 2025 at 12:58:00PM +0100, Mark Brown wrote:
> On Tue, Jun 17, 2025 at 05:15:08PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.15.3 release.
> > There are 780 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This breaks the build of the arm64 selftests due to a change in nolibc,
> it appears that "tools/nolibc: properly align dirent buffer" is missing
> some dependency:
> 
> aarch64-linux-gnu-gcc -fno-asynchronous-unwind-tables -fno-ident -s -Os -nostdlib \
> 	-include ../../../../include/nolibc/nolibc.h -I../..\
> 	-static -ffreestanding -Wall za-fork.c /build/stage/build-work/kselftest/arm64/fp/za-fork-asm.o -o /build/stage/build-work/kselftest/arm64/fp/za-fork
> In file included from ./../../../../include/nolibc/nolibc.h:107,
>                  from <command-line>:
> ./../../../../include/nolibc/dirent.h: In function ‘readdir_r’:
> ./../../../../include/nolibc/dirent.h:62:64: error: expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before ‘__nolibc_aligned_as’
>    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
>       |                                                                ^~~~~~~~~~~~~~~~~~~
> ./../../../../include/nolibc/dirent.h:62:64: error: implicit declaration of function ‘__nolibc_aligned_as’ [-Wimplicit-function-declaration]
> ./../../../../include/nolibc/dirent.h:62:84: error: expected expression before ‘struct’
>    62 |         char buf[sizeof(struct linux_dirent64) + NAME_MAX + 1] __nolibc_aligned_as(struct linux_dirent64);
>       |                                                                                    ^~~~~~
> ./../../../../include/nolibc/dirent.h:63:47: error: ‘buf’ undeclared (first use in this function)
>    63 |         struct linux_dirent64 *ldir = (void *)buf;
>       |                                               ^~~
> ./../../../../include/nolibc/dirent.h:63:47: note: each undeclared identifier is reported only once for each function it appears in

Thanks for the report, I'll go drop all nolibc patches from the queues
for now.

greg k-h

