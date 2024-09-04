Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D48219A280;
	Wed,  4 Sep 2024 09:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442184; cv=none; b=aDUqxyZZUytfsCDsbmhzJl2IXG+Qi2BxGrfhE+hlk8wEN3KsMr0ttFZIOkM6c//Rw83I5ASEVTRqo9/I3KoUi0i7qy42/fv3s/Lc/IsAZZ1Ef17rZZs32DiwHuT+bMbvr/yDXUcWwzWp2Fqp/Ml95xnuyY51B4MMhhlh7CFuYto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442184; c=relaxed/simple;
	bh=hbNlSjmK/Uz0cgICOymWuwgRMivBtn+074B4AI5cj5Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SiD7kcx2wpJ37OwfpTA21APjqhP/RlZe8U0OZl3UuZNwSKR/v89rBXLxGjfUmVJEnXNwV0+MqNrTLDqreKZIwMeAeHFOj24y/CyUiSvb08HV3CB3abCpoElD+dN4XNPyBj4QUmb0tDI62upQN/1t45R2/WAPdu8d52+x3KliiPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KjdO3q0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KjdO3q0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56488C4CEC2;
	Wed,  4 Sep 2024 09:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725442184;
	bh=hbNlSjmK/Uz0cgICOymWuwgRMivBtn+074B4AI5cj5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KjdO3q0bux1bMuGd9L3/VaGY/LNJ4JOlqxUtHee0l6yJDw7nQoP90K8jiTThJWCM7
	 VMQUWXIVbv+TIwFlW0lL+Hebv45Hqgy2mQ057EgagKsxqz682xy9VNtIlfAO9qNF4q
	 II8L8jF8Q2hP+TbtgKXYEfkAMMJAKSi4Jh73jUHA=
Date: Wed, 4 Sep 2024 11:29:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/151] 5.10.225-rc1 review
Message-ID: <2024090433-paramedic-unpaired-d90f@gregkh>
References: <20240901160814.090297276@linuxfoundation.org>
 <CA+G9fYuK+=YW6F+mBMeHAZoUrQQS6-AgAezRfQGEpZui4JUepg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuK+=YW6F+mBMeHAZoUrQQS6-AgAezRfQGEpZui4JUepg@mail.gmail.com>

On Mon, Sep 02, 2024 at 02:03:13PM +0530, Naresh Kamboju wrote:
> On Sun, 1 Sept 2024 at 22:20, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.225 release.
> > There are 151 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.225-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The Powerpc defconfig builds failed on Linux stable-rc due to following
> build warnings / errors with clang-18 and gcc-12.
> 
> This is a same problem on current stable-rc review on
>    - 5.4.283-rc1 review
>    - 5.10.225-rc1 review
>    - 5.15.166-rc1 review
> 
> In the case of stable-rc linux-5.10.y
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Anders bisected this to first bad commit id as,
>   fbdev: offb: replace of_node_put with __free(device_node)
>   [ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

Now dropped, thanks.

greg k-h
