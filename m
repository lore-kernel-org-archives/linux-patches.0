Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F313F14A85;
	Sun,  8 Dec 2024 02:47:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733626063; cv=none; b=Y9UdJDDRCfjMy8EpJ58vVBFAXE7oiJWKAZIoE2lXv5apXBwlp6dqFFDpqGq9puIhEMMgDcyWTTkhzLKxuc1YUl0D0MinjVpWOfXSZDfY2YRaA6ZPltm9uT5rtVssfra4eRfBFGSDT4kVQ994CMf9VybQnMfTIVTxlzs914J5oJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733626063; c=relaxed/simple;
	bh=NHJyeLRRWCQfj/dV5DQVg7AEGWqhmlfi6p74bANGV3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kkdhr0YkHISQM5E56NrbtQLLTo5s5jWnIntk9ktTt0xggPU8fHsOgNayBxKzsuQ568JGh1BKHLCvM9uId7F+rf9tBGsUWU9R6rLTEiVqW1L9NwP8e1ya09LIMey7/gOm4eQzrre5s0OPQ6K+dhcoGOriOeAGB84R++kha8yayKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LYwakqWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LYwakqWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C1C4CECD;
	Sun,  8 Dec 2024 02:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733626062;
	bh=NHJyeLRRWCQfj/dV5DQVg7AEGWqhmlfi6p74bANGV3I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LYwakqWzLHhgQ0LnSYRCcAampaWNh4CCP0KqRGRP/ZY3bJxtksUMvI/zSEBFzW5gB
	 yWalZGiRH/srfwE1p/Jbzg0FxrnOyRPRF4CvuqnFqaLxzQZGYYo2VSnVEM9qjLmqUQ
	 kAHytqH8fHABXWNXY/6hCk/0Qs9ZvbvmIjRJpg7DC/t3m/XeDrdSVOUiLgMHhkQAsr
	 XJ1wTZJh1OFXf0TJCnyUoFPEWaJrVgEFExyFpTGgqAOGSbAerUrOlv4/bpR0ThmLgf
	 XcV8uKaTeh3saSz/5lX4GOBEbYP1/YTVIaoVB8ha6H6w8Jk/LF0c1BijvVAUVvLBOo
	 EkndhUfiuW57g==
Date: Sat, 7 Dec 2024 19:47:36 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
Message-ID: <20241208024736.GA2495976@ax162>
References: <20241206143653.344873888@linuxfoundation.org>
 <CA+G9fYtsYhXwhewSJUnGAwFmSa5AnOvuREZiOGRCsOUWb6Kx3Q@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtsYhXwhewSJUnGAwFmSa5AnOvuREZiOGRCsOUWb6Kx3Q@mail.gmail.com>

On Sun, Dec 08, 2024 at 01:20:19AM +0530, Naresh Kamboju wrote:
> NOTE:
> [Not a kernel regressions]
> Powerpc clang nightly defconfig builds are failing on stable-rc linux-6.6.y
> clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=',
> expected one of: r2
>  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2pqeSKGTShWpi3PB2dFTogUwhpJ/

It is a kernel regression, it is fixed by taking
https://lore.kernel.org/stable/20241206220926.2099603-1-nathan@kernel.org/
atomically with the other powerpc stack protector clang fixes in this
series, which matches upstream.

Cheers,
Nathan
