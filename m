Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7601D2848BB
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 07:34:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772523301; cv=none; b=gYhDXMpP8rpUhk5X4lC5yv62Qi+KqRpldiGFwxV60oiXrUleyRQe7us3VbiZbBaLv042cOU32Yow3jSx1zcEugJ4KU/y3rUxKsskiR5Nm671PgqxPg23NPv0OxLisZ+GH7fznrcAKWHTLBzRdLli+B6RN7yo8pHxLjpoUx/Eob0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772523301; c=relaxed/simple;
	bh=eJBSjWKAqcnbs3vFYL0X8iwtAQ3ADuUvpnMXo30FNNA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SmAz+EZYgeS2BpHuWXoARwFwdCMVSPs5i8FWwIc7Qc5BY/WLx/GONr6EPdeUqcu147nwRpLMjCxA4OqEUTQc1z2SGBbB8HHHi/BU5QsEDTITKJP/DTBDjbQJQFx6VdJAwe7iNcGjmgKq93gkU+ckl0ucE+xfK8Ow4T05RUCqIDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=kLXSZbKe; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="kLXSZbKe"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 6ED392296C;
	Tue,  3 Mar 2026 08:34:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1772523296;
	bh=1n7XxrIbIP2ml68QkCxkal5P2o3ZuWEH5CDWcKf7GAU=; h=From:To:Subject;
	b=kLXSZbKeGYBbDlPZLE6ss5L9RK6AoAR3J+1G/F+MPCyi4Pq3k5aO0wxShsYjxM3fo
	 womo4vZTlpZdVDnyfft92b7R7pZxx60bycrt8qRJInewdn907uxNxVLfFE3x9HPtAB
	 Bdu3nOUTYko3zp/m/8MRSNPQ/PSkoWkBWG9+V/DkCxT5l6COey8aDp+9qv/OQFB8yp
	 CkQ60FpjaCPDSCK1su95VcHm1SO5X2pjLtmPre8nlJzinEbQ/mgunjqjtKCAqtbl3J
	 kjdSSgfdovplzho57SBXJbv0lHUD5QJ5NKmEDZfLA8fOkVMa/sMxbisj7FDhUx/2aK
	 G4s/qRqAVoNbA==
Date: Tue, 3 Mar 2026 08:34:52 +0100
From: Francesco Dolcini <francesco@dolcini.it>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Message-ID: <20260303073452.GA9569@francesco-nb>
References: <20260302160943.2522184-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>

On Mon, Mar 02, 2026 at 11:09:43AM -0500, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
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

