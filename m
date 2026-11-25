Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621092;
	b=tRdhXQDBSwIdYwAcDjtwFT9R/biLTGtDXuzhNvhm5AKNzFOnG7dIIclIzGpWetbR87N+
	 anMmf4XUwnmjj3d+cg3SGQXKywpJ1Wnbt5Mn1oNSXzSnBgFJbSbtdrc+yFoPVnCXLGhVP
	 /s0kgYeU5N+v/pOaJR+FUzAHqOCN4KyUZ/pOqn5juwgDihUJ4pcwXwZZ081HGilhyZQs6
	 ytJ8cPp/KxjXJRQ6BYIVuLTvlF4wogReK0UrtQdmDeJnz7Lijuz0xEqwpLOQwNVnTZrgf
	 zYPYdywLuzBR3RECyYgCw5rLQUnaDI5/ponHd4xTHfGWlLSnDrn5F9+1W5examtDGfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621092;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=T9D7+0eUyPyg+/u+PxIw0oKeKezZl0J6GicSItm2bIU=;
	b=ZNffra9Tq51o+RjXyefE0FT/Kqhn7H5KjifT93IAtOFUEMXZ/WGBx9gzvsgrSBYDK5hK
	 ijWmfXmuPLSxeAJXHNvttmxh9EbZLMU6j445j6fSmgrUW6E/NlDPNu6aQG1duEz8dQTxD
	 4nT9bRegBnXC0yKDxDfeB6wk2OIaeT1V+0DZo84msRn0dPLt1VtN1pV+Se2u5mzfur9VL
	 KBoh6SdBhHvIHaIJpQTDjyfvhHyM8R2VcUClH8Io+jzO/ai5TA5PImijhiVQah0YZ5zYy
	 zTA5DppcKYbU2EPR9EHEVrttLpRlEntuDaWdzEbEuDWXG35r7axELWaseHkqCZbhozQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZNWvxTr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4083D606A323;
	Wed, 25 Nov 2026 15:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kZNWvxTr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4639A1F000C0;
	Wed, 25 Nov 2026 15:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795621092;
	bh=T9D7+0eUyPyg+/u+PxIw0oKeKezZl0J6GicSItm2bIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZNWvxTrMHeEUAmsEbChCTRuxNHS6dMSWhWtgh1JCcKM/8OuUa5n7WkRztYNA+W2n
	 QXc4KwCrK06eeQmY8O+J9lc4yzoiHVPEqMGlkfJvN98ljh+S9bkySxxUyIkoJlsCVN
	 mv9gIcNfUSTarpeJ6tdgKK3MhjCl1MjSrC/FIOQuhGyD7Zj0a72WDEjW0yfgP9ie/g
	 UOVMTGNTWg/PixekD0Kc8fs7qTuTRg4nHK5IGM1nddf3o3xcXIewN0tqjTV8FxMMmD
	 NRLsUbYf5vmA0mZRpL5cCLhSKZFrgFz8zp+VgaBAEat56G76V/ygnQPYz6iU8VH3OE
	 6R5w+9dkk/0yA==
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
Subject: Re: [PATCH 6.12 000/816] 6.12.120-rc1 review
Date: Wed, 25 Nov 2026 07:38:03 -0800
Message-ID: <20261125153804.90824-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
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

On Wed, 25 Nov 2026 15:25:48 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.12.120 release.
> There are 816 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
