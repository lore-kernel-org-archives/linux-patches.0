Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F2ED26A08F;
	Wed, 11 Feb 2026 13:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770817506; cv=none; b=ogWKk/v7oooOq0ofNZP1IwTvV72rb7DQeujABOKfViqOko9HESTm5o2lEqG91eMCnaaO8IldUltCcRdNCAYl+rBUjjldQQv/05YYxhHPqCoonvOZkWNUWFChmsnVTyhXM+QAjZUgvRLuDOzhE7Du9Sxx+hw6xBUNMACPNUDI6CU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770817506; c=relaxed/simple;
	bh=X/OeMDz0V85/i+r1QvKASnA/EnZyxpOn9uZQz8V9rTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qnPKZMJZh+U0bDPuxi3DWleMHWnls9xPI1NLeb1Xt6I44MD/NJ7b95uEnM78UVi2gp+JTDxWF3LN/CcsmodemkJkpB7weDffUzIOTSzkIjHxmRO77YoFgoQKUztMJ4tdn1aPUQRNvMskBo2XjsmkxsYqwFv7DUZ+DmTGlroXbJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E0hdd9VZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E0hdd9VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59A1C4CEF7;
	Wed, 11 Feb 2026 13:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770817505;
	bh=X/OeMDz0V85/i+r1QvKASnA/EnZyxpOn9uZQz8V9rTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E0hdd9VZ2PRAe4EF7IZOvk85fSJipfTG/JPN8IN88le3Ym4R+dn6QeVKZap8CyJH1
	 O51XGapIqTbX2sf0KF22WnL3RX/QWpJXFJxbHO5ctBjdadL6nZ6nQwQeXYoO87yQoY
	 N/1M1fT1xOdekqH1pezvMYmUGJ+dfANhFC4g42ZSKCDN0ZodSSSWB6PWxtWd7A5uPb
	 AxTGbVLz251SCh9jitW7GdptOouRYte9EapvCun1hP7ZoJCj7GOYTlZl7A/JVE6f4e
	 xNx9srOWNfnl3tRn7gUJEmIqUSnC5waqyLDMnUF1YoG/zLvb9TWVHdJWxg4kF/7Ppp
	 FPdUrNsVMp+5w==
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
Subject: Re: [PATCH 6.6 00/86] 6.6.124-rc1 review
Date: Wed, 11 Feb 2026 14:44:55 +0100
Message-ID: <20260211134455.10993-1-ojeda@kernel.org>
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Mon, 09 Feb 2026 15:23:23 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.124 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
