Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14C0D370
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 00:26:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gzRWfxQp"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id CA8A920B74C0; Mon, 11 Dec 2023 16:26:37 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com CA8A920B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1702340797;
	bh=rJcScg8kzxb0DFV845l8jAftA80fK9HluK1Z1gzBS2c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gzRWfxQpV6zlWnj1HoUp2A75kYnKvrxATq0JDpFTmamKSc26oGzmw1zlnR04cdILS
	 OwCJV7kUYdypHbspgCcm4w4Yl8Eg7p8GotiqrpmYyZCENLJcpV4NSrtiFZc3+N9asp
	 ylPuMMlSlYZ+iP+FIv2dQLFr6PLd3UvO5Ne+nGFo=
Date: Mon, 11 Dec 2023 16:26:37 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
Message-ID: <20231212002637.GB3073@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20231211182036.606660304@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Mon, Dec 11, 2023 at 07:19:50PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you.

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
