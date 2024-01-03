Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4A301F932
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="QzMasmV4"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 7B2B720B3CC1; Wed,  3 Jan 2024 15:37:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7B2B720B3CC1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1704325074;
	bh=Y2xXW4rLnWBwv3XYyP22fwruGLmFCFghqVmYAEAWj9w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QzMasmV4qE9hL7y9F2XLb8O53pPX3OLvGN1KSXHd65qJ4RI7sEIJBrj3iF7RWjhT1
	 b8K9YJ/h/S5fClaT54tA2bHlDsnsYeWTAr4rfj1BrTZ5RXXo55AQK2zWs4YKjdPjNz
	 4ZBN05KRXmu6Pqv+40TSyWeprIxHFypfCWFSnewY=
Date: Wed, 3 Jan 2024 15:37:54 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/100] 6.1.71-rc1 review
Message-ID: <20240103233754.GC858@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240103164856.169912722@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jan 03, 2024 at 05:53:49PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.71 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
