Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795182694;
	b=OOfcrXu1gkmKNUdn3bLsrtBt0S3mW45tCzDKDYuefW+jR0C6c1x+G4QvBCH1lH9Ba0o8
	 62h/cH10cVKrS9sb7Rvd142XHVQNhCfjznRk5J+Qh+pOJ15spY4gqlb0byR/s6nwqVMXR
	 jkFQbbdIueFAKZjkrRmdfRZ8ERPhLmY+Bl05oEt15V3HC+XcQ0qorh36d97FmGkynwaN/
	 X+oSD0StKPEDMUkAeYLpZ3rTuLrJX52lKzSqAIzURYHhZ0MhBeO9C0f3hzfnrJ7g7PG2l
	 gQw0y15wtgLe6lXmcUc27r108M440vA41R0SaeTDOa8VOft2BofaLMyI++tLwK1YFNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795182694;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=DjJtftluh6k9RPnLsylMGUIkpRJJthy15jLJX8VY1b8=;
	b=RDL3vownoVGuxhOspkaaRjaEBYgKCWEDRSq8NIMU0reNXuYSmqBKBUbms7Wr/BDWLuYg
	 X3Rox806cRV4BajmZhEfuF0AjN0Wwykc2rf9IPQcbn+La/5/BUUHkGqet51OKOwjHvw8p
	 xPmWO7f6gowTIq4Oju6DEU/7csOmTfWVu1Q+n72Rb1dQgLUQdmnKTVnRuRuyB1Stfz598
	 Gvwk+5TlimmLUwWp2r5ixH/pm7cbnNeAhazD0wc1RuOKDjCN+A3oiI3oKY8mW5TD+Sq8Q
	 e8VzJRIPqhIQRlVZ14J55gMXVi8vYJ3lZ7gZRe/FAWq5PPUWFNTQTvdUQI0wIGw2zrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUBtRgLL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DB9606A33E;
	Fri, 20 Nov 2026 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CUBtRgLL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E041F000C0;
	Fri, 20 Nov 2026 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795182694;
	bh=DjJtftluh6k9RPnLsylMGUIkpRJJthy15jLJX8VY1b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUBtRgLLF3CRVLWqV/C/JWKt0+uX/UtEFbmnlRPXuQl7q63jtjs6o5jlYxV0dxGOY
	 Y+7wu4cwc27FqmKctkyxZQ284s9LR8a/j0lYr6uZWIaTrcHtSm52dNfyDqUCaHZGOV
	 8u8WK+OFsBN1zf/HXs+BgImC0LFINR6YygsFJGwSQNPHCta813P1k9wm06B/FI7Pii
	 iJkTmRoqu/NVDZT+tWDC1cPY2GpLGwkqFKO7S8eDoA1LyhAKZPQsYeffaXnU+CzZzn
	 UcH7f9TijneBa8dLNRrZUtW21BLNBriS+OPjJAHOkkJgF736IC2SYjCQ5s+lXMk3ek
	 P2952mCFTP7UQ==
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
Subject: Re: [PATCH 6.1 0000/2812] 6.1.193-rc2 review
Date: Fri, 20 Nov 2026 14:51:23 +0100
Message-ID: <20261120135123.16092-1-ojeda@kernel.org>
In-Reply-To: <20261120055200.707545519@linuxfoundation.org>
References: <20261120055200.707545519@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 20 Nov 2026 06:57:23 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.193 release.
> There are 2812 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
