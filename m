Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFB6B36492B;
	Thu, 26 Feb 2026 20:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772136665; cv=none; b=BSDTLTEYUR/2S/0RZKv1dssWkTRdcrVlySITARRn3TrAdwIGpBsXiH9f6q00uY4lzob7oHw4xDnMVlq48Alh3PvwNBLsiCjTV5hxz//blkU6ARVXOldzKQ/H0sRuzVZ7VBYv0f0SjBLMNjtJFCis8xC//KXf1OOfPzhYiyINVPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772136665; c=relaxed/simple;
	bh=s34e0Wjb0ayP9vCKMroZlUYMDH9ud56Kx7tEGJQ0BKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nf2ymXSzzttGoKUavCvMPldfEH4Ii6YYF7JNhFymQAJSrcv4sUK20qFLNK78JzYjAEHZRd5NqdjBjOHIw+9eD54gbOJEC2GeHYi9lcmTMLVv50KOgzdt0JEp4ifJn/bxjoK5VMhCXxwzYKnKUXPrMhRACODbSIU1zPl9Qw2jsdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ubgQco5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ubgQco5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A0FC19424;
	Thu, 26 Feb 2026 20:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772136665;
	bh=s34e0Wjb0ayP9vCKMroZlUYMDH9ud56Kx7tEGJQ0BKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubgQco5k+UidUNzHA31BijpSGMTRZld89UTdGaotCoClE9sULQdYBKDJUjonODWYg
	 SY/08h3Ptxe30qYDehpnZA8tZIfy5bfCd8XOF1zE2PWWXSmuq8DUDz1h7tQfk49zlZ
	 WCd3mOkPvk0WSIhigtbqnhl0euzLz82jYuaGa8p8wQWsVGuJBtFcd4ch3VXz/sNfyD
	 xTFnys0PXAcYK0UC803HMa703oFn/lp9HxukH9qUTxjhFqHLaCJpJn5NBZ08XKSb6H
	 b8dXPxKrg8Zap6dRoR/ITpVMClmhdL4JmEpcz+ebsM+WOnJdov+rAP8H3NKNMId+Ps
	 x01ozKVxVoCMw==
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
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
Date: Thu, 26 Feb 2026 21:10:56 +0100
Message-ID: <20260226201056.28728-1-ojeda@kernel.org>
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
References: <20260225155341.094945851@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 25 Feb 2026 07:54:11 -0800 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Feb 2026 15:52:18 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

The drm/tyr build error (`COMMON_CLK`) is now fixed, from 6.19.1:

  https://lore.kernel.org/stable/20260215023627.56245-1-ojeda@kernel.org/

The fixes for the other build error (`COMPAT`) and the warning
(`unwrap_or`) have not arrived yet.

Thanks!

Cheers,
Miguel
