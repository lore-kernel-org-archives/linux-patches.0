Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4F918FDD2;
	Fri, 30 Aug 2024 11:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725015859; cv=none; b=pU00uYcGs7z2tJh1kZN9p6H65AMs8l52EcfgoEsMC1xXX6SQqYR2FfIkfmLZsmIPTyk/kUZ6UYEhbSurPUfIYLcvjyW+ODGv9QdOj526oChLprTnsyP+cOqGhDD7vxE+opW8Lgf+/g/zoionoJEaACk1GqhJsVlCBEE7KKVPd0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725015859; c=relaxed/simple;
	bh=rO6b7QFMzMshg1b/0hXGx0Bjl6EL4/D2pRT9fm6J53o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cX3TEdasY+4roLIxPsrIhqSp3KQGcbK/W4goX7ZNz+XI/h8+YZqdXSLTfCox1ytS3lbf7oVfjkqSO+2oSAMJUaBQZzFrmTSQS5pvUABpc2uDLsIJM0SAW1BbJK2LObBX69hVCFBRVx7dpDtC1koYKlGp7jtgTsMsb1A6q0VRYh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cExWXtsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cExWXtsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19755C4CEC2;
	Fri, 30 Aug 2024 11:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725015858;
	bh=rO6b7QFMzMshg1b/0hXGx0Bjl6EL4/D2pRT9fm6J53o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cExWXtsFOxTgUaU9KshA4QxNtf7K1NEJriuqNf/EeM/NRe9phkQNkpeU1WZpHxfAT
	 hPZSpgo5aDKtsPI1YTJcIyqt4/AsAnXBz3ZkceNC4kzPk7bZ/K4WNl++wImmMFGN17
	 gRx4Bc2KeSPRrDbwsnKLtOuPTxIzKKfwX8fKSTL8=
Date: Fri, 30 Aug 2024 13:04:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc: Guenter Roeck <linux@roeck-us.net>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Florian Fainelli <f.fainelli@gmail.com>, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.15 000/479] 5.15.165-rc3 review
Message-ID: <2024083004-scouts-broadways-663b@gregkh>
References: <20240817075228.220424500@linuxfoundation.org>
 <135ef4fd-4fc9-40b4-b188-8e64946f47c4@roeck-us.net>
 <eb7fda2e-e3c3-42cb-b477-91bcafe3088a@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb7fda2e-e3c3-42cb-b477-91bcafe3088a@app.fastmail.com>

On Mon, Aug 26, 2024 at 02:27:17PM +0100, Jiaxun Yang wrote:
> 
> 
> 在2024年8月26日八月 上午2:04，Guenter Roeck写道：
> > On 8/17/24 01:00, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.15.165 release.
> >> There are 479 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >> 
> >> Responses should be made by Mon, 19 Aug 2024 07:51:05 +0000.
> >> Anything received after that time might be too late.
> >> 
> > [ ... ]
> >> Jiaxun Yang <jiaxun.yang@flygoat.com>
> >>      MIPS: Loongson64: reset: Prioritise firmware service
> >> 
> >
> > This patch in v5.15.165 results in:
> 
> Thanks for reporting!
> 
> This patch should be reverted for 5.15 as the infra was not here and 5.15
> is not intended to support platforms that may be impacted by this issue.

Now reverted, thanks!

greg k-h
