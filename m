Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0DC714F121;
	Sat, 22 Feb 2025 06:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740205758; cv=none; b=bD4ZVlb+2PWHBtoTHnoJfwxQIL+GnW1KsCeo7sdRIwjQbUTeqgQWxXVuBup/9lx1DZ3YsWM8LnPk4JdEmPE6Dg83w02TdmFjdtGaJfb3ee+x/7tnoM2rCE3qKno/p/mLOuN4VAhp8JSwmfd8rvKKVoAV+3FLEROcRhAdERVgpDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740205758; c=relaxed/simple;
	bh=+muNeOCR8HBJYWxkOjrvjnYNJ2Akk4PGI+8FWBBb58g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XlzCfdUWr17poRP/XJb4R56eEUGLfryYNKpgLuDkw+CPPUrhHCj/OklByqpqT4tGnfA9zF8m5+1rIHtmTN1B+tp1eOzoCXIRRCO49i77wZRgwAQN2oocD7L6HAlSU6WMQ05UgSDJGFqHf5ugF9GGczO0xpoB9TS3T12oqsjnHSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wgIsOA+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wgIsOA+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89C42C4CED1;
	Sat, 22 Feb 2025 06:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740205758;
	bh=+muNeOCR8HBJYWxkOjrvjnYNJ2Akk4PGI+8FWBBb58g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wgIsOA+Upi5ePZvQDkHzngKSZ/b279pvB+K2zGH0a350+i1ZZn3uwlsTbYdDF2OBB
	 gyySa4oXinMPHcyXtnhAzUxExPiaFHYUe9bWdDWyv5nmKCy9MDYML+X7BlYnDgRpf1
	 5watj/LPTZn7b3dUCjRP0Htx9NJiPJ3VFR26nFJo=
Date: Sat, 22 Feb 2025 07:28:10 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
Message-ID: <2025022221-revert-hubcap-f519@gregkh>
References: <20250220104545.805660879@linuxfoundation.org>
 <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80ab673f-aa94-43e2-899a-0c5a22f3f1e0@gmail.com>

On Fri, Feb 21, 2025 at 09:45:15AM -0800, Florian Fainelli wrote:
> 
> 
> On 2/20/2025 2:57 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.129 release.
> > There are 569 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> > Anything received after that time might be too late.
> 
> And yet there was a v6.1.29 tag created already?

Sometimes I'm faster, which is usually the case for -rc2 and later, I go
off of the -rc1 date if the people that had problems with -rc1 have
reported that the newer -rc fixes their reported issues.

thanks,

greg k-h
