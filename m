Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6AD515A9
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 02:54:36 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 9FD9B20E09E6; Tue, 17 Jan 2023 18:54:30 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9FD9B20E09E6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1674010470;
	bh=JLVTFAzL+JAZ2pxmDSF4NB8D4RqyUFQ9+L3wsEhfSd8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y1hOncumGI17savT5S+/Ms0+HlItFoeyu+lKT+smSCNJh82LJvLKcWjRnakA8ezMA
	 31wEzZuOXa7g/hImNKMqS1B59z2FIvnx8PySUwdQOtAf5xRLd1fIVD9oN2CEINi+kh
	 4S4Xrp3yFwJUXfxZyTlYGo/7k/AGwV1U6LOwrVZ8=
Date: Tue, 17 Jan 2023 18:54:30 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
Message-ID: <20230118025430.GA13408@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230117124546.116438951@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jan 17, 2023 at 01:48:13PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
