Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11937380FE0
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 21:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783028984; cv=none; b=CvCuBB36UKvTR3JQUPFa7bkzAEpKx6nwmHEeqrTlHxpjpwhCz/OMRjCxVYU4F55ikbY45LQPa+eHzSrSPDf7p0Dt3HxhVv9t0gvs/jt/SqJ7OCM0ktjEAL3+Ej+XEFNYIgorPtn12PYoW9Q/S7sBLBO4ZFb5MsGH+XwW2Dlzaco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783028984; c=relaxed/simple;
	bh=0fC5+7Qsj7SRA5PZBzND4iRKsv/Uckh03xn1Z5//zpQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p80O0jC9sqNTtFp++qqsMcynrY7a9TvLkHj+HuakB9yz8OJ9LvmuHyxNojmqbGm6H4Qg2XMfZsAX8wrJBUR0FJkywp/pCCon3OYMxg7sPHBw/PbAOEaN27pcEnrwJuGJGX1A24Xia8YUpjj+O/MYze6JP3QcxpLTg9eRzTmAF8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=z8GcIeNE; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="z8GcIeNE"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id D215E1FD17;
	Thu,  2 Jul 2026 23:49:31 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1783028972;
	bh=uWY7fw7M8W1sfIaSjOoPqodayJGDFfwG8TUmi3zZhbU=; h=From:To:Subject;
	b=z8GcIeNEN1F2kN/dzURZVX5bhhYaUJCrcB9UfxrTEojy6fZubIxK4hGKy2Fokbq1b
	 HE95GHz4RpSfteHyI4iJaDoVfErMxyruOSw7jwqS5Kzfi4cZV4/u6l8Lw7DXk9hRnP
	 MEY+GwALyeWatkNW8B37ygnu08lijHPI9MtosD6svZqFq+2RIzASv4FSwP/xGBktKK
	 dO4W84SE9kz1y8boLZap/t+j/NahxF0CMUrp638fFQ48hL/XDlVgBrFYx1nWoI5lsi
	 4yvVTgIljixNc5bHmgP1xnuRc9zBi5oJMTusC4Zch/R8rOjfoIGW66B5x5erzrSjci
	 ggq6aBdWE5l1g==
Date: Thu, 2 Jul 2026 23:49:28 +0200
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
Subject: Re: [PATCH 6.1 000/129] 6.1.177-rc1 review
Message-ID: <20260702214916.GA281897@francesco-nb>
References: <20260702155112.163984240@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>

On Thu, Jul 02, 2026 at 06:18:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.177 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

