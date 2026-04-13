Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDE61DFF0;
	Mon, 13 Apr 2026 18:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776106278; cv=none; b=YMEDWGSOf8xLEHoibohBPWTqUdSxeWzEJmvq7PgUTOYOKOjCAlKnT7ohHDKX9rE+QcwgasA73DXd710nI0Ix1rE8F7MQ4b+zCwCD9sz5Dz/mFXBdJTmIWl1jTvHv2SDGo/z8yVzEs3kMtI4T2Q+Qu0D3xzhuVJsC2U29+tQKnYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776106278; c=relaxed/simple;
	bh=HXsqcT3rBld5VoTWMeH3jBkm3Nq6h0sa2CVDqwLcUv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oLd+WfP61Oj8QyEBvEaOALsDrWQNnZrANcDcq0oJmLSKgBcY/dI6YgNm57hVt84UYMzN5MWjftfFfF9GElFGOwb4p7serm3VXXMgZP7YdzpJo3jVsdyAPCiREpmIN9HEIwP+nGM+n480oZ70juvZ8khabCnNxsmb4PWDirbk8PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ni8X6gcD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ni8X6gcD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDEC4C2BCB6;
	Mon, 13 Apr 2026 18:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776106278;
	bh=HXsqcT3rBld5VoTWMeH3jBkm3Nq6h0sa2CVDqwLcUv0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ni8X6gcD/9STAZ1RaYxaL5SBupbAMREma5vvqvHCm0yTmwRQlJLeZIF3wX593v8MC
	 XvuUTZQj8R1KDBuXe4SDI96xIHznX3+qSfaNal23+louS7zydzxbMXT6YFvEwwRFXC
	 9Be6qOhki07bnWJnN34IxK28bQfP9UBa50tt9b7mbpOeEanDwH7Vc+BHtv9hA3LNpU
	 ZzI6WCb6bweUfJhV4BSyxw/KmeR9Q85xv8bvNrKpyiJskP1CkEfhP9yNeGWqQxsFQm
	 T8wZw+LsZe/iHBJYy21pH9oCdl8S3PjzYwDtja7NbHrQK4s2W2RorsUCIV203IQRfu
	 b5q0NT6R4T1Nw==
Date: Mon, 13 Apr 2026 11:51:12 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/570] 5.15.203-rc1 review
Message-ID: <20260413185112.GA501334@ax162>
References: <20260413155830.386096114@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>

On Mon, Apr 13, 2026 at 05:52:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.203 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.203-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.

The build problem I pointed out in 5.15.202 is still present:

  drivers/i3c/master.c:2203:3: error: variable 'i2cdev' is uninitialized when used here [-Werror,-Wuninitialized]
   2203 |                 i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
        |                 ^~~~~~

  https://lore.kernel.org/20260318023542.GA2596820@ax162/

Our builds have been broken for a month:

  https://github.com/ClangBuiltLinux/continuous-integration2/actions/workflows/5.15-clang-22.yml

Cheers,
Nathan
