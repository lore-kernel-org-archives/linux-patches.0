Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DC0653;
	Sat, 14 Dec 2024 14:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734186039; cv=none; b=APqH1NDX65+nY/mDcMJ7/Hgj6M1QrUgWENSdy7FpQC0WJeyIK3K6JVCCx5MhJ+/SMTZnKyfSnYDIHtwyPX/efpDmkD158YoyJM/bh9IKdNL4/0V5jd5tfYwDs4DUaaPjxaj2jXzIMlUJdOASWytSgYQUQK4nM+GEnSE8lUlFGMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734186039; c=relaxed/simple;
	bh=4kVK4DZG4PCZ+Eoymvgc+/Q37BKkF8N2cGjg49zZHxQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zg/yQjVhIMdi9SeoKndulhNIqh1ce82iKg397Oh/xVsQ3xZn2agdaxKsH4z3scNIQdgTNYtNE2DGCGOISgqZR0m++CnGw5FWCxRo5ojkhLt+oGmuXCEwRC5pRWQoQqNcr3NotWH3mzEDqlCd1L8yERRvPz7hMQ6K/RRq3mVcJUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAAnk0Wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAAnk0Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B618DC4CED1;
	Sat, 14 Dec 2024 14:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734186039;
	bh=4kVK4DZG4PCZ+Eoymvgc+/Q37BKkF8N2cGjg49zZHxQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PAAnk0WgxI2KnP2xSet4wEJlF0/y9k4O5A+sN3a5db90PuvRWY7F0Lt1Ij9g319yW
	 T6xXdjuWsYE9QzL8GuW/OcBtT2E3zvdCFVBfu1TkLMl8rF+AeJO2Vw7tI66XXrzDeT
	 bJtPAPGvn10RbW+J4Z6s9l8hPKLLItuienPM2/7/74OicqQXyaK88eGTv0Uvs6kZ8e
	 sxEc2qXdXRyCZY7tQ6KccPd+O2UxXWvP4Y9FKxJ17zxK9/wuB7kXMYBFm8EYHKsbM1
	 o7bpot2ax+go5ec/tPpczDD7/qV2nM/3yWhTigLhA9j4Yx0GiXetInHMKwI4DtD6mZ
	 CLzjVCjCi61FA==
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
Subject: Re: [PATCH 6.12 000/467] 6.12.5-rc2 review
Date: Sat, 14 Dec 2024 15:20:25 +0100
Message-ID: <20241214142025.203882-1-ojeda@kernel.org>
In-Reply-To: <20241213145925.077514874@linuxfoundation.org>
References: <20241213145925.077514874@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 13 Dec 2024 16:03:57 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc2.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
