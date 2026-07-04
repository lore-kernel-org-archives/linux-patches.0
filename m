Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1720E2E65D;
	Sat,  4 Jul 2026 02:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783131280; cv=none; b=Ls9F8iw7hmJL41aN4BdF+QHdDQN7LZsUcotd8hmOFQkQiFqADiXKIGvAaa95UCKQO6mfydA+38BQtJSFfML41UWPQSzvOZ1WAZwrdt+VlqBcdoY7y6fdi+LpvD/slKSzfqbW1SGVt4UdjRkKsygXGzesssAM39GJWkXXgupIdOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783131280; c=relaxed/simple;
	bh=iAiDKQ4iSgz2XTfPLnYtaB0LborPCTmDt2NXeiKNruU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CDGJYdCGcpk30XLRjl29ZPlanoaNH/cFpqhhN33GI/WC2vHu7QM9DrzZ81TrG7bCOkE3rMILI/D/bnq/1pa3Vayl0KRqijsnvZ7LDEVGZnXepppUqGaJ9WQzPH4fLul6N0PVLsjw34YeedCJwooGG6VTKjLYDBhFb+3Jo8YZPgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VPCsfIIo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VPCsfIIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500231F000E9;
	Sat,  4 Jul 2026 02:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783131278;
	bh=Q8awLyWEvNZ8C5VKMUmfBo8/3zR/FfAfrSD1vAOn6jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VPCsfIIoFzBTxJ/8UWSemNXuZPFHiOX0hfpb1D+wuhjcDdIm48U3azZnQ5uw0ejkx
	 AicQYfC0vpG8dnked8aqWuguVU3VnHTkTxVQcWvCM7PII2CemgCcJ9V4s8kbCaoEef
	 7eRTqjphIovVRdOMbsF+SjhKmA7MT8z2cUxkBopLZ5VgT/VXAJWnvcTSSVeyHfFdOL
	 WkR2EcaDHIrjy/k708wj0NzzRymYr8js4a3huN/N+JhcjmG4sGooqy7coZ+W5uXuN7
	 P8R2mueat4G6xFGmS/rmdZFqeenRm6dOo9ENTSBp8wKhvPXJpHREBFOymjvEfxGI9v
	 iRjxLHmpufNZg==
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
Subject: Re: [PATCH 7.1 000/121] 7.1.3-rc2 review
Date: Sat,  4 Jul 2026 04:14:28 +0200
Message-ID: <20260704021428.56685-1-ojeda@kernel.org>
In-Reply-To: <20260703072822.817328079@linuxfoundation.org>
References: <20260703072822.817328079@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 03 Jul 2026 09:35:59 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jul 2026 07:28:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
