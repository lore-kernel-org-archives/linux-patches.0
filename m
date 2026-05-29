Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D961835F610
	for <patches@lists.linux.dev>; Fri, 29 May 2026 06:24:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780035851; cv=none; b=gp5yytrygC1x5ayjzenxLNqgP4/wxEGPWh292xn5fBQmxBwo0muluJuT65H0ra4iiaGBWX1K6xwTeNNNg8WvedEiE++8bNjR95iitcApinNktBBgjalCgYwdLklH6t2QNMchRXPpPXQSNOq/IEXQZpXz6I685sgS5B9NR/URyUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780035851; c=relaxed/simple;
	bh=1JOI+3y2uqmOtZnu1DdMFSgEWHL3QlW19+aaQiOk+lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CfdCFNywmR281JiCLv3rAT5BLjhJg1NvEQnMggV0Qqg+pacVIVt6xD2aeqHBtvb5BHyT8+slaNc/xddASneOE9UBDKuXjXVQcNepu+jE2AHdMJ/GMYIQwOXLkXLftjaMZH6lxRwi4S7yhAlSOygQA7XjDCkSD1IxvpmOxIuKSXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=FvwMJtdi; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="FvwMJtdi"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 9BA3220E6D;
	Fri, 29 May 2026 08:24:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1780035847;
	bh=shdz+nSJkLsEyJpagL5UyHS+phwwSIXwadhsYEdVxmg=; h=From:To:Subject;
	b=FvwMJtdiKC7brOo1ewJnWuQYImq8bLeDdLm7mk+OftqtqbGNalljAzIzPzeT0oqpc
	 t9X8CUEzq46ph0YPi37f38ERN60Ughunj6I2kmmBUOvw91/XnmPPk6d2wKKjbmbQO8
	 0YQ+SPshJMnJ9n2sjEHnSbXvwadPHW/Mj6CoVucgtXKqji1M5/rcgaiTWfx0XQ//oU
	 b301jg0cbD2jtnygknu/dmrXKG5EF5ywV4r0NbtEaddQgzVnvgsJHFdMJ2MdvUsc1Y
	 8xrfrxm+PODJmrSwm3Xj601NfcUuLl87Kc4T9AeDTn4mBiB6Ua0gvVZa+TpoqcNMLn
	 iS0W+Jo8cAFTA==
Date: Fri, 29 May 2026 08:24:02 +0200
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
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
Message-ID: <20260529062402.GA11571@francesco-nb>
References: <20260528194928.941004471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>

On Thu, May 28, 2026 at 09:48:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

