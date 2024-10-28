Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F847190674;
	Mon, 28 Oct 2024 08:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730102797; cv=none; b=WHwlfaCvlC0yhn/JlcgiPS4rxr8uVjh+dlNpCCzBPfRPfEUQ5ZOrODqyTENh3CfzHKR93DxmoLZ9iAulbz+Zp/P8g+ZnqMzWPsNZXGOw9wz81E69eD5gQRlymB8TXZJsAGu+TG2f6AvBa0qUSvbiHrsewuns6bV+gVHJ0AWm/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730102797; c=relaxed/simple;
	bh=wxNUnJ/4aK4LOb+bDBEkRDwTNg9OSthS+kn91U2Rtfs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIFszk5PPwgwrXnTJqKrdQyWP8CxMJYbSXdQtPxCa3WpMyvn4I1vRo8jEaRLTLPiDkqNTPdWwBAhdbGrGJt8A8G83cuBsVgKVWKt1PKvPogL0pevmF4/9XSA6i7UKTi4438WuIYQMUMPvCB5qAvbVaWNM1w0m/llNfK+xZdvrw4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GP75+83D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GP75+83D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E6A2C4CEC3;
	Mon, 28 Oct 2024 08:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730102797;
	bh=wxNUnJ/4aK4LOb+bDBEkRDwTNg9OSthS+kn91U2Rtfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GP75+83DC1WzDI8nBeRMGTdRn2cJYLU9ZdGZCTLxJ41BhPLpW43re+hhXaYO/Ghh1
	 ECFyM7bPnvVMr3z0TsKGv+bAr+1m75v+/icXZIFLuiYvHWIhpEyZSSmLnQgAHtedLj
	 SXuoe/y5IEcrFmaJ77IUitmYn2oYizLvo3hLRTC/v+3q3rP1VR6QzJgtOu/Qp9ERe2
	 4I52C8l88bWPUQq5fn7FdfrHEg4IMuwEOhPngNnAMMOxz7avY5UBvUDdsbsuUhALg0
	 UJTWlunh6BOOAulmDKrnYp/JILZ8bpGJ2F5NDmdIrBHFyknwqP0+FsEG/adVe1p0qr
	 PhaZUzDww95Vg==
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
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
Date: Mon, 28 Oct 2024 09:06:19 +0100
Message-ID: <20241028080619.589960-1-ojeda@kernel.org>
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 28 Oct 2024 07:23:00 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Oct 2024 06:22:39 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
