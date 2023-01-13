Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4042C36C
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 01:37:20 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id D3B2120DFE06; Thu, 12 Jan 2023 17:37:19 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D3B2120DFE06
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1673573839;
	bh=w5X0JTpcgb7Z+MBG+besMNQMxkZXg5N1okZUi3uLhHU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JoGjcnnC+9Swu8JZrxp2bSJQyVmjMnQiJZQrqiivFuvctlsldkANKq4EBJuqjgYKw
	 GuRxS+SEjRexu77ZWRhjbO4Oiw00NGg4ssJvlwFCbz5WNZvvsIcvsQS2yg08mjr4S8
	 TRjVDdxqjCcErb1O8f4oNBg6d54iqce8X+OCi9Xo=
Date: Thu, 12 Jan 2023 17:37:19 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
Message-ID: <20230113013719.GB27117@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230112135326.981869724@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, Jan 12, 2023 at 02:56:21PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
 
No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com>
