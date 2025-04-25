Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD0A29B0;
	Fri, 25 Apr 2025 00:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745540193; cv=none; b=U775tziOahKmUVk2ah7XWcbr4HPnilaMsbhBDVWHZiOqUqyUB7iaOwzdVOmHIxt9895tSVxfmecRSx2Dpl7+FvgQncTQNMUk2SUS+JnjDm7gpfneWWhHTMF0AFVp0eVT2I4dt++l5+nl/lzT7e6RVWF4+6bQKwJ+izW0fZADJCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745540193; c=relaxed/simple;
	bh=X5QUwLh6bjuZ1jpA1tIasHLNn246FNdG4/i4LkkXpo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szOSy/W5jnfFQV2/KNIR/KvGQLYidAXxNih8IM4zVo4hIRtd9DLSpHNnd3fKjgyIAd3YN7PILEleqhMcmQ4vgjQO0B7trZ6CdbmPZp6aWsn+uMAwfakJllYkCx1tKyW73lXD1hoxcNsIpMK9f4ZYCWq31HNJCZeEXH5hixe4/W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDMuMaSy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDMuMaSy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C74CC4CEE3;
	Fri, 25 Apr 2025 00:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745540193;
	bh=X5QUwLh6bjuZ1jpA1tIasHLNn246FNdG4/i4LkkXpo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kDMuMaSyNY6AOejA4NJperRvNHhiTmqk2a0fL8iVWg29SI0HDL3VH4uMDpc46jiEh
	 Oqlr94D1ijIVqyOy5viDclGChgdckGXq05HmYTJWaN2FyvFJlmmGPFei0v7SALvnbc
	 VAmAb1xC5Ux+QBT4nu5BlGFco2Be2HoJb7+8dFjNdncVnXd5Zatb3RWVrBJCTH+dL1
	 KiPYC/608qBaesBbuQdb4i5saHksO8/FqZTscuZCb7YTLNpzPVAiYbn6N46MifmYO7
	 QUMZOZjFXr8bSYW6uyxeSBP+DrEJ7CoLlJbnKuL1pRNYhHnQBNff7We/DtkLkIXTXi
	 4udOvsyeNK0+g==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.6 000/393] 6.6.88-rc1 review
Date: Fri, 25 Apr 2025 02:16:16 +0200
Message-ID: <20250425001616.62576-1-ojeda@kernel.org>
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 23 Apr 2025 16:38:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.88 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
