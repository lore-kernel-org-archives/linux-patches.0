Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7647378
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 02:53:07 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 7C1C520B4621; Wed, 11 Jan 2023 18:44:07 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7C1C520B4621
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1673491447;
	bh=PqYuv4pbyrA3Z72ZiqlYh5W5/ZuRXRzW1eF9xBJy7eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rCpCk939bCVs/yeH/unBVxo73hT6rDk2tPOwuAMJGq8r2ccDBbi259QmjEXWwNN8r
	 NxU/spldZRBquIUnSoMFzaTIgpTDrf5kvxuUfWoyy7EDQEVcL6Ib8alDxk7AQO27YB
	 mMIj3i7ogK6PSb7tw6cMnBA/YxVN3IgCQi7K5YS0=
Date: Wed, 11 Jan 2023 18:44:07 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <20230112024407.GA17118@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20230110180031.620810905@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.86.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
