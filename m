Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3725BAD48
	for <patches@lists.linux.dev>; Fri, 23 Feb 2024 01:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708651477; cv=none; b=p0jf8fdkc2T+JB6Wk461K0mXGnqBdNr2O3Ulb9xUrAgZSkC1iaP2JdCLF4o8cCyh+D0893JZDXwGNwke8+EZm/WOwBgpToyYqyQW6lGjYDni1L4Dz+C593JspEsq2zXMHXlXJ0HsrvDn9uuOeIw1Fe+RJAy1o4fX52DEYBOE2Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708651477; c=relaxed/simple;
	bh=yyQg6XYyqGW1cB+HwjZPHkKX14Ehl9PiApFpMimuFyo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CZUnQl9N2GvE7MmwN0spzBgDE1vQA05vZKKQfnwnMBnunW6bmClynCrXP+cz1bjPnY/NSuq0BQTgnWU16QZDqK2CbLkWvgYCMmXmE2nYNox3ZLYg77g0Nc/FNCwz2sBaEYaqmuswO5fO5k4kgAWueiNgGUAA13VxF4RymnM4A70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=lB1V9GQu; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="lB1V9GQu"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id E7E3A20B74C0; Thu, 22 Feb 2024 17:24:34 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E7E3A20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1708651474;
	bh=AnR/6UJPCClT4pxKKUKVNNuY0J9NeDwa5YyTzwv5ejo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lB1V9GQumX/jeI/WPyV1DTreH+f1YYg9TrGGwv3X6azVEnQ0KlllqhcSITnidM63p
	 3m4W0e+sW8ZsJntWkxzDZh1DODkNbiLAQsRiEDG8TDB9yyjV/9y5WkhGu54FFHyjZX
	 Q5EVP5Jt/mYRUj3dqCucrq9H+u2iBkU7fAUweqyk=
Date: Thu, 22 Feb 2024 17:24:34 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 000/476] 5.15.149-rc1 review
Message-ID: <20240223012434.GC20295@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240221130007.738356493@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Feb 21, 2024 at 02:00:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.149 release.
> There are 476 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Feb 2024 12:59:02 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
