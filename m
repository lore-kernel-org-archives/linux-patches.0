Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D98D31BC9E
	for <patches@lists.linux.dev>; Wed, 18 Feb 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771419084; cv=none; b=NoZos5a2GWw36PRXBMUJc7G9A9XvAxlcm1fxDQRqc52zoK8fo6M7Uqm8BaO1Oh4ykR6M1tWq5BgSuJ7Vi2pw2IHbyRwV52vs2NAemTmepajNC6dkZtajqzS6EuyocmUQfD4aqQaQ9xV4Qv8UQ33zuFC5+xQsT+SDcdXEyQeFwVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771419084; c=relaxed/simple;
	bh=liuZZYlrA43V2EPrxkhvXIqqqCrhh4XS54gi7wHiRUo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T2rNUvpUPNOXO7NH2D+fPb/ptyKLUrIIG+OFWz60SnmdIBTvy4GdUsUoc52Rg5vnNciFtT/jtB/UymXi92bpmGfsGIG3bF3hjrwb6sHilWItzXOSbvR5e3OzquHzddya4yQ+ma0ek7EaNFO8rT4KfIunSwUmAnpplVu8thHvL20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=ptfv8FiK; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="ptfv8FiK"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 1638D1F969;
	Wed, 18 Feb 2026 13:51:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1771419080;
	bh=57R2bMYcZgJmTh7nc5eturuwK9MC2OzRRt0ZjPOG1Yg=; h=From:To:Subject;
	b=ptfv8FiKx+AehtNPi6zNDNjXqFOjCdYEGvlR40YCuIXVlL2x8xglUJxADVezl8Fze
	 UQD/ae5E6SJMKZ1rVHX/G0I+YfaRdnYzE+VeiBb6BzN2BPZCT4f8Eid+nlvaiHHltZ
	 YIwLXMkxReTihcUqscGzoSO1bz7yy5tDCz0PELaEuF5xoI21xzOtxc/RzS7FUHRpY1
	 jlLMu4ByFnCq++1tnG4WsmkY3+WupvzXnLg0aBMNJU9/No2b4c3K6yD8l69COm0bO1
	 n03YbISuyRPTZoHQoo7uXaAc7oHSVD/sxZCgdKDDvpSfEYYyo79UakOVVMJrD7AxWY
	 r/Sz4qXEd22Kg==
Date: Wed, 18 Feb 2026 13:51:16 +0100
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
Subject: Re: [PATCH 6.12 00/42] 6.12.74-rc1 review
Message-ID: <20260218125116.GA92059@francesco-nb>
References: <20260217200005.998240758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217200005.998240758@linuxfoundation.org>

On Tue, Feb 17, 2026 at 09:31:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.74 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

(For the records, unfortunately I had some test failure on Verdin AM62,
 but I am 99% confident that it has nothing to do with this kernel, more
 likely something around my test infrastructure)

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

