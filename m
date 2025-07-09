Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79F935958;
	Wed,  9 Jul 2025 15:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752074247; cv=none; b=uAWpr7WdCjKX1AlxQm67f065XvgJznXC3HGORMdP2Mv8LmUaE9VibGcM/r+SNPj6ukfEistCvCQugQBTYTUBnTmHOoGhXyjCS8E7srjOSbLLAOURJnWXhtXuKyK98HiyHzq+5c54H5N/1w/guAviC4bimbe0P03M/yvcqkdHPDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752074247; c=relaxed/simple;
	bh=18qqlA5kt168isuNMXAGggkZU+AzFupJfjPwjcie+tU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=clklr8ABI+K1wXGkJ4souy4ZRp6/G25F8CHYqTDsUASRk1E0h2TeuKO6V/hzG8uSFhy4I/4l0EsC9db9M0JVzBwDNbahO1KQ17M3dAM8SqzUqKZNyRTBadx1PtT7iW//NvfEjFyY8Ov+hpyGzM2TX7in4eeMIdA94s23s9OvY/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oKEhwY/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oKEhwY/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D861EC4CEEF;
	Wed,  9 Jul 2025 15:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752074247;
	bh=18qqlA5kt168isuNMXAGggkZU+AzFupJfjPwjcie+tU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oKEhwY/WIIUKIjTV2SWvqlxCxyPGjMCefCHs/zvJKFROzsJDlKHEtyOnoD0ncXI6f
	 E7tHt98qiA4JKZYxIBCCVO6mJl3gkV+zvVpdLelnCYj41eiOgxbaPT6+qOvzL78Le9
	 CnxftMfk3OID0FcSEdHjK50c722BcaBIIvG/GBMt43UYU3Do08hwDd96WLzK2yVF2O
	 7esnj0eIwRiW3K9vJDZE04Vh1RbUoohMrnjsOnvGgx36URrD5sKX1bj84z29UHaM71
	 SbaxuReK+toszWiUVI5q7aM7w+9p/OT6SrT8luyccvztDYrOTqsv0RYcrcypUPJpAc
	 W+yKegWP9w5+Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
Date: Wed,  9 Jul 2025 17:17:15 +0200
Message-ID: <20250709151715.840970-1-ojeda@kernel.org>
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 08 Jul 2025 18:20:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
