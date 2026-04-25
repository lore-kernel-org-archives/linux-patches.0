Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CFF0846A
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 21:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777152664; cv=none; b=Y80SjVMmfuY7nBmFPVlxjbaui+YdZANbYjrI56yM5vm+OXDs9UM1pXg2X/dkpFSVscf4Z9vBJA8Bt5O4wPareu1z73uus/tyWKrIMAqRjggDeOn5IKt0dasmoCK10ZUXRD7n2dGzGwul50LVuYOLkw+mXQG9zCy4OFgZEOYF9TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777152664; c=relaxed/simple;
	bh=o3X9GeT87A/wRQaJf++Vs43Fi19V8rBkKEmZO+5ASB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fszOoyebCvZC7fFUKJDS9QAEOHjj0yeMiWdIodWFHlv4zPgkZtccepbbCuETJJXISneSSV3IhncT+sHe4jKxgm2zCyxWfwAKlgvb7yWCt475ykFpT138k0Dl2vozhj20ea8wZews1Vb52WRhwz2pzc4isgdho3lXldjAvnYu/9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=Bv3ybdxc; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="Bv3ybdxc"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 419211FCCF;
	Sat, 25 Apr 2026 23:30:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1777152652;
	bh=SSuZ1L0TC0B+bRlja12N/NXcLgKIcvPKtXOz7ratNCI=; h=From:To:Subject;
	b=Bv3ybdxc/MFcOXQttTrvJmUwVwAgiuxuWk+Z8h2CwVnuWmatYVJ3M1bzVtkxFYLiD
	 jLwzCOBjnQIviqwkXw79E1RHvyg/QK/UVbFhsux2nyrJ81TnIRIDCsKdGJIRSU9fBC
	 nm3lRSxdCECHRZYlbOT5vgYktX+zTBXVE2FqhmTRAOpIRFRsozEquV/PSpBxXj3WIv
	 ZyfLRAIgiRc4x7ji/aS6EJrdoKaa4agNDkgAmGIWB1wvCF7L/eTnh8exCKc2mv1MTl
	 cAxCnWAExGcjN8/I2v1W/Mij6TXq9Ve9F8rg6m8Ej+wk7PWVAIM8EE7leGo8AbLzKJ
	 Fr4S9kH0kjLXQ==
Date: Sat, 25 Apr 2026 23:30:47 +0200
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
Subject: Re: [PATCH 6.6 000/166] 6.6.136-rc1 review
Message-ID: <20260425213047.GA17563@francesco-nb>
References: <20260424132532.812258529@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>

On Fri, Apr 24, 2026 at 03:28:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.136 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

