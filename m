Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E2793C49D
	for <patches@lists.linux.dev>; Tue,  9 Jan 2024 18:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="dHHxPivL"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 2134920B3CC2; Tue,  9 Jan 2024 10:58:41 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 2134920B3CC2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1704826721;
	bh=XYq5dS1a/hTlZwvfXI3aGywP0eI2A7vKn4xo6wC+qeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHHxPivL09toWB8o64PAoMFh+O2hmveyIvl/PsFpxK3Ta7DzjOa1CqWOm2fyAMQCr
	 3vD1esvIc1BDVJcfBDtU0+vBxqViu7D86vhgkZCPCTz/Y4vJf2uHNwXCX+rmH8CQ6+
	 F9P9sXOKzpyUA24XhX/PlZr3rO1fftSxQYgnfYdw=
Date: Tue, 9 Jan 2024 10:58:41 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/150] 6.1.72-rc1 review
Message-ID: <20240109185841.GA4822@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240108153511.214254205@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Jan 08, 2024 at 04:34:11PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.72 release.
> There are 150 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Jan 2024 15:34:37 +0000.
> Anything received after that time might be too late.


No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
