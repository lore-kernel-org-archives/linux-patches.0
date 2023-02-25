Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5FE70D300
	for <patches@lists.linux.dev>; Sat, 25 Feb 2023 02:17:00 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 15B7C209C26E; Fri, 24 Feb 2023 18:16:54 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 15B7C209C26E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1677291414;
	bh=QLrY+vV78Xp+gcF5PXEG6OKv0VmG2wUifjKjcV4TYtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sdCEnJJrawRsYBEogOCbpenitFUZxHNLJEF75Jqd+aSSUwu/4SDrqKpYgCgkz+CEM
	 2eJmV15itehZh/RFkUQKsi9L/yoAYk2CvlvysUaDbg90bynbJL+hOSqHQd7qfLjW2f
	 6rddFCamHeWSsiPsTQXUWF7+YVPGvQyRg3nCmFFE=
Date: Fri, 24 Feb 2023 18:16:54 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
Message-ID: <20230225021654.GA16293@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230224102235.663354088@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
