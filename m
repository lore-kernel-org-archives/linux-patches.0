Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4E8449B34;
	Thu, 30 Jul 2026 18:58:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785437893; cv=none; b=B9Ps1wOePngA7AHKe6LSr0F5zAPCt5tbf9Nye3ZR0FhauMRkmwOYsezBBKQxeWSX3uMm9iwaebUwBhwY8ot62wPCHkwyGmgOyzhnUyGSx8AzprX79/RHYFPwAYAS8cL/JvpI44tDtlkbtPeLXxck4lQQdj3rsBjg0PXwCOv6bko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785437893; c=relaxed/simple;
	bh=eRHQMhQSbT9m3ZSE1KntZHcl3fIjzkR9pnjwq6HUuVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khYSDYVJcLutS9hDPqmb1x4ZsWMzr0uz8JVV+t5SxQcEhqpKb+G5Nnjtuzze39r5bMnc0zbXI21AJwyhEEzYvl7cW42tiolmEZ7mSsKfyJE3AlLIN7KkiccGre4scbrbJ+NMiSuMn9mDgTqDLpErcjt8KUK78mD2eERe82Yn/10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fDQ6NEZ+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fDQ6NEZ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4AB1F000E9;
	Thu, 30 Jul 2026 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785437892;
	bh=Yi282NGKtS0wXIcA49DEq3kmHzBMiMRZcEqAQaWq50Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fDQ6NEZ+ZNrZqevm86HtwZCJ1jBG8H4rOzGRPCeJmBErv3WxLbRA2ew/m3XSJk8HV
	 dFWBnsz68VDiUUXE9fbhIHHAq9AvoyiDzwDoWj3man9D4MaRm7g07wtlmNFdF6g2yX
	 SspfM8PB/cBgrWi7Odiqy2GsBqtRYTBmk3OrgGUCgEou9Bn26zWvgD2p8nZt5536L0
	 KjWBgz3eRidzrz3rDWkwIb+3ALa08mLM3fzKuh9gDIOI3QWwObsVkpAbKpfBvPlf5E
	 m9DuZGC5n8+hnbluAZ/ntC7DpEcJSyneO8Ic8sFx62X+0CF0cwYbgkip2nWvgzr2GG
	 xLgE8ZJDBZ00A==
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
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
Date: Thu, 30 Jul 2026 20:58:01 +0200
Message-ID: <20260730185801.99186-1-ojeda@kernel.org>
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 30 Jul 2026 16:04:33 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
