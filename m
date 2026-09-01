Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 193FE3932F9;
	Tue,  1 Sep 2026 22:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788302702; cv=none; b=R5+021xE2VEjzGSuVGjRY1sT7+XK6SCPvmbu+SIJd503hnXSI/3ikM3mfslImASZVSR0gr+YdSVMjwtVaGcwcz3ucab0aO/g1mkg930fSCDZoSl/tk8a4eeiYyRB6j8onbUotQkzv0v4A/XboSgeKMtxx6WWQxxHLXL0iyZGgX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788302702; c=relaxed/simple;
	bh=XCNUNOpHG6c9xfqJZQdOrlhozIKzFpDKfRumJ9+wEsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OvkNQltHHRuUiKlGfoOriohAXk1sRDUealpiPIAqsTqKiXGHEdV5Dgp340dVyk6mPENv4Rybo5bUkyNSQBlkaLEsNDTbHr2gC8rf36p47mnOZ7nTJflicXWxnEsAgsva5cSruVrGNi81oqKNGaHTcYiXA7yWwRzYrKiOFR/IiaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DA35TCJV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DA35TCJV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A21B1F000E9;
	Tue,  1 Sep 2026 22:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788302699;
	bh=fNkkfKa3oIoRFwUxvVKWaLeOIBPOr/UjdeUIPSG8H74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DA35TCJVEJZv+EpBZ+07K6sMTXAE7JN7YJNO/TGBay6s72xVt7lydCQ/At5VhapN3
	 Vay8Vpxlt9vV9gF1+wdCqeqvcuxFoJ8a7gK0xfSQAV0b/qr7HOSsLEOS1cguBGMzUU
	 qGT1J0YRtjA+F3XHcSpJsSuwTIx4XfeL789FbuERiF/6uE7P9iBfHijlG5f/mVTJok
	 Va2YK2f9lkkO5vE0xm+M7owDrxShEBPbyHnZtWb34u2snBNH5VoVI9rjYp44Nbjh6a
	 bm+fCv+HKTZZrIv9xcPV3CAA1Ys9pswIp3ZZzvDAYunJmg1uRaLSAMcm5ZJjN6UtF9
	 h2HbgiaoHZDNg==
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
Subject: Re: [PATCH 7.2 00/71] 7.2.3-rc1 review
Date: Wed,  2 Sep 2026 00:44:45 +0200
Message-ID: <20260901224445.63297-1-ojeda@kernel.org>
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 31 Aug 2026 15:33:25 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.2.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Sep 2026 13:32:19 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
