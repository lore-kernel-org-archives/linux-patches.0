Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5FA22848A8;
	Wed, 17 Jun 2026 09:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781688246; cv=none; b=BPmJIsT/1t5oK2xgiUr6L8CFIegtimhPg0NM5LavOHAq0KRlI80Ij/XfKabIAxe12DWY63M/Bk0dfcwhWHgjKuxV45Uwy4M5kk1x0LLjQX2hADQYVhYrySYtHX02oHVvi3eCi5pzCgFXGN5Sc/lbfu3pb+LV1r6ifgyzK96KQ8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781688246; c=relaxed/simple;
	bh=jNoGv2dbzbAQQ8IcHUN78jgs19tKhiJSw9rxuQFj334=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od8H5h8X4o1hwBnbnejb/kHlujIrOFcvrfiXvVk+mwQqh/RJi7bdnMz5IwcC89VufPZclPkHfHkEgYauJc2Cowgm06CpKidsYwlQDUIsMHzNgCUTi/sVVI00wajf1gMLDnVmiKs3rOxAv2hAefSwkk1+x5j+fOrXvn4+RwEllDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4fSKaBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4fSKaBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5FC1F000E9;
	Wed, 17 Jun 2026 09:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781688242;
	bh=G+1etUwPXyxC3Od6lnP0d5nrwXWw4/eZpw45st9PE6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b4fSKaBzK16g5mKUOxvTcFN52nGPr82u6MPY4YH3MNWaXGmybfdiAWjryzEx1RsK7
	 p9L5DFFCvKmdZerVF4HOespHl0+mRcFJ0PRU9ctTc/8S4vTgaEQ2kf/LG9Gumu8S99
	 qrfwCT2oUjwbLe6EH0gL3XrndPifxCjwmd0uDBaFNv1C3BT33Ixua7x48PjNQEMIRL
	 YfIzU6MSWHpJohN1qujHrM3iY8cTWvui06y1+vNzaX/YQCKIIQWZ3LjoOi0TnQimVe
	 YfEe/G92d2G3msmkKpwXxxNQqFIkMf1NOJm15iCf61QIRN6fCwgT0BllErQbErYgNI
	 hmEX7WBqLY26g==
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
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
Date: Wed, 17 Jun 2026 11:23:51 +0200
Message-ID: <20260617092351.56176-1-ojeda@kernel.org>
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Jun 2026 20:27:18 +0530 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
