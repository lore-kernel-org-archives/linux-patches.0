Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795188034;
	b=prDvvkZA9iQwLhuyX7FrD+IwTPHzSE0jgrRPk1+hz0ahlVyL/7kDF3YGOk9UPAq6MaX8
	 4JkMX+lCtzOF2QtBQLzQXc+ZR+0Oqz2BH4e6O/1ya1wQipvjM+qlQ3icfPgJuGHZ8DAJu
	 0tpZ6lJ+MckR3PR26spxxuYkxMpv8GNjHZOC19yo+6xEavKTBcLkiQ6ekr18uBF9PJiyV
	 EWv7VlZOKFhpHlW5cjjb7osD67Qg9vaTE4OPKwCscgRvS3EQWKNwHE6lDu3npOt5BtPvi
	 OEbEBcG7oYGrr3MgUbMQwrTP/hjRS8Nx1/p/pMiI2D17G1vicvTvLb/vOoQqiq4Q4Kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795188034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=mw9W7yG3b/5ngJNfYZs1DLh0D/ZBDHwP3c9DgQL212o=;
	b=tIf/TJv3NTnzE/dwqc/SojmSurqBPVgkJTbM9MC1aH5ehqLN2y7MqC1SpAklBwJD/K9W
	 zwtos195/WT2NObtq31ZbK2SCR6YGvCOk9dlZArk+ygFH06TABXmH+SaXjOh6KoVy7Wj0
	 h9zpIRmFHh+woU5Ux04PV5Y5d1fnL0DQupuASShLFmCr/VT8IptEYj44NDuEsStrFwVjO
	 Uz8p4njS+RFV9ZstD12r58mwl1q9Icnav26ND1w5xUsmLIYEjo8Aus0FS2vyRbzI0weay
	 rt9Vdr3bR9lUqzdev+NTNCzh2/Pdclmwsu0fdwEkmH7/ddPwSesiujZprF1aNN3FnuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPqyCJKj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3B6606A325;
	Fri, 20 Nov 2026 15:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPqyCJKj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 175841F000C4;
	Fri, 20 Nov 2026 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795188034;
	bh=mw9W7yG3b/5ngJNfYZs1DLh0D/ZBDHwP3c9DgQL212o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPqyCJKjNEIyMNIKtR7OYWPhnDc+K1LmyWo3cTnHOIxiW6ZBkU6qgZM7ZT33lmGgA
	 Te2xaXjgbDaqMenmXO24ODlEeaF9uYBd8607uQ5NzPEbyqMc0hBpikQKYZpqF0ckP1
	 h5hbFnk1i4+ic56VmTxUxpY5UOYtR3bXVDZSXz0Wm6vrW++dFjknCDlrAjmmyCHFF/
	 uWyfoUeqntC9rLuXRpgA6pumHCsRWV1QY+9Gre+YHB6/mOGF+RafFu6X4zF3QQ1pMc
	 XB5XPlNi1mXVEBrc/v+b3e5bgVB+U9Dr739u4jUttKbbKgbtIvMW97CcGK5Ta++Cl6
	 kK9O/IZPAun7A==
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
Subject: Re: [PATCH 6.18 0000/2144] 6.18.65-rc2 review
Date: Fri, 20 Nov 2026 16:20:23 +0100
Message-ID: <20261120152023.23562-1-ojeda@kernel.org>
In-Reply-To: <20261120055114.182757740@linuxfoundation.org>
References: <20261120055114.182757740@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:58:10 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

I don't see anymore Jiri's "cannot be shared between threads safely"
issue anymore (which he reported on 7.3, but I also saw on 6.18 in -rc1).

Thanks!

Cheers,
Miguel
