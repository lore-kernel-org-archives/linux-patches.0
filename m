Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07053DA5DC;
	Fri, 21 Aug 2026 09:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787306234; cv=none; b=iterB7Dhm/QuFxPgiS1RrI78fCwqCue8LBTNmR8CcpUHw2Grk/OU90lhgUMAZnbcNtjZxdprYlPImMmLGBxNVmF8KrwN9hmCGU2mKqUenEKEpHc+Eufvg7Pd/MswGLPOcmmFVPhdohwoqXnmheIVtvPdF8kfz2vRlzGGY2rH3a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787306234; c=relaxed/simple;
	bh=Vh5rTpWk5yf4YoSc1VoBihXffLvN+NfT/nbmvNgrXq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDMlE3I8jB1F8twHfq8pDdR0ryISftJuXRkW3hmG5RvtTQgFQ03kyy2dRegKzaQbmrGRgb3QaF71a7Ey1SImIlc7Ql2e6SxXfLL4W/8H9i6MxKSo9Hvoz5G9S9Wl8urB36T6c4NLV1d4F6u16gfpSuQA+BHYpu69FEoKgY37q4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPtHnFJW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPtHnFJW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 114EC1F000E9;
	Fri, 21 Aug 2026 09:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787306225;
	bh=ve+Uo3Pd8FUSIsOg9DfBkap2tT6/RNAeNyBVSsegSIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lPtHnFJWvukxbUVQGGjOzYZ0FAQppVpN4SCHSUH4ZGai13QmWUFrpWqjo1L7UF+PG
	 pKc9UVQePiBmgkbtbFD83bStZrKRyirdgP1CpOCr4AAnOsrLvJnbK+drvryccQSAzs
	 gt4+uK/ktQaiRP6fSsDzCa5u1PNz2NzBjuYpHhvOqo4Fyy7O59kyqMnFFTzmgVeCtN
	 hYg3n2usr6T6nvTipJ5ftPszyO3TN7cgJSM7y+zF3yCgMCqua6SBJgQ+ktLZWZvcrG
	 iXwbVIeFHFMflnC56TV9ZfzvATMXirXfTMOFezQ6d17e8lA5uS0obXIOGcucRcnZ9d
	 DqSfizdUEsobA==
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
Subject: Re: [PATCH 6.12 000/220] 6.12.105-rc1 review
Date: Fri, 21 Aug 2026 11:56:56 +0200
Message-ID: <20260821095656.130941-1-ojeda@kernel.org>
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 20 Aug 2026 16:53:10 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.105 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
