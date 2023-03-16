Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E40F20EE
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 07:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5869FC4339B;
	Thu, 16 Mar 2023 07:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678952988;
	bh=0yOANMPqtyND/qZrPRckKTU0+G5MvOSEyU4jtRcWVzU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hHkKMHYfMo/u5ASQuDW4Wfod9VB2DV0aXNGPOw4aDxYfg6mZgD2SfvXhpEfVmR556
	 rxRvCv+oywXXdot9qs7zimjPkhPLBCXRjAvZ9LpC3Pjdj4m8o6j2iAiKANIa+djggj
	 89Gy6kL7zFObax0ovJpt1gMVS2gpVmdgcD8zhz4E=
Date: Thu, 16 Mar 2023 08:49:46 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chris Paterson <Chris.Paterson2@renesas.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux@roeck-us.net" <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	"pavel@denx.de" <pavel@denx.de>,
	"jonathanh@nvidia.com" <jonathanh@nvidia.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Message-ID: <ZBLKGpyaGnpOb3Km@kroah.com>
References: <20230315115726.103942885@linuxfoundation.org>
 <TYCPR01MB10588F845D48C023460EDB70BB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB10588F845D48C023460EDB70BB7BF9@TYCPR01MB10588.jpnprd01.prod.outlook.com>

On Wed, Mar 15, 2023 at 02:27:28PM +0000, Chris Paterson wrote:
> Hello Greg,
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: 15 March 2023 12:12
> > 
> > This is the start of the stable review cycle for the 5.4.237 release.
> > There are 68 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> > Anything received after that time might be too late.
> 
> Tested-by: Chris Paterson (CIP) <chris.paterson2@renesas.com>
> CI Pipeline:  https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/807195748
> 
> We (CIP) are seeing some build issues with Linux 5.4.237-rc1 (543ff97e810c).
> 
> 1)
> For arm multi_v7_defconfig builds we're seeing a some errors when building the exynos5422 device trees:
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidxu3-lite.dtb] Error 2
> make[1]: *** Waiting for unfinished jobs....
> arch/arm/boot/dts/exynos5422-odroidhc1.dts:238.10-241.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map0: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidhc1.dts:242.10-245.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map1: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidhc1.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidxu3.dtb] Error 2
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:409.10-412.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map3: Reference to non-existent node or label "gpu"
> arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi:413.10-416.7: ERROR (phandle_references): /thermal-zones/gpu-thermal/cooling-maps/map4: Reference to non-existent node or label "gpu"
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[1]: *** [scripts/Makefile.lib:285: arch/arm/boot/dts/exynos5422-odroidxu4.dtb] Error 2
> 
> Log: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/3939400038#L8368
> 
> Presumably caused by "ARM: dts: exynos: Add GPU thermal zone cooling maps for Odroid XU3/XU4/HC1", but I haven't had a chance to revert and re-test.

Should now be fixed up for -rc2, thanks.

greg k-h
