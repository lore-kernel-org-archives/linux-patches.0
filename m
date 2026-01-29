Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B6F2C028C
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 07:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769672171; cv=none; b=CcmbZV2EDTW/7cq6P7xB9DbMfVIhls31qRUbX0T7G3yK4txKo+j0RkyZZU7B9a70rSjiv1YJpsqLpkloDtKfoMI7RUyff+wCmjYA2/JX0lsWidHjXHaJ5gqu7gGSJMzN2t402ocgoqBsJrbpuPIbLUS3nKXih96bBmDyAoWN/L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769672171; c=relaxed/simple;
	bh=epB7PaKNSfA9B75lTiH/mhE8TH0yxOOyk7IPIN3CvJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z5lbAxkpeOqYiHnWswWm8wq9m+spdQmI+PvDqyXvXbinZv0JFpLWdLr0/ScXNEFgbwDWAHE6tqqDOCSZN0tcjVcWwniJRDCi0aaEa9Hj1CFAXhYfck1q7bDNWmvH7bmRktBpfNAkJ2Lbcz5Z0GnURYf4Dgzt+cl5MDKkDZhqxqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=okQ4sw0v; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="okQ4sw0v"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 2393C1F94E;
	Thu, 29 Jan 2026 08:36:02 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1769672162;
	bh=wpLK1nS+dzOYj5Yuns3wNadzKrrZsnEDGbWBsQtTjSM=; h=From:To:Subject;
	b=okQ4sw0v1mqk4jcNH3JagmT70RxxHhAD2JCJ73Qg16K7Vfwyu0CVsnhCXoMirvyWI
	 8Fa46JVySO50XhYLmPG4/ceKtttq1eXlyUt61JUn65WSwG6sGri4OQaWj/TYYtRWKh
	 QoPAdoHI9GfTs0jQRMnlzv1OcU4qyZMe/+utDJg1o1a+3ZOrTp60YO0cJ8Zrk7p7QQ
	 153ZO3Q/65ArshAaCYi02QKwNMKvglgYby9Sy7CK4EDkw8MbPDRliLwgd45N6nS88p
	 cLk4Xisqk3GaBTHcOCFC8ShocaITJRCEzUygvVMjbABjOdymAfokyVBmysBd0VNNNV
	 mhJNdd7FYxQvw==
Date: Thu, 29 Jan 2026 08:35:58 +0100
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
Subject: Re: [PATCH 6.6 000/254] 6.6.122-rc1 review
Message-ID: <20260129073558.GA4757@francesco-nb>
References: <20260128145344.698118637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>

On Wed, Jan 28, 2026 at 04:19:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.122 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin iMX8MM
 - Colibri iMX6
 - Apalis iMX6
 - Colibri iMX6ULL
 - Colibri iMX7


Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

