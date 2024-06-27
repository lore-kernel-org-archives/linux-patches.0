Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84B6813FF9
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 03:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459399; cv=none; b=IADoTgw+6GN29b/7ZSBIZEDxwThaQ8wu1Bv3qVl4oRdkL+BcK8D+h3txQ7wt0QMkIuDDTY86B8SJUKyc08l2OP6DAzWilP0EiiFiT3kiuUv+6gbxg9q2UpOwd/a14z6ODe3Ksx3EFR3MJFwfLfP31L8241/lAYJ2dARFTQ0j7PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459399; c=relaxed/simple;
	bh=CGVBnUvrgUbNw9JtayPmHywmKor2DIok4PGslhat+V8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iyoIUJoDLlPFLnGbQEUOlU3b/0fDqhwowFwzqo+DkIUCOA0NFtK3/y7XQ7uLMMOgYPwrnLhBEu+N/I60uDyvjbiUJ4bt7sFGRWr+JSHT/uA2q/2oo2NXo95bARndTqqScGkTikW1tzUeV64w+5rzeK5yYwpoivlwNgsGOsftn9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ITbST3C4; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ITbST3C4"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 178F820B7009; Wed, 26 Jun 2024 20:36:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 178F820B7009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1719459398;
	bh=nAoci/BESLc6dj37WSE8/9lFjhKstX0dCbb9LThBThI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ITbST3C4UYcuVklLjZEoOUCKTxR4wj/XMEWbfHX2xFllZEl7yNT8FhV6tWlwAAcRy
	 DZF2goRYdi1w07u+tRIRXz6EX9pYKpcnEAfMFeGRePnT029kpQ8qWLp9Dhmk+/zYrw
	 qq/H431JV4TgMiQR7twJXT/VmrHKbW/v0PCBWHNc=
Date: Wed, 26 Jun 2024 20:36:38 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <20240627033638.GC6902@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240625085548.033507125@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jun 25, 2024 at 11:29:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
> 

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
