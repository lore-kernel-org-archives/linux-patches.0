Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BF8D245020;
	Sat, 18 Jul 2026 13:46:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784382416; cv=none; b=i1LYoqxPadmiX/1iCU8GibWwhlZs0gZb56RDKHPF+4TWX59nV1Hb9E3dQI4djnGlbH/yBDCwgM+I7ZMTxQuBmJu81SHxOpo223h7JVptxQgSQsv7V9N2A4hxGlDkXI1O50KCbOkCHUy3ul6gI1AoXYwZNuEOm2Q0l3S+pdHHeok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784382416; c=relaxed/simple;
	bh=lTN23+GGgNg0ITdcHf8F+p87xqFtXjFlpNOJw+cJr7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uure/YfVc5Yqy/MQB5WMNyvHgIEz4XX6hZUzAV8LigDxWGFvzFKZ3e3OQ8CKZFGQ+J/q3VARU5EHt57cF+VyJulX0qH+1LfoN9858/ThoEA5b6NX+rSDfV8GfA9/RyPaImNCCP69WlTSCvz8TtPWlXyXzKpN+ARk/z8oH7dmSKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVKaVpgw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVKaVpgw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231931F000E9;
	Sat, 18 Jul 2026 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784382414;
	bh=p0MYfcREOIcWiQna+3R2IsJMS3OcYYC6uIWnetsiQEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVKaVpgwdU0nB3WOjQ4MdWOvYnp+CYruq93yqccnueUBYBukBBsXBLx+ku4dS2mpJ
	 UlyGA+PYhrVGlNwSOL5Yy7r+z5aFt+Ra/LAtq+MEtIZkM00AqH7DTx+W8Ls5UpiFsE
	 M9hvkJWDRr5xD13Tk+ZUar+XMTgvVzAYjhzB4Mg+/kax6BHFbXexZK4FjSFd24Hj2R
	 bdTQJYfvwwY5q4HlO8Z3WhEdGhXw4m5cQefj0XQ3RnNVlFMJqYbarT2s9IAIPE6/as
	 NxbvQmMvj4RNP7LeYBVJjT7FtTbNjzkcPri1w9GW/eLdRTGnpWs8f+WXZEfHu5RLgK
	 jyNhn+hDxbHJg==
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
Subject: Re: [PATCH 6.18 000/495] 6.18.39-rc2 review
Date: Sat, 18 Jul 2026 15:46:42 +0200
Message-ID: <20260718134642.82135-1-ojeda@kernel.org>
In-Reply-To: <20260717101904.922623678@linuxfoundation.org>
References: <20260717101904.922623678@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 17 Jul 2026 12:41:38 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.39 release.
> There are 495 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:18:22 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
