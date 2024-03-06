Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BC471426B
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 23:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709766650; cv=none; b=cgmBPdncnTfeHMnd+FOSmjxyDGQw9pp92xbN/YS0hu5UNii8mrKOjfUfmVa82Jp7nzfauTzB04c6xygch5lJWexgtRa5q0WATWsJX3lwXVf2qTzHPK46KBeuxLMURgx/FCeDSOKiiQGlwie6I2hQScqApC47gYcSjAtcXBNY8qo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709766650; c=relaxed/simple;
	bh=7VTqeclVPr3FnGH9kzdAkOiynxNGbJdBd+5mrL37qUI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bL/+EoRL8L97ssclXwUAYbHw7A46wVir+z7zLfVjdRbzol28txTltyKoaFLL3jebpCSGuvOgmRXxyOekw2/iqMR4BEy/n+VWSUk1KQhVai/1ehfpPIAPENOyRmyM/gs7m3i5pqHb89f3f0hHJATct7E1Ymjlm2rdXsdpXEEqvVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=hP8u1OiJ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="hP8u1OiJ"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 6DA5D20B74C0; Wed,  6 Mar 2024 15:10:43 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6DA5D20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709766643;
	bh=+lT60b34SmHHwIMko6RDTMTeNyVjBhtZUMPZ/aaoAJE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hP8u1OiJAJbuwzASfA7NLZ8X2Ee4ebZrgWW6tBKhtH+wqsxcHeMkUzmJu85/vmLly
	 Vq+bkhPvmXrAFKpw3BEKsYSVI2m3dNSB/N+9YZQaA8zpZxFnkwA8GtTVjGPGMrpqjv
	 Rfg00LvRydZF/t76xtiy2vcNWMZj3vqr7n308e/k=
Date: Wed, 6 Mar 2024 15:10:43 -0800
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 5.15 00/83] 5.15.151-rc2 review
Message-ID: <20240306231043.GA18984@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240305113135.403426564@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240305113135.403426564@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Mar 05, 2024 at 11:31:56AM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.151 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Mar 2024 11:31:11 +0000.
> Anything received after that time might be too late.

No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
