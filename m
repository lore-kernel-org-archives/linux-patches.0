Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A8671A38D2;
	Wed, 28 Aug 2024 16:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724860892; cv=none; b=CovO7Gq3bOh86iS7mfx4Y/prFxMMOJf6cBElPTVu4bLriICoZjJ4iUGUeSqHK5avUXdUXZIJLp+Lc6WM02z/wvG40G8fV69/lzY6AqzGBWZFfvHaW4frUHGs1079MTsG04/V8AaFcKKtPEWG3191DAypkLcrjpbt2nIzJYVdRSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724860892; c=relaxed/simple;
	bh=2ZEc39QyYycRl49ZFRInIHmmXhN2ykEKq5khgjXkDOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EC9SRjONJ6eBvhFhHKAiu0b7eF4BvZ/8eGGLzPrTl9NVxChAEuT3On4r3qi41MBNrJ2IeCm5XAQmbxTGKbJroTJSVFtpHNdSWfpj8M6AUiiAh+V4b88aJfHl6s8NIHKwIzdibfwKe8urDDDzxi3naScKEw9Uoc2qL3OXRF26sZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b+e4Q7kQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b+e4Q7kQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A09A6C4CED7;
	Wed, 28 Aug 2024 16:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724860892;
	bh=2ZEc39QyYycRl49ZFRInIHmmXhN2ykEKq5khgjXkDOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+e4Q7kQ3x0bckAUBSJmaUm+sOKyZdfy8hhoVwllydQ2DSimcr7c5FXfy3SRbu8Lr
	 gNLUE9sDLRBUqKHs3lpDIF3IWmQfYMr8fdr/z2zAK/wBnCd+IKpy3RPy3Orn6aadve
	 7kyaHGTtwi939SKTUQ+2nwyZgEnuQq7itIFD7hxhlMNnjo0Y1LsY26vHS925mjGXzs
	 v3rtYrJbOF1vXQc2U8niNGTdhCbo6/pVYw6DRTsaqDzgxirnJoZtKysgnIz8+8wrRF
	 Sb3rfvH3PGGB2pNbov7kV1Nj+9J7BUMs41B8p+73DrJtgFFiHt6Xos/HPFvEq86icZ
	 djUX72pHHetZQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: gregkh@linuxfoundation.org
Cc: akpm@linux-foundation.org,
	allen.lkml@gmail.com,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
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
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.1 000/321] 6.1.107-rc1 review
Date: Wed, 28 Aug 2024 18:01:13 +0200
Message-ID: <20240828160113.139079-1-ojeda@kernel.org>
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 27 Aug 2024 16:35:08 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.107 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Aug 2024 14:37:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.107-rc1.gz
> or in the git tree and branch at:
> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.

Boot-tested under QEMU for Rust x86_64.

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
