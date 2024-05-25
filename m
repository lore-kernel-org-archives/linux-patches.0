Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1878AA47
	for <patches@lists.linux.dev>; Sat, 25 May 2024 01:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716599176; cv=none; b=iXxT/YHjp6oHaD5zVyTFt1hbUbFy20ShzYfRE8yUD3vIdSWK5musGb5FhbtDWQrRDNjD2GSZDlu9/wLmLEfpNRdDvaEzBhLPQ1zp8dIJfowJs2FEjV+U9rrnbi82Q1CYERnlgl9JS6cxEIWy2RnC86ILDBGOJIfafqsi7685Skg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716599176; c=relaxed/simple;
	bh=NCknf76MRpR20ILad/BzqWqMaTcV6AbBrxZA4egZt+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t7jxUDXSFOVkDZ9P0EqvhHdK66KnHx0sjmXQmjG1qjT2c9ebXyiaGnxUwwm056mzQ6JAi6vuQRPbkHlICGsP4fJQXxYf7hb67qD8LGctiyLd/27Mptt7UVVNSA0RFI5Oru/z2ly5EnBlUVVpcPcS57NbqxMcEp1BRPqDaIciVF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=d8jIOOT9; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="d8jIOOT9"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 995082067B51; Fri, 24 May 2024 18:06:14 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 995082067B51
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1716599174;
	bh=sy0QkNZINZi/+Pt8o6vSVMfz69ATnFWHORuPXwwpPVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d8jIOOT9Zt3FTS0x9pQOzQT8/KtDSqW3hVwKJxP6wlBOTMUKsnbd8EshZBLz66dm5
	 KxI4eWY932BgCkfebIVvEMuVAPdTfCrGYAEXDr8XrozioJCPL6QE5UwySp5I6l8aeX
	 NlQPlbdhokjROVgOP4CqIBxrpdu7IOIIW+zYUwN0=
Date: Fri, 24 May 2024 18:06:14 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/45] 6.1.92-rc1 review
Message-ID: <20240525010614.GB22512@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240523130332.496202557@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240523130332.496202557@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Thu, May 23, 2024 at 03:12:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.92 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
