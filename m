Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0133009F2;
	Wed,  7 Jan 2026 15:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767799590; cv=none; b=mA7clf6RV1ia+LZP0aZWSxpYa+F4WbI79wxfkCf1Fsva5LwgniCC9xWNPGxuZBWGdoo4SCyDozVbNr82v03PwdMWLpNrDnxtDI/UvjWuWu7Z++PSl6PsDlZ4UDa85DCnemN+25rvjRgQfYdn/YNIB73Nqq2Q8u27bvUEasbQ98U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767799590; c=relaxed/simple;
	bh=JdzkMupifK2b5xaWn09jEGt9VUFiDsmhKvQWG9Q6hLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhlNASUYPzzW1wY81Y6Ry529C2j7UDWaCe/xf6/tSmcA1FMw05okPczf4QDCq8f0LGtfOoraOeIxekplnCD5t+fEibEAOT5nSZEeCUqCtvwNPh1eDItNSk5K5WNb2HNJEWEvXIiZ77Zw0lNw8bQ1agzQmfmnavb14gr+UPMw+IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GiqXV6pZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GiqXV6pZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 956E5C4CEF7;
	Wed,  7 Jan 2026 15:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767799589;
	bh=JdzkMupifK2b5xaWn09jEGt9VUFiDsmhKvQWG9Q6hLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GiqXV6pZxEwg+2JoBbnkoiO+7vujkLqckidGjiJkLP8ehiqjSAqe2blQ7Z1g6ISaZ
	 SiXf+aV104ke7qcdv8PnHywYYKH/PBZFDAA9+hM8DxywSxDTaujcgEckcfYpbiSAio
	 ko9jQL0jjEEx5EWnvVTiG6Bz2j9TKMtP0YVLAyhpYkLuBlcv9q2PFf0w/kuqNxoLhU
	 ThxzS9YtXlh28EoORLJ6xkTHRIa64QYM5yCOJWRM/9sVm3M+QO+mhn5PVDiVbqyTit
	 RMfz4z+ZVFDlKt68crSycBzx7aL3IXkryhwBXx2jsxNTwEGqgrsTyQkCkoDIQs2L4n
	 F0dqBiwjR8WUw==
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
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/567] 6.12.64-rc1 review
Date: Wed,  7 Jan 2026 16:26:17 +0100
Message-ID: <20260107152617.473147-1-ojeda@kernel.org>
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 06 Jan 2026 17:56:22 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.64 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:03:16 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
