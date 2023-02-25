Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6919217E8
	for <patches@lists.linux.dev>; Sat, 25 Feb 2023 02:18:15 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 184E1209C26E; Fri, 24 Feb 2023 18:18:15 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 184E1209C26E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1677291495;
	bh=IhrwGLqmgF4B8WDfAYas0s8WpUDxNET0ahy0P8cBv64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J6yIiT4tShsq47A508dIj/ODfA5uk1cyFiu/TMb6XB/7oMIwg5SgztPLSKLtrLtfH
	 3Nu1fFr4KI1xoQP9bFLRi4AMljI0CRPbIAhcy+k7cxNTQvU+HY4nwJniYA8QhxIwD4
	 h6Q81vIv7+vFnZW4walnABuX+Rsuk6dN6xt3HEaA=
Date: Fri, 24 Feb 2023 18:18:15 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Message-ID: <20230225021815.GB16293@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230223141545.280864003@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Feb 23, 2023 at 03:16:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
