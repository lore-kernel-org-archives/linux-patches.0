Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A611764;
	Fri,  3 Jul 2026 00:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783036978; cv=none; b=eME+Jsn6xRxYhI9CCkXZZYksQKohaZphvfZn2vbw9r5inU08lAFMe6VrpV22kMiKIvhMaAhLlADeg8WVfy+yL7KKgwsD7Gnk+txNRtAufn/VY23EUFjaKFLDlYDu5pQyStDvtrWTVQCCVnDBVhmEjOjXUbFlrQuOebnxYEGaF38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783036978; c=relaxed/simple;
	bh=JR8RhZ1wnh2HpRDCWaahZhdD+9fcl7EvPalH+3+QEKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LMI1VoEs9a2PjQbPqxB8SU4txSWi1oT/H4PyX2/in3qqhScXSw3Xq8bs6dWItIZhoJ2xjesRJ6Io3Z51mml9YnjhGdxnMVyU35o+DwVpLRoAqf+mFm7T0qVkpSWDO19Eauf6Tk5HEV+HOE9mYJBbG/zobb5rj5nKNioqd62qO3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T5oZ4rfj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T5oZ4rfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63DB1F000E9;
	Fri,  3 Jul 2026 00:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783036977;
	bh=FRO6g01nVPHInGAvR3Ka6hS7cIBZETGk+uJbv8nmbxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T5oZ4rfj0m0OszkEys7ASza1lt1IGJrN9ObZUGyIMbiwSED7DVayXeh3Riwj1xI+L
	 ozC94qGXEo1js5xLSEG8SaVbLz34B2H++Lc6EmDab+xjimn7wG7BqcwLgOsBKz2u3g
	 KZPSrGLFG8CPchNlh/2dIxICZuhrQ9OjMykdC88886AcQoLMTUqcphx1EklTGz8edr
	 S79z++D7HfHZDavxAMbO2UvT8c0TgdDi2W7tD/CJhhmeDmk7fmOKmn5cPHuBLV1BPR
	 oFJYROBjnete/200jemZMyNVq2lw8DwRu3WGnVdHS1/eucD98KhtpEKovsUtXQHodW
	 9nfj4l/PWUQhA==
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
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc1 review
Date: Fri,  3 Jul 2026 02:02:47 +0200
Message-ID: <20260703000247.11776-1-ojeda@kernel.org>
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 02 Jul 2026 18:17:37 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
