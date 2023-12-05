Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75532D274;
	Tue,  5 Dec 2023 04:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J14Ly5sC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DEE1C433C7;
	Tue,  5 Dec 2023 04:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701750803;
	bh=W4tiU4S1AH+FQPouyCs9btB+Ud77ES08vPDVQ06zMnI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J14Ly5sCqZYjEefYm3PnmRtN5y88Hm8qHv/ntyxfbzu6tfv6w64YtaYLq+nXMa469
	 MpXyAL2pXUk7JRjiaXGOvczGFRwZuS666mPVuli7BF8Uud2RNnJHfMe1AWjn4YHzyb
	 +IErgqUIESSJR7crsiMvP+4HRtz3017mwq5q8Djc=
Date: Tue, 5 Dec 2023 13:33:21 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 00/94] 5.4.263-rc1 review
Message-ID: <2023120501-aftermost-thrill-6edc@gregkh>
References: <20231205031522.815119918@linuxfoundation.org>
 <7ac20588-3816-4e53-be31-8cc4c0de7caa@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7ac20588-3816-4e53-be31-8cc4c0de7caa@roeck-us.net>

On Mon, Dec 04, 2023 at 07:53:26PM -0800, Guenter Roeck wrote:
> On 12/4/23 19:16, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.263 release.
> > There are 94 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm64:allmodconfig ... failed
> --------------
> Error log:
> drivers/mmc/host/sdhci-sprd.c: In function 'sdhci_sprd_set_power':
> drivers/mmc/host/sdhci-sprd.c:393:17: error: implicit declaration of function 'mmc_regulator_disable_vqmmc'; did you mean 'mmc_regulator_set_vqmmc'? [-Werror=implicit-function-declaration]
>   393 |                 mmc_regulator_disable_vqmmc(mmc);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                 mmc_regulator_set_vqmmc
> drivers/mmc/host/sdhci-sprd.c:396:17: error: implicit declaration of function 'mmc_regulator_enable_vqmmc'; did you mean 'mmc_regulator_set_vqmmc'? [-Werror=implicit-function-declaration]
>   396 |                 mmc_regulator_enable_vqmmc(mmc);
>       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                 mmc_regulator_set_vqmmc
> 
> Commit 2b11e5bd4ac0 ("mmc: sdhci-sprd: Fix vqmmc not shutting down after
> the card was pulled") calls those functions without introducing them.

Ick, missed that somehow, I thought I had caught it already.  I'll go
drop it now and push out a -rc2.

thanks,

greg k-h
