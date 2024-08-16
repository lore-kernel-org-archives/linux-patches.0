Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23271304AB;
	Fri, 16 Aug 2024 09:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723801939; cv=none; b=pMofvIkCYGTr2Qh13Ixp1tuSn/LeGFuBJmUveCKl7UP01fIKOEfk6DO8yvr1AQd6agUMv7PfE8I+QZ9olhXes/NtMdBSMxPNYBgcWRAQyWDjrDa9x2kfBu2vFdu/VTvFaKSKVp1FuwiGEhbAHyGI5RHQTeWQLH9/dH0LyLv1UXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723801939; c=relaxed/simple;
	bh=0abDR47X1F5bNCDpDVpI73U3sF42dfY1UVk0OkpRzPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MfDgJH58AHB+P6SywI5idoPmWgL+1+djmkstvYGgsmqdL3XhIf/I6oglI63A7HOgfQMM6ZdiVVheWHb/XVOA+mDkmiDoKgRChgK4T6Bb5EwfMsw3JZXqOrMGULwn6lrEWszq8ZyEHvCT3Y9tPQpM1pwSLuTQxM+/++J+2KHb+Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPaundfR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPaundfR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E2FC32782;
	Fri, 16 Aug 2024 09:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723801938;
	bh=0abDR47X1F5bNCDpDVpI73U3sF42dfY1UVk0OkpRzPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fPaundfR/qdz87rS9TIhOwfUCKNS2Z4g61uIBI+m2I7E/OiplXQSJSzLlvJ/0BE1O
	 GZ/tDcL5XiQqouD9u6BCTxB52ZRMLSJEEHTnSvC8hisaG33DrNk5+MKVGkRMTBxyRD
	 PDjZ65kvvjAPp4tzk7QJpMHSxTY+cTUi2+9iJm1c=
Date: Fri, 16 Aug 2024 11:52:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Anders Roxell <anders.roxell@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: Re: [PATCH 5.4 000/259] 5.4.282-rc1 review
Message-ID: <2024081602-absence-preheated-eb57@gregkh>
References: <20240815131902.779125794@linuxfoundation.org>
 <CADYN=9+zo=R7jFdHGps0YedBqGzhjm7xeOZLsaR_E7-b0Y_CMQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADYN=9+zo=R7jFdHGps0YedBqGzhjm7xeOZLsaR_E7-b0Y_CMQ@mail.gmail.com>

On Fri, Aug 16, 2024 at 11:01:53AM +0200, Anders Roxell wrote:
> On Thu, 15 Aug 2024 at 16:12, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.4.282 release.
> > There are 259 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.282-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The following S390 build failed on stable-rc 5.4.y with gcc-12 due
> to following warnings and errors [1].
> 
> s390:
>   build:
>     * gcc-8-defconfig-fe40093d
>     * gcc-12-defconfig
> 
> Bisect point to deb23146ba03 ("s390/pci: fix CPU address in MSI for
> directed IRQ")
> as the problematic commit [ Upstream commit
> a2bd4097b3ec242f4de4924db463a9c94530e03a ].
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> ------
> /builds/linux/arch/s390/pci/pci_irq.c: In function 'zpci_set_irq_affinity':
> /builds/linux/arch/s390/pci/pci_irq.c:106:17: error: implicit
> declaration of function 'smp_cpu_get_cpu_address'; did you mean
> 'device_get_mac_address'? [-Werror=implicit-function-declaration]
>   int cpu_addr = smp_cpu_get_cpu_address(cpumask_first(dest));
>                  ^~~~~~~~~~~~~~~~~~~~~~~
>                  device_get_mac_address
> /builds/linux/arch/s390/pci/pci_irq.c: In function 'arch_setup_msi_irqs':
> /builds/linux/arch/s390/pci/pci_irq.c:298:2: error: implicit
> declaration of function 'msi_for_each_desc'; did you mean
> 'bus_for_each_dev'? [-Werror=implicit-function-declaration]
>   msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
>   ^~~~~~~~~~~~~~~~~
>   bus_for_each_dev
> /builds/linux/arch/s390/pci/pci_irq.c:298:37: error:
> 'MSI_DESC_NOTASSOCIATED' undeclared (first use in this function)
>   msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
>                                      ^~~~~~~~~~~~~~~~~~~~~~
> /builds/linux/arch/s390/pci/pci_irq.c:298:37: note: each undeclared
> identifier is reported only once for each function it appears in
> /builds/linux/arch/s390/pci/pci_irq.c:298:60: error: expected ';'
> before '{' token
>   msi_for_each_desc(msi, &pdev->dev, MSI_DESC_NOTASSOCIATED) {
>                                                             ^~

Thanks, will go drop the offending commits and push out a -rc2

greg k-h
