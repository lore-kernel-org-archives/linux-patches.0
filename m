Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A2D22616E;
	Thu, 19 Dec 2024 16:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734624330; cv=none; b=h+QunjcHYspW73FuYGTh+W45odNAfgeN30Jj31z/hH1ADPAmgTrQYI3lt2ouIQ+hgR/+yRG7A0pb6JLjgKGv0L2qCuM7hFfOK24blYnrlb24lifBqT2WJUs7gnhh+LicKJvPLPinhkzJDKw+e1M6kbJj1db3rFZgiJC/oUAh0UI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734624330; c=relaxed/simple;
	bh=4R/+QV53OxFa2E53IUeO+A5Grzm9WJmtDcMeN8fhiI4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j0vLDaXZSi0JxPh5YkThg/zlXM0Nzq53AQ+LNei4uEqhaeXQ2NtEz1Ui4o4dyjNyqtA1XeAB+3sVzrDldofiOlA3bfzDssKhrDXP5Jq/Jn6m7no2cT2FDGGZHTlBSHQ69YXN7loa+T+Cx7FPQnwBMX2es0qFi1WI++7wqB52gAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wf97qVWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wf97qVWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6876DC4CECE;
	Thu, 19 Dec 2024 16:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734624329;
	bh=4R/+QV53OxFa2E53IUeO+A5Grzm9WJmtDcMeN8fhiI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Wf97qVWFfsRD23uLu9bPaVwOXzpoi+ht1RVL8L8GwxXtp5O1mS3Wfu38MniqpKstm
	 uINFRsPF4mPZ3IXGKgMnBb5KnPb1LbKmHrrzximEbmMdAUcMFS9eBMOvKpMp2Xd3dN
	 RFNgy5WizEo3BkQECjq3n1qczrgxX6rW48ZIU23s=
Date: Thu, 19 Dec 2024 17:05:27 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/109] 6.6.67-rc1 review
Message-ID: <2024121921-employed-crabmeat-1b21@gregkh>
References: <20241217170533.329523616@linuxfoundation.org>
 <6c36f396-fb6c-4cbe-86e2-39b3ce85ffd3@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6c36f396-fb6c-4cbe-86e2-39b3ce85ffd3@gmail.com>

On Tue, Dec 17, 2024 at 12:00:51PM -0800, Florian Fainelli wrote:
> On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.6.67 release.
> > There are 109 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.67-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf fails to build with:
> 
> evlist.c: In function '__perf_evlist__propagate_maps':
> evlist.c:55:21: error: implicit declaration of function
> 'perf_cpu_map__is_empty'; did you mean 'perf_cpu_map__empty'?
> [-Werror=implicit-function-declaration]
>    55 |                 if (perf_cpu_map__is_empty(evsel->cpus)) {
>       |                     ^~~~~~~~~~~~~~~~~~~~~~
>       |                     perf_cpu_map__empty
> evlist.c:55:21: error: nested extern declaration of 'perf_cpu_map__is_empty'
> [-Werror=nested-externs]
> cc1: all warnings being treated as errors
> make[6]: *** [/local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/build/Makefile.build:98: /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/libperf/evlist.o]
> Error 1
> 
> this is caused by 74d444cca1eb616912c3ffe4b8a060a7bb192618 ("libperf:
> evlist: Fix --cpu argument on hybrid platform")

Now dropped, thanks.

greg k-h
