Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5A227E98;
	Tue,  8 Apr 2025 15:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125606; cv=none; b=jDtrujzxfE00GyFZUnlpIKj5hR8PWv7yBCKov37BUcyvf8eELWkwWKXd6e/Vm+U38V8ONuvIcMir7B0OAa2paCxEEKgSkfezxdbejRUGV7z1MU3YYY+pbhoPMmwaW+UJyK2ut+zoMc1ut0EzrkvMbwi2vjdXEt6INQzEP2ji2fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125606; c=relaxed/simple;
	bh=yr6QCEY711PylqBzLAo+WnLwqldcy639RCYOqa4s6eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rKrCQjLOaMOHcLwiXjnhpRV0fETPeF6NCSQONS43jJ3YoPnMn1K1Tq9omMMOfeIk/b0rqPiiLH8w2pV0VDDz7Xl0M1oITzmwIUc+fyuIJHTn8s7KA1EJL34QntzS+usYiQuw/OZika6Z3zGBARJKlN7YB4Nn+X3xpT8wVRNqQKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2WXFlv0U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2WXFlv0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41528C4CEE5;
	Tue,  8 Apr 2025 15:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125606;
	bh=yr6QCEY711PylqBzLAo+WnLwqldcy639RCYOqa4s6eg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2WXFlv0UzWqr6QXKm+EWYtoouUyxEgN8Eyvs1Y8aDGS0xhpojcGcXzrf831IXxnEV
	 yEZuEBXVWya9j5gfikjXyAS0QNK0PYA4FIe3g2QHgALT2Hlzhl5WPMzuX+r/ac8PLe
	 bWg0PTz1/FyPrqLK4RhQ72FFNjmnTM2SlgEt5ynE=
Date: Tue, 8 Apr 2025 17:18:31 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.13 000/499] 6.13.11-rc1 review
Message-ID: <2025040810-unpledged-bunkbed-1e2f@gregkh>
References: <20250408104851.256868745@linuxfoundation.org>
 <71339b92-5292-48b7-8a45-addbac43ee32@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <71339b92-5292-48b7-8a45-addbac43ee32@sirena.org.uk>

On Tue, Apr 08, 2025 at 04:01:05PM +0100, Mark Brown wrote:
> On Tue, Apr 08, 2025 at 12:43:32PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.11 release.
> > There are 499 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This fails to build an arm multi_v7_defconfig for me:
> 
> arm-linux-gnueabihf-ld:./arch/arm/kernel/vmlinux.lds:31: syntax error
> 
> and multi_v5_defconfig gives:
> 
> arm-linux-gnueabi-ld:./arch/arm/kernel/vmlinux.lds:30: syntax error
> 
> (presumably the same error)

What is the error?  "syntax error" feels odd.  Any more hints?  Any
chance to bisect?

thanks,

greg k-h
