Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10FFB19930
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 17:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9478C433D2;
	Thu,  8 Jun 2023 17:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686247025;
	bh=FpLokzzvgb8Su1TVOxrVGWWZ4a4F1CNAPWwV5MPS5J8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SG7zVSHd37Cz6pGm5ywhW4tw0tNbaARPlUU962UwZGHDdQ5KaYDk6JfllvULHPKam
	 tZ7rwh1uRazx3jVET3lv7jzi8zrJMlMwHGQSz4uNmM1qpaueaVW1eRTtJQ9jl1Kkum
	 SkyX+RTGxFqIsSjA2I6W+kVkXnaO10urilaM8YFo=
Date: Thu, 8 Jun 2023 19:57:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
Message-ID: <2023060848-vice-dismay-a6f2@gregkh>
References: <20230607200913.334991024@linuxfoundation.org>
 <cf6f959e-2885-1e7b-826d-61bff351ff14@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf6f959e-2885-1e7b-826d-61bff351ff14@roeck-us.net>

On Thu, Jun 08, 2023 at 08:08:50AM -0700, Guenter Roeck wrote:
> On 6/7/23 13:13, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.33 release.
> > There are 225 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Failed builds:
> 	loongarch:defconfig
> 	loongarch:allnoconfig
> 	loongarch:tinyconfig
> 	loongarch:allmodconfig
> 
> arch/loongarch/kernel/traps.c: In function 'trap_init':
> arch/loongarch/kernel/traps.c:815:21: error: 'EXCCODE_BCE' undeclared
> 
> EXCCODE_BCE is indeed undeclared in v6.1.y.
> 
> Commit 'LoongArch: Relay BCE exceptions to userland as SIGSEGV with si_code=SEGV_BNDERR'
> is not marked Fixes: or stable: and should arguably not have been backported.
> 
> The same problem affects 6.3.

Thanks, I'll go drop this from both trees and push out -rc2 releases.

greg k-h
