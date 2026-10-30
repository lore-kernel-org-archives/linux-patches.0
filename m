Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793368929;
	b=NaAiRvfk1F9TQAoc1O1gPqc6XLcE4aQcfsPALJEtf0yezbq1Xkt5LrfCRgi5X8DvZTs+
	 AfUSV5PW13FdfsuLbn5VTa04i9diMAZlKXqUUsWfTmUjXZx/qkbsdigfLtdkvFvRrS4/m
	 bPm06x3GWqj+1cgtiIdoOW8GoWfYF09i8KwkdvJsEPTNoJPh+xk2Y7Yk2rHNxP10A8Lev
	 asogqqLSPby0Sbeciby/Hk+6/XPo3O+oYr1NUNwx8gkJX6VamACRAcXLIuVsx+DzT104+
	 AOISCigTckt4EgB1NbY7wQo3ELKzpSZAEeu52Ak7+F6GKvYSitg3wiP1V50igLxdusA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793368929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=XuwH7EhHS5byXN4uqQyyViMwqBUJHDwLmZDy5TxCtGw=;
	b=Y+S2VNShVxpn+S9Ah6wrtTgxz9ZxUakOGPLeHzmgeuIuQ/dTBSVvq3HUzTTkt5HdWHvI
	 n1QptvHXAcGQS60M1x2A3uST7KdzTcEGNu3mBHeE1j8rYnY8zrMc/HtM3ndbmfrE84xdY
	 J9rWAzvUdu/kJamhF2kpPrKEtHkvuGhr1QrXslU/I6bRKSkyBsFOPjGsbHpt8hRSzPvjl
	 SRFHCDq8VBMFo0NVA4Wd9Ah2ZKXy7EabTHsc44DzhSQtjmhHful8WErpu451UvntLSzhY
	 CZ97/QEqrq4BII20h6YGneLrj6FY//IoKZTRD1ANiplGXor5dOkTc3toP5OQ0Iw3wDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDYUypkP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C016E606A31A;
	Fri, 30 Oct 2026 14:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QDYUypkP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D42991F000C1;
	Fri, 30 Oct 2026 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793368928;
	bh=XuwH7EhHS5byXN4uqQyyViMwqBUJHDwLmZDy5TxCtGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QDYUypkPQWNiQ5fN8qd9jERL8ndo27Y31c00Il58peYWj76DvTk84moN/Z4cnxUPD
	 h6fcym+i2XEyDyj+3waMlDGyei9HoitSXkvt4I6zVc92UVBKRWmHcEnqq8A4ZqU1Sx
	 HVe2jtqKTsdR5N1qSzG4nhDfAjtuKKVNNkram+NyBS3l9q6xgkkZppw2Nfo+Ln5gQ2
	 zCkcoRZLKG60LmFocmtHAwDsCFZnv1eCdbwHDj6+Tiw13kevu3GtUFOO4Wq7ZRggsS
	 L5tj4aBoG+grtp7I6MCjBEk3nh5bJXMByRMktXW4JIbeq34ZgfuMTZaPTQjxzOtPsZ
	 OxCDWjJVLS4Mw==
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
Subject: Re: [PATCH 7.2 00/10] 7.2.15-rc1 review
Date: Fri, 30 Oct 2026 15:01:49 +0100
Message-ID: <20261030140149.102508-1-ojeda@kernel.org>
In-Reply-To: <20261030121255.257615100@linuxfoundation.org>
References: <20261030121255.257615100@linuxfoundation.org>
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

On Fri, 30 Oct 2026 13:15:01 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.15 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Nov 2026 12:12:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
