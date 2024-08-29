Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 439B819408D;
	Thu, 29 Aug 2024 14:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724941019; cv=none; b=E+z5EZCBCZXf9qa49HXo1tVmaPE40RD3d1At8qi7HPpJX2925l+DNJdvz2dMwK52bp2b04rEBi3oI4VOOddRMLgz9LIklOVfnisX4hbRdKfW+r/0PX48a5EVvukahZipyz+MC9oK88WrX9DmsU4BjVKfbomV4R4yieVJDP4DCRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724941019; c=relaxed/simple;
	bh=H1Sy8zDhuFc4KosKqXbRt7UVQn1wMjRQY3F8zjVzAgg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dy1bab0m4IXWJgnaAYiW+Crw7k+DeIBoX8QHjD9LtzVR3axcyHQ+FzVtYin4xREyZ5efnYaLuiqd8IrB2JOqi+QQUtikmvUNCzf4QQma767hhEkRYuSYt/MkDlCCAR/ENb5Ve3S8VOm2XJpu0cJtme+BS74hm2LwriJfHctp9gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fm+L39i3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fm+L39i3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D701C4CEC1;
	Thu, 29 Aug 2024 14:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724941018;
	bh=H1Sy8zDhuFc4KosKqXbRt7UVQn1wMjRQY3F8zjVzAgg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fm+L39i3ayBX+0RQfZNKJGBbXNdGdB3eXRoirEXrfuTc8qZ8Yma0NrcbPPmWNxf36
	 0/do9jy6SkRV3rO8o+bI3JOHYpoQIhBOkWSd+uw5U1jW90WFvB2lLX4f9yoZ6Jzmdm
	 v2rRVRGKuU/+4SWDu3xvnoYKPO7CEoOmzOZgS7Tk=
Date: Thu, 29 Aug 2024 16:16:55 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Zhen Lei <thunder.leizhen@huawei.com>
Subject: Re: [PATCH 6.6 000/341] 6.6.48-rc1 review
Message-ID: <2024082938-aqueduct-turbojet-4018@gregkh>
References: <20240827143843.399359062@linuxfoundation.org>
 <CA+G9fYuVcn734B-qqxYPKH++PtynJurhrhtBGLJhzhXoWo0sWQ@mail.gmail.com>
 <CA+G9fYs40THj+m4hWqV3ubYBPZaWQE44SXOUYYuU1T0x6R83Ng@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs40THj+m4hWqV3ubYBPZaWQE44SXOUYYuU1T0x6R83Ng@mail.gmail.com>

On Wed, Aug 28, 2024 at 10:59:41PM +0530, Naresh Kamboju wrote:
> On Wed, 28 Aug 2024 at 20:00, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 27 Aug 2024 at 20:12, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.48 release.
> > > There are 341 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.48-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > The tinyconfig builds failed for all architectures on 6.6.48-rc1.
> >
> > Builds
> >   - clang-18-tinyconfig
> >   - clang-nightly-tinyconfig
> >   - gcc-13-tinyconfig
> >   - gcc-8-tinyconfig
> 
> The bisection pointed to the following is the first bad commit,
> 
> bc2002c9d531dd4ad0241268c946abf074d2145d is the first bad commit
>     rcu: Dump memory object info if callback function is invalid
> 
>     [ Upstream commit 2cbc482d325ee58001472c4359b311958c4efdd1 ]

Thanks for tracking this down, I've fixed it up by adding a patch before
this one.

greg k-h
