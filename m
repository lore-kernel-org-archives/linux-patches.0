Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794623318;
	b=ev12nGWYwgiVeOw96DUqi4XtXuDLH6O1razXrfBaehG0nRil9IR+CMAFSvHEyJnzsQYf
	 PH4BCHKfUiClNEx/TFCwnG4BIGDlgXiQiPn1Yxeej84wKNMOg/Zf4P46NjFb4tAZ3DjMY
	 wwWXLKw5ar/3z5I2O/B5xtt14EuactQgWtb9g2Gtw4jGWvv4yFBrAquvaCHoAso56M+xL
	 3ApaWm4MwGJtAE3rmQYzz8YteHbwwB4S/bLcRxlIcw5Zw+t2ryYJus8ubcT94kq1GsH7F
	 tq2f5xafEaFdCm030s9w/vNy7giL6om4++29V/WY3yBEZjoPxZ8ILFtQHgWfRHE4FSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794623318;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=GAeLe4QQAu7WcTf8cfYQxoj6i3UEzxa1BxAfHHs7UUw=;
	b=fmEP/uAPcHRLq8d+t0xdpEldSwHmpLMxb/nwN72oiu5aWSNs7YBjZ/P4ju7HXJ7C8hxi
	 +1w22shl704RrUQv6OIjkeZiiZLAIuEjf40OnA0jNsUUTbgkPU1ImxjampZrtUAR4NlaN
	 ricgvBImyUaiAYe1Ptx2pIIty2iOZWg3yTV4flgrw9vwnHVEVGpWzVq490bxrNkJH10MZ
	 4HX1mQJWqP5X7VZeTmgEh/3FPi6nlUjyKMLtJmoVqsQSwfg8eqtj5co/L+qrOfvy5eMt2
	 FA7AGk1wnx1jK3gTSPHoDIUuMKsBSX4C5au5YunQlUmbpgKnokej2PAZUCgSWu5Z6Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="S/OCUYx6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B24606A329;
	Sat, 14 Nov 2026 02:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S/OCUYx6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395381F000C4;
	Sat, 14 Nov 2026 02:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794623317;
	bh=GAeLe4QQAu7WcTf8cfYQxoj6i3UEzxa1BxAfHHs7UUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/OCUYx62DF44HXXGwNmyFxG9RvK3opIoNoF17lYClrjx8vM0W3QBqySEYsaca3cb
	 5AS1HAjNX3IwG58KXgpHWt1aSQRqhdDC0Bwd912uAhPtU3M4QuFahzX9Ggj1wZENP3
	 USiA6x5tw5SebHC9I4c+g8aN1SFA7bUmu8B71q32txRVvvFlYjy1EU9m/+zH2L8t4R
	 WJNYrwaT+Hk63jR9t37jYw1+sQfJExPR/ST7/2MZB4Rd1K88UA2JNgoWHhCoNx+9EN
	 X4RqfbMq1797VEzu8fzlHhwizlx9Oou6YyPj3zdUrrxm+60P/6aaJnRbkRHW6rQmoK
	 MF8ENaFc9z1Jg==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
Date: Fri, 13 Nov 2026 18:28:29 -0800
Message-ID: <20261114022830.110809-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: 
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Nov 2026 10:42:44 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
