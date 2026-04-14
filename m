Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E8B248166;
	Tue, 14 Apr 2026 18:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776189714; cv=none; b=exZE18U9tmaRWGKyENj3Fvx9C8U9iKvLNsUtIBemXc9V1UP3npHpqC+hhVGezjB9uAXCn/LaPBNiJLuTxwakDb+knmemg0Fukutylhwe332DnC4SMErUVlYoLZYhxn8AdA8l7u5i4kzUvWZPcu/vd2HpcZJ+NwWks9l9s2HASFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776189714; c=relaxed/simple;
	bh=nO0eBzYN4aw+4HiKINEO3rdsd6pPnuaZHzNDb7fVBFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qDwJii84+SXj8UlAUoRHx0dfmwzxRZ0+xcMXjkHTqm9Gz+fttq3pedYxbg+aSmyCK70be5mpd8ys3sLLemcTQ7IFIOXClhBMHeZiDKL7WlsiH4oGFUsex2YZspd97pTrX9HHpdMUBheBGpi2DozhKC3KBZ/fi5zUZiwpVlwqM2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l5e4g0nT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l5e4g0nT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C20FC19425;
	Tue, 14 Apr 2026 18:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776189713;
	bh=nO0eBzYN4aw+4HiKINEO3rdsd6pPnuaZHzNDb7fVBFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5e4g0nTdMAq4nlXymgL/+ufp0uIBZHxefiYiuTSsQRy8IzbhU0eJ0jgETkzUYSKw
	 XVUs9m8XoNmKsSxzEng2pPG1R7lZRj/q+6qGmgL/IVCKVSyqE+5ZoNGdSBBxHbyuNK
	 Wpkj6x76stKb7/phGfFZsho+Za8cI144v3qv7YnJGdQYlg+IUh07TDxxlCaA8RHPnC
	 pS+jGkinxpe2A34Vgn2/LjHJyQNNlXHJ58sWVXbwyJFHFBpgdT0vW+BHSjx/Vney74
	 3l6jOqBrjTNImWB3vClFurjFsuc2sf2FfGqS1iHk05ToTBfciS/LLsf2/tzHiZ2EcI
	 FJLArDbw8DESw==
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
	Miguel Ojeda <ojeda@kernel.org>,
	Benno Lossin <lossin@kernel.org>
Subject: Re: [PATCH 6.12 00/70] 6.12.82-rc1 review
Date: Tue, 14 Apr 2026 20:01:42 +0200
Message-ID: <20260414180142.270026-1-ojeda@kernel.org>
In-Reply-To: <20260413155728.181580293@linuxfoundation.org>
References: <20260413155728.181580293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Apr 2026 17:59:55 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.82 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Apr 2026 15:57:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Of course, we still have the many missing safety comments Clippy
warnings we expected from last time, i.e. the ones that we discussed
recently, e.g.:

    warning: unsafe block missing a safety comment
        --> rust/kernel/init/macros.rs:1015:25

Cc: Benno Lossin <lossin@kernel.org>

I hope this helps!

Cheers,
Miguel
