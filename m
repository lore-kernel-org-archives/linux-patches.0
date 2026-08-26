Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE6E3F4DDD;
	Wed, 26 Aug 2026 12:27:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747266; cv=none; b=Igbx7ztG1HSAQiLpwrLWKTtu7mok2BavLgXizeIqP5/WoLg+IF7fcaI2Kowhc+P2DKH/RB27OakU7YUqjvDysKdS9rw13+xl+5CLn89vwfoPy7YbNmsxjeM8M1Qz8SCZ/rrWGIuNmk0A1SnHFySp64582PRnOc95orZlNrJ/duw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747266; c=relaxed/simple;
	bh=0huXDNxiAgXvdBueO8aSY5wnslPpGJ0jhBYcdCVvBNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHUiBrPFfRh0Jqz8Y2US2B3wEay/zUE2+nx64Bm+nBkL4r8Ur75M7cjqfplXKNrxnLuLKWKqcl5qx/QMXNer49A+KKugTM0P0rwXF4iSCIY9AzaLVVsap3cazS3Q2xHZ8edumIPOj86UKvfeLA17iMa4lAB/aAZPP2F4mJc2/O8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DsVkkBrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DsVkkBrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5652C1F000E9;
	Wed, 26 Aug 2026 12:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787747265;
	bh=1b5BxBxCYq15T9gNAV57zTWWKhZfPx1TqqHG5wvtAXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DsVkkBrYnfLWX2J0XzWx/I8Gk5t/f+H/dn9Tp1KG2VT8WMYzgJ97E+BO+x1ZvvIrW
	 OKAv/fTWBIRStE39pq+e6HfXvZl8eSRlu42FOc4v3AzQRIXiJsrnE4o6rGF37Tzw17
	 rBGNBW9aVnNkMEh0cLUL+aDgPreQ79Htq0o4VIKyNYqizyfSqMZupeA91Ybftvhldz
	 ASCvuBao68bXfPEmHYfdBtTil1dsDUDnd5C9RtV1pQU2QBi6Qxgjg8Gzgz5ybGg1YM
	 v9X74JouanhZaTVK+KR+gPsm1O6z5eznrDJRY62RIPWBUMLnRIjqpD2IBliNwqI8rb
	 l9F2MaDb8lP9A==
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
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	amd-gfx@lists.freedesktop.org,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	loongarch@lists.linux.dev
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Date: Wed, 26 Aug 2026 14:27:31 +0200
Message-ID: <20260826122731.33748-1-ojeda@kernel.org>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
References: <20260825132541.986300899@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 15:24:38 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

In loongarch64, I am seeing:

    drivers/gpu/drm/amd/amdgpu/amdgpu_vm.o: warning: objtool: amdgpu_vm_handle_fault+0x140: sibling call from callable instruction with modified stack frame

Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: amd-gfx@lists.freedesktop.org
Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: WANG Xuerui <kernel@xen0n.name>
Cc: loongarch@lists.linux.dev

Thanks!

Cheers,
Miguel
