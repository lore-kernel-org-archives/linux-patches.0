Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795299790;
	b=DKC+Bux7q8CPKBuo3UDs8Zv+XAq9NncFFNA7f1DDAPa+w+ry0LWjSW8UVqxOrEl6EBAw
	 uEbGXs+w74JUTfiKAhtG9dmAoQxEBfbcgrA3/CAi6uVYUWINpTedl0WgZey7hCfrfu534
	 z5jufXSIiJHxbYYopEWWTPSKCvXsBUx8UFL5ClFF5F2t4fSX/rW27j2Ny3hm9BNzKkRP1
	 O7NT9yxe7l3nt/RwxswWvR3vTdH0hF235htI1iy/kSDIYcimgtFdNYY4mKX0RrtQgziU2
	 wT65nKxHhaD9wDEBzYBg4n/G3hqcj97txWHaNrOD304Qb/SQR8FpX5mjUgRFxQ1nsnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795299790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=K2M8mGPlBBZT5TrCC96KON2T8gBLDML6WwwTbsKwYZk=;
	b=ajwEAbtOx/vrAFWLrLDu11ZW/3V+SR/GR7YV4Kbl6l57Lx/M4NdnqXtRluwVSCkrnhlP
	 VNch+rEzCPv5sDSqYm0tXoTQ5x3UaEo+enKWmxWfEgmQBOKIKTwLG8fXyqDQH3cAwmBBY
	 5T+zijK04sFVTM0/gs8fqMJsGnYNvbRd8njdfznwY6scuhX1LwalGu1CpW8971gZXJ+XQ
	 172yWYc3Q9lEEJ3nk3Bl3sJpdxqzbVygNGuQNwSVY3OEhuMIxfwGEREsBet/8fjB5kmy/
	 F2Ch5/HaKIsB2t4cRwTNE+KUFpntjY6wC6WUxgRB7qJO9nToRcGDriTc0bdbjkpYQKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLrPd5Ew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAA0606A320;
	Sat, 21 Nov 2026 22:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kLrPd5Ew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A919E1F000C6;
	Sat, 21 Nov 2026 22:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795299790;
	bh=K2M8mGPlBBZT5TrCC96KON2T8gBLDML6WwwTbsKwYZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLrPd5Ewg9iBOOhv3730psRJvW/1j3Y9rtSoZCGFqBgTgyKE/diaOSY0bpGLFKS1b
	 BEjBnFOKB/5mNVU1UK1uJS8CNbmizk2JERW6gpLgEc8Jeipj5l2Kr37Gl8d4uLZ8yI
	 xF0LxafAtDqReNzaSIk8vNz4KY6bQvSQnsqc/2maZ++dXTxG49BCcem+KmN327wYjj
	 AibptQDdNlSZuvoMEH97/JIqV+na629u2VNVJlignNVU8jmTU3vn+iHoIoxeZ0QpGk
	 xPp1ANSQl1DyMT305cgD+ZdX1pRIrPBYh3DMq4Kq0VFIZEvM9iAJBSNwmWKHbiso8s
	 sWJ7MIbQac91Q==
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
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
Date: Sat, 21 Nov 2026 14:22:52 -0800
Message-ID: <20261121222252.136048-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>
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

On Fri, 20 Nov 2026 06:57:58 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3308 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
