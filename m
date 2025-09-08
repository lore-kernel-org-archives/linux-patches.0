Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B493C0C;
	Mon,  8 Sep 2025 11:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757331077; cv=none; b=mjA34LmplbIgV5pUM9uOA6OO9zr7MVLoM3f78m1wuTT43xsZ0DVLi2TjDEsHtph2fl2mU2eFonnRgSU6N5+muDGyrsrjjIRO5dTtxxNnptRPubd2U8DdXrUK0ZDEL8wPvjMH28ULy+PH/gMowhB9X8lM+jv28M3TxqvbzNSaF4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757331077; c=relaxed/simple;
	bh=Gkq+PGAOCQYdFihDXhDhIB69Wc5fpRIO48gj2j/UX8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8I/IKzf7sDZvYN2fQsZLXeEtoVHodAoAiG7r/j1TTK70E/Mi2gYTNaGs5aRQrtw47VQvufnsqfDP/nRdhJs4hP81hsTLpgkBhAgTHkzeBtolehus7/YRpEEiapjyZRWhgSr/aiPzaTuYlWdYk0r7TOSrDjmmViraqa5ULw+avk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rW/W/j9t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rW/W/j9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACD4C4CEF1;
	Mon,  8 Sep 2025 11:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757331076;
	bh=Gkq+PGAOCQYdFihDXhDhIB69Wc5fpRIO48gj2j/UX8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rW/W/j9tdtu0VyJGO37nuZdEWDX+HkgOSB+jXAaRsfYY/5cFBgYyet8OYjC3hzAOK
	 3JtlzS7JlcVpWgP2DY8e67hoWRU34ozadHl1MIojVPKSWUXu0IhrDuoTvlqxxV0j67
	 Ksx76Tl++qsL/QsPGMBOZvM4q4fc+E7/2GxaF+Iqo7PBcTvJeQKpal7uWyudt4Vr4s
	 LCiGUN36bD9+mefEdCmniPb0NdmkgTMYB9+PxHxsCOyyYbM+Xpnp+sRDoPz3ioV+7Q
	 1dgZc0L8LIV6m5rbdYODrXLeeipuZBAJSp1k4NqfgbSLkxyKwUOtxzMwu5bAL2eHb+
	 fG9HtAbxkriUg==
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
Date: Mon,  8 Sep 2025 13:31:06 +0200
Message-ID: <20250908113106.567906-1-ojeda@kernel.org>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun, 07 Sep 2025 21:57:07 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
