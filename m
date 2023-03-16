Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3A4320EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 07:48:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC7C5C433D2;
	Thu, 16 Mar 2023 07:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678952894;
	bh=fLaU07I4+Dr+CjI8srUoR/4EE9CrXJQmJo1hE3fZPOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1kARIgAdv9SDQZsdQIg/nEsHEn29mkOrOElRF4I3G6vKFv3/3U6qRZgtoK71dMOqO
	 9USdwRyMofz+OEwJd06ntwbi1RnT67nxrkmFP4iC96Cv1iGy+/bpSxUv7gvTrHJV2P
	 7vWM+rQTnVJNZ79MNOX2gndrwauTcaO0taOc3cj8=
Date: Thu, 16 Mar 2023 08:48:12 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.19 00/39] 4.19.278-rc1 review
Message-ID: <ZBLJvEUfuwvg24Yy@kroah.com>
References: <20230315115721.234756306@linuxfoundation.org>
 <7e46d536-cc68-4b7c-e56e-cf1b94a925cb@linaro.org>
 <c3b1918b-be90-0a85-6f91-83b2c2805f67@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3b1918b-be90-0a85-6f91-83b2c2805f67@linaro.org>

On Wed, Mar 15, 2023 at 10:28:15AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On 15/03/23 09:44, Daniel Díaz wrote:
> > Hello!
> > 
> > On 15/03/23 06:12, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 4.19.278 release.
> > > There are 39 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.278-rc1.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Lots and lots of failures, mostly Arm.
> > 
> > For Arm, Arm64, MIPS, with GCC-8, GCC-9, GCC-10, GCC-11, GCC-12, Clang-16, for some combinations with:
> > * axm55xx_defconfig
> > * davinci_all_defconfig
> > * defconfig
> > * defconfig-40bc7ee5
> > * lkftconfig-kasan
> > * multi_v5_defconfig
> > * s5pv210_defconfig
> > * sama5_defconfig
> > 
> > -----8<-----
> > /builds/linux/kernel/cgroup/cgroup.c:2237:2: error: implicit declaration of function 'get_online_cpus' [-Werror,-Wimplicit-function-declaration]
> >          get_online_cpus();
> >          ^
> > /builds/linux/kernel/cgroup/cgroup.c:2237:2: note: did you mean 'get_online_mems'?
> > /builds/linux/include/linux/memory_hotplug.h:258:20: note: 'get_online_mems' declared here
> > static inline void get_online_mems(void) {}
> >                     ^
> > /builds/linux/kernel/cgroup/cgroup.c:2248:2: error: implicit declaration of function 'put_online_cpus' [-Werror,-Wimplicit-function-declaration]
> >          put_online_cpus();
> >          ^
> > /builds/linux/kernel/cgroup/cgroup.c:2248:2: note: did you mean 'put_online_mems'?
> > /builds/linux/include/linux/memory_hotplug.h:259:20: note: 'put_online_mems' declared here
> > static inline void put_online_mems(void) {}
> >                     ^
> > 2 errors generated.
> > make[3]: *** [/builds/linux/scripts/Makefile.build:303: kernel/cgroup/cgroup.o] Error 1
> > ----->8-----
> > 
> > 
> > For Arm64, i386 x86, with GCC-11, Perf has a new error:
> > 
> > -----8<-----
> > In function 'ready',
> >      inlined from 'sender' at bench/sched-messaging.c:90:2:
> > bench/sched-messaging.c:76:13: error: 'dummy' is used uninitialized [-Werror=uninitialized]
> >     76 |         if (write(ready_out, &dummy, 1) != 1)
> >        |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > In file included from bench/../perf-sys.h:5,
> >                   from bench/../perf.h:18,
> >                   from bench/sched-messaging.c:13:
> > ----->8-----
> 
> Additionally, there's this on Arm with GCC-10, GCC-12, Clang-16 for:
> * defconfig
> * exynos_defconfig
> * lkftconfig
> * lkftconfig-debug
> * lkftconfig-debug-kmemleak
> * lkftconfig-kasan
> * lkftconfig-kselftest-kernel
> * lkftconfig-kunit
> * lkftconfig-libgpiod
> * lkftconfig-perf
> * lkftconfig-rcutorture
> 
> -----8<-----
> arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-existent node or label "gpu"
> 
> arch/arm/boot/dts/exynos5422-odroidhc1.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-existent node or label "gpu"
> 
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[2]: *** [scripts/Makefile.lib:294: arch/arm/boot/dts/exynos5422-odroidhc1.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3.dtb: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> 

<snip>

Thanks, Sasha dropped the offending commit from the queue, and I've
dropped a few more as well, so this should be fixed up when -rc2 comes
out.

greg k-h
