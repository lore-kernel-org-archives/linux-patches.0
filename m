Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C321CD2A;
	Wed, 17 Jul 2024 09:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721208615; cv=none; b=LjXu8QqWUPQs/9TP2eSusZVEzEgAcKPs6Uh00v9DgIu+FDMhkPAX1jC8hKCivnSoAE8MRAVdC1U7EU5H30f6py1zypR3hk6hfpmL8Uyq/ENaI5HltqHlaxA/TR0YTAVg0cjDUqm7yZnCTaKlHGX2PpU+0Im2qtcO/WyjWzBWF1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721208615; c=relaxed/simple;
	bh=PK6aB2zg7+EqfBEFGLERVlGnVJwa/HTrTYn80atgCgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZSd/gprhi7pvnhOUuZ0R5ggrjSVVZSQ0ONr1ig0+2RowfKxPJHd3nkxZak98Og5mulDEnmaKGkLK01YWudV4/HlbiZCC37ex0JxKKjIf9WJBRGCwmzmaFurFo0HiPROPColJVmj/HThEcPx9TOoCOTn9WNxhKXuqDkxK559pkPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wu+Zfl6P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wu+Zfl6P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5439C32782;
	Wed, 17 Jul 2024 09:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721208615;
	bh=PK6aB2zg7+EqfBEFGLERVlGnVJwa/HTrTYn80atgCgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wu+Zfl6PeZDlAmSIUdyuD6DqXeLvWGoKJ2zEBUmaPdY+mrC5UNrBXz8e0JP7jsN5J
	 fxMWylaTLjMSGRz9oIoG2YVwaLr+1MXFruwUEWvnOnY7Oi3ckC5SGNo+J8qW6BO70M
	 vayq8jtESGg6L5nsh36J4dkxg52djhqJg/0KimZ4=
Date: Wed, 17 Jul 2024 11:30:07 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Frank Scheiner <frank.scheiner@web.de>
Cc: akpm@linux-foundation.org, allen.lkml@gmail.com, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	=?utf-8?B?VG9tw6HFoQ==?= Glozar <tglozar@gmail.com>
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc1 review
Message-ID: <2024071700-precision-basin-0e6e@gregkh>
References: <20240716152738.161055634@linuxfoundation.org>
 <01082e96-8c2e-4ebe-8030-6e308a03f9e5@web.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01082e96-8c2e-4ebe-8030-6e308a03f9e5@web.de>

On Wed, Jul 17, 2024 at 10:54:40AM +0200, Frank Scheiner wrote:
> Hi there,
> 
> fb3739759474d150a9927b920a80ea2afb4c2a51 (from mainline) should be
> included in linux-4.19.y, if a589979f345720aca32ff43a2ccaa16a70871b9e
> stays in.

I do not know what commit a589979f345720aca32ff43a2ccaa16a70871b9e is,
sorry.  If you rea referring to commits in the -rc tree, please don't as
that tree is rebased and regenerated all the time.  In fact, my scripts
don't even save a local copy when they are generated so I have no idea
how to find this :(

Please refer to the commit id in Linus's tree so I have a hint as to
what is happening here.

> ****
> 
> ## Long version ##
> 
> It looks like:
> 
> ```
> hpet: Support 32-bit userspace
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-4.19.y&id=a589979f345720aca32ff43a2ccaa16a70871b9e
> ```

Ah, you mean commit 4e60131d0d36 ("hpet: Support 32-bit userspace"),
right?

> ...breaks the non-HP-Sim ia64 build ([1]) for us since yesterday:
> 
> ```
> [...]
> drivers/char/hpet.c: In function 'hpet_read':
> drivers/char/hpet.c:311:36: error: 'compat_ulong_t' undeclared (first
> use in this function)
>   311 |                 if (count < sizeof(compat_ulong_t))
>       |                                    ^~~~~~~~~~~~~~
> drivers/char/hpet.c:311:36: note: each undeclared identifier is reported
> only once for each function it appears in
> [...]
> ```
> 
> ...as it uses a type not known to ia64 (and possibly other
> architectures) w/o also including:
> 
> ```
> asm-generic: Move common compat types to asm-generic/compat.h
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=fb3739759474d150a9927b920a80ea2afb4c2a51
> ```
> 
> The latter seems to be in mainline only since v4.20-rc1 and fixes the
> non-HP-Sim ia64 build ([2]) for me.
> 
> So fb3739759474d150a9927b920a80ea2afb4c2a51 should be included in
> linux-4.19.y, too, if a589979f345720aca32ff43a2ccaa16a70871b9e stays in.

Ok, I'll queue this one up as well, hopefully nothing else breaks...

thanks,

greg k-h
