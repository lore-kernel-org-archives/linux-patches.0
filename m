Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443753612D;
	Wed,  4 Sep 2024 09:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725442267; cv=none; b=iXXFpse/IyP8wq999KHYglY42DpGXdcUAdEV6HSBR+XZAHnz4TkmqnoM/EytSHz1AK7NyEnIhn+DbpVrAQl0G0NDwWlqRUrbfRD22gHHLkzQJ8aIZ4ELzzQLdNalL8wkLW1kc0S+ipgta/gfFfHmSoOWHTsA0c/Rk7yj/i1xdj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725442267; c=relaxed/simple;
	bh=RaE29n79blFA/4iDD8e+Sf4gFGcJ5PCPJdwdFc+uvgU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=he5Y7E5wd6XSjsmkpq4WD66dDZIGVTcY5sCSve7x1sIBrAanPxCA7dmUTm7lVo2fFdlHOdcgxcnJNwylJshWJE8maejDzB1zDHSUJOHojWO/gyGHAsZuA1COHyT7mZbeSrx6tXCHvTeLB1PNuZfvn5d7S/IkwIOEtblJSSUCqdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HpmUKv5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HpmUKv5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39159C4CEC6;
	Wed,  4 Sep 2024 09:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725442266;
	bh=RaE29n79blFA/4iDD8e+Sf4gFGcJ5PCPJdwdFc+uvgU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HpmUKv5zuP9DIHiqlN+puPnPHhjGAIU3JHVGffOun7lc4+CaDy0jbFN8gmL8rNB3u
	 VrhNpIeMloJ+Oeh/ppjcas2nvaLZa8jLMue3psD3Q6IGOASN93+leeuXV9FNtr04oB
	 DxPs6LIEFDonLb5u1bYUfbMUwPMDWe1R4cWdMtis=
Date: Wed, 4 Sep 2024 11:31:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	abdulrasaqolawani@gmail.com, Helge Deller <deller@gmx.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 5.15 000/215] 5.15.166-rc1 review
Message-ID: <2024090455-gag-carving-018f@gregkh>
References: <20240901160823.230213148@linuxfoundation.org>
 <CA+G9fYu3+16JcZbAJY0SXoqnMDOMXr8S136Zb4ONh7WpD-5-Hw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYu3+16JcZbAJY0SXoqnMDOMXr8S136Zb4ONh7WpD-5-Hw@mail.gmail.com>

On Mon, Sep 02, 2024 at 02:01:22PM +0530, Naresh Kamboju wrote:
> On Sun, 1 Sept 2024 at 22:29, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.166 release.
> > There are 215 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.166-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
> In the case of stable-rc linux-5.15.y
> 
> first seen on 36422b23d6d0243e79a6ddc085f8301454ea5291.
>   Good: v5.15.164-480-g2a66d0cb3772
>   BAD:  v5.15.165-216-g36422b23d6d0
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Anders bisected this to first bad commit id as,
>   fbdev: offb: replace of_node_put with __free(device_node)
>   [ Upstream commit ce4a7ae84a58b9f33aae8d6c769b3c94f3d5ce76 ]

Now dropped, thanks.

greg k-h
