Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0A810798
	for <patches@lists.linux.dev>; Thu,  1 Dec 2022 22:45:18 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id A442F20B83C2; Thu,  1 Dec 2022 14:39:50 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A442F20B83C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1669934390;
	bh=z5Cw5u6TReiRhY26yzoxDGMBNd/PBkF+Ku3phsSlamE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eXaMpd7wZhgrQ8aRfU0Nc2KO/7wwz2b8+JrB4IPaB7gtHDDWATNq6aW5neaCdEGdJ
	 1mzI/n58qJyueOUKBAz2ZxKbnzELtaMDPEDQVT/Nzl/q2Yn0JT/pOjUBVJ7syD6lnr
	 gUnSuYa4SFcxl2pT8FtH5cuukph3rfpmUBh4wQ5Q=
Date: Thu, 1 Dec 2022 14:39:50 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/206] 5.15.81-rc1 review
Message-ID: <20221201223950.GA15551@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221130180532.974348590@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Nov 30, 2022 at 07:20:52PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.81 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.80.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
