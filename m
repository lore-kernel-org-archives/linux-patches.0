Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E362E2F745D;
	Sun, 18 Oct 2026 10:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792318165; cv=none; b=FlNPkgXTBG6gsAtuxHSvAyo0K/mnNrg4cGs4txMZ2jt9T1EJ1MplPgXfZwArNIK2XMIMosTAW6xHa6oP75hRI1VIQRUI/zc8nMqOQgYB9iYFAI8QEuRx4/qw3pHFwEwjdrHjreFXK2vemXGjV5FgwYpkjUwCcFIvz5/8Y2K9PX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792318165; c=relaxed/simple;
	bh=f5LfeOOR+T+AJ9JCbpP5ObMTllY+dxdUVy7vwtRdYzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXdItocac0+jRyOuFYCcveKQa+02ozfYy7dbJcB1Tw95oXesdk+RkKcpqUHQ/qVzdtXJ1bQn9ncShmbn2cOQIc5TFwRKarvAMHrVLS9waw/VJUmvIiKi6AbIOS+PygrvAyfUQYzMCkF8QP1yS9nU6BfDoimLg4KO9w4yf9SVGUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UD8TMk98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UD8TMk98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131801F000C4;
	Sun, 18 Oct 2026 10:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792318159;
	bh=5aWf32wcpf9vmrl4EC28Fl01gzRwMBwB7dBfgd5BTC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UD8TMk98m1XgQb6VJKpMshy6kzEFYey8Q6ie6xeqHU4NwteMDdHBsW7dYNoR0SE3Z
	 TfNXOFQQLVyvmNOQABv3pkMJS+xalY4q+aJVSwDVRe36lL8BqycTva3sxzZxLaiMiD
	 D5IVrSepOOMM5rEFFo5UA6YBLWefm5W6NdTT6Eny3cdnL43yBPREpnQgmlGHHcQRSi
	 whX4rRpnbCOCuA53cRu1zQ98l8dJ/1j893tcEg40cnTx2gpD0zpX0Abh/BQfV3kpDn
	 0y3ggLDDBC5z76L/hBvlS1SSPCj/X0CDYeUkbp200U7SX0Kc6pyYqbTqqzeeFw3mHB
	 kwcCjbsP3cCSQ==
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
Subject: Re: [PATCH 7.2 00/10] 7.2.12-rc1 review
Date: Sun, 18 Oct 2026 12:09:08 +0200
Message-ID: <20261018100908.50076-1-ojeda@kernel.org>
In-Reply-To: <20261017155059.698368299@linuxfoundation.org>
References: <20261017155059.698368299@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 17 Oct 2026 17:54:29 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.12 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Oct 2026 15:50:51 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I see some `objtool` warnings with Rust nightly (there was a change
upstream to `core`), so I will send a patch to mainline as usual.

Thanks!

Cheers,
Miguel
