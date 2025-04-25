Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9722F191;
	Fri, 25 Apr 2025 00:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540084; cv=none; b=OPoUlrgJZAnB6g9Sr0Nl5ybvqxeeVkmin3YOPnUK/O++s5Tm2rvz3DlJOrPgUR3JoPD1clH8AqWGV94HQCEkVssQq7meGDLrWqRiK/QDen8HNsUbC6GNDMDLYMZvIBFp5g1KbUk2QuvAb3btuLP/kCU64bkbfFz41DLq+A+gSTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540084; c=relaxed/simple;
	bh=4eZUBazFf9ayGgk0U60/oYAzj34pgTS2mZIiBFLS1Vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9My4z35C+0YsIn12PMAJtrL/BFZtPUlG9qm8MglmgmS0wDV55qvrIlvwxU8tJSeIHI7g/cTv9rLmHXNFOHtJ9oDJOB2aNURdeiKgYDI0h/U81djRuAUmxNsU+60/Gm8/ibleKVw8s5XFYd1gehHKey2EkoVVGYiKf4WTBdbcEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ed58ypxK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ed58ypxK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98EA2C4CEE3;
	Fri, 25 Apr 2025 00:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745540081;
	bh=4eZUBazFf9ayGgk0U60/oYAzj34pgTS2mZIiBFLS1Vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed58ypxKwxormM75MN6qHmefaviuFilFoBGLhadbQUx+w7X9kpAYM0+/y77ik+APv
	 6IAK6SZObKiykEeWDficRdzZyGyMpE9UGDeWP4CQtvyqiRSLyH9OFVO8B+MvcVg6x+
	 yZSotJeRGNq2rLfbaXCAmQjqquMEo9ijXLUxi0uDerUR6xrXX2XmX54CqBLrWvUFmI
	 kEG9ESeL7BqXdospd8a96486NxOzF0b6Mo/MHwqtKvqS1RNL2pMvL4pjWiYrGuKn8I
	 2W20sQ1bnlpAt2vI7D2hPTXWiEbAwX7WGtupXqQ2Mk0iD+lc/kNpREJ8O2un5/x99+
	 iwEnqku8WVQWQ==
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
Subject: Re: [PATCH 6.12 000/223] 6.12.25-rc1 review
Date: Fri, 25 Apr 2025 02:14:28 +0200
Message-ID: <20250425001428.62311-1-ojeda@kernel.org>
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 23 Apr 2025 16:41:12 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.25 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
