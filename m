Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFCD23644D;
	Thu,  6 Feb 2025 14:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738853136; cv=none; b=nqZ/SlC47d6VrytnTFDJErOwiq17AAfKql5W3a1dstZt5vTTsfwVWKoO/lG1nbkmQ1e57fai/tzlocKpK0ozLT/quSMC2mkGL+tSf+TEMvFGJ+6hBEYyUuPzSQV7BjVm9cZpJFtioASaiFal4nBohFKz03DyXgn7bYUD7CTurbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738853136; c=relaxed/simple;
	bh=2FgrKdbnK+b00GWj9omYgHNPOcOcjfa1fv41p2yBFhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hxVgN58WPz2acSe5K8tCKpORB8yoobyi15TU8BecI3o9Pk8/9z1GG/ikZ2dy5izvfzpzEsEfivJku9cn5v6cEgBwUoMzIyHzojPAxY/CwqD5eMedM4VD7Yg9DxoJJohBY8D5cdegOakXi4OOT5RYJKel9ik5mWoUFDtsGWP1KAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2bDL3Obp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2bDL3Obp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0D2C4CEDD;
	Thu,  6 Feb 2025 14:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738853135;
	bh=2FgrKdbnK+b00GWj9omYgHNPOcOcjfa1fv41p2yBFhM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2bDL3ObpbSxp60WGZ1BUtIyfyyXueIqkBwCt/q0idERoCOWnFNEO80G/mBK3K05eK
	 xiBrBJk1v1gHEsgPQvl5Jd9sknws2VJKG7x1VeEW7aBvcpiiS1uu9mMjz025Uv1t13
	 izq9sB3fiC4vAltDwuMGSELA2awNxYJ5vd26v0Yk=
Date: Thu, 6 Feb 2025 15:45:32 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Theodore Grey <theodore.grey@linaro.org>
Cc: akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@denx.de, rwarsow@gmx.de,
	shuah@kernel.org, srw@sladewatkins.net, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	dan.carpenter@linaro.org, anders.roxell@linaro.org, arnd@linaro.org,
	david.laight.linux@gmail.com,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
Message-ID: <2025020615-nursery-cupcake-20ce@gregkh>
References: <20250205134456.221272033@linuxfoundation.org>
 <20250206113721.2428767-1-theodore.grey@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206113721.2428767-1-theodore.grey@linaro.org>

On Thu, Feb 06, 2025 at 12:37:21PM +0100, Theodore Grey wrote:
> Regressions on the arm64, builds failed with gcc-8 on Linux stable-rc 6.13.2-rc1
> But the gcc-13 and clang builds pass.
> 
> This was also reported on Linus tree a few weeks back [1] and also seen on
> the stable-rc 6.12.13-rc1.
> 
> Build regression: arm64, gcc-8 phy-fsl-samsung-hdmi.c __compiletime_assert_537
> 
> Good: v6.13 (v6.13-26-g65a3016a79e2)
> Bad:  6.13.2-rc1 (v6.13-652-g32cbb2e169ed)
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> * arm64:
>    build:
>     * gcc-8-defconfig
>     * gcc-8-defconfig-40bc7ee5
>     * gcc-8-lkftconfig-hardening
> 
> ## Build log
> In function 'fsl_samsung_hdmi_phy_configure_pll_lock_det.isra.10',
>     inlined from 'fsl_samsung_hdmi_phy_configure' at
> drivers/phy/freescale/phy-fsl-samsung-hdmi.c:466:2:
> include/linux/compiler_types.h:542:38: error: call to
> '__compiletime_assert_537' declared with attribute error: FIELD_PREP:
> value too large for the field
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>                                       ^
> include/linux/compiler_types.h:523:4: note: in definition of macro
> '__compiletime_assert'
>     prefix ## suffix();    \
>     ^~~~~~
> include/linux/compiler_types.h:542:2: note: in expansion of macro
> '_compiletime_assert'
>   _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)
>   ^~~~~~~~~~~~~~~~~~~
> include/linux/build_bug.h:39:37: note: in expansion of macro
> 'compiletime_assert'
>  #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>                                      ^~~~~~~~~~~~~~~~~~
> include/linux/bitfield.h:68:3: note: in expansion of macro 'BUILD_BUG_ON_MSG'
>    BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?  \
>    ^~~~~~~~~~~~~~~~
> include/linux/bitfield.h:115:3: note: in expansion of macro '__BF_FIELD_CHECK'
>    __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: "); \
>    ^~~~~~~~~~~~~~~~
> drivers/phy/freescale/phy-fsl-samsung-hdmi.c:344:9: note: in expansion
> of macro 'FIELD_PREP'
>   writeb(FIELD_PREP(REG12_CK_DIV_MASK, div), phy->regs + PHY_REG(12));
>          ^~~~~~~~~~
> make[6]: *** [scripts/Makefile.build:196:
> drivers/phy/freescale/phy-fsl-samsung-hdmi.o] Error 1

Offending commit now dropped from 6.13.y and 6.12.y, thanks.

greg k-h
