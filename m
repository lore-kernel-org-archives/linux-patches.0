Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124BE20EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 08:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD2FC433D2;
	Thu, 16 Mar 2023 08:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678953752;
	bh=sCg7LY++8tSg2hrlbPjQpl0Er0nwVxgieBMOEu+U/As=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aLxmWmCa/LngmD3xlP3zeb0KUYTZ7rMzgDDADHHf1Q4JvNtgmI0sN/C4645s4xt7U
	 NFB1jLWtT56V6qRduvwM7zbi4EclGy8H5PAhKxavcQKY4kRNuqYSG2N1XBEd0Oey3k
	 h7hYu15oXiqIm3rIxNcpK9mGYXjZrAICNkJ6QcQU=
Date: Thu, 16 Mar 2023 09:02:30 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Message-ID: <ZBLNFrZmpOLvGJCb@kroah.com>
References: <20230315115740.429574234@linuxfoundation.org>
 <b97c4328-54fd-0461-5fa9-323a0d2ba1f4@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b97c4328-54fd-0461-5fa9-323a0d2ba1f4@linaro.org>

On Wed, Mar 15, 2023 at 09:21:53AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 06:11, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.20 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> > -------------
> 
> Build failures on PowerPC (GCC-8, GCC-12, Clang-16, Clang-nightly) on:
> * cell_defconfig
> * mpc83xx_defconfig
> 
> -----8<-----
> In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1253:
> /builds/linux/drivers/usb/host/ohci-ppc-of.c: In function 'ohci_hcd_ppc_of_probe':
> /builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (irq == NO_IRQ) {
>              ^~~~~~
>              NR_IRQS
> ----->8-----
> 
> 
> PowerPC with GCC-8 and GCC-12, for ppc6xx_defconfig:
> 
> -----8<-----
> /builds/linux/drivers/ata/pata_mpc52xx.c: In function 'mpc52xx_ata_probe':
> /builds/linux/drivers/ata/pata_mpc52xx.c:734:17: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (ata_irq == NO_IRQ) {
>                  ^~~~~~
>                  NR_IRQS
> /builds/linux/drivers/ata/pata_mpc52xx.c:734:17: note: each undeclared identifier is reported only once for each function it appears in
> make[4]: *** [/builds/linux/scripts/Makefile.build:250: drivers/ata/pata_mpc52xx.o] Error 1
> make[4]: Target 'drivers/ata/' not remade because of errors.
> make[3]: *** [/builds/linux/scripts/Makefile.build:500: drivers/ata] Error 2
> In file included from /builds/linux/drivers/usb/host/ehci-hcd.c:1321:
> /builds/linux/drivers/usb/host/ehci-ppc-of.c: In function 'ehci_hcd_ppc_of_probe':
> /builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (irq == NO_IRQ) {
>              ^~~~~~
>              NR_IRQS
> /builds/linux/drivers/usb/host/ehci-ppc-of.c:122:13: note: each undeclared identifier is reported only once for each function it appears in
> make[5]: *** [/builds/linux/scripts/Makefile.build:250: drivers/usb/host/ehci-hcd.o] Error 1
> In file included from /builds/linux/drivers/usb/host/ohci-hcd.c:1253:
> /builds/linux/drivers/usb/host/ohci-ppc-of.c: In function 'ohci_hcd_ppc_of_probe':
> /builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: error: 'NO_IRQ' undeclared (first use in this function); did you mean 'NR_IRQS'?
>   if (irq == NO_IRQ) {
>              ^~~~~~
>              NR_IRQS
> /builds/linux/drivers/usb/host/ohci-ppc-of.c:123:13: note: each undeclared identifier is reported only once for each function it appears in
> ----->8-----

Those all should be fixed in -rc2.

> 
> 
> PowerPC with GCC-8 and GCC-12, for ppc64e_defconfig:
> 
> -----8<-----
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crt0.o] Error 1
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:237: arch/powerpc/boot/crtsavres.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/cuboot.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:238: arch/powerpc/boot/div64.o] Error 1
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:234: arch/powerpc/boot/devtree.o] Error 1
> [...]
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_sw.o] Error 1
> powerpc64le-linux-gnu-gcc: error: missing argument to '-mcpu='
> make[2]: *** [/builds/linux/arch/powerpc/boot/Makefile:235: arch/powerpc/boot/fdt_wip.o] Error 1
> make[2]: Target 'arch/powerpc/boot/zImage' not remade because of errors.
> make[1]: *** [/builds/linux/arch/powerpc/Makefile:247: zImage] Error 2
> make[1]: Target '__all' not remade because of errors.
> make: *** [Makefile:238: __sub-make] Error 2
> make: Target '__all' not remade because of errors.
> ----->8-----

Odd, ok, I think I've fixed this one up as well now.

thanks

greg k-h
