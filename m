Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F8127F
	for <patches@lists.linux.dev>; Wed, 14 Dec 2022 01:02:45 +0000 (UTC)
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 048EA20B83FB; Tue, 13 Dec 2022 17:02:39 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 048EA20B83FB
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1670979759;
	bh=maRg8G3Tdq9v9MViU7vfDaJQHCt4cZ60ApGNvy1tfP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jlWXnu+Z252HouDKjPRxDiV6a9Cuvk7tSCTHQDGm9B8F4Ejs7Sj72bhT1WdWvN+iv
	 CqdbVI5NYaX/DFmG3LjrKzs8zpCax/keNOm/0TZq/2lUdXaj+34AX699nq9H90b22+
	 kE66aVnRv7MdHsmiUEZ/yEF1LdHAgsXidGMQBFmM=
Date: Tue, 13 Dec 2022 17:02:38 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/123] 5.15.83-rc1 review
Message-ID: <20221214010238.GA4793@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20221212130926.811961601@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Dec 12, 2022 at 02:16:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.83 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

No regressions found on WSL x86_64 or WSL arm64

Built, booted, and compared dmesg against 5.15.82.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
