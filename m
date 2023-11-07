Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D348838DD0
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 20:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKCftizd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BFEC433C9;
	Tue,  7 Nov 2023 20:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699388548;
	bh=B+YmIgmEttrAvv5Hnk3++lIKvCuVEgeEMhcwRK+abFc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BKCftizdNq+DHRrrXM/Fg+I1wLwXUjiJIXIumLpGl33LNnOV11eJq470o0G9FSkmN
	 aCIU9GmoPp9f/5J6g0awHWNcrR+DZgC4QnzEcEDQ880Ib40nFHJ2YOkR1YfZMpJs1B
	 Slu4zqtrUBm6L8kLe58D5tVHiO3aCePzJc7aPQcY=
Date: Tue, 7 Nov 2023 21:22:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 5.10 00/95] 5.10.200-rc1 review
Message-ID: <2023110716-attic-rebuff-fdf1@gregkh>
References: <20231106130304.678610325@linuxfoundation.org>
 <f643650a-d520-4789-b67c-4f8da46fee73@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f643650a-d520-4789-b67c-4f8da46fee73@gmail.com>

On Mon, Nov 06, 2023 at 09:37:56AM -0800, Florian Fainelli wrote:
> On 11/6/23 05:03, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.200 release.
> > There are 95 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.200-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf fails to build with:
> 
> util/evlist.c: In function 'evlist__add_aux_dummy':
> util/evlist.c:269:31: warning: implicit declaration of function
> 'evlist__dummy_event'; did you mean 'evsel__is_dummy_event'?
> [-Wimplicit-function-declaration]
>   269 |         struct evsel *evsel = evlist__dummy_event(evlist);
>       |                               ^~~~~~~~~~~~~~~~~~~
>       |                               evsel__is_dummy_event
> util/evlist.c:269:31: warning: initialization of 'struct evsel *' from 'int'
> makes pointer from integer without a cast [-Wint-conversion]
> 
> ...
> 
>   LINK /local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf
> /local/stbopt_p/toolchains_303/stbgcc-12.3-0.2/bin/../lib/gcc/aarch64-unknown-linux-musl/12.3.0/../../../../aarch64-unknown-linux-musl/bin/ld: /local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/perf-in.o:
> in function `evlist__add_aux_dummy':
> /local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/evlist.c:269:
> undefined reference to `evlist__dummy_event'
> collect2: error: ld returned 1 exit status

Will go fix that now, thanks.

greg k-h
