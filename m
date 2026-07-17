Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 669E9238C0A;
	Fri, 17 Jul 2026 00:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784248980; cv=none; b=Ojru4r43ZSuq4OLkVh0rmfI/CKeq6PgK631fQnTh2EA4MrJ0MtSEuaFcfh8sitiyp99pD34VIPhbPfwB4De7P0F90VV/kf6LGEZCEM9n8854X1JVe06vG8VxTY2Zk6nwi7XzOO+le8hC9Tpllac125PGPhR5Os97h3sNgn6uPDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784248980; c=relaxed/simple;
	bh=QFqxRh0UBnmS2EH4+Mb3IuYLaSjEVkPtk0QuPqaJIiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYlUp2d8XFTI+66YIyCGuro7Wf4tghAWYX5b1/+xaUw924Zuvm+jCcrQkicez2dUNvWtUZTR/Qg5z8/0GkuPiIAcjOhCEnAVMwRg458EqOFV8g1BwrTbFqEoGMg6c7CI0zz9zoujPTZGd9F/W3VNTz73X2sK/KhWaHyx0xRtu+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oP6f1/Up; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oP6f1/Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F141F00A3A;
	Fri, 17 Jul 2026 00:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784248979;
	bh=N8RXDPtbHLov3ZxWMrI7M3rCiU3mZN9cxFzm16nhkpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oP6f1/UpOrAJ1rMGlGsu/TRpC1DV1E18umolnRgsBaMi2VEaA6Z6iEq03ipoFlUtZ
	 45byO/GvPWaR5tUwK8htHDWNJ1AMnB5M8+xGyK+21hwA85IyirtBnmrv/hJkbK6mNG
	 kaCrMttO3ts2wFpOiVOiPJS/V3n4QgMMbN8ccbPNWoR1YfM4bjT0yeWfLGrpDjpZrn
	 usqlzY73cMcFI4vyiE7sgHbON/mABGI1TUFrnI5/OPovKXizXCCz5lt4WY9iioMS62
	 HKq7fU8uUXyr3vEvFqBt4R3lU67p76ieGJonX9QlOLNn5uMIQv+TF3UDtxFWW0AXiQ
	 iM9IthzDdkRJw==
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
Subject: Re: [PATCH 6.18 000/480] 6.18.39-rc1 review
Date: Fri, 17 Jul 2026 02:42:49 +0200
Message-ID: <20260717004249.133770-1-ojeda@kernel.org>
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 16 Jul 2026 15:25:47 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Jul 2026 13:30:01 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
