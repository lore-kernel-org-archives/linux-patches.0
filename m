Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E21D13093CF;
	Tue, 14 Apr 2026 18:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776190374; cv=none; b=u0FsCu+WhwoR1/FevyflwuRDqEZmYNWV+Oh/HuXKOIhW5B4Z0vU5zTfVy/LkSQlSZGe4OBkuemzOg8BRrq58BFtomxArA7TFN4m4wEids912uwbGQAd3h4j3pR695/uKMNZxXsUKCBnqVMZa9HlFy31AuVo1j1YctRFYCb1JrSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776190374; c=relaxed/simple;
	bh=15GtSkQR9O4+LZBOTi9Ge+gKyKWRFdRvd9CXUz0EVGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpZQ1AEmTnadgXBx6RrYGh/3gHP3xH0hu/jmwCzjwOZF+t+9rSoOj8LIVc1C61RoRGBfYOrZMnjdp64Du9BZTtT5+mWawj0jH7kMcgXfS9FFPBmZVYYcwLFpqm0i6xoWhzH+hGMYcsPKqTVqS3u1WxMXOhCvNeGCmAU0bGI3ckA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tDPzOYYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tDPzOYYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A541FC19425;
	Tue, 14 Apr 2026 18:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776190373;
	bh=15GtSkQR9O4+LZBOTi9Ge+gKyKWRFdRvd9CXUz0EVGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tDPzOYYc08XryfEm2cghS73CWFQLyoVCGAhNe7AyI7ygN7P2ibaqZU8cTCO00J/wm
	 UpITc+8TElR8PtgrBSQzO7eDImjkrM7KSyiJHA/NphdBeErBHSC1ua1qdY7wb+udBv
	 JMaiuA3S7nGtREieIzuz9F/mz9lQzyrx9XUsVOjlRYP/EMbcwfKMJV8Ds8t88hGSlJ
	 v3T9L4nLEXAQX3XlIJlosL7ZnweVAj+2xDbZoiic1kcZWyW9jR5cdVFQ6LoE4GTvEY
	 hGBqmLEbYeDbcDmQ8RDQltGKwUCHRFOB6D++yB/SmsPDIzWAhEn0nG0garVwTY/HeP
	 UKjrt0rTEjCWw==
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
Subject: Re: [PATCH 6.18 00/83] 6.18.23-rc1 review
Date: Tue, 14 Apr 2026 20:12:44 +0200
Message-ID: <20260414181244.271034-1-ojeda@kernel.org>
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Apr 2026 17:59:28 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.23 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(arm 32-bit seems to build-test fine as well. Same for UML x86_64 on
a non-debug configuration.)

Thanks!

Cheers,
Miguel
