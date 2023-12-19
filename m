Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7859917CD
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 01:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="PpDLhMAW"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id F1FF8208A7FD; Mon, 18 Dec 2023 17:06:49 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com F1FF8208A7FD
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1702948010;
	bh=4kDo6sElBtBlfEMuJpsvg0vSk3Ie3s0Xo6MC0Pqe/sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PpDLhMAWjMsg5/N1KF0PgNwXbRk+H1e9NcgEDN1oSKxSU6TYzTD1CzfCk2MLpVZuv
	 +EzAZmev8cW4SzewcSkqM/1TMUdahn8VqOOE5tgmfQOzdGcKLBVz0+lqBt0ame8BHa
	 bB1n8DQ1zByERLYxrrfDildSl/xaWqnjCRVZyRig=
Date: Mon, 18 Dec 2023 17:06:49 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
Message-ID: <20231219010649.GC15952@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20231218135104.927894164@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Dec 18, 2023 at 02:49:26PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
