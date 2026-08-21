Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36016493651;
	Fri, 21 Aug 2026 18:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787338005; cv=none; b=LZrOULU9vZPTT1uWWJEb/SUrwofuWsFOycBGqlpXeGRnpoF9gZ8aZPBoNlOr7foKUFy9Reh6uJ/GJN4IY9a4soKpZVog4kM3MrUdQepX4xhYUZDV79vEq3ALCRjOeASCw7ZiZH1WSdmo9pbhLFZCYKwJG0pCeWngW9l3EqDPLDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787338005; c=relaxed/simple;
	bh=egZu8Kj3lAyhb5rjjAsoB5vUcbYJFyBLJNF5vR8of6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcIrLuTguJAzPkxGKzzgaK1RK5RndQHlCRq+VhwrusSKSjNYB6dB9gdLgXJBZa+xewBWRQSbFO3Osz2Ip2S5db/GY/6ahxQdwy1W+QKdMFEAw4DTzZu8GhNVkCzOJPiKd2sLVy+fQuKmcvCAj1DGgB9zc2moAi2yI0Tx3TUqQwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lL7s2oBu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lL7s2oBu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 453AC1F000E9;
	Fri, 21 Aug 2026 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787338003;
	bh=xM/zfEa1UXvLqCdsBXuYrvvh8YS1ZHfmjVEIktWcgLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lL7s2oBuFaygfLBMD7/jo2Kb5zRP6tzgO+FY7FL81rn1D6cP0NsmJiQEFFuUF7GyB
	 Q+15y+RMbHR0Wt3hVpTPnV5W9jl1h/AyY86qCqUpDr5nDDVav4J4bwkL/ARAWk0AWP
	 lovRwbcTIu7TyMuj9gKrmzUgQeGDs1FY4I44ZcAFo3KNDOG7BfTeJcQXD3lbTqjH3O
	 b0crxyhppq34bIQkCxo9WAspTlAVw/xRArUzToV2hFmpBQSIxRX1MhQQ5FqotRwyXz
	 MZdeKoaDd597UfGO7TrRE01XSatgrqMgcxLz8toUu2wazgOt734sCDIZiEsdgWhE/S
	 4m7sauzUo1eDw==
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
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
Date: Fri, 21 Aug 2026 20:46:31 +0200
Message-ID: <20260821184631.18851-1-ojeda@kernel.org>
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
References: <20260821142844.249995408@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 21 Aug 2026 16:30:31 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 23 Aug 2026 14:28:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
