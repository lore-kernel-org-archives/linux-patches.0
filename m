Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794152717;
	b=YpguqNZO7YxXW442kUfYfc0I5xWZu0Ogri2o++sK1zAep9niXIb+JR8tko/U1j/Othsu
	 yOvOExv54f6+RrWVlPw+5plLDOAvbkXfqMRoQVkeVdcCzrbQLBZD9gGi7yihQeTozdCiK
	 qNHkn57+m18rU7kfUEkkJ0TvNxB0q3RoxqN22gcbuXENV8nulTBcDTT6dZ2ihy/tTWjCy
	 yOMRNspwwP9I8XzY8bTiWMhRcS0z4CuYEGVLyNbXAOPC4Ux+KpJn46D+M4EBLWJF1x7tk
	 K4oX/46fWdqs/dh3GnrPWCspOVAxhcUXbOpcZ7nFOSkpR2GoKdvhR3TWgz/zY5flkWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794152717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=qSpAEUGUsxH1O+NDTFf1UnEoumt85r3iNDynmfYIBxM=;
	b=CVzlEli5vW8lzkHhVka3OSWWsm8cjw8jQpY9TD+dG8XgQa9WVZsgq6iZ+7+mmR6sQt+J
	 fuCV4TjmR1852Sov20xI5/r6c0yBrZcnNWU6AlUxv+c0XuObF6dzpRFcW0Qhfw8NpPR00
	 VuHUHrtSUv+9U6hhSjH6U/abS5x280y+l5GZc/n09Ua0airRn5C7HEFTVvItfmC87GPZJ
	 pJFMiLv7ZGhTPc4NwamLJ+iZz34aBUftsM6+56AOvghnUYlR/aSfb10ZjQl25cYnJIMAf
	 grqNVtHqCKzm5S1SxNnKIoJyNufNOrJPeyYMRJq/7E4TtZnSzfCyaQGL0gWSqZrotew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7OobCYW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24EB1606A320;
	Sun,  8 Nov 2026 15:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I7OobCYW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4282E1F008A1;
	Sun,  8 Nov 2026 15:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794152716;
	bh=qSpAEUGUsxH1O+NDTFf1UnEoumt85r3iNDynmfYIBxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I7OobCYWmm+PKKO6o5eycQlk6zPEVcWyFhwra4zGCOiQ9fOo9E03s5Dw+v9Im4raE
	 mmxcC33ftOZ+H21x9LnKGk+dWyIUyYtmOtR9jq/inT7iwrLBzeB8LYflf+BYYKbD2p
	 nq6zmu5ITtfIuEr1nug56VaOCi/kjAiy68Me0VS2IM49y22xcHXhqHkuNerElrBFNN
	 uvH4rDhHpeNQo6T4OYaF8y+nyUi/j/VVrX0JbVjUt2qBTp90JYFjrafd+3k6QQVcuS
	 VIbfkdtzwlrEqr2/hTn5qxX95pz6ltgcBCKqmWxfjcbKdKhzzWrn80emYLAZSGE5z4
	 QAfP2mQ3bHuDQ==
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
Subject: Re: [PATCH 7.3 0000/1257] 7.3.4-rc1 review
Date: Sun,  8 Nov 2026 16:45:04 +0100
Message-ID: <20261108154504.118645-1-ojeda@kernel.org>
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

On Sat, 07 Nov 2026 08:38:16 -0500 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.3.4 release.
> There are 1257 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64 and arm32:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

In loongarch64, I still see the XFS issue:

  https://lore.kernel.org/stable/20261106071743.90363-1-ojeda@kernel.org/

Thanks!

Cheers,
Miguel
