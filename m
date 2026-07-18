Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D32B38AC91;
	Sat, 18 Jul 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784382164; cv=none; b=Hl4IaCliwSMfjGJ97sxv1Y+EYRrCnfOHfJE7JsRxQg133J36Kj5iFvtpD0P9eEgYdJc+H/nqzhLUTvf600zMp1ABEfPgsIblXuGfLb2/vroaAnZJ2K4l0cb+Shwl9sLQaZqbWKeLhAFQJigHt8xUnHLs7djuJPNahIiDuu8c5uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784382164; c=relaxed/simple;
	bh=b0rl7k42FM8NzHumugyk/HDdy1aWZA5kb7lH/kAB7gU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlYs9plQ3Na5bt0hC7c2Yp/3rxGAoOuBQp0fgLOtZQt2WYyzVQG0YhNkb5W1UYq4ykO4drPdgBXvBgW3tREy84eoBexC3VOfemKnm2ZiNVYz8q7MH8CE2QaQ8o/xfnpxcjwK4/li4+XPFTO3OUL0b6TAby1ClTg3nwASv4kbVKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2FuQ0Qs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2FuQ0Qs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5E71F000E9;
	Sat, 18 Jul 2026 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784382163;
	bh=gqBrayeVZHaDXvMR7ftaERnfK1HM6vkPwQdmma2Ll2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o2FuQ0QsnSXwC7yTLFlcy8cmwk3UKpjT7IKF52sY+xOmXRwoODdJMYQlUBIoGWAVA
	 kGAwpBJXHQ5SWrSfF4d/n/7gWN8+IeJx51/6ld1qSUdNnIVLyyboOk6VvnwJ1WS3HB
	 3oTTieLq9Uzs65zOC69vuiDgUI6yu7DCGsM1OtTjM62tiL302YLPqS+21dIlvNaqcF
	 OB5/QBdbpzhu8acPCEvXWcv00AQkWLQJdELj8ZPr0rYKkSWMLU6v/rAzUmPX/R8Jmd
	 osFmC3tUft8H/JDYuS3zFfV4TNS0g8cYpfrharPMoZqgw4V+Kdirb5WGif3sWxx604
	 XRzRTFjp11s+g==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@nabladev.com,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/357] 6.12.96-rc2 review
Date: Sat, 18 Jul 2026 15:42:32 +0200
Message-ID: <20260718134232.81734-1-ojeda@kernel.org>
In-Reply-To: <20260717101823.379399592@linuxfoundation.org>
References: <20260717101823.379399592@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 17 Jul 2026 12:41:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:17:43 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
