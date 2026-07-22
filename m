Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B972F332EC5
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 06:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784702074; cv=none; b=FW0K75RpfcR6wQ1D1ueRjYdeQqlxmlcL5HHhxzHT/4GyQ/K3ZUNW9k7j2ay+9wCaD6ts6ZhRREXp3HBQdvGJyh+RoCKoEiFB9PAIMt/8eISKM1vNXz2PoJybRCLCNd4g7T+CxFRzqyRlUPR/2Y4siErh38GCcqCDtoZu/xb7PBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784702074; c=relaxed/simple;
	bh=wRv7NwmYw4jRk4hsSlUoYVACnODYzINxW1cvx+QslGg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lK8H1nEJJqVWOtreHFCtxXH0Vp546FdCeVCpQI0qjIyen9W2MTDodKZkORBCrNATzJug4mJRqYhX9bd5wjb2oGHF2Ts0rbBgRfH4r6wEKZVB8W8LB/tZQAvjIr0ilMQlpXjQ1aktKsdB51AHZoYfOfcIxpzqFT8KGrF3+t4+WSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=DIbVny+H; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="DIbVny+H"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 21E4A225D9;
	Wed, 22 Jul 2026 08:34:30 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1784702070;
	bh=+vQ1FD9ZQF4OK8ldPTvcAbIxp0CbuhPEhUYWox1c/Xw=; h=From:To:Subject;
	b=DIbVny+HFUcyfQrAUnz15K8VU7dQ05RLITb3HIySdiLRbRfgUMus0JeLklz6Q7Ay6
	 fKZbUUQdr4x+EvmfZPWoQmPfBR5kfC8k/qhx3Rri3ZAlZAIAwWBmiGbDL8kHY90wGk
	 hJEsHOLF8PymVS5HCqt0VklOCy1NGuAE/FadlJAitnFwfpT23jfJ4FNEEHadib0VUy
	 7La4dSJJHYurnzawm6XK5R/R+THPq6xswr7/RnMYFfGIu7UOh0Aj32Y6AsJ8b8JCTn
	 NojBpPNH4ancaTxC3jblpTtzCspCcmDDo+HBjndoktB7vMM67YC5K6kN+0NLKblsA5
	 GqdmyQkrlJOtw==
Date: Wed, 22 Jul 2026 08:34:26 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1266] 6.6.145-rc1 review
Message-ID: <20260722063426.GA27207@francesco-nb>
References: <20260721152441.786066624@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>

On Tue, Jul 21, 2026 at 05:07:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.145 release.
> There are 1266 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

