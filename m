Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [80.241.56.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF063C3F66
	for <patches@lists.linux.dev>; Sat, 19 Sep 2026 09:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789808943; cv=none; b=tDyOBEbGdSJeUugYe9n7S8YLcWwkQjuG4weZmKm/TEMl6ABRG+YyIx0i/juUD6ep/ny0rxvJrOXZuPQh1sOZSXEp4AfponQr1BVlN1tzEj+Q5LflGOSnOGiSC1GD/L/TkvDKHCCpwkxrO9y3SyA+czLrGnYDEOuxc5iKO1tR5pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789808943; c=relaxed/simple;
	bh=T+6tlpx7O/vCmTjaMD/5vJPnEo/q/48ftL521gl0NB0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IU1x/RXiLptTkAalah1j9H9JZMlwRCqW8ON6wOjCOw9bbdYTFUg2ZlgiJpHJ5SID+nx5CZHu56bTRxkjbYuk8OEQImmTt/Pu0Cx6rPOw6VWrOD6TkkLal5UvJ9VGSRfKJNQi6zrzZthBTY/IWm38aDsKLp7bZdNdpkvMk/Bchg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=Ry9iIynv; arc=none smtp.client-ip=80.241.56.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="Ry9iIynv"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519MLKEM768 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4hn3Zf14FJzKmXd;
	Sat, 19 Sep 2026 11:08:58 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1789808938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sq8Fs53U/8C8u7j5kIO7KQppAPopLyaEcRo+0OywO8M=;
	b=Ry9iIynvcxPbBNaEHDhUBZIZuCU1nvp+SnwqxozwvWSv6+ONduhKQpNYEolO2nhHEZALx4
	9zUYz3Zpe0MDy1dBY2G+/q9L47V6eFAwrxRgInLEwDBg0VPrdSRwRgIcrOcwykRqjYEybt
	NNWcQyG5iKKpEtahzcVZEDHXSPxH8S/33NXlKwU/T3urgsdEyoIoweaqbLVj5WeoZgCcaX
	Cc2qf4rWsqjn+L+VmbMUXrIJyhxrSl8e7cBF0pJmc98AKujPuwRecFiBxJKcVp5QGu/kX0
	Aey7u2YGvev0qRqJZ83t4fm8+20lt0QkC0QecUK4/a/OZFe5hOEfJ6hwcoUw1g==
Date: Sat, 19 Sep 2026 11:08:51 +0200
From: Benjamin Boortz <bennib@mailbox.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/733] 7.2.7-rc1 review
Message-ID: <aq5Q85CVLp9PApJ4@bb-82jq>
References: <20260917151350.597953846@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
X-MBO-RS-ID: 8b8e97d9ba7d23b60cf
X-MBO-RS-META: oga3ozukkp1trtu1j8hp5wpodxpf6okd

On Thu, Sep 17, 2026 at 04:05:08PM +0100, Greg Kroah-Hartman wrote:

>This is the start of the stable review cycle for the 7.2.7 release.
>There are 733 patches in this series, all will be posted as a response
>to this one.  If anyone has any issues with these being applied, please
>let me know.

Build and boot tested with QEMU for x86_64, i386, arm64, and riscv
across multiple configurations, and boots on AMD Ryzen 7 5800H.
No regressions observed.

Tested-by: Benjamin Boortz <bennib@mailbox.org>
