Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DD420B81B;
	Thu, 14 Aug 2025 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755182804; cv=none; b=La6pN0TACkscEW5Y+mXWzhJyVtxKbLiwALZWZNj6i3JqlzAfVL6MhXWHsfJ4cxetarFDX7ksPVYyaV/+Ti0eAr+mstoSVLPUK6vTauOY//VICsURyMG6m//EOq5KUoMkD/qUV9x5vOheHggNx/8scDRd5iSoBw3/XtuadnGiu4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755182804; c=relaxed/simple;
	bh=yqXnPX5mZQX3mtT0UkvcCTZEZdRZgd7a+BImxUtpRao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MmQJ/T7hQdX3Lo44RR5E8S4ns6x0rKL/SRocobP+nLWJhBYRRECeiHzY+UzNnSwzQ4/4F3wyPH2CQ/6iEo883+JJuKb7sZ8g6o0pews+4DEY4SfsHWQJtltgpNmnQokflQ0ZZ2tQrAQHzp8/7QbrgSDjZ9JPMAXtS3i5G/+HJmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ACFlFEI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ACFlFEI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1510C4CEEF;
	Thu, 14 Aug 2025 14:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755182804;
	bh=yqXnPX5mZQX3mtT0UkvcCTZEZdRZgd7a+BImxUtpRao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ACFlFEI7u8cKBAN5/a6EvfGFrhki8yxxupMgJ0aeNM8w7INTGyR2u2PWCxIR0ImBu
	 u/SzxNfnUKoo+fSs1SanutwRZavJmuZwfEsm21Wb+O2ARyyLSwjWcaNhcmgn0qRfT7
	 HNniJWywG4SXaFqyktm7seLEq2UcUfcQhvrXOcEjqSrFwbXi+otwjhod78M+cAThoR
	 2nHUkMBg8migboDe8bHwngZrur9FW1eWv7hIUpa3uxkXv7SKayDyFL39xzU+PcVp3/
	 wDO86jnxu42HdAqpqK3Pm827Mhb4QUxRTAGkidVMgzhDxwI9krOdxYfJ1qI/imZaOS
	 vj30aHTLA8FPQ==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
Date: Thu, 14 Aug 2025 16:46:34 +0200
Message-ID: <20250814144634.2342105-1-ojeda@kernel.org>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 12 Aug 2025 19:24:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
