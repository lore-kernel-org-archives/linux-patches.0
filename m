Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A2F4FF
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 10:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r7OSk9c2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC9CC433C8;
	Fri,  6 Oct 2023 10:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696587915;
	bh=MVH7x9N25lGNzI2/k2QWeN3rLCO8cwbceLAdRNEQdsY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=r7OSk9c2xIAjt3sZYoUkzPPa9xoaiyL7NgFtm6ulkxKZAVmi1jE5g9gSn18XKQl1i
	 NETlGNbKhmu0yQuq+QcuCFtzO84QkMiRKegC9uEPqWFiScdoa3f8Mt7bBjCOrXMMrs
	 jKpc+r+GfFTBZlAjJVcTSy8Vn/ly/n7lzk10bOXE=
Date: Fri, 6 Oct 2023 12:25:12 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
Message-ID: <2023100601-ending-prevalent-c8d4@gregkh>
References: <20231004175203.943277832@linuxfoundation.org>
 <ec06c2fb-6737-489f-8439-307e0d84687b@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec06c2fb-6737-489f-8439-307e0d84687b@gmail.com>

On Wed, Oct 04, 2023 at 11:43:46AM -0700, Florian Fainelli wrote:
> On 10/4/23 10:53, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.134 release.
> > There are 183 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.134-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf fails to build with:
> 
>   CC /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/metricgroup.o
> util/metricgroup.c: In function 'metricgroup__parse_groups':
> util/metricgroup.c:1261:7: error: 'table' undeclared (first use in this
> function)
>   if (!table)
>        ^~~~~
> util/metricgroup.c:1261:7: note: each undeclared identifier is reported only
> once for each function it appears in
> make[6]: *** [/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:97: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/util/metricgroup.o]
> Error 1
> 
> caused by c1ef510a0f2a879bf29ddebae766ec9f0790eb8f ("perf metric: Return
> early if no CPU PMU table exists"). Dropping this commit allows the build to
> continue.
> 
> I had reported in the previous cycle that 00facc760903be66 ("perf jevents:
> Switch build to use jevents.py") was causing build failures:
> 
> https://lore.kernel.org/all/6a577578-8adb-aa70-1bf8-b1a4573152cf@gmail.com/
> 
> do we still want these commits to be included?

No, I'll go drop them now, thanks for the report.

greg k-h
