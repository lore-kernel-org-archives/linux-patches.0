Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909D3187346;
	Wed,  9 Jul 2025 15:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752074213; cv=none; b=C0KdRE5IYIyEcYrKHCxR2XG8dFKiOR68wRZJMeknVLHczIxio1tvZF+QgEN+vyzb4WfkI3BYpmiedBI0J+wNnrR70dxUoee0RP+LUiF76JoJax24QBMG/CwYO5Bo5/dqPlDwj4uvVdYkQ9FehNCIeIdwZqAPPry9n65gJ7NEYRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752074213; c=relaxed/simple;
	bh=9AcA8FN43fJBx8LusdgIy2znb19PC6dO/zaPyYir+qE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsKDkfD8wiDazSSR4g0U4mj7wj6CPeWOJvNKvmN3ncF3vzke5NTUOVMSmcQj3pOFIO30j4jaKCPHeEvMZc45KqhWLF3q6grSbn8XbwLIDyQWRZIUia25zPHl3BJasFpKVNINz++KrqTBpgDrEXRzC9tCNCpe94hmWskPyUOHPs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Doa8gnht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Doa8gnht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF0C7C4CEF1;
	Wed,  9 Jul 2025 15:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752074213;
	bh=9AcA8FN43fJBx8LusdgIy2znb19PC6dO/zaPyYir+qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Doa8gnhttnjl407qrGT58kEVY+7j2u41jrrNPMt+AHj8dgJM4thVhdivrOvFskLew
	 LVY8w5TbDZ7r+uOZ4cYVpV5VymaT6yL7DHcNPlJaIztGJc21Hxjv5aqSEVNZpfLETd
	 gb5K8xiH6d3tJ1zSJEPq+vZB0XNd4IYDhhvZAs7WyRp3ZucSt8366nRo0OQKl7gi0V
	 F+9SwzR24DKiIWEHnjQaWM24M5nEycYKH2QMI4/LL4ojlJovhDlpddoEzTjVg52RWR
	 F7jkKgfy8skL3Pe3a2h+1OgXrcZQTN1FgmHB/3Kyb1JoHemzeysdqpXMXSEPDVAEbt
	 HZEk+GpFwrvsA==
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
Subject: Re: [PATCH 6.12 000/232] 6.12.37-rc1 review
Date: Wed,  9 Jul 2025 17:16:40 +0200
Message-ID: <20250709151640.840820-1-ojeda@kernel.org>
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 08 Jul 2025 18:19:56 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.37 release.
> There are 232 patches in this series, all will be posted as a response
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
