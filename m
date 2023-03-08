Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B061627710
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 22:27:26 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id BD0542057641; Wed,  8 Mar 2023 14:20:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com BD0542057641
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1678314010;
	bh=wKOZ0NtJVZvpbDURIAy3RDo50n2p5jkyluRdFUNyLlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M5291RNk5V1sHf3Tge5I2vQ9frEoCMFuxMXdaQeKAjZZrvE2RP+BHLqQjUPxLfwIz
	 z7l3OQWyAH6DWtfYsy3PEPjkwuzQpxt5FjUrTAbzkqs6/4vMt4OMUJ4V7B+0RRcbou
	 KLTXGl9hCi8am4/H1aJxXQx7W8GH3oshQoKBKi8Y=
Date: Wed, 8 Mar 2023 14:20:10 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Message-ID: <20230308222010.GA9044@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230308091759.112425121@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Mar 08, 2023 at 10:29:40AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
