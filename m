Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE0E227710
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 22:20:47 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 5E90D20C14D5; Wed,  8 Mar 2023 14:20:47 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5E90D20C14D5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1678314047;
	bh=laX+9r3N8J6ML42rUkDuUJzagntslBBug9S0aP109Tk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WQGoYetRGfk4lLMl/bhYhbey05TXdYrfwcxR3IBMJx6lCwXuku7zQCiSgZATy8USp
	 dMXA8XX1M2LyQ/NXH1bShEVXYnszkOqptiOgztA8xS5SmWl64P0UHApSnmzZZuXB5W
	 4fH2DTeMy9RLrVkZjA2tLu1WCz6G4KOlq1a95NzM=
Date: Wed, 8 Mar 2023 14:20:47 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Message-ID: <20230308222047.GB9044@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230308091853.132772149@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Mar 08, 2023 at 10:29:31AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL x86_64 or WSL arm64

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
