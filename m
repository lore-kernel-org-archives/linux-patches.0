Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7D84411
	for <patches@lists.linux.dev>; Sat, 25 May 2024 01:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716599229; cv=none; b=JuvbrmvorMdLgoUM0yX4avLKKFUJEP9JOs5Nv7Kju6IxOjFVhOxAt9AWuPpEm/Jt8NWs6XKIY7pYiv5+bhrXZxNO3HUf5qMh0dAJ/RZaW3WAn6S1u/D3f5IcosmgGRrqTr0IMeIS/M7nBqrkM4dI3DSTvTf7t5reYLBp+dUtBhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716599229; c=relaxed/simple;
	bh=uilga4oWzswFecrKy+rNWuRtTKPO7IQ0aXRzZmHTV7M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qS0128ckxSE1r7rJtIWi03nwISS9MNqpjvi4WdzUxGAPCe/j1PwteHVqxO+2NGY46DgZKnoXhYpceITf8NyfJr3/dvHmVhapnbaEYfX+0X3hH3llWhG4uU0zAayYAG/n2O7pmL5+C2OiDXjJTs2vDCoxIosnqYOAdgj/cxSgwW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MNhVXDOg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MNhVXDOg"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 36E4720B915A; Fri, 24 May 2024 18:07:08 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 36E4720B915A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1716599228;
	bh=VLiNY0dLrTQh2C7AZ6ESL2TifG3JLLbQOQsM3wDPhWE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MNhVXDOg+ICTAtWaFm2C/XfhhFK7KbN58XNAnq1iRmQJsChEfC2vRA3Ftn5N1Zxqw
	 geid9gv2iVFrQFLfIi4Q59IoD+ruGiIUdw4e6PF8cHaNqhPbuqlnPseACEs3eguPzp
	 eDHPsKBT1bD3hsIIYmJUK6HTERGRgfaio3GNQhVI=
Date: Fri, 24 May 2024 18:07:08 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
Message-ID: <20240525010708.GC22512@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240523130342.462912131@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, May 23, 2024 at 03:12:25PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
