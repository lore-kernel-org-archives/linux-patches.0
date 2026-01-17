Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7A8B67E;
	Sat, 17 Jan 2026 14:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768661358; cv=none; b=BdP7rb+otYKCTJ8I9orzcSqVo7Kf4/Dv+6t+00rzTeugtE48aXcyRq54DXMNrcomnbGYF0cMc6KjrLiPTw5WRcGC63QK3GaOa95LkdATbtmyKJLsY2TG0LSrPyuwov2/NB/Zc2QDkzOxEmLCMavNzUzi0h2JmncWGo5PhclnuHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768661358; c=relaxed/simple;
	bh=Lal338Pej9X4atoPK+K0bBQ5fnFDyXLDNYcMv+VDQro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7hYidRkLY9ZwYLVGbF8z0ANRr1JP6L0aFU6Y2zsrONJLbnJla21sW+2y4xDEGAhtecyESCeuJQmOOy6zjvQR+IbHqChq3v7iEC3xX6pYgfhnoLZimJPTw5J/+59coCeenDLv1aXUcKiDSZJGUznOPCjjzLl3MEPg8DDu2lckrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jSUi+Cuj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jSUi+Cuj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE97C4CEF7;
	Sat, 17 Jan 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768661358;
	bh=Lal338Pej9X4atoPK+K0bBQ5fnFDyXLDNYcMv+VDQro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSUi+Cuj+NpGTQSgleYgTbS9YbsnFgAXw+AuZG2BliVL5BjEEXH4yi/D0XS2He6VL
	 RcXRp45QNVJ93O9ljbTgDgTND5kaoXmir4lpNrfFBnofOuq8dfj+pHNgCZ4f7Olg/p
	 b+m6SjWbzZI+4ZnsdEnR5/YJsE3M5lJIIZ2Dw+Oxxg2/a5j39VrO2g9GeN2cDIe9jA
	 7andBVxBPTCWKta7TXdnOHhjP67wcWsECEpmsWsNKphh4FBbTF4LR3rISpSOTcRIte
	 eWNwTqXrqkIo/g9MGslsmf5fhs8BFxXInRQt0qOtSmb7hBXM7DHr61m5a+ZXZR+IGD
	 PfZnN9xvssfMg==
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
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Miguel Ojeda <ojeda@kernel.org>
Subject: Re: [PATCH 6.18 000/181] 6.18.6-rc1 review
Date: Sat, 17 Jan 2026 15:49:09 +0100
Message-ID: <20260117144909.172235-1-ojeda@kernel.org>
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 15 Jan 2026 17:45:37 +0100 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.18.6 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.

Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
for loongarch64:

Tested-by: Miguel Ojeda <ojeda@kernel.org>

Thanks!

Cheers,
Miguel
