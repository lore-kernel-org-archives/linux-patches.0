Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B223536AB56;
	Tue, 21 Apr 2026 10:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776766946; cv=none; b=BWnzwFvG6W61qdBFeHmTWVOeYe7eC8ozy2bwOr9QIBLyySUYXajOIJ8YDaIm6ATyaBoIgZJceItnKZZtjSPDmpNW/MB8U4fynFQL1V36EjIoeuq3YSdJyRQLYlSWy1mFKG+d94AXG+B8S4sBYn/O5lV3LT3TRrlpIXoOVHVyrdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776766946; c=relaxed/simple;
	bh=yq8DCpxCypg2h6lQBEDeMsZdsBGc1bcsoGnGFjiDwRY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Do8gl578awOFWTmeOnBzWvS8qk4Giv7a10/LOhdpjvQgxaQ7AqGGRFcD99M5ZbPYYQXslBOkmjx96RXDvfvmEF0xZfxUiOxmLJpvlAqXJhbXXXL8+mPrXvUJudn9Pe2A3FCS4cS3wnxd5yyIBiaRWkAua35BExVQL88nPFKVEU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IW32JZ6u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IW32JZ6u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A66CC2BCB0;
	Tue, 21 Apr 2026 10:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776766946;
	bh=yq8DCpxCypg2h6lQBEDeMsZdsBGc1bcsoGnGFjiDwRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IW32JZ6u3LNBahGyKV9Rx1Els/dUzXfTEWxSUwRBqdk+xUF0QQEl1uVRx/5e2D0nm
	 n6zdi3bOpOLr4/+eMmXcaKjUwBU8SZYtlSlSjZPqP6c9erRcSELXawUeEwX0kNWf/u
	 P7YTyYoDcn8TVvxPHi5RDEXeX1HqGWv4BuH7vQDSqwSM6NFKx9Xp7E70sP8lzpQ7nO
	 W4xfKKeaixJb1FII9XuXBgmpeI5eqCKhzrpXcn049aCGYjDr5lcjAM2RimJ4s3MjZC
	 WR0Qf20IPkfW1RNzZtAPHzbj6+aF+4PI7s9+tUeRshqMqjUMgNviCFqb193+piAAHF
	 auSpCAISKfCEA==
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
Subject: Re: [PATCH 7.0 00/76] 7.0.1-rc1 review
Date: Tue, 21 Apr 2026 12:22:16 +0200
Message-ID: <20260421102216.51168-1-ojeda@kernel.org>
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 20 Apr 2026 17:41:11 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.0.1 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Apr 2026 15:38:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
