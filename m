Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63783403EE;
	Fri, 29 May 2026 05:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033729; cv=none; b=eRJtS9FarKI8JUsUzUWvDb2OIStiNeWEOE9NWv/DRTg5faoxzDGJa6KMa6dteGyMG1+DoMozJpf22mWoRhnOPd9SvCIW9LxVsrmPF+hrE1mYj/PHCW4GYC0qL/k9ila7frkbt7T1kVOtyh34CxOYdv39l6hVICcFVDD6FAyoxk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033729; c=relaxed/simple;
	bh=fMeHltEPz5l9/G24EMN+v/88OXFbpsdo77rS6DZgoQ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1j6JZyYT6dK46VgWHYkCGz7Xp8feF89SKPOWT0p3KdYxZc+7kiDdVRKGypiR4ETaJH3t5IsI9ED2NDVOb9RUkou/k5H2Cz6lceKz0TeKE9Zrt+OZepS0aHdQINXVMFIESRRCDkUgl/NqKCvXQiwT3gpq+trH4AklLtm81FJWMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I2Y74zG9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I2Y74zG9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2501F00899;
	Fri, 29 May 2026 05:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780033728;
	bh=wcD3BIhargwoi+QyRVlduUJ9saJEYYNX9jDKO7WVtbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I2Y74zG97yWPB6g729puiZyorpOB13APs1bohNIRiWv/1/3pTt++stx5PO3KuWI+4
	 hFiQtKwVSWSh8f/otQ33v/373WaKc6hXnOS+n7J6/Etf/2DFRBtOGK5PjMN/stivIX
	 dbL15cM5TfuYzHbOSJbG3lWVnDcEogJnevtCqskqrw61I8lAHcwIrUJpKsZqD2lXBX
	 Phlz34a5G3/sPSLp8AnV09zUG7wykpRkZjaxg8g22sECYtrlCWO3Lmg2tHJWB8sdSb
	 /CIsRaY3bgJIaEmuvf1mJY+/fV4L9d7mjdSVej92EEuSnTSQoaIHE+XoPj3YEN2TxU
	 k+od20w4KbY6g==
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
Subject: Re: [PATCH 6.18 000/377] 6.18.34-rc1 review
Date: Fri, 29 May 2026 07:48:32 +0200
Message-ID: <20260529054832.120970-1-ojeda@kernel.org>
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 28 May 2026 21:43:58 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.34 release.
> There are 377 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:50 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Like for 7.0.y, for arm64 and arm, I am seeing:

  https://lore.kernel.org/stable/20260529054139.120182-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
