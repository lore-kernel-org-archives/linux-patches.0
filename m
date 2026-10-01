Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7590948F03B;
	Thu,  1 Oct 2026 13:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790860283; cv=none; b=VQ54SMz37Elk7USFYPX6b3mqY2gkNJO4bTYkug0Y1/AdoEymVqhOpq9I2rhj80/edfLZDvBifooa8aqV4X+effCzKf435YSfKftt6ycWdMjJK83ywe2F4IEjPmkly6XYT5nYEwMhYjIqpXtJ6gTnz6Fy7L3blEzMT5zZhEGjeoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790860283; c=relaxed/simple;
	bh=4sa3EAlsF5XoBRaLj7ELSwvNGNIVF0uRGRlYFqdTOq8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEp3sfcUE2DOK+i/jrjS0LWItQygwIYYmZn0xyauYDYaiDaiPnEegIyi6VetPtOhbcIT69sX++x430Ag+oKBnFTt80pj9ZNueuFfGyGox495mZte54/CX8JtGhxIojCmyuk92gGnqlL+ciQV3aVrVDEi9BoFb9OP5kLfJ6jdnC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6nbh+bT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6nbh+bT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559311F000FF;
	Thu,  1 Oct 2026 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790860282;
	bh=RA2a5/n91yILgBPppOaOZG2O1P/Z2bE6DT8PCqLpIvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6nbh+bT/D8RrUMSlVMcx/wtyxcwK5x6RluRrc2QNlbhdJ5UNgqiTGGdVfqyzQH5A
	 PWh4XRjXb9JXMdRCTZ2EnNU8zyqeuJoP7V6zjdgPZDULc9UKSLb4HzI960EyNEE5du
	 shWb1IIXkfPbvy4SsmeIPJdpB1N9s3+pjMXxVV6v/7zQE6F3P8mUUhrbCaMOM82gwx
	 XAxZp+OOSragOEPQIX0129/uiajnetE+vXavryiHrIzOQ7QkNa8g/c0nzF/zRCqdrX
	 anQp2Eo4o0t2gD3HDnjGkEirXLdD3FhUqGYDbUB7O6OCz7wrobHhME9LuycBM7CR2H
	 l/gDPa53RMmsw==
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
Subject: Re: [PATCH 6.18 000/395] 6.18.55-rc1 review
Date: Thu,  1 Oct 2026 15:11:11 +0200
Message-ID: <20261001131111.72483-1-ojeda@kernel.org>
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 17:24:22 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.55 release.
> There are 395 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
