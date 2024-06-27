Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D1C134A9
	for <patches@lists.linux.dev>; Thu, 27 Jun 2024 03:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719459350; cv=none; b=KhnlIphH4bfthmYtvhpVnfinBr+r9u5ZiO8VJt0LVCPEoqqA59apV50kmtLpgX2C6kHqhtcgDOwWi2KsTrUtVQZdw9ouP5ZFhuswzSXD3FtomVi8/D5+nLUcPNRMUO9yQ7D2V1ajEJOea0n4YcXtCQ86Hltjmpl99mg+MVsvj4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719459350; c=relaxed/simple;
	bh=MRIn2jfw28f9bV+2ZEyuhfAkUgY2Jbior1J1xcqIcKQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W/T5O3fVDUnQKnVp9eF+06AeLBKFEUALQRJ+dky3DoQ06Qj1wa5Ct0lxtBKoqDhmeradCdDvyTZgm7+aICI6giicnaw6XYNo2OjHjsPMK1nDfwWdE8fmuYSmtGYbM0ukoTqWf9aiQfFTV8XylGHi526+3am19/ZAZTiQS0Dt+mI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=cQQhB7tC; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="cQQhB7tC"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 5C23320B7009; Wed, 26 Jun 2024 20:35:48 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5C23320B7009
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1719459348;
	bh=+AqxwhDmM0tctRAf3xh1bP1yYfeASz2/N9+7o989uCo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cQQhB7tCXICaQRcjPLWM57AH/xAKR7aMgSeqOvE2nD5PQXtHGdNBGdwWX7dGjNzdV
	 ionZ/QdYRSEyc9h4U8W9JecT8lbvby7k1muibPhHMUKTlcx8l1esaRw+g6xMQBnG0D
	 DgNb2ZQpfM4HPJHcEtjWlqyXVCt6nJHTgATSR9UE=
Date: Wed, 26 Jun 2024 20:35:48 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/192] 6.6.36-rc1 review
Message-ID: <20240627033548.GB6902@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240625085537.150087723@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jun 25, 2024 at 11:31:12AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.36 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
