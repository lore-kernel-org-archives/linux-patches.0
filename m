Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E22F846;
	Sat, 25 Nov 2023 19:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NIOTBwZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFB3DC433C7;
	Sat, 25 Nov 2023 19:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700941359;
	bh=79ZNx7QbXwaR+DfeqRTqWoT3nqX+9Dx5NLciWccHvug=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0NIOTBwZUI2ROKL5BP9uDPFQLAX4dOowNfklRMvs1UGB5Vm+IhldlYSzE8uiy0nJC
	 9UNw5LoGbnZgak3ouwW2tdKVlNNqtF/enAeyiAxohivjZXliHVLeUiL3IshAXyO0Ju
	 9UdC6Gj63jCBv3rRe/6DvpdMIQnb8SRj3xYcU7SE=
Date: Sat, 25 Nov 2023 19:42:36 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 5.4 000/155] 5.4.262-rc2 review
Message-ID: <2023112529-waking-breeding-bc77@gregkh>
References: <20231125163112.419066112@linuxfoundation.org>
 <261a0a3b-d1a4-4fe8-8fd7-42e9e2786348@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <261a0a3b-d1a4-4fe8-8fd7-42e9e2786348@gmail.com>

On Sat, Nov 25, 2023 at 10:07:33AM -0800, Florian Fainelli wrote:
> 
> 
> On 11/25/2023 8:32 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.262 release.
> > There are 155 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 27 Nov 2023 16:30:48 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.262-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf does not build on ARM and ARM64 with:
> 
> util/evsel.h: In function 'perf_evsel__has_branch_hw_idx':
> util/evsel.h:387:54: error: 'PERF_SAMPLE_BRANCH_HW_INDEX' undeclared (first
> use in this function); did you mean 'PERF_SAMPLE_BRANCH_IN_TX'?
>   387 |         return evsel->core.attr.branch_sample_type &
> PERF_SAMPLE_BRANCH_HW_INDEX;
>       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>       | PERF_SAMPLE_BRANCH_IN_TX
> util/evsel.h:387:54: note: each undeclared identifier is reported only once
> for each function it appears in
> 
> dropping 946b6643e67f552a9966a06ab5a9032120eeeea9 ("perf tools: Add hw_idx
> in struct branch_stack") allows me to build again for ARM and ARM64, howevef
> for MIPS we also have:
> 
> 50a3ffda05679c55929bf2bdebc731dfafe3221b ("perf hist: Add missing puts to
> hist__account_cycles") failing to build with:
> 
> util/hist.c:2600:5: warning: nested extern declaration of 'maps__put'
> [-Wnested-externs]
> util/hist.c:2600:23: error: 'struct addr_map_symbol' has no member named
> 'ms'
>      maps__put(bi[i].to.ms.maps);
>                        ^
> util/hist.c:2601:24: error: 'struct addr_map_symbol' has no member named
> 'ms'
>      map__put(bi[i].from.ms.map);
>                         ^
> util/hist.c:2602:25: error: 'struct addr_map_symbol' has no member named
> 'ms'
>      maps__put(bi[i].from.ms.maps);
>                          ^
> 
> so I would suggest we just revert both commits. Once we do that, all is well
> for ARM, ARM64 and MIPS.

Thanks, both now dropped.

greg k-h
