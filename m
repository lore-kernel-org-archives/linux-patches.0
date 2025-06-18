Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F2A2E7639;
	Wed, 18 Jun 2025 13:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750251607; cv=none; b=QKfeGwNQt2S/24FDT+6LF4uRQaorRqqGAvAIaau9wiQGiPfAhnCx3Qorf6aEcc0LBLM6Rgus+L7LFXu7z8+ZTuF8b8syBS9J38xI+J3spqGOTesgENG8BbIIXmMXzV+GelfcEQJVyBFeABgrb4G681YlJVWW/AvwQNzHU1wWp9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750251607; c=relaxed/simple;
	bh=BFtGtfz8CaBRAJNMtWNqPNVb80xkQMh1TasnboFQ6sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oXEr640Y4jzwmIY2Rx3206R+XPZOGEFgXJ6EyK7JzkF272domLjD8nIMiBbFXcBjdrCQO8qZQNw14c9dWSm6Mem8IrUJhZW5IvvpJZri5vSSsPAOTrujzVxgssN+g/FNrAvzEijntP9K/qAXfHJauKx4o+5LMZrSQqxXxHXsYB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iNSS3Y02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iNSS3Y02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ADFC4CEE7;
	Wed, 18 Jun 2025 13:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750251606;
	bh=BFtGtfz8CaBRAJNMtWNqPNVb80xkQMh1TasnboFQ6sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iNSS3Y026myeYYrid0cJSEw5YE3x8ciX0g0J+aKzhED2oPZVrf8OyWzkWhZbWcS1B
	 sKu/3AreJCyahdt91jlGikvI363/OyNT2hh2NAWcQOA6gHiAN3OxFzbW0zTAhLKdIP
	 cyIKd7Tyzl4cJK96CYVQ2eR7A2cvt+6jBSljppfTQrQxymQeezqlOHWSy5OcrSuvnf
	 89kH+UhEKnP8lUcSssXCjs1C+Rucgo1WDGfuNlwGImVBoOAZ3rimInmiLhWoKxvSfs
	 NBBEbD6Ie3N/4kMCJZr6R1QFwMxWmLkCK3dQhE69ZVHh6qlp+cccwpkCnxR5a8MoLq
	 hx6mh2jLvBZtw==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
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
	srw@sladewatkins.net,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
Date: Wed, 18 Jun 2025 14:59:52 +0200
Message-ID: <20250618125952.1920952-1-ojeda@kernel.org>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 17 Jun 2025 17:15:08 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.

For arm64, with Clang 18, I found the same issue as for 6.12.y:

    https://lore.kernel.org/stable/20250618125710.1920658-1-ojeda@kernel.org/

Otherwise, boot-tested under QEMU for Rust x86_64 and riscv64;
built-tested for loongarch64.

Thanks!

Cheers,
Miguel
