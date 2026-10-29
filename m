Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793284976;
	b=Ae5sEBSnSM5wEk69+3ZuRjw0ayMbNjfq83ME910tqgHObRG52MaZhs2+G/PNPspn+0ac
	 Bfdxcsx8O1WYJyr+f+nPtaCzWDMPy42NameYxiUyA+lpXDCrQ9myyCMLQDg4iYrvdZB6M
	 zzTLtyRQqy0tEyGQuZkSSZqmtQK8oRxdcbEyNemjA8Gfu7NUVRpaFd6jMKYNKq5WaFCEa
	 WcGwujSPqcxOfMsL90/DcdfbjqVlpMnLts0mqJ8FIYxByMaHYC+uB+fdwQA30xjizppbW
	 TljkJvYZVWmwktrsfEk1N8o5WLLKhAoYMwJfEC0kuHyW9uziUF6Zwxmd6j9CDdzHYhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793284976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Gk1fCl3VTM4/LB4O57ubm1CJf3ZTQHL5d08jH1qvrFA=;
	b=aPTv4+XOvgerABiDdcEAMcs0nFmP88Ll4hPpudI2q5X+/r0H5vjni4O4s9bBJ/Wenhly
	 QeXJeFdEe0iYp5Pif6UkpllQLiTPDzV5v1hmIXY2egjNCl4+y/9OnGRg+lLjF5wDdmcc0
	 Gb01H6n6YabKytYYpHP/2B/9TLJS84CDFjpjbcV7+TAX/hjrXGcfa9UbeluHtMx6Ssolv
	 /fcNqLCSDRc6A0qruIdn4LnildpmyYBamwqgHNG5wy3U6+1wlxgwmwkdEBNybs7ct+72l
	 rd/fUffT8VXlfrd9OvvFgeMZPRBnTz6v2XywflUilOZuEpPlpP3T9ypSgwkzQ3x5HDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSsC3axd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12FB7606A31A;
	Thu, 29 Oct 2026 14:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HSsC3axd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E729B1F01825;
	Thu, 29 Oct 2026 14:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793284975;
	bh=Gk1fCl3VTM4/LB4O57ubm1CJf3ZTQHL5d08jH1qvrFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSsC3axdhVPncsdp57Cv2EfJMdm1+Sh5cMuZ63zueRGVv0GUUwzNbXObs55iZ63Qh
	 GOcBYvpr1nz3mLexIJ5IQD4BmVu5mKxGJT8JUFQ1RogbLvpC7NUcWj/z4y4AbX8SkT
	 3xJZ0SMzxMRG5CocrBlrJJXsFZeFXv9Miw8HJGHA6iQR2DgKoZfr67aVktc+/NZsqp
	 EJEIajm5X2eYaB7YVNXgV/nLxGmLDdPsZPpbLZDWKL8P4Y4iNGzMs7qYB5kgUDe+MW
	 MsQL4SDQ/aGTKs5SSksxECkrBHCZbHYTIpSdFdWuEMP7Skpgz5Jfg7j70wQ0JfG427
	 noh2vhBMF3Amg==
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
Subject: Re: [PATCH 7.3 00/38] 7.3.1-rc1 review
Date: Thu, 29 Oct 2026 07:42:47 -0700
Message-ID: <20261029144247.149769-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
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

On Wed, 28 Oct 2026 17:59:47 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 7.3.1 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.

This rc kernel passes DAMON functionality test [1] on my test machine.

Tested-by: SJ Park <sj@kernel.org>

[1] https://github.com/damonitor/damon-tests/tree/next/corr


Thanks,
SJ

[...]
