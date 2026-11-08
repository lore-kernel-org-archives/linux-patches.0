Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794176592;
	b=czKvCEqs8zL4LCJSHq81NuaZuJgc4U3/bLF61TTD9NqWfRkVwORIUl4tFKZyaw4eqqjm
	 v8dadlTKWoESK7OYhkiKDmvlyM/B6b/45PlyPMOtjUM2YsDzGEPykmOVI2u1/hjrfS7Y7
	 7bUg3fGJApLXzhDcDeS3vNZimgdYblcXHFqXD4wO4+utUpX6501/H6FQya3DMegUtZ105
	 gRN6Fu2P1ASYiT8C1hVekjULbK3D6xWqX8atauMLrjUPzUdDKWCL3s+ltI40lexM7uYxp
	 BaH9Z7D+bf4rR06camu/KsBMzTBdUawhd2TypoLPPU2/sTdcOK3ECEJ8mxTGK9qMT8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794176592;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Ti4G1+U++r64+s/VifPd0SRhQ8L9S1XNkJ2HCTXQirQ=;
	b=EcN+ohs3s73G4QuYFydSsZl5lj/ESoYeCCdl2fE18mRD1kfEltgC49yZldQixiSpfMlh
	 Xem7MiJXT9MJWD4pnspO1ERIOeG6hEbkl5n1CktO4sIwL74m7ijUYkhyfEeJ2ZTMlMPXy
	 pqSo0SGKjfv61TOvZ+IhvYLfICJLDoDPDde+K0LwT2/WSj/VcVsHx17TuZptnl6ll5O5B
	 rV25Xv39q4EIoX87KF5h+FvlXRUFTeUAShdOT6xM7UH83qReTiXYtZt573Kh2htWBbIWp
	 yv0eqpZHnYSdzpkkRmVzJM9Vuzy+GZCEayNhEmOxzQnqAaJaQM4Fa/bq+eZVuyCMkbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFGVPMAY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F3D606A31C;
	Sun,  8 Nov 2026 22:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GFGVPMAY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3021F0089F;
	Sun,  8 Nov 2026 22:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794176591;
	bh=Ti4G1+U++r64+s/VifPd0SRhQ8L9S1XNkJ2HCTXQirQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFGVPMAYtxdpxCwlUCFbHhQga1qAA798L9tVY14dDe+evAPIMl65oh58ysDCjAD7m
	 x70ZM7tCBRcUN6315gJXURu97dfH3PywxdS1ZEgvxOs1ooHBBwXPTz/wo6evZIpYxr
	 IetLyuTxMqOIAmnFFO/GwAxBf49hb80JGJPDM970IeJWcgHhmggHQYfFoOh/aa+DHF
	 K63Pt0e1qLMRFtbHXa3AI/WBi9vbSkZnIxxUEfiyy+uPvPzWMk+aJLGNWcKAByG0jA
	 9e3dxQAUe37gTFOrSZsrG+UZiJHaYsCuhaekiy4RVbLbUTXaAgVi8+v6qVHC+WvPMI
	 O4PNE3TeMojtw==
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
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
Date: Sun,  8 Nov 2026 23:22:59 +0100
Message-ID: <20261108222259.138366-1-ojeda@kernel.org>
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, 07 Nov 2026 08:33:36 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.

I did another run with the Rust block one reverted, and with that,
I get my usuals results:

  https://lore.kernel.org/stable/20261108163608.122524-1-ojeda@kernel.org/

i.e.

  Boot-tested under QEMU for Rust x86_64, arm64 and riscv64;
  built-tested for loongarch64:

  Tested-by: Miguel Ojeda <ojeda@kernel.org>

I hope that helps!

Cheers,
Miguel
