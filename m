Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBD420E334
	for <patches@lists.linux.dev>; Fri, 16 Jan 2026 07:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768550154; cv=none; b=itmLY6a5jbfsi1MXjMbPrZv8Ek4Uw80P6GKU2RL+koNZFfVRHj6lJ58kujTmdOCeumX1WDe7n7esDI7PjhgS69wT9viMC6KkRR+lAO47ZaosdEElqSkgAKPVFMjKajOGBJZPlMGt+86eEsmU+3+8b5oBrx1RqEhfkPbLQA1rAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768550154; c=relaxed/simple;
	bh=nsxYasNH1H+bd0FpVC2TRBmyODxx3oiJ89iVxpMgRgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D0o5dRFoBZKaUiB6qL/dTMa6xT4wUvHl+sfm6SY9RE5+1momWhOzvkeZ1z+WFPJ6WLmvGLAcYcZZTVvMoaQbJwgakQtkGR+nJPnPJOIVFiolrW9Oh2YHw6MIv++WVeOmaZRoDbNZlY4XQo6k5EZRPrLP3l9Zk0TSq3AK0M0e3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=tX2nCRSk; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="tX2nCRSk"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id C17761FAFD;
	Fri, 16 Jan 2026 08:55:40 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1768550142;
	bh=ZA1WRS8CBmwiyn7cH/fYPyJwsVCBVl94OU14vHjLO1E=; h=From:To:Subject;
	b=tX2nCRSkJ0RJwkqZml9dSu3Yw1NEbic1++IhSiAahvapRaG3nWuwVPZHk2lXz17ve
	 G+RMDgeLoZa0V7O5zdV9mO3urdpZiOCtbCIcVsDMRD1Xh9V/qZxNnc2DZjva9JR97c
	 2Gd97P06hn1Ez5ProA97AnfpJMdy9ZcmmekF8NMvIuQSW/RYMI64l2jSSkFbQzG/5r
	 mqqJE/SKwjXBH+aw0/wYkoWZt55OoEOF7mbP/GJYHzhu3t6V5jTCyEjUUKuy5sPOQX
	 HVt/c43+G3smjAUZsSsjxIV0W/KfYKQ1vHPHFagGUSuOz3eByPQ4OZCPSOoBHPmk8e
	 IFB30eoAFyUyg==
Date: Fri, 16 Jan 2026 08:55:36 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 00/72] 6.1.161-rc1 review
Message-ID: <20260116075516.GA4713@francesco-nb>
References: <20260115164143.482647486@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>

On Thu, Jan 15, 2026 at 05:48:10PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.161 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Compiled and tested on

 - Verdin iMX8MM
 - Verdin iMX8MP
 - Colibri iMX6
 - Colibri iMX6ULL
 - Colibri iMX7
 - Apalis iMX6

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

