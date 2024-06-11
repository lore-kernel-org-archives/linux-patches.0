Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9FC11E488
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 03:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718078396; cv=none; b=nNlUcs6I8skDdjZ7HZkFUiAX3yzVESnfxhnioTf9tuY7egsEYB08MBt2Pz/6k+5XNYTyBAjyQd3wBkzYUy/NvDlZ0BmBjNHu5t2xBUDaDk2CmPtPBrfvNUP/Ja6Te3c4EjGb+xsfhlkAwgyib+joawg27Lg6SPekXBwrzEsGwsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718078396; c=relaxed/simple;
	bh=t3n1jARdwCEpwkFlx3UPCwYWR3ioikWGpffuxIdqtts=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uGLJNSYU6WlBhcYO3Krbc6q9v3rgduFRC+mrl9+eJjhV7LTqT+weqdu8zXwXk4hVB2RNs3QtZIujd4+cH4P7QpWegFnZYeCvr5LCXVRQfF/4WiJWSJ6YGGtyZZBxNphb01Yx8HwcCQVJjO50NF40nk3b9TPWGcu8BQUbZGN5VWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=eJCAd/rs; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="eJCAd/rs"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 35B9A20693F6; Mon, 10 Jun 2024 20:59:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 35B9A20693F6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1718078394;
	bh=lf+a1Y8JwL/u+XX2fROmxQYeNIyz1Ke9sCcb/wE+Fjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eJCAd/rscTtxzK1TWUD/MNCQDLfHF4dafagnBwfGwXgHs7KzgiQu7dJCe6Qo/7DW2
	 QZsXDo3H66OxXE4bt9BbNOcqy7W3bfdRDMC7NdOxAfHgjVX4VNOAuRoxQmw5sOiZk7
	 H+mECnKK0eRCSoy84LAyKkOh5XhKPCRW7/DmF8+A=
Date: Mon, 10 Jun 2024 20:59:54 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/368] 6.9.4-rc2 review
Message-ID: <20240611035954.GA27792@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240609113803.338372290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240609113803.338372290@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Sun, Jun 09, 2024 at 01:41:29PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.4 release.
> There are 368 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
