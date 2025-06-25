Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C65520A5D6;
	Wed, 25 Jun 2025 23:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750892951; cv=none; b=jccpUpM5L1pTLXU/7KnZ4zK2KXp3D54cwGNLvAwrvJN4d1IT2rMeDXWUjYNwulWfGg8FOvdXw1Do4DcdUUjsOFU5i+Lo9szS42CpFkm6luLETzcWUnvUWBp47dzQjMTRgtxUz76ZDgPfz10D2YZndpjd+cWFFI4S+l3EgP80n94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750892951; c=relaxed/simple;
	bh=aEj6e3xvgQ2+p4MSYu1drVRHNDyI4Dcge7jKENuT2SQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ew1n2lOGa+KVwkH8QZIF1QoyqpagycaVxUMFrDavwAzq4f+T282k60DEQevS2dMQGuqMt2+NMrZUBvpHuumm7JEGU4nCXtekIo0xw/IqvjQamEBmYT1PTgE/Pux60Uw0ssWnhxQRTDwMg1mHUEG5KwmaZDo/dyPQm8MXPz0NgDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YULd8Jwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YULd8Jwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85B5C4CEEE;
	Wed, 25 Jun 2025 23:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750892951;
	bh=aEj6e3xvgQ2+p4MSYu1drVRHNDyI4Dcge7jKENuT2SQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YULd8JwmDF6pXMC6I9AOFnzaPQKvAQWm7u4WuBQxOBW2WDmSI91de/rjEGSbJjcb6
	 hLERQGOdE+umYu/XWZieltbRbFErJPHTzk1dNWUCg76uE2a3MY6OaAI0Qql/3SeVkI
	 CM1QBrDSjhQfbfTZEa8G4k7rGMJZQGiJ0pyo04mWUE1EfowLsQ0SfwvbAhyU0kIpRa
	 gQeFUTaNl25plCnCP2tYfQPim8zFHL+EUyK277Z5nyw0yqJt6Rb8YDFH+dmBKqEsSR
	 ICPl/FHh/EIcKtkrJ6MgLvUSE45USYyWiGEriljVhQTXxEr44cC0odUGVYy/LUITN0
	 Ao0JudUjoZKrg==
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
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
Date: Thu, 26 Jun 2025 01:09:00 +0200
Message-ID: <20250625230900.951836-1-ojeda@kernel.org>
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
References: <20250624121426.466976226@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 24 Jun 2025 13:29:53 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

(-rc1 was also fine)

Thanks!

Cheers,
Miguel
