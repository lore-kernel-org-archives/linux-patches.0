Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53B403FFAD0;
	Thu,  1 Oct 2026 11:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790852977; cv=none; b=lraq1om22eeszlZXSeniYO2UyLVEVVslJFvcjGwbCBCuTt4t4HOmyOZYy8d2djyUKk1hLMrmur1d2fWf6HvT0/CV+41kxLWgw0oiSvb4BwJx8qwl7+jMNtjCxk6nYDq2AbrqkafzFWWoSh3acOU0ILbR0HlJHpq6Jt+87gUMY6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790852977; c=relaxed/simple;
	bh=eovwdya9zJaERSruej5QBIxSnpSHVlHXMHX1PaAAAoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNGivBpChvxJ07+ZyHpDkjqonK9p1ZUmxwMUJOM/PxyvVMeN7xr1+mD1i8MH5at3r1jbqW0ZL+uAQXKKtM0O768JorXTaceFJ3Orxp4XVr/iYtb/fVNLumsyso5aIHD6ekcs0ptVu2syvDkgTRFJ9CXUY2obWWhnhUGZpo0F0Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FIIlMJ4Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FIIlMJ4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B7681F000FF;
	Thu,  1 Oct 2026 11:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790852976;
	bh=u3lHsx//c+giDnGM8kOIz1qtbmH+WKEWKgQVQagN43g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FIIlMJ4Zj8jGxCmWumkqCQZqNTE6uaqc+6VwcuvZP+jIxwiwP6+or7ZYVPPOzLBBR
	 ioK+WsC8FNFZmjR2P89xiWXn2ZTFXKe96TEB92AtwSfa1sMR5NKXyTiDEbxRD6/pcg
	 XdQFq5ooR0XipaZJBn3VEaQ3xqAhzJdnUWtCbtcCCU/JWOPbZepBY7fRUpH+yxtzmE
	 9vlvvFy33BIxkBYNAE3LlwZ6nJYwHo7+esb3iKYJZbX0dMiU3sHJAUfPPSPWYIoOX7
	 amiYecAv0Bm0PBeMMN9NBR2Rj2jjl9XTvM3kfnp5DZB6ojoySWbSdOQWt5tAKJJrIP
	 rTDh9k7iZBR3w==
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
Subject: Re: [PATCH 6.1 000/982] 6.1.189-rc1 review
Date: Thu,  1 Oct 2026 13:09:24 +0200
Message-ID: <20261001110924.60291-1-ojeda@kernel.org>
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, 30 Sep 2026 17:12:16 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.189 release.
> There are 982 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Oct 2026 15:23:04 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
