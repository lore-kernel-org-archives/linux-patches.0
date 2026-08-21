Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76A43B71BD;
	Fri, 21 Aug 2026 09:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787305692; cv=none; b=Kcn+ijwk1Roz4vjv7ktevGPiacpKF2l/HYn5njkEPdua7MsWR7vllZdDyFabfWiCYYVIf4GwEJzwPw6QVpNrzd5J8snQdHW7Fxo1C2Z+AD9AHsppDn44YUGmJXOyPDfi+S1a/9opj0f6FHsdPkTrjzr6wlXLdysO3/FcJSpi1/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787305692; c=relaxed/simple;
	bh=jZC4WRbAbkrkc7K0c+hyryFhbPf11e0HwMmj3eqSs1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQawssbSCdl6oec8aeAiAwXZHXKb+nITcun+7tFi8KLAi8H8qnfrzlzyUhu8wtdD1WzdkyLxnCNXcctMyr15Ear5ADxVIb2KSJwwWFcf9lCL6lk22h9+Actpla7p/Hx4oqgBpQzhE8C/KeyVwBTz2HOFgtBzZu61kNlqmTscPnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjWZr9D0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjWZr9D0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B091B1F000E9;
	Fri, 21 Aug 2026 09:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787305681;
	bh=Rv8P5XhX9JLX0CAQJDrk2VIILxjM4vSciqfxBGBjgYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GjWZr9D0sy7rIiYEXzI3xMvWc2t2V80W50RKib4xoBEXVcoIArrkcpz0ZnjatQNfY
	 tH7CkBNeBgXBaz8lcwbo2R5yRoX6LbKfdmlGAP6sztzpi49eLBeMPBtMkoybtN8xps
	 7ICLgsqIQem71/7U/fUqVOAocgQaJjPSZE0KWlqLhWYWvz72LF4LK7lwSaPG8ozH+6
	 CeNuVNhQxRSJUzRJR9AHNIZB/9woRQulLFBVG4VLPXqZVEO5C0zbQosTEYVKbwKtRd
	 GAmpaskzYhbJ9iPVgnc+ch5We5Sw2Vh/8V4PN739tyAp5i0XHD9YOqqDvNvlt31Lcf
	 b/F/FyQkOSlxQ==
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
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
Date: Fri, 21 Aug 2026 11:47:49 +0200
Message-ID: <20260821094749.129819-1-ojeda@kernel.org>
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 20 Aug 2026 16:52:22 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
