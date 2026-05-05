Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD8E18BC3B;
	Tue,  5 May 2026 09:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777974712; cv=none; b=GRGmdhXWjs061hRiV9E6WPxbv9RUCxp+JcDx2HCxhBDHS8i5isLb9CCrJspRKTpE9F5LSn4F3581OtlCpMgaO+UG45w2PdfYK4TIDA+d962H32WmIzAJjYJTNyxoTVzQwYwsQLDElZzpI5aXrYOwPpNqtV1nVU8ShVTaNNHiP14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777974712; c=relaxed/simple;
	bh=wXAGRypnGyfRebs7mQy9HBOehU0JLwH65QKdFED4DB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KB9LOY6sn8yEiJLr/TiWlaxCBLBPuyp7cIPsWU8CjRadQFtARJ00cbWU0rQIi/1h+K1nFhy8AuPnNz7/Lgccz9oH2hkGOAOFxxjvcR76AzEBZ6lxDBRqh4aeWXprkux+2A1UF83Ru9UkKT0GeZCED4VOnimHc1+nBQbfz88ACII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3ZM6mSt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3ZM6mSt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1062DC2BCB4;
	Tue,  5 May 2026 09:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777974711;
	bh=wXAGRypnGyfRebs7mQy9HBOehU0JLwH65QKdFED4DB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3ZM6mStEOZNfab2MZk7RRZZdn2mIYgyQrZXvo2e7f+mZc3TV9CwMKDGjV3dF99QW
	 LXK9hftQVK+b7YvmXJUSGYby0KIjhlDC5H/V3jkIYrAbaW7EuRWKaJDopvPQKCU+Wz
	 ziD6UcojKGFGN35VqlXx38yb2sGmz5G56kPuXyxug9ALKcNYMtGU8tZ6PSb6c5jZbs
	 yaeBA9/Xu1F+L9ypJ1wsNTnIe5E4ec7Y1ksfHxBZsyfXdrKPKWP9VmS3+2GI5AAEM0
	 xFb8AqfgRN9joYEbEx6xaETlP/Slb6Xq8mQZMuePuaRHNBMhMORjY5OYR1P7GqoByM
	 GiB3NFiz2J/cw==
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
Subject: Re: [PATCH 7.0 000/307] 7.0.4-rc1 review
Date: Tue,  5 May 2026 11:51:36 +0200
Message-ID: <20260505095136.246649-1-ojeda@kernel.org>
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 04 May 2026 15:48:05 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.4 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 May 2026 13:50:49 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
