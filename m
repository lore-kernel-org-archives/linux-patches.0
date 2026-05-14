Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1A03909AE
	for <patches@lists.linux.dev>; Thu, 14 May 2026 11:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778759988; cv=none; b=uBCWz05eDzu5kb34LC+jVMYcRFL9rPAckMtppnapEdzG4FmBoZygOYQ4LkCWsNaHm9ZiJBq4vmQvSjPBgWGTRW9BlVV3z4Ob0dc1b79MrgcP6BLnIxTNlrMjyjH/F3Nv8fqWq/1dSPQhO8ut7Mbp3zbO72/7bugJZKhe8xbDt+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778759988; c=relaxed/simple;
	bh=PVBeJb8wrQ4ls6WOJspmZ6aU8l0SukGC9SlYz4EvF24=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NL3NqAk37oIj8pLsQcy6W29iS5kbDIGf9CqizT62dZ69zlN+7zEmtrGSmVGJ8bGaHY403ir17POYOyadMStVIXTHQqPvH4xtafwGkFlQNadqAEA4Bj7BKW7rkEw1rLlHJAfmOeyzjKmdBHdXdxNB7M7sXwknDHjIxVzXeGALwiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=i1/cW2GO; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="i1/cW2GO"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 385A61F92A;
	Thu, 14 May 2026 13:59:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1778759984;
	bh=U8YREDNUUsB/v1tJ6TEOknoVCf4/EvZwsTxSLR50ZPw=; h=From:To:Subject;
	b=i1/cW2GOyVeIyoF7jr+C17HxCw+mInzPYflXBqtmBsFWqnLKPiJU9wpgpgb918qVI
	 vf1lMC0kak6ttrBVnwutEhiJgxUNKzRex+OQzGzzOnYK3EEwwfd5c7CpiTzz9150gK
	 Z/Xn6I1letqjLv03nkwuqNXARdpNJ1gfLXy8cfaps7tKhwkwnHoY2iustQEEKfd7eb
	 e0HsbuWdvQSNWUj6YiFG1iWMQCHnnT5AnIsDkaubBO2tlpiBOfmKUHjK+vhn6hkzK7
	 aTpt/ZctTe+ogAB/HCr9KGDKgRuIx0id3sWn2BzF3QeOsI5dSv4T5ZLnFNPpmhi7OX
	 J9oft77rmSBXA==
Date: Thu, 14 May 2026 13:59:40 +0200
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
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
Message-ID: <20260514115940.GA6968@francesco-nb>
References: <20260513153743.326058350@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>

On Wed, May 13, 2026 at 06:17:18PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

