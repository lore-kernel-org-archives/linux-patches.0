Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5E42D662F
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 13:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781704181; cv=none; b=cu06K3c8BJqFFf+oDeRpnLdzO4BrjactQqverPuWYLUNNiRXfjTfliZRJSSWDyuOWiZxLT9Zj30VjPR2qXudI+H2+aQjiNdpGP8OQglBtmJ3ZQpHzHUvSkBrfMmWY+NvIVOF5K3G26KIEPVh64l36ssc8mZCzySIZDsrdDHXCnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781704181; c=relaxed/simple;
	bh=fKrwzxDUmmC18tDkWzS3lFmWYZ/NYAlYDFt15KIfwVU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=btzaQ7CEo8zgQOm6aWnFwAs8u+eUEWfuFkxL8xVQ3dUOFR6VqJFIlgt0DoRVJM6IVuSLKJs9dYoNAUooVFknRpFH/Dipmbt3WMuM1YzqVi8K/iGcdHtFb+eekLJ0MUJ1Rqedl7fRYBnWHb8ojEPcEVhVBdwzjfiHcjGf8uzfrtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=atKthuo4; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="atKthuo4"
Received: from francesco-nb (xcpe-178-82-120-96.dyn.res.sunrise.net [178.82.120.96])
	by mail11.truemail.it (Postfix) with ESMTPA id 7D8361F927;
	Wed, 17 Jun 2026 15:49:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1781704178;
	bh=VQVgcFhbSUCAtYo+7LoOmMjqgPOS4SGHIysryY2A8c0=; h=From:To:Subject;
	b=atKthuo4IwojA0WYhj5gH0vhY/0VDv3/hY77+UwpNLzIgkvdgnbHqOKU3HzN8THHU
	 BOjVy+ZU42ADtqfGGwqLUiUgMdIhJLxaegzkUXGzVWNZxgT0amtfXDls7r6v32svk/
	 z54u6K+MJd2Vi88HGEKBWcQDN2PYp8oibxvcxeqXeoTV5xYu6njW5d2dalQ5mGQhrs
	 6tTx5OXOx1U8FVH+FLqgg5q3DLQX2r49bxx3qJVrfiG25lt4rCJZqFaRvDN8tA/vqm
	 2nnwOebK5z4btGMMCBzUFy00rVc6Cws2u2OvBRu4JxGiP/+OHq4GzHqHja6w7DdJbf
	 3oolIU0ZdNKjw==
Date: Wed, 17 Jun 2026 15:49:33 +0200
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
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Message-ID: <20260617134933.GA99189@francesco-nb>
References: <20260616145044.869532709@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>

On Tue, Jun 16, 2026 at 08:27:18PM +0530, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

