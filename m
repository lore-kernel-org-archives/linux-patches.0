Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E8F29B8E5;
	Sat, 10 Jan 2026 21:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768080310; cv=none; b=MxHQcyBMCPSzV6M/rEhyXYj4mlrSGlCKaMJ/X93DPg/2n3JACpRSYxihfeOJ1irvEQNTmogv9uGe+ZSBvKy1Q1Z2LOtDZWbQeG+pAdCGvXLigPVXFSQo5LC+DMvI0700G/QTc35if43YkWnmBLVC3GzoaAgjZ9QwC/gxFnNyF9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768080310; c=relaxed/simple;
	bh=3aAb59tpp/XMuPuHpqTvrlX5cdYDWGtjb0gMHhU9zTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gffat0scosdSYiysRrgsNnjpiDI+8s5lSDCAR1k3L4uKoARnwCXvK/2LkqUFzpDni6aK+EcXpDviofOUWA7xI5gcPfbB9JrM95+dyirL+Kn6G9bxaPhZrofgM8N4d3pnihcsN52DJ81Vu4XCrSPYPRM7YIvA2SVPOM5jKCfFfPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jvkW+lOe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jvkW+lOe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C503C4CEF1;
	Sat, 10 Jan 2026 21:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768080310;
	bh=3aAb59tpp/XMuPuHpqTvrlX5cdYDWGtjb0gMHhU9zTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvkW+lOelxyHtClzdZsG8dG6QZgYhKg//tNB1OamapJ6+adPplb3Dbu9EsgCAQQY3
	 tTOvgONP8aHfuniW6GZQ8vZCrM4fYQtr1jC5i7HduWOtmRc2dqbbT9Gl1ugGLvMq84
	 g6UAtPphL2CnoyS0cgQCcSDc5BQY7IFnYh6XVo5C93ZKH7bkabINYVqNnzvW26N+8O
	 ipM6Gp/2xQRH0TRYnvMXPkTFKA7lkrfCRLZYdR7mxdp3jgf31Hf5DemY0kiGjaGHwt
	 zagNgeeE3rNtnnbVTzjx/sEm5EJInn17CxX3vvpV9PFy1u+ebvxigYfeiAFxmLbJsX
	 mjeweEYTgVdWg==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
Date: Sat, 10 Jan 2026 22:25:00 +0100
Message-ID: <20260110212500.121285-1-ojeda@kernel.org>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
References: <20260109111950.344681501@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 09 Jan 2026 12:44:02 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
