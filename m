Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A27EC44C85
	for <patches@lists.linux.dev>; Sun, 28 Apr 2024 12:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.107.17.57
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714308127; cv=none; b=YRkw7AN1GKrWF4oAfHcv4D6AdMOJM+K/uwSoG0DbwKKgDcFyNOtS4DSLuT3tUtY3Dp1fQ0LegwuCl0pU73GCpwwzggoP2eBXCrBiEVnYQQ4kgVcGybmcBDwiuc/ZSQy53WoYibrGtbJh3my2L54xO1vuw6Z7zcPpSm/QC2DAHKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714308127; c=relaxed/simple;
	bh=4rJ79cL03WI0ASPd54J4EunuDnXh6e35XgFDhwgi+No=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfgAaAVC8tGQjvssWK0LYITSoxnvGsZtRawrRfT7usbU8uFamAPNYy8CXOB4qMyns5rOf4JcLVcLHyBxxyLLb2atXut+E8+qnndojJisC5xpIVLOjgkxbN/ShKzllZQodi/kmQxevfe+CJD8l25Tb81tTC5e6MA0Nhmouiqu1CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=194.107.17.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
	by vmicros1.altlinux.org (Postfix) with ESMTP id D8F7C72C8FB;
	Sun, 28 Apr 2024 15:32:55 +0300 (MSK)
Received: from pony.office.basealt.ru (unknown [193.43.10.9])
	by imap.altlinux.org (Postfix) with ESMTPSA id C414836D016B;
	Sun, 28 Apr 2024 15:32:55 +0300 (MSK)
Received: by pony.office.basealt.ru (Postfix, from userid 500)
	id 9978D360B980; Sun, 28 Apr 2024 15:32:55 +0300 (MSK)
Date: Sun, 28 Apr 2024 15:32:55 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: Re: [PATCH 6.1 000/141] 6.1.88-rc1 review
Message-ID: <3yj4eo4ww6wfz4ggaurutemobxi7pwdg7gctnhmwytalimpdcz@hve522lspsdv>
References: <20240423213853.356988651@linuxfoundation.org>
 <CA+G9fYuv0nH3K9BJTmJyxLXxvKQjh91KdUi4yjJ0ewncW5cSjw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYuv0nH3K9BJTmJyxLXxvKQjh91KdUi4yjJ0ewncW5cSjw@mail.gmail.com>

Greg,

On Wed, Apr 24, 2024 at 01:53:35PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Apr 2024 at 03:14, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.88 release.
> > There are 141 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.88-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> As Pavel reported,
> 
> LKFT also found these regressions on 6.1.
> 
> The arm build failed with gcc-13 and clang-17 on the Linux stable-rc
> linux.6.1.y branch.
> 
> arm:
>  * omap2plus_defconfig - failed
>  * defconfig  - failed
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

I'm curious why v6.1.88 is still released nevertheless the reports of the
build regression on ARM32.

Thanks,

> 
> Suspecting commit :
> -------
>   ASoC: ti: Convert Pandora ASoC to GPIO descriptors
>     [ Upstream commit 319e6ac143b9e9048e527ab9dd2aabb8fdf3d60f ]
> 
> Build log:
> ---
> arch/arm/mach-omap2/pdata-quirks.c:259:15: error: variable
> 'pandora_soc_audio_gpios' has initializer but incomplete type
>   259 | static struct gpiod_lookup_table pandora_soc_audio_gpios = {
>       |               ^~~~~~~~~~~~~~~~~~
> arch/arm/mach-omap2/pdata-quirks.c:260:10: error: 'struct
> gpiod_lookup_table' has no member named 'dev_id'
>   260 |         .dev_id = "soc-audio",
>       |          ^~~~~~
> arch/arm/mach-omap2/pdata-quirks.c:260:19: warning: excess elements in
> struct initializer
>   260 |         .dev_id = "soc-audio",
>       |                   ^~~~~~~~~~~
> arch/arm/mach-omap2/pdata-quirks.c:260:19: note: (near initialization
> for 'pandora_soc_audio_gpios')
> arch/arm/mach-omap2/pdata-quirks.c:261:10: error: 'struct
> gpiod_lookup_table' has no member named 'table'
>   261 |         .table = {
>       |          ^~~~~
> arch/arm/mach-omap2/pdata-quirks.c:261:18: error: extra brace group at
> end of initializer
>   261 |         .table = {
>       |                  ^
> arch/arm/mach-omap2/pdata-quirks.c:261:18: note: (near initialization
> for 'pandora_soc_audio_gpios')
> arch/arm/mach-omap2/pdata-quirks.c:262:17: error: implicit declaration
> of function 'GPIO_LOOKUP'; did you mean 'IOP_LOOKUP'?
> [-Werror=implicit-function-declaration]
>   262 |                 GPIO_LOOKUP("gpio-112-127", 6, "dac", GPIO_ACTIVE_HIGH),
>       |                 ^~~~~~~~~~~
>       |                 IOP_LOOKUP
> arch/arm/mach-omap2/pdata-quirks.c:262:55: error: 'GPIO_ACTIVE_HIGH'
> undeclared here (not in a function); did you mean 'ACPI_ACTIVE_HIGH'?
>   262 |                 GPIO_LOOKUP("gpio-112-127", 6, "dac", GPIO_ACTIVE_HIGH),
>       |                                                       ^~~~~~~~~~~~~~~~
>       |                                                       ACPI_ACTIVE_HIGH
> arch/arm/mach-omap2/pdata-quirks.c:264:17: error: extra brace group at
> end of initializer
>   264 |                 { }
>       |                 ^
> arch/arm/mach-omap2/pdata-quirks.c:264:17: note: (near initialization
> for 'pandora_soc_audio_gpios')
> arch/arm/mach-omap2/pdata-quirks.c:261:18: warning: excess elements in
> struct initializer
>   261 |         .table = {
>       |                  ^
> arch/arm/mach-omap2/pdata-quirks.c:261:18: note: (near initialization
> for 'pandora_soc_audio_gpios')
> arch/arm/mach-omap2/pdata-quirks.c: In function 'omap3_pandora_legacy_init':
> arch/arm/mach-omap2/pdata-quirks.c:271:9: error: implicit declaration
> of function 'gpiod_add_lookup_table'
> [-Werror=implicit-function-declaration]
>   271 |         gpiod_add_lookup_table(&pandora_soc_audio_gpios);
>       |         ^~~~~~~~~~~~~~~~~~~~~~
> arch/arm/mach-omap2/pdata-quirks.c: At top level:
> arch/arm/mach-omap2/pdata-quirks.c:259:34: error: storage size of
> 'pandora_soc_audio_gpios' isn't known
>   259 | static struct gpiod_lookup_table pandora_soc_audio_gpios = {
>       |                                  ^~~~~~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> make[3]: *** [scripts/Makefile.build:250:
> arch/arm/mach-omap2/pdata-quirks.o] Error 1
> 
> 
> steps to reproduce:
> ---
> # tuxmake --runtime podman --target-arch arm --toolchain gcc-13
> --kconfig omap2plus_defconfig
> 
> 
> Links
> ---
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2fWG4dRZzA7WgJqyLQ8Rm05WTUo/
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.87-142-gcde450ef0f2f/testrun/23640116/suite/build/test/gcc-13-omap2plus_defconfig/details/
> 
> --
> Linaro LKFT
> https://lkft.linaro.org
