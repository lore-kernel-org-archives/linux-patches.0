Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6DC20EB
	for <patches@lists.linux.dev>; Sat,  3 Jun 2023 14:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98DAC433EF;
	Sat,  3 Jun 2023 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685802967;
	bh=B+VdiPG1FamBWIcbL30jkM0gvYJcncxHC7Q7s8oufQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0jY4nmSgiELJKYg4YCDn9bXebdz06ax8y8CzYZvrdNYupY+uwwQtxj67CJgz3d4pY
	 EsrI/O6jlYkqzgwFoQYxVqXPvny7sCRSm8MSEdZd1gjT3F3E/b14yvabxfPuq0kASa
	 zTU0z2EdtQwg1tfPBt3WveI8rK4kSk0/OGgnRkCE=
Date: Sat, 3 Jun 2023 16:36:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
Message-ID: <2023060350-mountable-deploy-09bd@gregkh>
References: <20230601143331.405588582@linuxfoundation.org>
 <CAEUSe7-qcYwBbeFGKAOvf-rPMdgAMfE6t42Urnhjam9nWN-gFg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe7-qcYwBbeFGKAOvf-rPMdgAMfE6t42Urnhjam9nWN-gFg@mail.gmail.com>

On Thu, Jun 01, 2023 at 10:17:48PM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Thu, 1 Jun 2023 at 08:36, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.115 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 03 Jun 2023 14:33:22 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.115-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Build failures on System/390:
> -----8<-----
>   /builds/linux/arch/s390/kernel/uv.c: In function
> 'should_export_before_import':
>   /builds/linux/arch/s390/kernel/uv.c:204:40: error: 'mm_context_t'
> has no member named 'protected_count'
>     204 |         return atomic_read(&mm->context.protected_count) > 1;
>         |                                        ^
>   /builds/linux/arch/s390/kernel/uv.c:205:1: error: control reaches
> end of non-void function [-Werror=return-type]
>     205 | }
>         | ^
> ----->8-----
> 
> That's with defconfig and GCC-8, GCC-12, Clang-16.

Thanks, I've dropped the broken patches now and will push out a -rc3.

greg k-h
