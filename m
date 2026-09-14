Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFFA339381
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 05:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362575; cv=none; b=S5SyFgWLygT1Paxr+Qi7O92GDyK8dptzmtyu1mqylrhnNAt3i5utgeh7pCLrmA1Mpdqu3XkMsw4lAfrF+GXl3fHvovEwYjRKJVzc0TXdrq9tUtmDZjwYR2huMF3TnpPiWkXsufcYkis0gRVELbfEIT+u3Eo/1hZarY6tqsLLhlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362575; c=relaxed/simple;
	bh=lfgCZ4FmxzPoowNybtyb47M8UwQPYDxto1QOg5YRoQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTENRez7f3NTziEAf+Fr4zCSkkU2CYRE4Ib/hrdYS5UfFhPFKlvFwmFwX/sW0uU/4Ui5cr2RPWxaFtvuV1n3lUSerCJ5Dp4uEBobj33L6s1lBts7IaUEyjxj6msHTQzEttRdyxn2VNZg2FBvYeuHa1y9DwQ0+Nhb+rKKx48kGHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=SCkT/wSm; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="SCkT/wSm"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id B4EB8244DB;
	Mon, 14 Sep 2026 07:09:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1789362572;
	bh=2nk7AUvuM86hOe4gvawwlWgYJ7/+DznRWm/fcg8VKFw=; h=From:To:Subject;
	b=SCkT/wSmLrX5eHEnbg1TFLCdUjNwMOojpxtyCIfD+UV3qrzz9PBAMYM595/EPkK36
	 3H8wAQQ2Tn3+aIDJJUJSDBiG0FpS+9dlQOFhgt8+/7WSH/hYSNlV1ceHhfp8tr1thA
	 9COescSQD/bKiZu/bRExgobpquDaBwbGPbqSh0AxoGlL+l20g9XycJd5YuzI2YIkny
	 gArbirf5c0bdBfJsRqQc9XWzS6SWJV03GtgRTzfolMVHBDPEEqsTeGfSEb/yym3fhj
	 nEyZjKsMztpK+dI2ct/IXUpt+dDxjSE2WwlEmUK4uxQGUiJMnFFpnGdMnNDdecQ9ck
	 rZXUELO5gJH6A==
Date: Mon, 14 Sep 2026 07:09:30 +0200
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
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
Message-ID: <20260914050930.GB17380@francesco-nb>
References: <20260912065607.535295758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>

On Sat, Sep 12, 2026 at 08:40:26AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

