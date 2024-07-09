Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3528F182A74
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 19:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720555008; cv=none; b=VPHNRXG0vxCJ4hdUjbwrnPtnHkfO8y5c3uBdBDwwpz0dRbeqrby9gup9hjJIdLZa2dr8FtkR6zZsNUHW2sxwbj0NztgHZhCNFz4PT7f5JZ4d83YyP40ZGvv96Er81eF0d3u51n17NOc3VDH6uIVJgbkHQnIOX34Lcy1GovCvDQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720555008; c=relaxed/simple;
	bh=yMlblo3pT/WeBHON112I8jimtkQPW6zIHpL/oOklDXw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OzkvRuZGu5jBcSkkrnU+5FHAJ6khGyb7UDSBqKv/em7T8+pbEB+TbULYQtfCNc9GMiOiJ/2K4R0Ou7RjBEKbcpspj6+MLof8Z3uZyMfCn/xccEqb3IVfniExUOv/Oq/Z2KzXNCaO5MQfOEbPKHvm+xmjg2SuCfLq4/l70E9rAl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=ATiLkjxc; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="ATiLkjxc"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id B5D3C20B7165; Tue,  9 Jul 2024 12:56:46 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B5D3C20B7165
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1720555006;
	bh=dhi1vSchw/EYAhES2PjHFkEvmmjxoqTPVbWzzTRz3AI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ATiLkjxclJMC9arufM6VeFayAoxqWAcguyYldnw0jU8cB6mkPrlQpntb+tDxi4CGZ
	 efU0TY4lobVPxMc5uMZzsiqcnVr4V6phoHLNN3Bhli5+bjJRtkO+PeITpvilFnX/sA
	 AuwkSeOmoWaoxoW7SN7hKT50PaubOZsLid9SKUkU=
Date: Tue, 9 Jul 2024 12:56:46 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
Message-ID: <20240709195646.GA28302@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240709110651.353707001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Tue, Jul 09, 2024 at 01:09:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
