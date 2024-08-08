Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E901918A6D2;
	Thu,  8 Aug 2024 10:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723113153; cv=none; b=E3X56Pk2X6CpPcQ1gVExQkemkiOoe4MtUFoe/3OneB3/QcfsDWJHGQJPhGFXHMLYkG776meLcwJX220aJ0anekNBKR0RCa8MWDJxNpfVejv+Ob7eD3mI2KKIqXWq1QfiZweXZwc2kuNJiasB8QzR5dA00mBiKv7ESheO2m1JbNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723113153; c=relaxed/simple;
	bh=04e2/I2uBHH42AxQNaL3/NJ9u2TZv4277aPqLCd0478=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bER1sxPnemwk8Ke/0zKflqlFpsFUohKcKi3HUiKyWqxc/aUK6d5bXdOcqtauRSSmI5L9+rag98WN+KhrDBPqCwqio8vF6b8H7/oFhtzVll41nX/CckB+gQACwEE/AQF7VoAOI1BNay09kHeRoccq4PvKzUq/M4UrhIptvKMBJ40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tLFVJQfV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tLFVJQfV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4BC4C32782;
	Thu,  8 Aug 2024 10:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723113152;
	bh=04e2/I2uBHH42AxQNaL3/NJ9u2TZv4277aPqLCd0478=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLFVJQfVyObvoe/USebQAR/6+MIKM6zfD3j0ZuDpIxZhulJfW0/2KgHH1D936M+6V
	 Am6cNRQsjhYEvXQq1/LlB5fvx5oXXPv58E0YZh3Sxy57KuxEdUnnhkaQ9WHq+BYg5N
	 i706pYTwSJSdm+1m2KnZKd1tK0zo8fWyczm59tFxN58gDpB39pC+yDrg866O+tSAbH
	 uIFelwTW95WpOU2LWQHaOC5/rLzd1UIY3wcUAYh3f3d2pVlzoZUySBF/13+mJpIbwj
	 IQg02+MUnCpaBM+DbUC9rxAyY0Dd9EI/11TaM2ErFXnRh/5sAsxJxEDGkb0LR3542a
	 odjxgksmr6ECA==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
Date: Thu,  8 Aug 2024 12:32:14 +0200
Message-ID: <20240808103215.377996-1-ojeda@kernel.org>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
References: <20240807150020.790615758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 07 Aug 2024 16:58:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
