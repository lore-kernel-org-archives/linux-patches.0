Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [80.241.56.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12B0C3537FD
	for <patches@lists.linux.dev>; Fri, 25 Sep 2026 02:28:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790303325; cv=none; b=CqahvLqnwJ3O9MYLLXeWJiKplt21t+ulfkGiuvild1oD0LMvkvptuLNhsCg+J4G+mQsFvWLd56JwCIypsli8bUDcqxDxFLIwWlSWt+eZzoqgGQh0Qtps+dPystWWIWVTErC88cJmr6ffOd2k5OEZGqUoFKvFdc5FTYhdUJ/dgNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790303325; c=relaxed/simple;
	bh=zso+kvxDJ2qv1iSLP+PynnfmiZtMeHqCGB0+L3RiEr0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BhTTERAHFHzv8zNW3Sdtv4uplTFxlofsEaVh92XUDTwpVbWMPPeLZ1mM9ter87VVHTIHYm7MZaiDZb3DbSxkxEmbIihSnpeI91br7pDC+SesvF0UGHszH6rLwfXA2dootOHjqepBOvv8CoJTgFqNtVLItuSaDPuTb/lq+Jhv07k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=oi9wDrWC; arc=none smtp.client-ip=80.241.56.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="oi9wDrWC"
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4hrZPt1tr4zMlfh;
	Fri, 25 Sep 2026 04:28:34 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1790303314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=t2LBfSxfYe3nbU/Oot6vi1YmJRa0ldi8/fdJliZoxhE=;
	b=oi9wDrWCwviJoq7itWrS+FalgDhqY1qSnj/ItoxGgFO1Gu32Xmkh2FEqd59qSGTkcLTC7F
	enNCjTKmb7ZzeGicbRgcxgsQOdJvx77zvUIAi8Vl7IMJOWkx+pFM/JSSpvhbCK4yzw8+rK
	42hSO5CJxuGNheYgkC1WnrlQ74uA+m/JPb6glIcmt6COQ+9yzN88VVomaOkZonbt3EzeO7
	JAirXVGFevO7WjWjUIrFDjztORUMLV6/VdJT8eeaF1wa1BA1Xe2En7gKXHB6hM32OXcqQz
	BxXU/6Zx2Pn50wQGb0osGkOzu5p6j3u3Ivx1TXzHWODpouA4hfGcMg6msNG2Rw==
Date: Fri, 25 Sep 2026 04:28:29 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/438] 7.2.8-rc1 review
Message-ID: <arXcFhLUX0qXiQsm@bb-82jq>
References: <20260923140644.756254324@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
X-MBO-RS-ID: 8e7a7eb4477a049776a
X-MBO-RS-META: ysd5qnass3dta3brsxa47rf8xkszep8z

On Wed, Sep 23, 2026 at 04:00:21PM +0200, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.8 release.
>There are 438 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>

