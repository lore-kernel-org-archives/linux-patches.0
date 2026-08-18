Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF8E11F94F;
	Tue, 18 Aug 2026 23:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787097313; cv=none; b=cqaj5S4fiO0HDAr/Svs2zNZW4uX3ziwda9Av1EMW08Cn1Ru6PpWhVlm3KSE1RH1q1uskpxM7Xgi+6tqrU4V2YkpBpOxGtTm2nbcW29xjHebsHe+jyVhOUxU0xxoiMzhRxjC+qVk/wRjcI2YH7OX+VV6qZZMYnNzdxWvMC4YDc9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787097313; c=relaxed/simple;
	bh=BgmtGYRGzACNZGwnFkcRLyd7F9DMSy3zhqsOHcd1LZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PNrYjY0Ia2fXJ9rm2/Kv4eAOE1y7QySwwkht8eMvdORPrQWhj2FnrgGjKRMVTgWj52jdYOjXsbACxAZySEHoGXrp/yYZu6eGdjEU+nws6tZBQjSXwK3+nkaBtFsqVTLiwjCwvEVYFyVqi5Vy2ERwbC7nlXJ/qKbVkawWWA81zS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFaMvTgf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFaMvTgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71EF1F000E9;
	Tue, 18 Aug 2026 23:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787097312;
	bh=VWkINps4cnAAY1u7/3+jrZCvmYzeGD/Ssbd+QEkzJG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LFaMvTgf1KnpvPF6/8/0gTgouRbPGmXi59EvIqXKO+Z5VfPCl2XCYNl+TOdnw37VI
	 C7s0Gg47AgPvXYMT+W6UURfnvIqm1udBcoUy1Hzl/nMq83qGnjvVE8z9ac/v0dj/jX
	 GkA4xRyh/5nq8fwD2vy5o0+/+GFKqxUfJpJsNkCw3n5Fcizn5x8D5sbXTr42toTLB8
	 MmScbayS6aZwQQ9/avEJRYEm9m18TqxK+Z5Rk3dRe1MBpayuAFfX6QKzYgj/ymI3O+
	 35VsN97lv5iWP/Uq9Krs7rN6urf5UfddtzXNmDEKKa9aE1gsKF9dsiKQeJU2fBO6KH
	 bqmizTNyqUrZg==
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
Subject: Re: [PATCH 6.18 000/250] 6.18.45-rc1 review
Date: Wed, 19 Aug 2026 01:54:46 +0200
Message-ID: <20260818235446.400398-1-ojeda@kernel.org>
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 17 Aug 2026 15:29:21 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.45 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
