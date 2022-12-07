Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 089A5376
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 01:19:34 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 5B33720B83CB; Tue,  6 Dec 2022 17:19:28 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B33720B83CB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1670375968;
	bh=sd8kovaysO7xgbfTp2ZqWJMsIQ59/Ae4mCY9lSxD8G0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FRyYvdnmDDT5paZQQ/txj0BlgljpDQtSAK4zsdlzmZk2HwXsx95eFGdtZWzgYJGQi
	 6gvAaFR4AyifvRgKG/wRmrvVKLoEvIwpzqFG0g7FG6exN/KpcYPGt2uiwWlAqcHqfa
	 mtaIjfMe96/fxRhCnvgkN4o6oQHqyHIj+CbbQrY0=
Date: Tue, 6 Dec 2022 17:19:28 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <20221207011928.GA21598@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221206163439.841627689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.81.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
