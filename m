Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795720616;
	b=j5wBH3o4acifWUSxclZ4++r3P23OwXQzPykMTl+6d0p6KmNynW+4D6+PCzFuT02uFGRy
	 1UR6teaQdbBYmtrkgyDz4rJggR5V/ogN19Xv1p2K7Z/GAH82W+VZGA/gNOC8vAuGnfFO3
	 DwdST7hc5R2czm8S3bL/J0Ye1F/VrWsBHY1dEDfgU6sKUSgWZOypk03fkCJEXJuINaZ+Z
	 yBharym2B9zqQsY0RidA7j6UpCYHp+U5kpscpRLe+F49m60qz5IGglQFXrNbIGPGt0O0c
	 9CZ9NW30jZWRe8K6yFaHWUa+2CdDvZZ+gywlDtcLGStzsHMpxsSfZwjds5ttAY1LYbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795720616;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=/ePZYrbdQ16+slOUwQ7xouliurGZR5fcRweQhbu7V7Q=;
	b=ToPS34dBLJHSvNGyOygWGjFf0/b9VsfHO1cbO6B4uoQnrO+zXYXZN6GgzEbcKh5DsEuY
	 1QKmhOB2WMHV8z42wFp3UNsee3OFaOojAKY09uo8v19eQZA+uUbe9h8uXvZALI/0Q1wol
	 0GnPg7bEtTPVgPQyUCQalGSm5LHbMDhVaeQt7mlOqyapRU+IXO5dn1Rj7T5RjZzRitrry
	 n569wEVHApjbJb368DElVDSHjyYlDfM9SXPEHmKddOOYFqAHvAy2SBy2VRyY4G6i0rEyp
	 y7DmMJUtKJzVIlW2DUXE6aOdSCLGb7X/Zsj7/yJmOSzzjkdYZ6aKwEDI0T4ni8HFGqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gigbH0ZA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B736606A31E;
	Thu, 26 Nov 2026 19:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gigbH0ZA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86E251F000CA;
	Thu, 26 Nov 2026 19:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795720615;
	bh=/ePZYrbdQ16+slOUwQ7xouliurGZR5fcRweQhbu7V7Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gigbH0ZAoPCdAyfX1TXXLc9EfNmb/vwkv9vIrmTdUTvlPakTLNU7z3HK68Lg5wQSP
	 NnWv7RtmlYghOTZOBDzwFCjONxTO2mCv+9mSiX/5EWKewfHQonhhMooUnSwvcBcPqw
	 XrpYjGnEZ2/VaEG8RisQPUnu172MuJ+C6eUfBoKN9Z9+An59sFPaisA63ZzcT8mp1d
	 TiOB9A0PabFKvgA/zVPIWsbk9GCg7DMyelzmP/qy2pI+olVBVssCbBYrWR0bwnPztD
	 U1axI9dnjzLMcTAR7ufnSd94SxeOP90uT/+oKh0zMyOy2+SdDssxS6v6fuWY8ZckCD
	 9D3nGtstdkvjw==
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
Subject: Re: [PATCH 7.3 0000/1002] 7.3.7-rc2 review
Date: Thu, 26 Nov 2026 20:16:44 +0100
Message-ID: <20261126191644.96323-1-ojeda@kernel.org>
In-Reply-To: <20261126105729.110697432@linuxfoundation.org>
References: <20261126105729.110697432@linuxfoundation.org>
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

On Thu, 26 Nov 2026 11:58:20 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.7 release.
> There are 1002 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 28 Nov 2026 10:55:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Same applies for -rc1.

Thanks!

Cheers,
Miguel
