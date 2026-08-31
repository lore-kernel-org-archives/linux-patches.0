Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD1945FFCB
	for <patches@lists.linux.dev>; Mon, 31 Aug 2026 18:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788200179; cv=none; b=njPEIKsEcT4kVmN5sc09NrgPPfG7BhNi47aurLzb8luPAyo5Ph00rfXcFugyP56sCEobMFZlWOo3gLsdhvUGrkRY3+su8wwluQtrQ2qWWxfbKl7E/AeU9XxpdKcEoklz8Gcf7BKIqRsgrh3AiDDlsqmGjA2dRHvjRuQiAvvhHRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788200179; c=relaxed/simple;
	bh=kD10233b+HVOp/v3cC9FItIPriSA4l0wbNRd965C+wA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GqM09Y+zwWQoI5X4zi8mVNeU4tNc3RwuP+j63stBTqVzWMwZjZ6UJX+PZA+/tXPZaN2xgVJnRi87kOW/zEusOgyCqYJhJHUPdYqIFShX16DcLzH9C/rx2vQLSH2V3hEuqM6SCqz7f+hNMnxQL1adilLfoaFFZsyv9DC+6zdcEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=E98gB4bc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="E98gB4bc"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 89C871F95D;
	Mon, 31 Aug 2026 20:16:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1788200175;
	bh=ojl6/OGk19bGzH7ms87Ii/MK+bWEGrZq4jbFee/HSeE=; h=From:To:Subject;
	b=E98gB4bce0sSPnOOFuF16LVaIFPiB/Ohq0aW/tQyygE7koLM1R5rsDwTggcDm31YT
	 hyuYSCcNDH/AD6IBt77CGBqyHYR1Cl4/hftIw0wjFJk0sC2+fCT51PL7wDzfLti16D
	 VOUyjL+aQxkI71zsoe7GtjrrsliDLVJLB+ognITCwxB+HeLQIJirjcFEkOu1Ahphu7
	 S1FJEYlEhAGKNduIxbRRYlOjV3WI/eWU1gDc/lD3yQlqmt2UzH76xgSBnk+KEa/+Y0
	 1HYkilNX4FJ+FqxiXYQtzvi86/wOWB4akX/SHWOhKOtxKT0Vewyj2x53FELXZegm7j
	 eOXLA+HY3oYYQ==
Date: Mon, 31 Aug 2026 20:16:12 +0200
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
Subject: Re: [PATCH 6.6 00/91] 6.6.156-rc1 review
Message-ID: <20260831181612.GC124452@francesco-nb>
References: <20260831133359.468089036@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>

On Mon, Aug 31, 2026 at 03:33:48PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.156 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

