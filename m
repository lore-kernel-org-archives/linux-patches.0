Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0190D2F5A37;
	Tue, 14 Oct 2025 18:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760465503; cv=none; b=kpg+xjNhcaWyGfmqjoWPqMUy4CJfeT7y9K7yE/LjKtrjgXIZUyudDcu2CAKU9vZAAT1KYJtiZSS4KdJlV1r6DmucdcnM8fR1StzWoB3zjefUjh+8J1whdrLUeRcE6APTxsZMZ+fugKU6DwGvLax0+XtyQqO3eCCkOH13Xz7M0M0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760465503; c=relaxed/simple;
	bh=JeTQjAfWq9qM7cX1ZWKKyO/92NXNQXfNZe0RuspUR38=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IgiaopvbAD5hSylARBL08Wo+uPACe6LzcWyG/VBEMVPiEtpwjrkc9XTZ93DZjaOqfkEDFrAoxq/QMVZyLKUSrZTP4dwGIpxwiFGKAOu2+XIbik7ZcopGAwRDS7g/So3TBX0DO+vt4mTLaUoGkq8rZfuDyoc6NTS3k7BFo9+HWrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WU3N63Y8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WU3N63Y8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52790C4CEE7;
	Tue, 14 Oct 2025 18:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760465502;
	bh=JeTQjAfWq9qM7cX1ZWKKyO/92NXNQXfNZe0RuspUR38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WU3N63Y8qVgYf/CMD3+ZEVauHtnG/khipBSxd35KYOM8AoGNhGyV372X/5YIQAus1
	 5IqeAd+ZPk6HTTUi8ORf4P8o09Z8Tp42lFdxvgH6AC0UxkQ2KMe83omDbJMpiWmu0x
	 msYTdGEb/Atc8i0coyPDuzUUQ+Wy10BZaeI5iVi4ttwKy7NH2jNMTSx7le96FeFWlv
	 jcIPFRVmTrMijx7X67sIZCvH7THO2Z+sDioRrGvkIIj8LHV4lmuv58c9ukcyVRVJNH
	 kTO9ueveloC/GBffnu+awJhTMHmHGc+d+29BCZbq0n3Zo7K21M58zIO1/pGfadSjK5
	 yhVtcpHdHbNlA==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
Date: Tue, 14 Oct 2025 20:11:33 +0200
Message-ID: <20251014181133.1257293-1-ojeda@kernel.org>
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 13 Oct 2025 16:42:22 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.53 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
