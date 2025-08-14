Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4658415A87C;
	Thu, 14 Aug 2025 14:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755183445; cv=none; b=nbG1N9NdtE+5ei8PeKSx9h3KMT49Kw+T6YnmMtiZMD40C/ZdpI73IbCOmKGZW0AWJFBCKuvaTlryh/bQO2Q+TnR8nut97xA1r2Gx3jGYoykvKrYfGxsri3pCTiHxHg1HRyijAPpMFJVC6PgC/UURBefG0OPSjaK6Z9WwaqaxKt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755183445; c=relaxed/simple;
	bh=bLAHQLb9+poQkaztCxX9pjVXTn82TD+7a4KBsnS89N8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShLLpQpwSsBmHp3FnqxrYQG+8kqURCbC0ZInLnkVb+FdJIsIUR9sayL+EczjS2GQIWJQxDQTLIlj2tiEtP33u3iBGqiXcRVbFPL+kZSRIEhW1yf+JSUh7jdaj4tPUQxcl3rU2p4H+aVPAw6YTvStCIvhmU+JGv22teq++czpWVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NtTsyw19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NtTsyw19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E54AC4CEED;
	Thu, 14 Aug 2025 14:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755183444;
	bh=bLAHQLb9+poQkaztCxX9pjVXTn82TD+7a4KBsnS89N8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NtTsyw197VcNICyYl7Yhu5nJnVUlGMti8m9256ByjsHpCwJcxgcqf0bJpHVxiNEZK
	 PCZIX95P/iRsU7bQPW2HJV10SO3PQk3o+jx0B5b1sHfpEegUjirJeO3BEGP+zLmYAf
	 S9LbNqEHArezN3T5F7JssQf5sRqmSOErRCxNitr4xc2BOahqS86T2ndCAeQv0IInEl
	 c+DE42BMCpRHEd9fjdQ8OQUulhwpLU6CObjXu3rnJ4X4S2FM1o6qOQa+qjDjBI0FnY
	 6rnZ3gojC5Jc+2/tBbPXtAzvDewBvnCf13ZZKRytz9WYOwDMjIyVplkr/iMy9U1JmS
	 nHdncdmpPloVw==
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
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
Date: Thu, 14 Aug 2025 16:57:17 +0200
Message-ID: <20250814145717.2343377-1-ojeda@kernel.org>
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 12 Aug 2025 19:24:55 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.1 release.
> There are 627 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:32:40 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
