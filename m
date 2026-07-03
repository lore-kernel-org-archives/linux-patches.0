Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D410C38D;
	Fri,  3 Jul 2026 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783037338; cv=none; b=Wpk3pcvEdE0fr7zEquUKfxOqkbe3gG/xox2d5tarVuggYioeirQh00XdU6NQkxOxNR2TVHiDRSfb0AAF5z/5EdrjITJCgNnYfmYeDnP2NZ/Irw353VhgDXC1kxcb/I4I5reLCqf9jhGExhSoBKugqara73Q/1FVa3FhyP20una0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783037338; c=relaxed/simple;
	bh=ENdR8ESvB0ZIe7nIDdqZfa5Jhurl63DJVo75adnZgjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nb0yTxOgHx9z8/gNlP78lt2H71GVj6eH+zsmUCKZqIjK43YukGxMykAswDOlBGeOB7xhYj6rAf0SUyBSmPyjkNhC0ZSw9GtAJZKg4RC38N6FJinuk5qTfj+4vhC4zwTFzWR5NaY8cqRCz25WtXpqUrvP7B1Gz76bZfPaK4UqeJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YnYs6s2Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YnYs6s2Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142221F000E9;
	Fri,  3 Jul 2026 00:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783037337;
	bh=phg1aR2g/N64zlKhdFmAa0PE1PZrpupj6T/qmgl67zI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YnYs6s2YvpuYFspkDfWpnM4xPU4smpueMOk8SwLXvx8xf6cANuK4JRpS49aOuoYrN
	 eTw3AdlbipwmTGzYtCd90PG52yf8JVILNFwX6q/mfQ8i11QNzg4SJj2gtc/NXC9cMY
	 GISj8M+BLtYuz0vjGR3MCwm1o9sx5bHpN4CVCzX8ZuRVAEMPAS9cX8bgFbnKzNF3RW
	 qGHKaZCEIXdBLhJoO5O/49CrCyZ7M3w4VDhY7Ho+BTmAmdmMcRBJOWE/+ZfUhlJZMe
	 D/g6JEUAsRiChaQiESYL55YR2XZGKWu0DA85X1lB82h0OxhzZsa8X3xir2yc6IcmVw
	 D06YB0/RuUrDQ==
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
Subject: Re: [PATCH 6.18 000/108] 6.18.38-rc1 review
Date: Fri,  3 Jul 2026 02:08:46 +0200
Message-ID: <20260703000846.12304-1-ojeda@kernel.org>
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 02 Jul 2026 18:19:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.38 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
