Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792876264;
	b=VQaRvRVPtVVeWIyVA/GRmECS1H3S5gcE/H5zN/33YSlYzDd+1OYaVA9ZAGJ2Aj4rnn1F
	 hGpgr3El4JAc/aFNCaTV2FwpjFLxe/vvRXwa29Z5a3MckntIqi2KjajxG+gSp0PyBXNSw
	 A3csD16SDzuVtzw0Y88uluTbhKmZBlWH4uuPsDAW/IHouXIIfUuznyEYifkJFFSPEkhQc
	 SE27ig12CIdqE8ojqm9h81uwFCQ5HpwuyHcfrKtn2JQEk9PAn7BWqsk67rRI2mS4+07eo
	 Q2aJ4LmJKASOC+oiVpPfUCk7nWK/76YymRHLYBDOUY5fb0KrT52tPcI+fasZ0VlS7dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792876264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ByKjQe24XP7eTHpFFxq0X+PAMjWmkTjVLO0jHPHjPrc=;
	b=h+qb8rlz63J5dOn7h2AFM6Nd3BbRIfdIwWur7cI4fUajKBrD77gEQ9uFED5JYXk9cuAR
	 sQKVcs+yA+latEKfFb2hM9MjSaRYqcMW+tVzZ+AyN82FO88EdBkTtdWgJaf5UbkwDLcOy
	 gcblFNmJRq+sROsorQoO5MPGaPVrNsU9dXE/9PIJmmDD0Qt+CceQBDh0WD6Umq9hAfXF1
	 bjF4qOOIbrQ3lb8Ad4PhvErnn1fFdLE5gaYY8q/zwmlh9Iy7cR641jyXIqUIkruunb8UR
	 GuWDaCwXIF416gahn/CihxIqBEttuV4GPZhJPMjB1II5bFl7NNtVHqqwEseNXuZbDsw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8ukMLkz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0005606A31A;
	Sat, 24 Oct 2026 21:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8ukMLkz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B1E1F01825;
	Sat, 24 Oct 2026 21:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792876263;
	bh=ByKjQe24XP7eTHpFFxq0X+PAMjWmkTjVLO0jHPHjPrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8ukMLkzAno+G504VtCz4VV1Uz1V6Y1RJWliw2EA111fsC7TLZW+XNYYZXm1IJ3pp
	 oFAx62EkbiWu3B+yXzTLhA6Vn5Bcifz8ZGFqHsiXrQp84m5vO2jO2sZ1yXCazBzOPj
	 fyoGZxqzuQvz5cK22y7WCep8xU51m3WA9OfbHwM6EiSn1AvjsJMGax4rarXZIMIWn/
	 092lUp8osS3mXiGAgE2QsgVfybospKtBaoG9w/MGUGK+WasKMK1JFT9fy7KEir5Q9m
	 7GN38DdDc7/RkEhPdNwH7iZp7NjqHUd5isuos1ldcy5RQpqffMzfGJ1a0a7tsMKvay
	 iHPnu/TRCta3A==
From: SJ Park <sj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 7.2 000/243] 7.2.13-rc2 review
Date: Sat, 24 Oct 2026 14:10:50 -0700
Message-ID: <20261024211050.88625-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261024064731.125251200@linuxfoundation.org>
References: 
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

On Sat, 24 Oct 2026 08:59:39 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.2.13 release.
> There are 243 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 26 Oct 2026 06:46:54 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
