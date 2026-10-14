Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D5A483811;
	Wed, 14 Oct 2026 08:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791967007; cv=none; b=qur7oEZIFvnUCkmJM/ufyQjrfCHYiD9CQZ2KrTUP4AAxI5PXjEeclT8P1nswfbjUxLKhzTPM0IJNDmIRf2i8V8B/iI8/De++EVLMQHybmmqSLaMHWazEkhDiy9rZnJgJZgU4gp4gN0djNUKa9wuGBODOrXyC7M6KDNW6LOsz5cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791967007; c=relaxed/simple;
	bh=5tjWKYA5F53iSUUqZds6EphwcaHUsooGiCY0KJZrUaw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qEyKZQ/oPuOG2NXiqZnAMIRasr1hj/Fq/b+Gpp98KkEzNYpDrKSoLfIyt9PDoTSWmc78SoIAMDoGau2Dt0uR/evL9d2gh7hMhcYNQbRutnmX3gUtT9u8SvIjvEBNbNXfIF/HJXW8i7tDFqr26KIJV15QLUlF9PQEhx9jpMCZ6rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Wed, 14 Oct 2026 10:36:34 +0200
From: Brett A C Sheffield <bacs@librecast.net>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
Message-ID: <as8_EiojooHC5H-v@karahi.librecast.net>
References: <as4kGIjqjrKzu0O0@auntie.librecast.net>
 <2026-10-13-1-daily-reply-0014-6-18-rc1-krb5-link-failure@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026-10-13-1-daily-reply-0014-6-18-rc1-krb5-link-failure@kernel.org>

On 2026-10-13 21:27, Sasha Levin wrote:
> > Build failing on amd64:
> >
> > /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_get_mic_v2':
> > (.text+0xfc2762): undefined reference to `crypto_krb5_get_mic'
> 
> Thanks for the report. The krb5 patches in the queue need a select of
> CRYPTO_KRB5 that was missing. Queued for 6.18.

Thanks.

Will there be an RC2?


Brett
