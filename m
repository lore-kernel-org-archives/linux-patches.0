Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA522282F04;
	Fri, 13 Mar 2026 21:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773436276; cv=none; b=a0YE6pYo7ujVrxlx9jWq3vrBAQg+tsgR+WT8nlBgYo0jJp8lWxHoianYeiHQyv0mqLvBUPnnkD23dHmb6XQpKpcDwEn8WtsybTLz0EzvFYUv40fNffkMnIci2kUfOru5xVDhEjSHSSGgsbHP77Jx/Ix2rr+48HdomUKyT+wOZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773436276; c=relaxed/simple;
	bh=4q6LOGO5lDpuIW189XIYYXhoZC/dxo0+dO0bbPuWvEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/xdVEb38Ma239VNpU7IY6e71FO7Odmi2L50qx5k1EwNcmCCDsL0PC7s6/hU95DcCAKTvrsIqUXjABPGuE+ikDan+ZfaUwiKhvo3B0nqlr7bGIjJTxJ02Siku5Z+YBhFZJkCeN19A4KCS/vIdsm1e0Dv8H1iwnhTli5HSytBDVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UbTC29GN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UbTC29GN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2805AC19421;
	Fri, 13 Mar 2026 21:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773436275;
	bh=4q6LOGO5lDpuIW189XIYYXhoZC/dxo0+dO0bbPuWvEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UbTC29GNRRezkMkoTASt9+D70CwtdsR6LZRJtP/EVREjI+CZldlhtkC2oUO+ZGGb5
	 nYfBU1W3dRaIsit/NeG1/chgQaedxYhtutiU7TrTP7gm1aOO7C5x4FzypJF+KGjg5B
	 5JuAnx6H4UjaI8DstdUHEnrN7IzzLuG5SArVSma5ZIep+HfxKu7TxTlc2o3z+9ZgKX
	 gEb0eov9jeOXppUnwsaHiT0YLrQ0mbflBHBR0197h1d13lnjQarposZLhc6C7T9Vnc
	 Tkmbr0KX53INNIlV9JTrXo6IkpZvEQvIdhHTvvy7Y7IKDuRcxtipPTgg87i2A3GTXi
	 6WHtRlIHJ0Byw==
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
Subject: Re: [PATCH 6.12 000/265] 6.12.77-rc1 review
Date: Fri, 13 Mar 2026 22:10:50 +0100
Message-ID: <20260313211050.183163-1-ojeda@kernel.org>
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 12 Mar 2026 21:06:27 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.77 release.
> There are 265 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 13 Mar 2026 20:09:29 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
