Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9C34BA32;
	Wed,  1 Oct 2025 17:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759340963; cv=none; b=dh3LOIVc1KjHFO8nRl7kooaIwXaIIP9xUmrTapFDrZrc8AnnVFLKQFrfYsPKt8WhkS/v1bKMaCBw2WcK24XZZ5i4ChvloH4xwZIVAjqYAxguDor/mUfYUxQmqwESnLdx+i6WP1TyEzdjSFXlCoA/ISVL41oS3wV3DI99Tj83A8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759340963; c=relaxed/simple;
	bh=1GvNcdgjbr2SIE/4k8eA9UYSFmQT77JSBWNinbvuMms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kw+kJou5tbXiezAteLeK0rMQzkr8FYxd6RxYAQKiN+YSlMGAQFybO24Nigtag1ZiOcAM+LugFxBpEZGTfvcL1WgX1HhZMNcAWriTceRdLh1EYUoNNzNuwmuC9Cp98nAY7AYOANk6EqXwcGFyzvNmnySYt6LtuOkx+MJgkTKQB2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gk0Z7EV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gk0Z7EV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE37BC4CEF1;
	Wed,  1 Oct 2025 17:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759340962;
	bh=1GvNcdgjbr2SIE/4k8eA9UYSFmQT77JSBWNinbvuMms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gk0Z7EV72toUA0VP4TOWJ6YG7NL70LQF8Fo54VGVFUqVNUNdQgaMtMkQB1dVU04NE
	 B6jhFasQqHvFlRAVV9quV1G5rOj4t19On5+GYXx3BHzMWaGK3QhXbUqL3pUMVJhWj5
	 o+GGzctGogeJSk3fHfKQ3yTsdYrYUNhfm3/WmgvCxdVh9Wv23CKOHrRjCKDqhpvLTl
	 p0XXJ0BjL+FQRK/ywwmuVLwhwFu5LOpdLxnJv2K7Nfx3Y0lGxEySYbiMmaNbbnWvLe
	 mAVXI1VCD8a7QZIVnQWMP5zR0DZM//fdcHBx2zmbPGcAMQGntglVzAbKuffm3x5UrT
	 AJnuQe+Q2oFOA==
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
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
Date: Wed,  1 Oct 2025 19:49:14 +0200
Message-ID: <20251001174914.48153-1-ojeda@kernel.org>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 30 Sep 2025 16:45:24 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for arm and loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
