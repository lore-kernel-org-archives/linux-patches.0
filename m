Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C982537D12F
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 07:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769671914; cv=none; b=br1gd789SzMjrJfO6+KsTCVSH6pujID1WQOKUIhIpY7AEGiZCSMxm7Ht3w/VI770zr/L4G+W+D/HVBcgU6w+hGO7bpW9G4qtEPtvebkml+JTq/RxdFys4LNGYFS3Pvp+LXg15kQ+jhKVyYXAFZbxWLU/OEpRp+tW2iDXdFMwf8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769671914; c=relaxed/simple;
	bh=G+c3dy+TtvebUZpOn5DilXhuONHcA9Zv4zq+BVHeUAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p24kVN3L+52S8zZlTD3j+mrrLdzHjIwtOlhit71LKI2PNTeYEJoPtF7ONSfklHYLsvPSHlrH86Ml8Ps5IN1TXBMv2aPudCM7+4okkiwWo2IiyFInrfiegLNz99owO+ZjjI/Z+i7uL4rQ/+DkeXCq3OUXVzwQBlPQJET9+WQfI08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=hKoe/65t; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="hKoe/65t"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id 89B861F94E;
	Thu, 29 Jan 2026 08:31:41 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1769671902;
	bh=W04uS02BIV5JBZQpHTGOvLH5aqQGgX9+4NLVifUkN5Q=; h=From:To:Subject;
	b=hKoe/65tCLbvtXuY9jhFXOipJyoeOJsvSpsr1O34nDG6ZRWxuAuAEuO5RmtEORpp1
	 l15NjfwAY2nc4MLJD2mZISGd5KAJ7C3udlR8VbdZ60C7rCRRxypodEJQuEXhYkG3Bn
	 JXHTTo5Oo+RjN1UwoFh34cmDxI+eK29dt3/W73Hs9WSeQLkYaBuaUZYbC3KM56SjAZ
	 jZeINhk+YtkjYgmKkhUxB05yMLpevRI5fM5O4LJBwlUUO5w7L4gpHpfXXYs5uN8HmW
	 gbHX+3+jLYEmn7+b5qVHrfiyM8KHUOKrD32NnHXrGTLcdab8dStd3C7PPUnE0ZaCfy
	 LzF81gq9Bvvsg==
Date: Thu, 29 Jan 2026 08:31:37 +0100
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
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
Message-ID: <20260129073137.GA4549@francesco-nb>
References: <20260128145334.006287341@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>

On Wed, Jan 28, 2026 at 04:21:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and tested on

 - Verdin AM62
 - Verdin iMX8MP
 - Toradex SMARC iMX8MP

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>


