Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF3E46F48D;
	Thu, 15 Oct 2026 06:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792045003; cv=none; b=aionydSfusbJyfvjpVCtvsxVyW64UVPkj5z+mwWJgQoEg/A597BdzAPM1HzIYIT5VqF6lliUvJuMtktArh/s3FuHudlztdx3mG/KbolABHclg4Ur8X9mHqNZX97hy03BI2wiPFYWTfjPdI8WxRk+rXVuJ4BxrLhiLn97D0gwE0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792045003; c=relaxed/simple;
	bh=UDmT28w5sjMUp1dlb/J6oP9RvrRei6J/9rQpulyJuJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcxo19r1JARdUOAE84NUBYk+eyxXEe//V19aATGjLMtxAH3ztFVk0klz69NQ9p5plPYNWCI1gln6Y0C5n3Tv2Cp3wnZJAyEyiOeGbhUht/2eo9J4Cpa2JGbcmln0BskzxET34kHYQhz59XK6oIrq0ic0Xn/yJY/ohHmHWCf0rxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KUkcO89H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KUkcO89H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE301F000C4;
	Thu, 15 Oct 2026 06:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792044998;
	bh=iSHYUE5unVP+n7dvBXJOWTzSXZrMWKnkHolt3ScGT18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUkcO89HSFHjhgGkmJ4v0xxtwwOf60/r+xM/LyUL/7grK0Uqm3bWOoRwSRnTiPKdy
	 2WbTWAKI1aTaRUjv3VPLPPSg/MMDFFx5lNfPhDYk4noIXv3Vy7xR41LWmJTh7l1nxZ
	 Huz+gL8hbC0GWlD/YX7rEV/JUMo18lccGTFZJIvmj/mQ7vsjTxDE40bdvE6Jj0oryV
	 F6B/JImvd7oRF1LVc6x8OPj+QfsitDgbU97sbFyddVLHLBR89Efnd8HF3sO8P8FGBG
	 0y41UPtNJ1Bw1bAOA+Ca9K3nf8t2RgdSoj7oKZXewKgRbwwgIgsXnk3XRJhwlxW7Eq
	 yYgQ8qp5XtJxA==
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
Subject: Re: [PATCH 6.18 000/632] 6.18.57-rc2 review
Date: Thu, 15 Oct 2026 08:16:27 +0200
Message-ID: <20261015061627.35336-1-ojeda@kernel.org>
In-Reply-To: <20261014123820.008483134@linuxfoundation.org>
References: <20261014123820.008483134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 14 Oct 2026 14:50:40 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.57 release.
> There are 632 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Oct 2026 12:37:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

For UML (x86_64) I am still seeing:

    ./include/linux/srcutiny.h:14:10: fatal error: 'linux/irq_work_types.h' file not found
       14 | #include <linux/irq_work_types.h>
          |          ^~~~~~~~~~~~~~~~~~~~~~~~

The patch is in the queue but not in -rc2:

  https://lore.kernel.org/stable/20261015061400.35195-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
