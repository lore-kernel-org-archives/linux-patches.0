Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1EE518754A
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 18:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720030112; cv=none; b=UlcX0cMS2mZsa72F9qWJw4GGTCC7szx95Yzio1mdLt9OYJ0wi2SIIc9MH83kNsDu2k4CfoH2MslFY38jlYErVAotCHNHTPFSlzagnsuVPNKjAEdpnZnkWAh4gQDoN9lNc2Vv64om7uKre5ArlbWPUAb9Ej1I8vCoEwmBzThGo2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720030112; c=relaxed/simple;
	bh=qs0I/SSidq9zOLNIaIIKiUcMkXMdRuw+S0QByhC3PU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d+/idwaipE2VR8q+liPCb8Jadw7lmSBR5aggksOHQ+4rXYeU9r5PlxkhNeeIkCsBhSDynKN5+JFTHCSLF5Lf5V+f9b96jFObqLu/Y/0nopLeLNvRVcc1M7aP72jyKlso3p6vxBOyKT8jJJGMuHXLEQQ3HkqN62Rk4/MdVRfveoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=q40+sjjW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="q40+sjjW"
Received: by linux.microsoft.com (Postfix, from userid 1131)
	id 62E0820B7001; Wed,  3 Jul 2024 11:08:30 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 62E0820B7001
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1720030110;
	bh=oBFHtL4VSS/X6+5V2B7fPBH77t/px3KqX2Rlv/oBa6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q40+sjjWMvnh2BatX6Sbvf0mXCmGSnLKgY+0nog2FTsmSNHqW0E5zHPhRgiCXleOy
	 kNg+MyY0FoyogYMaCRQBhIPA8VU91oU+DOshuIgl4CQziZT78AowqZ4quPMYTx8chD
	 TiJpm1+4Q2rknvouUsiwdmqfO3rfJvba2SEJnxhQ=
Date: Wed, 3 Jul 2024 11:08:30 -0700
From: Kelsey Steele <kelseysteele@linux.microsoft.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
Message-ID: <20240703180830.GA16822@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20240703102913.093882413@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)

On Wed, Jul 03, 2024 at 12:35:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
> Anything received after that time might be too late.
> 
No regressions found on WSL (x86 and arm64).

Built, booted, and reviewed dmesg.

Thank you. :)

Tested-by: Kelsey Steele <kelseysteele@linux.microsoft.com> 
